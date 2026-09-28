"""Targeted bridge checks after implementation; never launches or accesses HD2."""
from pathlib import Path
import argparse
import hashlib
import json
import sys
import zipfile

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--runtime-path',type=Path,required=True)
    parser.add_argument('--hd2runtime-source',type=Path,required=True)
    parser.add_argument('--loader-source',type=Path,required=True)
    args=parser.parse_args()
    sys.path.insert(0,str(args.runtime_path))
    from lupa.luajit21 import LuaRuntime
    source=(ROOT/'src/?.lua').resolve().as_posix()
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path=source+';'+lua.globals().package.path
    lua.execute('''
        Bridge=require('hd2modcore.integration_hd2runtime')
        function host()
            local callbacks,unload={},{}
            local core={Hooks={},Logger={}}
            function core:State()return 'running'end
            function core:OnUnload(owner,fn)unload[owner]=fn;return {ok=true}end
            function core.Hooks:Subscribe(owner,phase,opts,fn)
                assert(phase=='after_update');local token={};callbacks[token]=fn
                return {ok=true,value=token}
            end
            function core.Hooks:Remove(token)callbacks[token]=nil end
            function core.Logger:Emit(...)end
            local function tick()
                for _,fn in pairs(callbacks)do fn()end
            end
            local function count()local n=0;for _ in pairs(callbacks)do n=n+1 end;return n end
            return core,tick,count,unload
        end
        local core,tick,count,unload=host()
        local imports,reads,writes=0,0,0
        local runtime={api_version=1,version='0.24.0'}
        runtime.weapon=function(name)
            if name=='bad'then error('unknown target')end
            return {describe=function()return {name=name,fire_modes={'semi'}}end,
                read_target=function()return {resource='amr',fields={'crosshair_type'}}end}
        end
        runtime.read=function(request)
            reads=reads+1;local job={status='pending'}
            function job.step()
                job.status='complete';job.result={mode='fixture',stable_snapshot=true};return true
            end
            return job
        end
        runtime.patch=function()writes=writes+1;error('bridge must not call writers')end
        local bridge=Bridge.new(core,function(name)
            imports=imports+1;assert(name=='mods/skyeshade/hd2runtime');return runtime
        end)
        assert(imports==0 and count()==0 and bridge:Status().state=='not_checked')
        assert(not bridge:Target('weapon','sample').ok)
        assert(bridge:Connect().ok and bridge:Connect().ok and imports==1)
        assert(bridge:Status().build_support=='not_checked')
        assert(bridge:Describe('weapon','sample').value.name=='sample')
        assert(not bridge:Target('entity','sample').ok and not bridge:Target('weapon','bad').ok)
        local target=bridge:Target('weapon','sample').value
        local results=0
        assert(bridge:ReadLegacy('reader',target,function(result)
            assert(result.mode=='fixture');results=results+1
        end).ok)
        assert(not bridge:ReadLegacy('reader',target,function()end).ok)
        assert(count()==1 and reads==1)
        tick();assert(results==1 and count()==0 and bridge:Status().active_reads==0)
        assert(bridge:ReadLegacy('reader',target,function()error('cancelled callback')end).ok)
        unload.reader();assert(count()==0 and bridge:Status().active_reads==0)
        for i=1,8 do assert(bridge:ReadLegacy('r'..i,target,function()end).ok)end
        assert(not bridge:ReadLegacy('ninth',target,function()end).ok)
        for i=1,8 do unload['r'..i]()end
        assert(count()==0 and writes==0)
        runtime.read=function()
            return {status='pending',step=function()error('read failed')end}
        end
        local rejected=0
        assert(bridge:ReadLegacy('failure',target,function()error('not successful')end,
            function(error)assert(error.code=='ReadFailed');rejected=rejected+1 end).ok)
        tick();assert(rejected==1 and count()==0 and bridge:Status().active_reads==0)
        local absent_calls=0
        local absent=Bridge.new(core,function()absent_calls=absent_calls+1;error('not installed')end)
        assert(not absent:Connect().ok and not absent:Connect().ok and absent_calls==1)
        for _,value in ipairs({{api_version=2,version='0.24.0'},
            {api_version=1,version='0.23.2'},{api_version=1,version='bad'}})do
            assert(not Bridge.new(core,function()return value end):Connect().ok)
        end
    ''')
    checks={'bridge_contracts':True}
    bundle=(ROOT/'build/hd2modcore.lua').read_text(encoding='utf-8')
    for order in ('core_first','runtime_first'):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.globals().runtime_root=args.hd2runtime_source.resolve().as_posix()
        lua.execute('''
            table.insert(package.loaders,1,function(name)
                if name:sub(1,11)=='hd2runtime/'then
                    return assert(loadfile(runtime_root..'/'..name:sub(12)..'.lua'))
                end
            end)
            package.preload['mods/skyeshade/hd2runtime']=function()
                return require('hd2runtime/api/hd2')
            end
            CowboyBingusModLoader={api=1,open_log=function()
                return {write=function()end,close=function()end,flush=function()end}
            end}
            update=function(v)return v,nil,'stock'end
            shutdown=function()return 'stock_shutdown'end
        ''')
        if order=='runtime_first':
            lua.eval("require('hd2runtime/runtime/windows_ffi')")
        core=lua.execute(bundle)
        bridge=core.Integrations.HD2Runtime
        connected=bridge.Connect(bridge)
        if not connected.ok:
            raise AssertionError('actual runtime metadata did not connect: '+str(connected.error.detail))
        described=bridge.Describe(bridge,'weapon','AR-23 Liberator')
        if not described.ok:
            raise AssertionError('actual runtime semantic lookup failed')
        if order=='core_first':
            lua.eval("require('hd2runtime/runtime/windows_ffi')")
        if lua.eval('update(7)')!=(7,None,'stock'):
            raise AssertionError('stock callback results changed')
        if core.Diagnostics.Status(core.Diagnostics).scheduler.active!=0:
            raise AssertionError('metadata connection installed background work')
        lua.eval('shutdown()')
        if core.State(core)!='stopped':
            raise AssertionError('Core cleanup failed')
        checks[order+'_actual_metadata_and_ffi']=True
    lua=LuaRuntime(unpack_returned_tuples=True)
    discover=lua.execute(args.loader_source.read_text(encoding='utf-8'))
    hasher=discover.hasher(lua.eval('require("ffi")'),lua.eval('require("bit")'))
    paths=lua.table_from([(ROOT/'build/9ba626afa44a3aa3.patch_0').resolve().as_posix()])
    entries,warnings=discover.scan(paths,hasher,lua.eval('io.open'))
    assert len(entries)==1 and entries[1]=='mods/codex/hd2_mod_core' and len(warnings)==0
    checks['loader_v18_discovery']=True
    package=ROOT/'build/HD2ModCore-v0.3.2-Runtime-Candidate-Arsenal.zip'
    with zipfile.ZipFile(package) as archive:
        assert len(archive.namelist())==4
        assert archive.read('Addon/9ba626afa44a3aa3.patch_0')==(ROOT/'build/9ba626afa44a3aa3.patch_0').read_bytes()
        assert b'hd2runtime/runtime/' not in archive.read('Addon/9ba626afa44a3aa3.patch_0')
    checks['package_parity_and_no_embedded_runtime']=True
    report={'checks':checks,'game_tested':False,'game_process_accessed':False,
        'live_read_tested':False,'writer_integration':False,
        'package_sha256':hashlib.sha256(package.read_bytes()).hexdigest()}
    (ROOT/'build/bridge-checks.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    build_path=ROOT/'build/build-report.json'
    build=json.loads(build_path.read_text(encoding='utf-8'))
    build.update(bridge_contracts_tested=True,actual_hd2runtime_metadata_tested=True,
        loader_discovery_tested=True,isolated_bundle_tested=True,peer_ffi_order_tested=True,
        full_offline_suite_rerun=False,hd2runtime_live_read_tested=False,
        hd2runtime_game_coexistence_tested=False,hd2runtime_dependency_optional=True,
        hd2runtime_source_vendored=False)
    build_path.write_text(json.dumps(build,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
