"""Build a separate consumer package. No deployment or live validation."""
from pathlib import Path
import argparse,importlib.util,hashlib,json,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
PACKAGE='HD2FullAutoAssist-v0.1.2-Current-Patch-Validation-Arsenal.zip'
def main():
    p=argparse.ArgumentParser()
    p.add_argument('--core-source',type=Path,default=ROOT.parent/'integrations/HD2ModCore-runtime-candidate')
    p.add_argument('--identity-records',type=Path,required=True,help='Preserved original identity captures; never generated fixtures')
    args=p.parse_args()
    spec=importlib.util.spec_from_file_location('archive_builder',args.core_source/'scripts/build.py')
    builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder);builder.MODULE=MODULE
    lines=[f'-- HD2-Addon: {MODULE}','local factories,loaded={},{}','local builtin_require=require',
        'local function own_require(name)',' if not factories[name] then return builtin_require(name) end',
        ' if not loaded[name] then loaded[name]=factories[name](own_require) end',' return loaded[name]','end']
    for f in sorted((ROOT/'src').glob('*.lua')):
        raw=f.read_bytes().replace(b'\r\n',b'\n')
        assert b'\r' not in raw and b'\0' not in raw and not raw.startswith(b'\xef\xbb\xbf')
        lines += [f'factories[{f.stem!r}]=function(require)',raw.decode(),'end']
    lines += ["local core=require('mods/codex/hd2_mod_core')",
        "return own_require('full_auto_assist').install(core,function(c)return own_require('native_fire').new(c)end)",'']
    source='\n'.join(lines).encode();archive=builder.archive_resource(source);builder.verify_archive(archive,source)
    assert source.count(b'local IDENTITY_VALIDATED=true')==1
    receipt_path=ROOT/'docs/identity-validation.json'
    receipt=json.loads(receipt_path.read_text(encoding='utf-8'))
    assert receipt['identity_validated_for_observed_states'] is True
    assert any(row['resource_hash']=='05e4e5c2db6e44a2' and row['semantic_id']=='weapon:P-2 Peacemaker'
               for row in receipt['validated_resources'])
    assert receipt['captures']
    observer=(args.core_source/'src/hd2modcore/game_state.lua').read_bytes()
    # The preservation repository uses CRLF; the validated observer used LF.
    # Normalize only line endings before comparing the original source receipt.
    observed_source=hashlib.sha256(observer.replace(b'\r\n',b'\n')).hexdigest()
    records=args.identity_records
    for capture in receipt['captures']:
        assert capture['source_sha256']['game_state.lua']==observed_source,'Observer changed after identity proof'
        assert hashlib.sha256((records/capture['file']).read_bytes()).hexdigest()==capture['sha256'],'Identity record changed'
    out=ROOT/'build';out.mkdir(exist_ok=True)
    (out/'hd2_full_auto_assist.lua').write_bytes(source);(out/ARCHIVE).write_bytes(archive)
    manifest={'Version':1,'Guid':'cf368f5c-f686-453f-a566-435b4b7fcf26',
        'Name':'HD2 Full Auto Assist v0.1.2 current-patch validation candidate',
        'Description':'Weapon policy v2, controlled validation only. Balanced default; Native Cap selectable in INI. Requires Core 0.3.2 Runtime candidate, Loader v18 and separately installed Runtime exactly 0.24.0. No dependencies embedded.',
        'Options':[{'Name':'Selective weapon policy validation',
             'Description':'Explicit reviewed weapons only; native Full Auto and charge/hold remain vanilla. AMR Balanced 120 RPM is provisional. Live cadence and performance pending.',
             'Include':['Addon']}]}
    files={'manifest.json':(json.dumps(manifest,indent=2)+'\n').encode(),'Addon/'+ARCHIVE:archive,
        'Addon/'+ARCHIVE+'.stream':b'','Addon/'+ARCHIVE+'.gpu_resources':b''}
    for name in ('README.md','HD2FullAutoAssist.example.ini','HD2FullAutoAssist.validation.ini',
                 'docs/VALIDATION.md','docs/NEXT_TEST.md','docs/identity-validation.json','docs/weapon-policy-evidence.json'):
        if (ROOT/name).exists():files[name]=(ROOT/name).read_bytes()
    with zipfile.ZipFile(out/PACKAGE,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            i=zipfile.ZipInfo(name,(1980,1,1,0,0,0));i.compress_type=zipfile.ZIP_DEFLATED;i.external_attr=0o100644<<16;z.writestr(i,raw)
    report={'source_sha256':hashlib.sha256(source).hexdigest(),'archive_sha256':hashlib.sha256(archive).hexdigest(),
        'package_sha256':hashlib.sha256((out/PACKAGE).read_bytes()).hexdigest(),'offline_tested':False,'live_tested':False,
        'identity_validated':True,'repeating_enabled':True,'hud_implemented':False,
        'identity_receipt_sha256':hashlib.sha256(receipt_path.read_bytes()).hexdigest(),
        'assist_scope':'Explicit weapon policy v2 including Verdict, Diligence, Diligence CS and AMR; current candidate gameplay pending',
        'core_source':str(args.core_source.resolve()),'module':MODULE,'package':PACKAGE,
        'source_files':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))},
        'observer_sha256_lf':observed_source,'observer_sha256_raw':hashlib.sha256(observer).hexdigest(),
        'cadence':{'default_repeat_ms':0,'balanced_ceiling_rpm':380,'amr_balanced_rpm':120,
                   'repeat_ms_zero_means_policy_interval':True,
                   'weapon_cadence_validated':False,'input_attempts_are_not_shots':True},
        'eligibility_changed':True,'embedded_core':False,'embedded_hd2runtime':False,
        'arsenal_options_ui_verified':False}
    (out/'build-report.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Built current-patch selective weapon-policy validation candidate; no installation performed.')
if __name__=='__main__':main()
