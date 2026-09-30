"""Main-to-candidate native-work parity, semantic tests and research budgets."""
from pathlib import Path
import hashlib,json,subprocess,tempfile
from run_b3 import runtime,plain,work
ROOT=Path(__file__).resolve().parents[1]
BASE='2bba9ab85ab2f1264a310e9aa77168a9e22a5185'
HASHES={'Arc':'96de9cd50f7306e6','Purifier':'fb3a19078694708a',
        'Loyalist':'aa69a60d74a3ec54','Meltagun':'6cfcc7f8801a0266'}
def charge_idle(src,weapon,held=False):
    lua=runtime(src);lua.globals().weapon_hash=weapon;lua.globals().held=held
    return plain(lua.execute('''
        local f=require('native_transition_fixture').new()
        f:weapon(weapon_hash);f:tick(5000)
        f:fire(held);f:tick(5000)
        local before=f.host:diagnostics().observer
        local reads,queries=f.host.reads,#f.queries
        for _=1,1000 do f:tick(5000)end
        local after=f.host:diagnostics().observer
        assert(not f.backend.lease and f.writes==0)
        local out={updates=1000,native_reads=f.host.reads-reads,page_queries=#f.queries-queries,
            identity_rediscoveries=after.discoveries-before.discoveries,expensive_scans=0,
            mapping_writes=f.writes,automation_enabled=false}
        assert(f.consumer:stop().ok and f:restored());return out
    '''))
def main():
    lua=runtime(ROOT/'src');lua.execute((ROOT/'tests/test_next_version.lua').read_text())
    research=plain(lua.globals().NEXT_RESEARCH_BUDGETS)
    with tempfile.TemporaryDirectory(dir=ROOT/'build') as temp:
        src=Path(temp)
        files=subprocess.check_output(['git','ls-tree','--name-only',BASE,'HD2FullAutoAssist/src/'],cwd=ROOT.parent,text=True).splitlines()
        for file in files:
            if file.endswith('.lua'):
                (src/Path(file).name).write_bytes(subprocess.check_output(['git','show',BASE+':'+file],cwd=ROOT.parent))
        parity={}
        for scenario in ('ship_idle','unsupported_idle','supported_idle','unsupported_held','active_fire'):
            before,after=work(src,scenario),work(ROOT/'src',scenario)
            assert before==after,(scenario,before,after)
            parity[scenario]={'main':before,'candidate':after,'identical_native_work':True}
            print('PASS main native-work parity:',scenario)
        for name,weapon in HASHES.items():
            for held in (False,True):
                before,after=charge_idle(src,weapon,held),charge_idle(ROOT/'src',weapon,held)
                assert before==after and after['identity_rediscoveries']==0
                parity[name+('_manual_hold' if held else '_idle')]={'main':before,'candidate':after,'identical_native_work':True}
    report={'passed':True,'base_commit':BASE,'game_process_accessed':False,'live_validated':False,
        'charge_automation_enabled':False,'native_work_parity':parity,'research_budgets':research,
        'hud_added_native_reads':0,'hud_added_page_queries':0,
        'charge_active_cycle_budgets':{name:{'status':'pending native evidence and input integration'} for name in HASHES},
        'source_sha256':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}}
    (ROOT/'build/next-version-checks.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS unpublished next-version work and evidence gates')
if __name__=='__main__':main()
