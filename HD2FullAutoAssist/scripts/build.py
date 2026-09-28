"""Build a separate consumer package. No deployment or live validation."""
from pathlib import Path
import argparse,importlib.util,hashlib,json,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
PACKAGE='HD2FullAutoAssist-v0.1.1-Selective-Live-Validation-Arsenal.zip'
def main():
    p=argparse.ArgumentParser();p.add_argument('--core-source',type=Path,default=ROOT.parent/'HD2ModCore-runtime-candidate');args=p.parse_args()
    spec=importlib.util.spec_from_file_location('archive_builder',args.core_source/'scripts/build.py')
    builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder);builder.MODULE=MODULE
    lines=[f'-- HD2-Addon: {MODULE}','local factories,loaded={},{}','local builtin_require=require',
        'local function own_require(name)',' if not factories[name] then return builtin_require(name) end',
        ' if not loaded[name] then loaded[name]=factories[name](own_require) end',' return loaded[name]','end']
    for f in sorted((ROOT/'src').glob('*.lua')):
        raw=f.read_bytes();assert b'\r' not in raw and b'\0' not in raw
        lines += [f'factories[{f.stem!r}]=function(require)',raw.decode(),'end']
    lines += ["local core=require('mods/codex/hd2_mod_core')",
        "return own_require('full_auto_assist').install(core,function(c)return own_require('native_fire').new(c)end)",'']
    source='\n'.join(lines).encode();archive=builder.archive_resource(source);builder.verify_archive(archive,source)
    assert source.count(b'local IDENTITY_VALIDATED=true')==1
    receipt_path=ROOT/'docs/identity-validation.json'
    receipt=json.loads(receipt_path.read_text())
    assert receipt['identity_validated_for_observed_states'] is True
    assert any(row['resource_hash']=='05e4e5c2db6e44a2' and row['semantic_id']=='weapon:P-2 Peacemaker'
               for row in receipt['validated_resources'])
    assert receipt['captures']
    observed_source=hashlib.sha256((args.core_source/'src/hd2modcore/game_state.lua').read_bytes()).hexdigest()
    records=ROOT.parent/'HD2FullAutoAssist/validation/selective-identity-2026-09-28'
    for capture in receipt['captures']:
        assert capture['source_sha256']['game_state.lua']==observed_source,'Observer changed after identity proof'
        assert hashlib.sha256((records/capture['file']).read_bytes()).hexdigest()==capture['sha256'],'Identity record changed'
    out=ROOT/'build';out.mkdir(exist_ok=True)
    (out/'hd2_full_auto_assist.lua').write_bytes(source);(out/ARCHIVE).write_bytes(archive)
    manifest={'Version':1,'Guid':'cf368f5c-f686-453f-a566-435b4b7fcf26',
        'Name':'HD2 Full Auto Assist v0.1.1 selective live validation candidate',
        'Description':'Selective firing validation, not release ready. Only Peacemaker is approved for assistance. Requires Core v0.3.2 Runtime candidate, Loader v18 and separately installed HD2Runtime 0.24.0+. Missing Runtime leaves vanilla.',
        'Options':[{'Name':'Selective Peacemaker validation',
             'Description':'One explicit assist candidate; Amendment, AMR and all unsupported identities remain vanilla. No universal or Maximum variant. Selective firing/performance pending.',
             'Include':['Addon']}]}
    files={'manifest.json':(json.dumps(manifest,indent=2)+'\n').encode(),'Addon/'+ARCHIVE:archive,
        'Addon/'+ARCHIVE+'.stream':b'','Addon/'+ARCHIVE+'.gpu_resources':b''}
    for name in ('README.md','HD2FullAutoAssist.example.ini','docs/VALIDATION.md','docs/identity-validation.json'):
        if (ROOT/name).exists():files[name]=(ROOT/name).read_bytes()
    with zipfile.ZipFile(out/PACKAGE,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            i=zipfile.ZipInfo(name,(1980,1,1,0,0,0));i.compress_type=zipfile.ZIP_DEFLATED;i.external_attr=0o100644<<16;z.writestr(i,raw)
    report={'source_sha256':hashlib.sha256(source).hexdigest(),'archive_sha256':hashlib.sha256(archive).hexdigest(),
        'package_sha256':hashlib.sha256((out/PACKAGE).read_bytes()).hexdigest(),'offline_tested':False,'live_tested':False,
        'identity_validated':True,'repeating_enabled':True,'hud_implemented':False,
        'identity_receipt_sha256':hashlib.sha256(receipt_path.read_bytes()).hexdigest(),
        'assist_scope':'P-2 Peacemaker only; gameplay validation pending',
        'core_source':str(args.core_source.resolve()),'module':MODULE,'package':PACKAGE,
        'source_files':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))},
        'cadence':{'default_repeat_ms':125,'peacemaker_provisional_max_repeat_rpm':480,
                   'weapon_cadence_validated':False,'input_attempts_are_not_shots':True},
        'eligibility_changed':True,'embedded_core':False,'embedded_hd2runtime':False,
        'arsenal_options_ui_verified':False}
    (out/'build-report.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Built Peacemaker-only selective validation candidate; no installation performed.')
if __name__=='__main__':main()
