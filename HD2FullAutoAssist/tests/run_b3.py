"""Offline B3 regression and identical native-work comparison. No game access."""
from pathlib import Path
import hashlib,json,subprocess,tempfile,sys
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
BASE='be04ea15359b505bf953ef22d747e8f5e2de013e'
def runtime(src):
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path=f'{src.as_posix()}/?.lua;{(ROOT/"tests").as_posix()}/?.lua;'+lua.globals().package.path
    return lua
def plain(value):
    if hasattr(value,'items'):return {str(k):plain(v) for k,v in value.items()}
    return value
def work(src,scenario):
    lua=runtime(src);lua.globals().scenario=scenario
    return plain(lua.execute('''
        local Policy=require('weapon_policy');local original=Policy.new;local classifications=0
        Policy.new=function(...)
            local policy=original(...);local classify=policy.classify
            policy.classify=function(...)classifications=classifications+1;return classify(...)end
            return policy
        end
        local f=require('native_transition_fixture').new()
        if scenario=='ship_idle' then f:game_state(1)
        elseif scenario=='unsupported_idle' or scenario=='unsupported_held' then f:weapon('968211c0033dce64') end
        f:tick(5000)
        if scenario=='active_fire' or scenario=='unsupported_held' then f:fire(true);f:tick(5000) end
        local reads,queries=f.host.reads,#f.queries
        local initial=f.host:diagnostics().observer
        local changed=f.consumer:status().counters.identity_changes
        local initial_classifications=classifications
        local maximum_reads,maximum_queries=0,0
        for i=1,1000 do
            local r,q=f.host.reads,#f.queries
            f:tick(5000)
            maximum_reads=math.max(maximum_reads,f.host.reads-r)
            maximum_queries=math.max(maximum_queries,#f.queries-q)
        end
        f:healthy()
        local final=f.host:diagnostics().observer
        local result={updates=1000,simulated_seconds=5,reads=f.host.reads-reads,
            page_queries=#f.queries-queries,max_reads=maximum_reads,max_queries=maximum_queries,
            observer_calls=final.calls-initial.calls,
            discoveries=final.discoveries and final.discoveries-initial.discoveries or final.calls-initial.calls,
            cache_hits=final.cache_hits and final.cache_hits-initial.cache_hits or 0,
            identity_changes=f.consumer:status().counters.identity_changes-changed,
            policy_classifications=classifications-initial_classifications,
            mapping_writes=f.writes}
        assert(f.consumer:stop().ok and f:restored())
        return result
    '''))
def main():
    passed=[]
    for name in ('test_b3_cache.lua','test_b3_cadence.lua','test_b3_windows_reads.lua'):
        runtime(ROOT/'src').execute((ROOT/'tests'/name).read_text())
        passed.append(name);print('PASS',name)
    with tempfile.TemporaryDirectory(dir=ROOT/'build') as temp:
        src=Path(temp)
        files=subprocess.check_output(['git','ls-tree','--name-only',BASE,'HD2FullAutoAssist/src/'],cwd=ROOT.parent,text=True).splitlines()
        for file in files:
            if file.endswith('.lua'):
                (src/Path(file).name).write_bytes(subprocess.check_output(['git','show',BASE+':'+file],cwd=ROOT.parent))
        results={}
        for scenario in ('ship_idle','unsupported_idle','supported_idle','unsupported_held','active_fire'):
            before,after=work(src,scenario),work(ROOT/'src',scenario)
            results[scenario]={'before':before,'after':after}
            print(scenario,json.dumps(results[scenario],sort_keys=True))
            assert after['policy_classifications']==0,(scenario,after)
            assert after['discoveries']==0,(scenario,after)
            assert after['page_queries']<before['page_queries']/5,(scenario,before,after)
            assert after['max_reads']<=55,(scenario,after)
            assert after['max_queries']<=(25 if scenario=='active_fire' else 20),(scenario,after)
            if scenario=='ship_idle':assert after['reads']<=3200 and after['max_reads']<=6
            elif scenario in ('supported_idle','unsupported_idle'):assert after['reads']<=5000 and after['max_reads']<=40
            elif scenario=='unsupported_held':assert after['reads']<=12000
            else:assert after['reads']<=55000
    report={'baseline_commit':BASE,'offline_only':True,'game_process_accessed':False,
        'live_performance_validated':False,'passed':passed,'work_budgets':results,
        'source_sha256':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}}
    (ROOT/'build/b3-checks.json').write_text(json.dumps(report,indent=2)+'\n')
if __name__=='__main__':main()
