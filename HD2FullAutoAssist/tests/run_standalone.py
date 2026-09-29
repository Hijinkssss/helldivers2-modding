"""Offline RC7 checks, including differential replay of the preserved reference.

Requires Python + lupa.luajit21 and git. Never opens a game process.
The reference is read from commit a93008f; it is not packaged with the mod.
"""
from pathlib import Path
import hashlib,json,subprocess,tempfile,zipfile,sys,math
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parent
REFERENCE='a93008f5c0a69bf5bcf4be8bddb468dc5607bcf3'
checks=[]
def check(name,fn):
    fn();checks.append(name);print('PASS:',name)
def plain(v):
    if hasattr(v,'items'):return {str(k):plain(x) for k,x in v.items()}
    return v
def lua_at(path):
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path=';'.join([path.as_posix()+'/?.lua',
        (REPO/'integrations/HD2ModCore-runtime-candidate/src/?.lua').as_posix(),lua.globals().package.path])
    return lua
def reference_file(name):
    return subprocess.check_output(['git','show',REFERENCE+':HD2FullAutoAssist/src/'+name],cwd=REPO).decode()
def host(path,standalone):
    lua=lua_at(path)
    lua.execute((ROOT/'tests/policy_host.lua').read_text(encoding='utf-8'))
    lua.execute((ROOT/'tests/host.lua').read_text(encoding='utf-8'))
    lua.globals().app=lua.execute((path/'full_auto_assist.lua').read_text(encoding='utf-8'))
    if standalone:
        lua.execute('''
            standalone_host={read=function()error('unexpected real read')end}
            function standalone_host:log(level,event,fields)core.Logger:Emit(level,'hd2_full_auto_assist',event,fields)end
            function standalone_host:remove(token)
                core.Input:Remove(token);core.Hooks:Remove(token)
            end
            function standalone_host:on_stop(fn)assert(core:OnUnload('hd2_full_auto_assist',fn).ok)end
            function standalone_host:config(schema,text,arsenal_options)
                return require('config').load(schema,text,arsenal_options)
            end
            function standalone_host:parse_key(key)
                if key=='=' or key=='+' then return 0xbb end
                return assert(core.Input:ParseKey(key).ok)
            end
            function standalone_host:build_status()return core.Build:Status()end
            function standalone_host:eligibility()return core.Input:ShortcutEligibility()end
            function standalone_host:local_avatar()return core.Diagnostic:LocalAvatar()end
            function standalone_host:on_toggle(key,fn)
                -- Core-backed reference fixture only emits F8 key events; the
                -- standalone VK_OEM_PLUS path is covered by lifecycle fixtures.
                if key=='=' then key='F8' end
                return assert(core.Input:SubscribePressed('hd2_full_auto_assist',key,{debounce_ms=150},fn)).value
            end
            function standalone_host:on_identity(fn)return assert(core.Hooks:Subscribe('hd2_full_auto_assist','before_update',{every_ms=100},fn)).value end
            function standalone_host:on_fire(fn)return assert(core.Hooks:Subscribe('hd2_full_auto_assist','before_update',{every_ms=0},fn)).value end
            function standalone_host:diagnostics()return core.Diagnostics:Status()end
            function standalone_host:write_status()return core.Diagnostics:WriteStatus()end
            function standalone_host:read_scope(fn)return fn()end
            function standalone_host:stop()return core:Unregister('hd2_full_auto_assist')end
        ''')
    return lua
def controller_test(path,standalone,name):
    lua=host(path,standalone)
    code=(ROOT/f'tests/{name}.lua').read_text(encoding='utf-8')
    if standalone:code=code.replace('app.install(core,','app.install(standalone_host,')
    if name=='test_gate':lua.globals().app=lua.execute((path/'full_auto_assist.lua').read_text(encoding='utf-8').replace('local IDENTITY_VALIDATED=true','local IDENTITY_VALIDATED=false'))
    if standalone and name=='test_validation':
        code=code.replace("bridge.Status=function()return {state='unavailable'}end",
            "core.Diagnostic.LocalAvatar=function()return {ok=false}end")
        code=code.replace('runtime_connection_invalid','identity_unavailable_or_player_changed')
    lua.execute(code)
def native_test(rpm=None):
    lua=lua_at(ROOT/'src')
    lua.execute('''
        local actual=require('native_fire')
        native={new=function(fake,factory)
            local h={build_status=function()return fake.Build:Status()end,
                read=function(_,at,n)return assert(fake.Memory:Read(at,n)).value end,
                ptr=function(_,at)return assert(fake.Memory:ReadPointer(at)).value end,
                u32=function(_,at)return assert(fake.Memory:ReadU32(at)).value end,
                symbol=function(_,name)return assert(fake.Symbols:Resolve(name)).value.address end}
            return actual.new(h,factory)
        end}
    ''')
    code=(ROOT/'tests/test_native.lua').read_text(encoding='utf-8')
    if rpm:
        interval=60/rpm
        code=code.replace('assert(b:begin(row)==2);assert(read(bucket+8,20)~=original)',
            f"assert(b:begin(row,{interval!r})==2);local f=ffi.new('float[1]');ffi.copy(f,read(bucket+24,4),4);assert(math.abs(tonumber(f[0])-{interval / math.ceil(interval)!r})<.000001)")
    lua.execute(code)
