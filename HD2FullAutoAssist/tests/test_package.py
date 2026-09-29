"""Verify the standalone ZIP, actual Loader discovery and deterministic rebuilding."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,subprocess,sys,zipfile
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--loader-discovery',type=Path);args=parser.parse_args()
    spec=importlib.util.spec_from_file_location('faa_builder',ROOT/'scripts/build.py')
    builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
    archive=ROOT/'build'/builder.ARCHIVE;package=ROOT/'build'/builder.PACKAGE
    source=(ROOT/'build/hd2_full_auto_assist.lua').read_bytes()
    builder.verify_archive(archive.read_bytes(),source)
    assert source==builder.bundle()
    assert b"mods/codex/hd2_mod_core" not in source and b"mods/skyeshade/hd2runtime" not in source
    lua=LuaRuntime(unpack_returned_tuples=True)
    assert lua.eval('loadstring')(source.decode('utf-8')) is not None
    # Only built-in FFI is allowed; Core/Runtime and filesystem Lua paths cannot load.
    lua.execute('''
        real_require=require
        require=function(name)assert(name=='ffi','External dependency: '..name);return real_require(name)end
        stock_update=function()end;update=stock_update
    ''')
    lua.globals().source=source.decode('utf-8')
    lua.execute('''
        local good,why=pcall(assert(loadstring(source)))
        assert(not good and tostring(why):find('Bingus Shared Loader required',1,true))
        assert(update==stock_update and not HD2FullAutoAssistStandalone)
    ''')
    lua.execute('''CowboyBingusModLoader={api=1,open_log=function()error('should not open before build guard')end}''')
    # Runner process has no game.dll. Windows FFI creation or exact fingerprint guard
    # must fail safely; no game process is opened and no callbacks may be installed.
    lua.execute('''
        local good=pcall(assert(loadstring(source)))
        assert(not good and update==stock_update and not HD2FullAutoAssistStandalone)
    ''')
    report=json.loads((ROOT/'build/build-report.json').read_text())
    assert report['external_dependencies']==['Bingus Shared Loader v18 / API 1']
    assert report['offline_tested'] and not report['live_standalone_validated']
    with zipfile.ZipFile(package) as z:
        names=z.namelist();manifest=json.loads(z.read('manifest.json'))
        assert len(manifest['Options'])==1 and manifest['Options'][0]['Include']==['Addon']
        assert 'SubOptions' not in manifest['Options'][0]
        assert manifest['Guid']=='cf368f5c-f686-453f-a566-435b4b7fcf26'
        assert z.read('Addon/'+builder.ARCHIVE)==archive.read_bytes()
        for ext in ('.stream','.gpu_resources'):assert z.read('Addon/'+builder.ARCHIVE+ext)==b''
        assert not any('hd2modcore' in name.lower() or 'hd2runtime' in name.lower() for name in names)
        for name in names:
            if name not in ('manifest.json',) and not name.startswith('Addon/'):
                assert z.read(name)==(ROOT/name).read_bytes(),name
        for f in (ROOT/'src').glob('*.lua'):assert f.read_bytes().replace(b'\r\n',b'\n') in source
    discovery=False
    if args.loader_discovery:
        lua=LuaRuntime(unpack_returned_tuples=True)
        api=lua.execute(args.loader_discovery.read_text(encoding='utf-8'))
        hasher=api.hasher(lua.eval("require('ffi')"),lua.eval("require('bit')"))
        entries,warnings=api.scan(lua.table_from([archive.as_posix()]),hasher,lua.eval('io.open'))
        assert len(entries)==1 and entries[1]==builder.MODULE and len(warnings)==0
        discovery=True
    before=hashlib.sha256(package.read_bytes()).hexdigest()
    subprocess.run([sys.executable,str(ROOT/'scripts/build.py')],check=True)
    assert hashlib.sha256(package.read_bytes()).hexdigest()==before,'Nondeterministic package'
    result={'archive_source_zip_parity':True,'bundle_requires_only_builtin_ffi':True,
        'missing_loader_and_unsupported_process_fail_closed':True,'single_option_and_empty_companions':True,
        'deterministic_rebuild':True,'actual_loader_discovery_checked':discovery,
        'package_sha256':before,'live_standalone_validated':False}
    (ROOT/'build/package-checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
