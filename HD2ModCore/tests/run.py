"""Run the small LuaJIT 2.1 infrastructure suite without launching the game."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import sys
import zipfile

ROOT=Path(__file__).resolve().parents[1]


def main() -> None:
    parser=argparse.ArgumentParser()
    parser.add_argument('--runtime-path',type=Path,
                        help='directory containing the locally installed lupa package')
    parser.add_argument('--loader-source',type=Path,
                        help='optional BingusSharedLoader/src/discover.lua for real discovery check')
    parser.add_argument('--peer-adapter',type=Path,
                        help='optional CowboyBingus windows_api.lua for FFI order checks')
    args=parser.parse_args()
    if args.runtime_path:
        sys.path.insert(0,str(args.runtime_path.resolve()))
    try:
        from lupa.luajit21 import LuaRuntime
    except ImportError as exc:
        raise SystemExit('Install lupa into a local test directory first: '+str(exc))

    source_path=(ROOT/'src').resolve().as_posix()+'/?.lua'
    for name in ('test_services.lua','test_memory.lua','test_entry.lua',
                 'test_game_state.lua','test_input.lua','test_input_eligibility.lua'):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.globals().package.path=source_path+';'+lua.globals().package.path
        lua.execute((ROOT/'tests'/name).read_text(encoding='utf-8'))
        print(name+': PASS')

    bundle=(ROOT/'build/hd2modcore.lua').read_bytes()
    if not bundle.startswith(b'-- HD2-Addon: mods/codex/hd2_mod_core\n'):
        raise AssertionError('bundle is not a discoverable plaintext resource')
    with zipfile.ZipFile(ROOT/'build/HD2ModCore-v0.3.0-dev-Arsenal.zip') as package:
        manifest=json.loads(package.read('manifest.json'))
        if manifest['Options'][0]['Include']!=['Addon']:
            raise AssertionError('Arsenal package does not deploy Addon directory')
        if (package.read('Addon/9ba626afa44a3aa3.patch_0')!=
                (ROOT/'build/9ba626afa44a3aa3.patch_0').read_bytes()):
            raise AssertionError('Arsenal package archive differs from tested build')
    if args.loader_source:
        lua=LuaRuntime(unpack_returned_tuples=True)
        discover=lua.execute(args.loader_source.read_text(encoding='utf-8'))
        ffi=lua.eval('require("ffi")')
        bit=lua.eval('require("bit")')
        hasher=discover.hasher(ffi,bit)
        archive_path=(ROOT/'build/9ba626afa44a3aa3.patch_0').resolve().as_posix()
        open_file=lua.eval('io.open')
        entries,warnings=discover.scan(lua.table_from([archive_path]),hasher,open_file)
        if len(entries)!=1 or entries[1]!='mods/codex/hd2_mod_core' or len(warnings):
            raise AssertionError('Bingus discovery rejected built archive')
        print('Bingus Shared Loader discovery: PASS')

    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.execute('''
        _G.CowboyBingusModLoader = {api=1, open_log=function(name)
            return {write=function(self, text) return self end,
                    flush=function() return true end,
                    close=function() return true end}
        end}
        _G.update = function(value) return value, nil, "stock" end
        _G.shutdown = function() return "stock_shutdown" end
    ''')
    core=lua.execute(bundle.decode('utf-8'))
    if core.State(core) not in ('degraded','running'):
        raise AssertionError('bundled resource did not initialize')
    result=lua.eval('_G.update("hello")')
    if result!=('hello',None,'stock'):
        raise AssertionError('bundled callback did not forward all values')
    lua.eval('_G.shutdown()')
    if core.State(core)!='stopped':
        raise AssertionError('bundled shutdown did not clean up')
    print('Exact bundled resource load/update/shutdown in isolated LuaJIT host: PASS')

    for first in ('core','consumer'):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.globals().core_source=bundle.decode('utf-8')
        lua.execute('''
            _G.CowboyBingusModLoader={api=1,open_log=function()
                return {write=function(self)return self end,
                    close=function()return true end}
            end}
            _G.update=function(value)return value end
            _G.shutdown=function()end
            _G.consumer_loads=0
            package.preload['mods/codex/hd2_mod_core']=function()
                return assert(loadstring(core_source))()
            end
            package.preload['mods/test_consumer']=function()
                local shared=require('mods/codex/hd2_mod_core')
                assert(shared:OnLoad('test_consumer',function()
                    consumer_loads=consumer_loads+1
                end).ok)
                return shared
            end
        ''')
        if first=='core':
            lua.eval("require('mods/codex/hd2_mod_core')")
        shared=lua.eval("require('mods/test_consumer')")
        if (not lua.eval('rawequal')(shared,
                lua.eval("require('mods/codex/hd2_mod_core')")) or
                lua.globals().consumer_loads!=1):
            raise AssertionError(f'{first}-first loader fixture duplicated the core')
        lua.eval('_G.shutdown()')
        if shared.State(shared)!='stopped':
            raise AssertionError(f'{first}-first loader fixture did not shut down')
    print('Core-first and consumer-first require fixtures: PASS')

    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path=source_path+';'+lua.globals().package.path
    observed_hash=lua.execute('''
        local p=require("hd2modcore.platform_windows").new()
        local ffi=require("ffi")
        assert(type(p:clock_us())=="number")
        assert(type(p:module_address(nil))=="number")
        assert(type(p:module_image_size(nil))=="number")
        local bytes=ffi.new("uint8_t[4]", {65,66,67,68})
        local address=tonumber(ffi.cast("uintptr_t",bytes))
        local region=assert(p:query_region(address))
        assert(region.base<=address and address<region.base+region.size)
        assert(p:read(address,4)=="ABCD")
        return assert(p:module_hash(nil))
    ''')
    expected_hash=hashlib.sha256(Path(sys.executable).read_bytes()).hexdigest().upper()
    if observed_hash!=expected_hash:
        raise AssertionError('Windows adapter module hash differs from Python file hash')
    print('Windows FFI adapter read, region and module SHA-256 smoke test: PASS')
    if args.peer_adapter:
        for order in ('peer_first','core_first'):
            lua=LuaRuntime(unpack_returned_tuples=True)
            lua.globals().package.path=source_path+';'+lua.globals().package.path
            lua.globals().peer_path=args.peer_adapter.resolve().as_posix()
            peer='local f=assert(loadfile(peer_path))(); assert(type(f())=="table")'
            core='assert(require("hd2modcore.platform_windows").new())'
            lua.execute(peer+';'+core if order=='peer_first' else core+';'+peer)
        print('Windows FFI declaration order with peer adapter: PASS')
    report_path=ROOT/'build/build-report.json'
    report=json.loads(report_path.read_text(encoding='utf-8'))
    report['unit_tested']=True
    report['loader_discovery_tested']=bool(args.loader_source)
    report['isolated_bundle_tested']=True
    report['consumer_order_fixture_tested']=True
    report['windows_adapter_smoke_tested']=True
    report['peer_ffi_order_tested']=bool(args.peer_adapter)
    report_path.write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')


if __name__=='__main__':
    main()