def native_intervals():
    for rpm in (900,750,480,450,400,380,350,120,80,60,50,32):native_test(rpm)

def native_transition_checks(name):
    lua=lua_at(ROOT/'src')
    lua.globals().package.path=(ROOT/'tests').as_posix()+'/?.lua;'+lua.globals().package.path
    lua.execute((ROOT/'tests'/name).read_text(encoding='utf-8'))
def static_checks():
    lua=lua_at(ROOT/'src')
    for f in (ROOT/'src').glob('*.lua'):
        s=f.read_text(encoding='utf-8');assert lua.eval('loadstring')(s) is not None,f.name
        assert 'hd2modcore.' not in s and "mods/codex/hd2_mod_core" not in s and "mods/skyeshade/hd2runtime" not in s
        assert 'SendInput' not in s and 'VirtualProtect' not in s
    config=lua.eval("require('config')")
    schema=lua.table_from({'enabled':lua.table_from({'type':'boolean','default':True}),
        'fire_rate_mode':lua.table_from({'type':'string','default':'balanced','max_length':16,
            'values':lua.table_from({'balanced':True,'native_cap':True})}),
        'talon_mode':lua.table_from({'type':'string','default':'balanced','max_length':16,
            'values':lua.table_from({'balanced':True,'efficiency':True,'full_auto':True,'fuller_auto':True})})})
    assert config.load(schema,'enabled=false').enabled is False
    for text in ('enabled=no','enabled=true\nenabled=false','unknown=1','bad line','fire_rate_mode=fast','talon_mode=fast','x'*8193):
        try:config.load(schema,text)
        except Exception:pass
        else:raise AssertionError('Invalid config accepted: '+text[:40])
    p=lua.eval("require('weapon_policy').new('balanced')")
    assert p.available and p.status(p).mapped_resources==33
    policy_for_talon=lua.eval("function(profile)return require('weapon_policy').new('native_cap',profile)end")
    for profile,rpm in (('balanced',210),('efficiency',60),('full_auto',380),('fuller_auto',750)):
        profile_policy=policy_for_talon(profile)
        talon=profile_policy.classify(profile_policy,'416d053372c4e433')
        assert talon.allowed and talon.max_repeat_rpm==rpm,(profile,talon.max_repeat_rpm)
    for bad in ('0000000000000001','1980d92b619ff5fe','bad',None):assert not p.classify(p,bad).allowed
def parity(ref):
    rows=[('05e4e5c2db6e44a2',380,900),('4d58c77087b774c5',380,900),
          ('c780bcd79547da0f',380,750),('1a437158e1b8d2a1',380,450),
          ('03e67a19b07c6523',350,350),('4c786785c79d44e7',350,350),
          ('0f83639ab8c86165',380,480),('89c5493e08ca4207',120,400),
          ('416d053372c4e433',210,750)]
    for mode in ('balanced','native_cap'):
      for override in (0,800):
        results=[]
        for path,standalone in ((ref,False),(ROOT/'src',True)):
          lua=host(path,standalone)
          obj='standalone_host' if standalone else 'core'
          lua.execute(f"a=app.install({obj},function()return backend end,function()return 'fire_rate_mode={mode}\\nrepeat_ms={override}'end)")
          record=[]
          for i,(hash,balanced,native) in enumerate(rows):
            lua.execute(f"resource_hash='{hash}';entity_id={1001+i};fire=false;tick({i*200});fire=true;tick({i*200+20})")
            assert lua.globals().backend.lease is not None
            state=plain(lua.eval('a:get_state()'))
            seconds=lua.globals().backend.repeat_seconds
            expected=max(override/1000,60/(balanced if hash=='416d053372c4e433' or mode=='balanced' else native))
            if standalone:assert abs(seconds-expected)<1e-7,(hash,mode,seconds,expected)
            record.append((state['weapon'],state['eligibility']['category'],state['effective'],seconds))
            lua.execute(f'fire=false;tick({i*200+40});assert(not backend.lease)')
          for hash in ('968211c0033dce64','35a61296619cc47e','1980d92b619ff5fe','0000000000000001'):
            lua.execute(f"resource_hash='{hash}';entity_id=9001;fire=false;tick(2200);fire=true;tick(2220);assert(not backend.lease)")
          lua.execute('assert(a:stop().ok);shutdown()')
          results.append(record)
        for i,(a,b) in enumerate(zip(*results)):
          assert a[:3]==b[:3],(rows[i][0],a,b)
          if rows[i][0]!='416d053372c4e433':assert abs(a[3]-b[3])<1e-7
