"""Verify the standalone ZIP, actual Loader discovery and deterministic rebuilding."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,subprocess,sys,tempfile,zipfile
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--loader-discovery',type=Path)
    parser.add_argument('--research',action='store_true');args=parser.parse_args()
    spec=importlib.util.spec_from_file_location('faa_builder',ROOT/'scripts/build.py')
    builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
    if args.research:
        builder.OUTPUT=builder.OUTPUT/'charge-research'
        builder.PACKAGE=builder.PACKAGE.replace('-Arsenal.zip','-Charge-Research-Arsenal.zip')
    archive=builder.OUTPUT/builder.ARCHIVE;package=builder.OUTPUT/builder.PACKAGE
    source=(builder.OUTPUT/'hd2_full_auto_assist.lua').read_bytes()
    builder.verify_archive(archive.read_bytes(),source)
    assert source==builder.bundle(research=args.research)
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
    report=json.loads((builder.OUTPUT/'build-report.json').read_text())
    assert report['external_dependencies']==['Bingus Shared Loader v18 / API 1']
    assert report['offline_tested'] and report['live_standalone_validated'] is False
    assert report['version']==builder.VERSION and report['supported_build']=='25480438'
    assert report['charge_automation_enabled'] is False and report['charge_research_enabled'] is args.research
    if args.research:
        # Execute only the packaged target factory, bypassing all native startup.
        tail="return own_require('lifecycle').start(_G,{charge_research=true})"
        assert source.decode('utf-8').count(tail)==1
        isolated=source.decode('utf-8').replace(tail,"return own_require('charge_probe_targets').names")
        packed_targets=LuaRuntime().execute(isolated)
        targets={str(hash):str(name) for hash,name in packed_targets.items()}
        assert targets=={'6cfcc7f8801a0266':'40-K Meltagun'}
        assert targets==report['charge_probe_targets']
    suffix='-Charge-Research-Arsenal.zip' if args.research else '-Arsenal.zip'
    assert package.name==f'Full-Auto-Assist-{builder.VERSION}'+suffix
    with zipfile.ZipFile(package) as z:
        names=z.namelist();manifest=json.loads(z.read('manifest.json'))
        assert {'README.md','LIVE_TEST.md','HD2FullAutoAssist.example.ini'} <= set(names)
        assert not any('validation.ini' in name.lower() or 'diagnostic' in name.lower() or '/docs/' in name.lower() for name in names)
        example=z.read('HD2FullAutoAssist.example.ini').decode('utf-8')
        for setting in ('enabled = true','user_enabled = true','repeat_ms = 0','toggle_hotkey = =',
                        'debug_logging = false','validation_logging = false','performance_profile = false',
                        'performance_label = unlabeled','fire_rate_mode = balanced'):
            assert setting in example,setting
        assert manifest['Name']==('Full Auto Assist RC4 Meltagun Probe' if args.research else 'Full Auto Assist')
        assert manifest['Description']==report['description']
        assert len(manifest['Options'])==10 and manifest['Options'][0]['Include']==['Core']
        assert z.read('thumbnail.png')==(ROOT/'thumbnail.png').read_bytes()
        assert 'SubOptions' not in manifest['Options'][0]
        assert manifest['Guid']=='cf368f5c-f686-453f-a566-435b4b7fcf26'
        if not args.research:
            assert report['target_release_version']=='1.1.0' and report['supported_weapon_count']==31
            assert report['charge_factories_packaged'] is False
            assert b"version='1.1.0-rc2'" in source
            tail="return own_require('lifecycle').start(_G)"
            assert source.decode().count(tail)==1
            packed_policy=LuaRuntime(unpack_returned_tuples=True).execute(source.decode().replace(tail,"return own_require('weapon_policy').new('balanced')"))
            roster=json.loads((ROOT/'docs/supported-weapons-1.1.0.json').read_text())
            assert len(roster)==31 and len({r['hash'] for r in roster})==31
            for row in roster:
                decision=packed_policy.classify(packed_policy,row['hash'])
                assert decision.allowed and decision.name==row['name']
                assert decision.max_repeat_rpm==row['balanced_rpm']
            for key in ('96de9cd50f7306e6','fb3a19078694708a','aa69a60d74a3ec54','30061f91af477f5e','6cfcc7f8801a0266','ffffffffffffffff'):
                assert not packed_policy.classify(packed_policy,key).allowed

            assert 'CHARGE_REASSESSMENT.md' not in names
            assert b'Meltagun support is not included' in z.read('README.md')
            assert b'actively researching how to implement it for a later update' in z.read('RELEASE_NOTES.md')
        assert report['hud_force_visible_default'] is False and report['hud_diagnostics_record_cap']==120
        assert 'hud_probe_visible = false' in example and 'hud_diagnostics = true' in example
        assert not any('stable_26' in name for name in names)
        for name in ('README.md','CHANGELOG.md','RELEASE_NOTES.md','SUPPORTED_WEAPONS.md','LIVE_TEST.md'):
            if not args.research:
                text=z.read(name).decode()
                assert '26 RPM' not in text and '26/27' not in text
                assert '1.1.0-rc1-Arsenal.zip' not in text
        assert '31 explicitly supported' in z.read('README.md').decode()
        assert 'MLS-4X Commando' in z.read('README.md').decode()
        assert z.read('Core/'+builder.ARCHIVE)==archive.read_bytes()
        for ext in ('.stream','.gpu_resources'):assert z.read('Core/'+builder.ARCHIVE+ext)==b''
        expected={
            'P-2 Peacemaker':[('Balanced',380,'balanced'),('Full Auto',900,'full_auto')],
            'M6C/SOCOM Pistol':[('Balanced',380,'balanced'),('Full Auto',900,'full_auto')],
            'P-69 Veto':[('Balanced',380,'balanced'),('Full Auto',750,'full_auto')],
            'LAS-58 Talon':[('Balanced',210,'balanced'),('Efficiency',60,'efficiency'),
                ('Full Auto',380,'full_auto'),('FULLER AUTO',750,'fuller_auto')],
            'APW-1 Anti-Materiel Rifle':[('Balanced',120,'balanced'),('Full Auto',400,'full_auto')],
            'MLS-4X Commando':[('Balanced',120,'balanced'),('Full Auto',240,'full_auto')],
            'R-4 Hyena':[('Balanced',120,'balanced'),('Full Auto',190,'full_auto')],
            'SG-22 Bushwhacker':[('Balanced',90,'balanced'),('Full Auto',650,'full_auto')],
            'R-36 Eruptor':[('Balanced / default',28,'balanced_28'),('Slower Cadence',27,'slower_27'),('Maximum Full Auto',32,'max_32')],
        }
        assert [row['Name'] for row in manifest['Options'][1:]]==list(expected)
        option_modules=[];option_keys=[]
        for group,(setting,title,profiles) in zip(manifest['Options'][1:],builder.OPTIONS):
            assert group['Name']==title and len(group['SubOptions'])==len(expected[title])
            assert len({child['Name'] for child in group['SubOptions']})==len(group['SubOptions'])
            for child,(label,rpm,mode),(_,_,profile,expected_rpm) in zip(group['SubOptions'],expected[title],profiles):
                assert rpm==expected_rpm and child['Name']==(f'{rpm} RPM - {label}' if setting=='eruptor_profile' else f'{label} ({rpm} RPM)')
                folder=child['Include'][0]
                module=builder.option_module(setting,mode);option_modules.append(module);option_keys.append((setting,mode))
                content=builder.option_bundle(module,setting,mode)
                packed=z.read(folder+'/'+builder.ARCHIVE)
                builder.verify_archive(packed,content,module)
                for ext in ('.stream','.gpu_resources'):assert z.read(folder+'/'+builder.ARCHIVE+ext)==b''
        assert len(option_modules)==len(set(option_modules))
        assert len(option_keys)==len(set(option_keys))
        assert not any('hd2modcore' in name.lower() or 'hd2runtime' in name.lower() for name in names)
        sources={'README.md':ROOT/'docs'/('RC4_CHARGE_PROBE.md' if args.research else '../README.md'),
            'LIVE_TEST.md':ROOT/'docs'/('RC4_LIVE_TEST.md' if args.research else 'RELEASE_1.1.0_LIVE_REVIEW.md'),
            'CHARGE_REASSESSMENT.md':ROOT/'docs/CHARGE_REASSESSMENT.md',
            'RELEASE_NOTES.md':ROOT/'docs/RELEASE_1.1.0.md',
            'SUPPORTED_WEAPONS.md':ROOT/'docs/SUPPORTED_WEAPONS_1.1.0.md'}
        for name in names:
            if name not in ('manifest.json',) and not name.startswith(('Core/','Options/')):
                assert z.read(name)==sources.get(name,ROOT/name).read_bytes(),name
        for f in (ROOT/'src').glob('*.lua'):
            if not args.research and f.stem.startswith('charge_'):
                assert ('factories['+repr(f.stem)+']').encode() not in source
                continue
            assert f.read_bytes().replace(b'\r\n',b'\n') in source
    discovery=False
    if args.loader_discovery:
        lua=LuaRuntime(unpack_returned_tuples=True)
        api=lua.execute(args.loader_discovery.read_text(encoding='utf-8'))
        hasher=api.hasher(lua.eval("require('ffi')"),lua.eval("require('bit')"))
        with tempfile.TemporaryDirectory() as tmp:
            archives=[archive.as_posix()]
            with zipfile.ZipFile(package) as z:
                for name in z.namelist():
                    if name.endswith('/'+builder.ARCHIVE) and name!='Core/'+builder.ARCHIVE:
                        target=Path(tmp)/hashlib.sha256(name.encode()).hexdigest()/builder.ARCHIVE
                        target.parent.mkdir()
                        target.write_bytes(z.read(name));archives.append(target.as_posix())
            entries,warnings=api.scan(lua.table_from(archives),hasher,lua.eval('io.open'))
            found={entries[i] for i in range(1,len(entries)+1)}
            assert found=={builder.MODULE,*option_modules} and len(warnings)==0, (found,option_modules,list(warnings.values()))
        discovery=True
    before=hashlib.sha256(package.read_bytes()).hexdigest()
    subprocess.run([sys.executable,str(ROOT/'scripts/build.py')]+(['--research'] if args.research else []),check=True)
    assert hashlib.sha256(package.read_bytes()).hexdigest()==before,'Nondeterministic package'
    result={'package_file':package.name,'archive_source_zip_parity':True,'bundle_requires_only_builtin_ffi':True,
        'missing_loader_and_unsupported_process_fail_closed':True,'arsenal_profile_groups_and_empty_companions':True,
        'deterministic_rebuild':True,'actual_loader_discovery_checked':discovery,
        'packaged_probe_targets_verified':targets if args.research else None,
        'package_sha256':before,'archive_entries':sorted(names),
        'dependency_audit':{'required':['Bingus Shared Loader v18 / API 1'],'embedded_hd2modcore':False,'embedded_hd2runtime':False},
        'live_standalone_validated':False,
        'live_validation_source':None}
    (builder.OUTPUT/'package-checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
