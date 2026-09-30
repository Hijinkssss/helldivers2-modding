"""Verify RC3 targets against unmodified pinned exact-build authoring catalogs."""
from pathlib import Path
import argparse, hashlib, json, subprocess
from run_b3 import runtime

ROOT=Path(__file__).resolve().parents[1]
COMMIT='fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595'
DLL='2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E'
EXE='F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06'

def walk(value,name):
    if isinstance(value,dict):
        if value.get('name')==name:yield value
        for child in value.values():yield from walk(child,name)
    elif isinstance(value,list):
        for child in value:yield from walk(child,name)

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--catalog-root',type=Path,required=True)
    base=parser.parse_args().catalog_root
    lua=runtime(ROOT/'src')
    names=lua.eval("require('charge_probe_targets').names")
    targets={str(hash):str(name) for hash,name in names.items()}
    assert set(targets.values())=={'PLAS-39 Accelerator Rifle','40-K Meltagun'} and len(targets)==2
    rows=[]
    for hash,name in sorted(targets.items()):
        filename=('player_weapon_authoring_catalog.json' if name.startswith('PLAS-39') else 'support_weapon_authoring_catalog.json')
        relative='schemas/'+filename;raw=(base/relative).read_bytes()
        pinned=subprocess.check_output(['git','show',COMMIT+':'+relative],cwd=base)
        assert raw.replace(b'\r\n',b'\n')==pinned.replace(b'\r\n',b'\n'),relative
        catalog=json.loads(raw)
        assert catalog['gameFingerprints']=={'dll':DLL,'exe':EXE}
        entries=list(walk(catalog,name));assert len(entries)==1
        entry=entries[0];assert entry['resolution']=='UNIQUE'
        assert [s.removeprefix('0x').lower() for s in entry['resources']]==[hash]
        candidate=catalog['candidates']['0x'+hash.upper()]
        assert candidate['resourceHash'].removeprefix('0x').lower()==hash
        charge=candidate['ownership']['WeaponChargeComponentData']
        assert charge['uniqueOwner'] and charge['ownerCount']==1
        beam=candidate['ownership'].get('BeamWeaponComponentData')
        if name=='40-K Meltagun':assert beam['uniqueOwner'] and beam['ownerCount']==1
        rows.append({'name':name,'resource_hash':hash,'resolution':'UNIQUE',
            'catalog_file':relative,'catalog_sha256':hashlib.sha256(raw).hexdigest(),
            'catalog_matches_pinned_commit':True,'resolved_entry':entry,
            'charge_ownership':charge,'beam_ownership':beam})
    result={'revision':'1.1.0-research-rc3','steam_build':'25480438','catalog_commit':COMMIT,
        'catalog_repository':'https://github.com/SkyeShade/HD2Runtime',
        'source_snapshot':'F5FEE03DCFDB-20260926T222226Z.hd2snap',
        'game_fingerprints':{'dll':DLL,'exe':EXE},'targets':rows,'target_count':2,
        'identity_verified':True,'automation_enabled':False,'live_identity_verified':False}
    (ROOT/'docs/RC3_IDENTITY_EVIDENCE.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print('PASS pinned exact-build identity verification:',targets)

if __name__=='__main__':main()
