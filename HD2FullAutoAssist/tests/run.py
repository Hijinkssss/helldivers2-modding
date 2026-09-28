"""Targeted selective checks. Synthetic state and mappings; never accesses HD2."""
from pathlib import Path
import argparse,sys,json,zipfile,hashlib,importlib.util
ROOT=Path(__file__).resolve().parents[1]
PACKAGE='HD2FullAutoAssist-v0.1.2-Current-Patch-Validation-Arsenal.zip'

def plain(value):
    if hasattr(value,'items'):
        items=list(value.items())
        if items and all(isinstance(k,int) for k,_ in items):return [plain(value[i]) for i in range(1,len(value)+1)]
        return {k:plain(v) for k,v in items}
    return value

def main():
    p=argparse.ArgumentParser();p.add_argument('--runtime-path',type=Path,required=True)
    p.add_argument('--loader-source',type=Path,required=True);p.add_argument('--hd2runtime-source',type=Path,required=True)
    p.add_argument('--core-source',type=Path,default=ROOT.parent/'integrations/HD2ModCore-runtime-candidate')
    p.add_argument('--identity-records',type=Path,required=True);args=p.parse_args()
    sys.path.insert(0,str(args.runtime_path));from lupa.luajit21 import LuaRuntime
    app=(ROOT/'src/full_auto_assist.lua').read_text(encoding='utf-8');assert app.count('local IDENTITY_VALIDATED=true')==1
    closed=app.replace('local IDENTITY_VALIDATED=true','local IDENTITY_VALIDATED=false')
    def host(open_test_gate=False):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.globals().package.path=(ROOT/'src/?.lua').as_posix()+';'+(args.core_source/'src/?.lua').as_posix()+';'+lua.globals().package.path
        lua.execute((ROOT/'tests/policy_host.lua').read_text(encoding='utf-8'));lua.execute((ROOT/'tests/host.lua').read_text(encoding='utf-8'))
        lua.globals().app=lua.execute(app if open_test_gate else closed);return lua
    checks={}
    lua=host();lua.execute((ROOT/'tests/test_policy.lua').read_text(encoding='utf-8'));checks['policy_fail_closed_and_metadata_cache']=True
    lua=host();lua.execute((ROOT/'tests/test_gate.lua').read_text(encoding='utf-8'));checks['closed_gate_regression_no_backend_no_writes']=True
    lua=host(True);lua.execute((ROOT/'tests/test_selective.lua').read_text(encoding='utf-8'));checks['simulated_selective_swaps_guards_toggle_cleanup']=True
    lua=host(True);lua.execute((ROOT/'tests/test_validation.lua').read_text(encoding='utf-8'));checks['validation_off_input_trace_cleanup_and_runtime_disconnect']=True
    for mode,override in (('balanced',0),('native_cap',0),('native_cap',200)):
        lua=host(True);lua.globals().cadence_mode=mode;lua.globals().cadence_override_ms=override
        lua.globals().cadence_config=f'fire_rate_mode={mode}\nrepeat_ms={override}'
        lua.execute((ROOT/'tests/test_weapon_cadence.lua').read_text(encoding='utf-8'))
    checks['controller_balanced_native_special_release_swaps_and_slow_override']=True
    lua=host();lua.execute((ROOT/'tests/test_weapon_policy_v2.lua').read_text(encoding='utf-8'))
    checks['weapon_policy_v2_all_values_and_promotion_vetoes']=True
    for cfg in ('enabled=false','enabled=maybe','toggle_hotkey=invalid','unknown=1','repeat_ms=-1','repeat_ms=1001','fire_rate_mode=invalid'):
        lua=host();lua.globals().cfg=cfg
        passed=lua.eval('function()return pcall(app.install,core,function()error("No backend expected")end,function()return cfg end)end')()[0]
        assert passed==(cfg=='enabled=false'),cfg
        assert lua.eval('core.Diagnostics:Status().input.active')==0 and lua.eval('core.Diagnostics:Status().scheduler.active')==0
    for missing in ('nil',"{Connect=function()error('absent')end,Target=function()end}"):
        lua=host();lua.execute('core.Integrations.HD2Runtime='+missing)
        lua.execute("a=app.install(core,function()error('No backend expected')end,function()return ''end);tick(0);assert(not a:get_state().effective)")
        assert lua.eval('core.Diagnostics:Status().scheduler.active')==0
    lua=host(True);lua.execute("a=app.install(core,function()error('Native adapter unavailable')end,function()return ''end);tick(0,false)")
    assert lua.eval('a:status().failed') and lua.eval('core.Diagnostics:Status().scheduler.active')==0
    lua=host(True);lua.execute("backend.begin=function(self)self.lease={};error('partial failure')end;a=app.install(core,function()return backend end,function()return ''end);tick(0);fire=true;tick(20)")
    assert lua.eval('a:status().failed') and lua.eval('backend.lease==nil') and lua.eval('core.Diagnostics:Status().scheduler.active')==0
    lua=host(True);lua.execute('''
        restore_attempts=0
        backend.restore=function(self)
            restore_attempts=restore_attempts+1
            if restore_attempts==1 then error('transient restore failure')end
            self.lease=nil;return true
        end
        backend.begin=function(self)self.lease={};error('partial begin failure')end
        a=app.install(core,function()return backend end,function()return ''end)
        tick(0);fire=true;tick(20)
        assert(a:status().failed and backend.lease and core.Diagnostics:Status().input.active==0)
        tick(40);assert(backend.lease==nil and core.Diagnostics:Status().scheduler.active==0)
    ''')
    lua=host(True);lua.execute("a=app.install(core,function()return backend end,function()return ''end);tick(0);fire=true;tick(20);shutdown();assert(backend.lease==nil)")
    checks['config_dependency_failure_rollback_and_shutdown']=True
    for result in ('nil','{}','{ok=true,value={state="present",unit_ref=123}}',
        '{ok=true,value={state="present",unit_ref=999,held={state="present",entity_id=1,resource_hash="05e4e5c2db6e44a2"}}}'):
        lua=host(True);lua.execute("a=app.install(core,function()return backend end,function()return ''end);tick(0);fire=true;tick(20);assert(backend.lease)")
        lua.execute('core.Diagnostic.LocalAvatar=function()return '+result+' end;tick(40);assert(backend.lease==nil and not a:get_state().effective)')
    lua=host(True);lua.execute("a=app.install(core,function()return backend end,function()return 'repeat_ms=200'end);tick(0);fire=true;tick(20);assert(backend.repeat_seconds==.2)")
    lua=host(True);lua.execute("a=app.install(core,function()return backend end,function()return 'user_enabled=false'end);tick(0);fire=true;tick(20);assert(backend.writes==0 and not a:get_state().user_enabled)")
    checks['malformed_snapshot_and_cadence_startup_preference']=True
    lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().native=lua.execute((ROOT/'src/native_fire.lua').read_text(encoding='utf-8'))
    lua.execute((ROOT/'tests/test_native.lua').read_text(encoding='utf-8'))
    lua.execute("write_count=0;assert(not pcall(b.begin,b,{},.025) and write_count==0)")
    # A fresh fixture verifies a caller-selected conservative cadence and restoration.
    lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().native=lua.execute((ROOT/'src/native_fire.lua').read_text(encoding='utf-8'))
    fixture=(ROOT/'tests/test_native.lua').read_text(encoding='utf-8').replace('assert(b:begin(row)==2);assert(read(bucket+8,20)~=original)',
        "assert(b:begin(row,.2)==2);local f=ffi.new('float[1]');ffi.copy(f,read(bucket+24,4),4);assert(math.abs(tonumber(f[0])-.2)<.000001)")
    lua.execute(fixture);checks['native_mapping_bounds_exact_restore_and_edit_preservation']=True
    # All current candidate native caps fit the unchanged mapping mechanism.
    for rpm in (900,750,480,450,400,380,350,120):
        lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().native=lua.execute((ROOT/'src/native_fire.lua').read_text(encoding='utf-8'))
        interval=60/rpm
        fixture=(ROOT/'tests/test_native.lua').read_text(encoding='utf-8').replace('assert(b:begin(row)==2);assert(read(bucket+8,20)~=original)',
            f"assert(b:begin(row,{interval!r})==2);local f=ffi.new('float[1]');ffi.copy(f,read(bucket+24,4),4);assert(math.abs(tonumber(f[0])-{interval!r})<.000001)")
        lua.execute(fixture)
    checks['native_mapping_all_current_policy_intervals_and_restoration']=True
    lua=host();lua.globals().runtime_root=args.hd2runtime_source.resolve().as_posix()
    lua.execute('''
        table.insert(package.loaders,1,function(name)
            if name:sub(1,11)=='hd2runtime/'then return assert(loadfile(runtime_root..'/'..name:sub(12)..'.lua'))end
        end)
        public_hd2=require('hd2runtime/api/hd2')
        actual_bridge=require('hd2modcore.integration_hd2runtime').new(core,function()return public_hd2 end)
        actual_policy=require('weapon_policy').new(actual_bridge)
        assert(actual_policy.available and actual_policy:classify('05e4e5c2db6e44a2').allowed)
        assert(not actual_policy:classify('968211c0033dce64').allowed)
        assert(actual_policy:classify('35a61296619cc47e').category=='EXCLUDE_CHARGE_HOLD')
        assert(not actual_policy:classify('1980d92b619ff5fe').allowed)
        assert(core.Diagnostics:Status().scheduler.active==0)
    ''')
    actual_status=plain(lua.eval('actual_policy:status()'));checks['actual_runtime_public_metadata_no_background_work']=True
    policy_entries=[]
    metadata_path=args.identity_records/'runtime-public-metadata-expanded.json'
    assisted_names={'P-2 Peacemaker','M6C/SOCOM Pistol','P-69 Veto','LAS-58 Talon','R-2 Amendment',
                    'P-113 Verdict','R-63 Diligence','R-63CS Diligence Counter Sniper','APW-1 Anti-Materiel Rifle'}
    for weapon in json.loads(metadata_path.read_text(encoding='utf-8'))['weapons']:
        metadata=weapon['metadata'];resources=metadata.get('resources',metadata.get('resourceHashes',[]))
        for resource in resources:
            result=plain(lua.globals().actual_policy.classify(lua.globals().actual_policy,resource))
            assert result['allowed']==(weapon['requested_name'] in assisted_names), (weapon['requested_name'],result)
            policy_entries.append({'requested_name':weapon['requested_name'],'resource_hash':resource,**result})
    # Recheck the compact promotion receipt against real reviewed Runtime APIs.
    evidence=json.loads((ROOT/'docs/weapon-policy-evidence.json').read_text(encoding='utf-8'))
    runtime_root=args.hd2runtime_source.resolve()
    for name,digest in evidence['runtime_source_sha256'].items():
        assert hashlib.sha256((runtime_root/name).read_bytes()).hexdigest()==digest, name
    for row in evidence['weapons']:
        target=lua.globals().public_hd2.weapon(row['name'])
        metadata=plain(target.describe(target));modes=plain(target.fire_modes(target))
        assert modes['nativeModeVector']==row['fire_modes']['nativeModeVector']==[2,0,0]
        assert modes['allowedModes']==[2] and modes['defaultModeSemantics']=='semi_auto'
        assert metadata['resources']==[row['resource_hash']]
        assert metadata['implementationFamilies']==['conventional_projectile']
        cap=next(f for f in metadata['fields'] if f['semanticFieldId']=='weapon.fire_rate')
        assert cap['currentDefault']==row['native_cap_rpm'] and cap['backing']==row['fire_rate_field']['backing']
        b=plain(lua.globals().actual_policy.classify(lua.globals().actual_policy,row['resource_hash']))
        assert b['allowed'] and b['native_cap_status']=='RUNTIME_SNAPSHOT' and b['max_repeat_rpm']==row['balanced_rpm']
    checks['promotions_match_pinned_runtime_metadata_and_cap_provenance']=True
    # Cancellation of an actual bridge job when the consumer owner unregisters.
    lua.execute('''
        job_steps=0
        public_hd2.read=function()return {status='pending',step=function()job_steps=job_steps+1;return false end}end
        assert(actual_bridge:ReadLegacy('hd2_full_auto_assist',
            {read_target=function()return {resource='fixture',fields={'fixture'}}end},function()error('cancelled')end).ok)
        assert(core:Unregister('hd2_full_auto_assist').ok)
        tick(100);assert(job_steps==0 and actual_bridge:Status().active_reads==0 and core.Diagnostics:Status().scheduler.active==0)
    ''');checks['actual_scheduler_runtime_read_cancellation']=True
    bundle=(ROOT/'build/hd2_full_auto_assist.lua').read_text(encoding='utf-8');lua=host()
    assert lua.eval('loadstring')(bundle) is not None
    assert 'hd2modcore.' not in bundle and 'SendInput' not in bundle and 'VirtualProtect' not in bundle
    lua.execute("package.preload['mods/codex/hd2_mod_core']=function()return core end")
    # Package execution uses an absent fixture INI, never the user's live settings.
    lua.execute('''
        fixture_open=io.open
        io.open=function(path,mode)
            if path:match('HD2FullAutoAssist%.ini$') then return nil,'fixture config absent',2 end
            return fixture_open(path,mode)
        end
    ''')
    consumer=lua.execute(bundle);lua.eval('tick(0)')
    lua.execute('io.open=fixture_open')
    assert consumer.status(consumer).failed and not consumer.get_state(consumer).effective
    assert lua.eval('backend.writes')==0;lua.eval('shutdown()')
    checks['actual_bundle_missing_game_fails_closed']=True
    lua=host(True);lua.execute('''
        state_policy_calls=0
        local p=require('weapon_policy').new(bridge)
        local classify=p.classify
        p.classify=function(...)state_policy_calls=state_policy_calls+1;return classify(...)end
        local s=require('assist_state').new(p,true)
        local value=core.Diagnostic:LocalAvatar()
        s:resolve(value);local revision=s:snapshot().revision
        for i=1,100 do s:resolve(core.Diagnostic:LocalAvatar())end
        assert(state_policy_calls==1 and s:snapshot().revision==revision)
        s:invalidate('fixture');s:resolve(value);assert(state_policy_calls==2)
    ''');checks['unchanged_state_policy_cache_with_fresh_observer_calls']=True
    lua=LuaRuntime(unpack_returned_tuples=True);discover=lua.execute(args.loader_source.read_text(encoding='utf-8'))
    hasher=discover.hasher(lua.eval('require("ffi")'),lua.eval('require("bit")'))
    archive=ROOT/'build/9ba626afa44a3aa3.patch_0'
    entries,warnings=discover.scan(lua.table_from([archive.as_posix()]),hasher,lua.eval('io.open'))
    assert len(entries)==1 and entries[1]=='mods/codex/hd2_full_auto_assist' and len(warnings)==0
    spec=importlib.util.spec_from_file_location('selective_builder',ROOT/'scripts/build.py')
    builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
    spec=importlib.util.spec_from_file_location('core_archive',args.core_source/'scripts/build.py')
    verifier=importlib.util.module_from_spec(spec);spec.loader.exec_module(verifier);verifier.MODULE=builder.MODULE
    verifier.verify_archive(archive.read_bytes(),bundle.encode())
    with zipfile.ZipFile(ROOT/'build'/PACKAGE) as z:
        manifest=json.loads(z.read('manifest.json'))
        assert len(manifest['Options'])==1 and manifest['Options'][0]['Include']==['Addon'] and 'SubOptions' not in manifest['Options'][0]
        assert not any('Maximum' in n or 'hd2runtime/' in n for n in z.namelist())
        assert z.read('Addon/'+archive.name)==archive.read_bytes()
        for file in ('README.md','HD2FullAutoAssist.example.ini','HD2FullAutoAssist.validation.ini',
                     'docs/VALIDATION.md','docs/NEXT_TEST.md','docs/identity-validation.json','docs/weapon-policy-evidence.json'):
            assert z.read(file)==(ROOT/file).read_bytes()
    for file in (ROOT/'src').glob('*.lua'):assert file.read_text(encoding='utf-8') in bundle
    checks['loader_v18_source_archive_package_parity_single_option']=True
    receipt=json.loads((ROOT/'docs/identity-validation.json').read_text(encoding='utf-8'))
    assert receipt['identity_validated_for_observed_states'] is True
    report={'checks':checks,'identity_validated':True,'live_selective_firing_tested':False,'game_process_accessed_by_this_runner':False,
        'closed_gate_tested_only_in_memory':True,'hud_implemented':False,'release_ready':False,
        'identity_receipt_sha256':hashlib.sha256((ROOT/'docs/identity-validation.json').read_bytes()).hexdigest(),
        'runtime_metadata_policy':actual_status,
        'policy_entries':policy_entries,
        'source_files':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))},
        'package_sha256':hashlib.sha256((ROOT/'build'/PACKAGE).read_bytes()).hexdigest()}
    (ROOT/'build/selective-checks.json').write_text(json.dumps(report,indent=2)+'\n')
    build=ROOT/'build/build-report.json';data=json.loads(build.read_text(encoding='utf-8'));data['offline_tested']=True
    build.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