def lifecycle_checks():
    lua=lua_at(ROOT/'src')
    lua.execute((ROOT/'tests/test_standalone_lifecycle.lua').read_text(encoding='utf-8'))
def arsenal_profile_checks():
    lua=lua_at(ROOT/'src')
    lua.execute((ROOT/'tests/test_arsenal_profiles.lua').read_text(encoding='utf-8'))
def preserved_guard_checks():
    lua=lua_at(ROOT/'src')
    for name,old,new in [('test_game_state.lua','hd2modcore.game_state','identity'),
                         ('test_input_eligibility.lua','hd2modcore.input_eligibility','input')]:
        code=(REPO/'integrations/HD2ModCore-runtime-candidate/tests'/name).read_text(encoding='utf-8')
        lua.execute(code.replace(old,new))
def known_data_checks():
    evidence=json.loads((ROOT/'docs/known-weapon-evidence.json').read_text(encoding='utf-8'))
    assert evidence['runtime_commit']=='fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595'
    lua=lua_at(ROOT/'src');policy=lua.eval("require('weapon_policy').new('balanced')")
    count=0
    for row in evidence['entries']:
        hashes=row['resources']
        if len(hashes)==1:
            entry=policy.classify(policy,hashes[0]);assert entry.name==row['name'],row
            count+=1
            if entry.allowed and row['name']!='APW-1 Anti-Materiel Rifle':
                modes=row['native_fire_modes'];vector=modes['nativeModeVector']
                assert vector==([2,3,0] if row['name']=='R-2 Amendment' else [2,0,0])
        else:
            for resource in hashes:assert not policy.classify(policy,resource).allowed
    assert count==11
def main():
    (ROOT/'build').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(dir=ROOT/'build') as tmp:
        ref=Path(tmp)
        for f in (ROOT/'src').glob('*.lua'):
            if f.name in ('full_auto_assist.lua','weapon_policy.lua','assist_state.lua','native_fire.lua','validation_trace.lua'):
                (ref/f.name).write_text(reference_file(f.name),encoding='utf-8')
        for name in ('test_policy','test_gate','test_selective','test_validation'):
            check('reference '+name,lambda n=name:controller_test(ref,False,n))
        check('standalone mixed-weapon transitions, guards, toggle and cleanup',lambda:controller_test(ROOT/'src',True,'test_selective'))
        check('Warrant release, OFF, and unknown-identity guards',lambda:controller_test(ROOT/'src',True,'test_warrant_safety'))
        check('live-order startup reconciliation, delayed avatar, mission persistence and toggles',lambda:controller_test(ROOT/'src',True,'test_live_startup_reconcile'))
        check('all 21 expansion identities, including the live-tested Warrant, repeat normal Fire and stop on release',lambda:controller_test(ROOT/'src',True,'test_expansion_controller'))
        check('standalone validation trace and closed identity gate',lambda:[controller_test(ROOT/'src',True,n) for n in ('test_gate','test_validation')])
        check('differential replay: 9 reference weapons, 2 modes, 2 overrides; existing roster preserved',lambda:parity(ref))
    check('native mapping safety, conflicts, axis exclusion and partial rollback',native_test)
    check('actual native mapping bytes and restore at every policy interval',native_intervals)
    check('real native weapon transitions, all policies/profiles, identity recovery and ship/death lifecycle',lambda:native_transition_checks('test_native_transitions.lua'))
    check('within-update page cache rejects incorrect/new addresses and expires after failure',lambda:native_transition_checks('test_page_scope.lua'))
    check('Lua syntax, no external imports, strict config and unknown fail-closed',static_checks)
    check('actual standalone lifecycle, native observer and UI/input guards',lifecycle_checks)
    check('Arsenal settings precedence and every selectable profile reaches policy',arsenal_profile_checks)
    check('preserved observer layout/race/bounds and complete native UI guard fixtures',preserved_guard_checks)
    check('known resource table matches pinned real Runtime metadata; no discovery',known_data_checks)
    check('opt-in performance profiler summaries and percentiles',lambda:lua_at(ROOT/'src').execute(
        (ROOT/'tests/test_performance_profile.lua').read_text(encoding='utf-8')))
    report={'reference_commit':REFERENCE,'checks':checks,'offline_passed':True,
        'core_behavior_parity':'preserved for known identities, guards and input intervals except intentional Talon Balanced change',
        'live_standalone_validated':False,'game_process_accessed':False,
        'external_dependencies':['Bingus Shared Loader v18 / API 1'],
        'source_sha256':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}}
    (ROOT/'build/standalone-checks.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'{len(checks)} offline check groups passed.')
if __name__=='__main__':main()
