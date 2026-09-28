"""Targeted selective checks. Synthetic state and mappings; never accesses HD2."""
from pathlib import Path
import argparse,sys,json,zipfile,hashlib,importlib.util
ROOT=Path(__file__).resolve().parents[1]
PACKAGE='HD2FullAutoAssist-v0.1.1-Selective-Live-Validation-Arsenal.zip'

def plain(value):
    if hasattr(value,'items'):
        items=list(value.items())
        if items and all(isinstance(k,int) for k,_ in items):return [plain(value[i]) for i in range(1,len(value)+1)]
        return {k:plain(v) for k,v in items}
    return value

def main():
    p=argparse.ArgumentParser();p.add_argument('--runtime-path',type=Path,required=True)
    p.add_argument('--loader-source',type=Path,required=True);p.add_argument('--hd2runtime-source',type=Path,required=True)
    p.add_argument('--core-source',type=Path,default=ROOT.parent/'HD2ModCore-runtime-candidate');args=p.parse_args()
    sys.path.insert(0,str(args.runtime_path));from lupa.luajit21 import LuaRuntime
    app=(ROOT/'src/full_auto_assist.lua').read_text();assert app.count('local IDENTITY_VALIDATED=true')==1
    closed=app.replace('local IDENTITY_VALIDATED=true','local IDENTITY_VALIDATED=false')
    def host(open_test_gate=False):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.globals().package.path=(ROOT/'src/?.lua').as_posix()+';'+(args.core_source/'src/?.lua').as_posix()+';'+lua.globals().package.path
        lua.execute((ROOT/'tests/policy_host.lua').read_text());lua.execute((ROOT/'tests/host.lua').read_text())
        lua.globals().app=lua.execute(app if open_test_gate else closed);return lua
    checks={}
    lua=host();lua.execute((ROOT/'tests/test_policy.lua').read_text());checks['policy_fail_closed_and_metadata_cache']=True
    lua=host();lua.execute((ROOT/'tests/test_gate.lua').read_text());checks['closed_gate_regression_no_backend_no_writes']=True
    lua=host(True);lua.execute((ROOT/'tests/test_selective.lua').read_text());checks['simulated_selective_swaps_guards_toggle_cleanup']=True
    lua=host(True);lua.execute((ROOT/'tests/test_validation.lua').read_text());checks['validation_off_input_trace_cleanup_and_runtime_disconnect']=True
    for cfg in ('enabled=false','enabled=maybe','toggle_hotkey=invalid','unknown=1','repeat_ms=25','repeat_ms=1001'):
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
    lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().native=lua.execute((ROOT/'src/native_fire.lua').read_text())
    lua.execute((ROOT/'tests/test_native.lua').read_text())
    lua.execute("write_count=0;assert(not pcall(b.begin,b,{},.025) and write_count==0)")
    # A fresh fixture verifies a caller-selected conservative cadence and restoration.
    lua=LuaRuntime(unpack_returned_tuples=True);lua.globals().native=lua.execute((ROOT/'src/native_fire.lua').read_text())
    fixture=(ROOT/'tests/test_native.lua').read_text().replace('assert(b:begin(row)==2);assert(read(bucket+8,20)~=original)',
        "assert(b:begin(row,.2)==2);local f=ffi.new('float[1]');ffi.copy(f,read(bucket+24,4),4);assert(math.abs(tonumber(f[0])-.2)<.000001)")
    lua.execute(fixture);checks['native_mapping_bounds_exact_restore_and_edit_preservation']=True
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
        assert(actual_policy:classify('35a61296619cc47e').category=='IGNORE')
        assert(not actual_policy:classify('1980d92b619ff5fe').allowed)
        assert(core.Diagnostics:Status().scheduler.active==0)
    ''')
    actual_status=plain(lua.eval('actual_policy:status()'));checks['actual_runtime_public_metadata_no_background_work']=True
    policy_entries=[]
    metadata_path=ROOT.parent/'HD2FullAutoAssist/validation/selective-identity-2026-09-28/runtime-public-metadata-expanded.json'
    for weapon in json.loads(metadata_path.read_text())['weapons']:
        metadata=weapon['metadata'];resources=metadata.get('resources',metadata.get('resourceHashes',[]))
        for resource in resources:
            result=plain(lua.globals().actual_policy.classify(lua.globals().actual_policy,resource))
            assert result['allowed']==(weapon['requested_name']=='P-2 Peacemaker')
            policy_entries.append({'requested_name':weapon['requested_name'],'resource_hash':resource,**result})
    # Cancellation of an actual bridge job when the consumer owner unregisters.
    lua.execute('''
        job_steps=0
        public_hd2.read=function()return {status='pending',step=function()job_steps=job_steps+1;return false end}end
        assert(actual_bridge:ReadLegacy('hd2_full_auto_assist',
            {read_target=function()return {resource='fixture',fields={'fixture'}}end},function()error('cancelled')end).ok)
        assert(core:Unregister('hd2_full_auto_assist').ok)
        tick(100);assert(job_steps==0 and actual_bridge:Status().active_reads==0 and core.Diagnostics:Status().scheduler.active==0)
    ''');checks['actual_scheduler_runtime_read_cancellation']=True
    bundle=(ROOT/'build/hd2_full_auto_assist.lua').read_text();lua=host()
    assert lua.eval('loadstring')(bundle) is not None
    assert 'hd2modcore.' not in bundle and 'SendInput' not in bundle and 'VirtualProtect' not in bundle
    lua.execute("package.preload['mods/codex/hd2_mod_core']=function()return core end")
    consumer=lua.execute(bundle);lua.eval('tick(0)')
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
    lua=LuaRuntime(unpack_returned_tuples=True);discover=lua.execute(args.loader_source.read_text())
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
        for file in ('README.md','HD2FullAutoAssist.example.ini','docs/VALIDATION.md','docs/identity-validation.json'):assert z.read(file)==(ROOT/file).read_bytes()
    for file in (ROOT/'src').glob('*.lua'):assert file.read_text() in bundle
    checks['loader_v18_source_archive_package_parity_single_option']=True
    receipt=json.loads((ROOT/'docs/identity-validation.json').read_text())
    assert receipt['identity_validated_for_observed_states'] is True
    report={'checks':checks,'identity_validated':True,'live_selective_firing_tested':False,'game_process_accessed_by_this_runner':False,
        'closed_gate_tested_only_in_memory':True,'hud_implemented':False,'release_ready':False,
        'identity_receipt_sha256':hashlib.sha256((ROOT/'docs/identity-validation.json').read_bytes()).hexdigest(),
        'runtime_metadata_policy':actual_status,
        'policy_entries':policy_entries,
        'source_files':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))},
        'package_sha256':hashlib.sha256((ROOT/'build'/PACKAGE).read_bytes()).hexdigest()}
    (ROOT/'build/selective-checks.json').write_text(json.dumps(report,indent=2)+'\n')
    build=ROOT/'build/build-report.json';data=json.loads(build.read_text());data['offline_tested']=True
    build.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
