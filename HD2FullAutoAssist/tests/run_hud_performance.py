"""Matched HUD measurements on owned test memory only; never attaches to a game."""
from pathlib import Path
import json, subprocess, sys, hashlib, statistics
from lupa.luajit21 import LuaRuntime
root=Path(__file__).resolve().parents[1]
repo=root.parent
out=root/'build'
baseline=subprocess.check_output(['git','show','8fbe8d4:HD2FullAutoAssist/src/hud_anchor.lua'],cwd=repo,text=True)
current=(root/'src/hud_anchor.lua').read_text()
results={}
for label,source in [('rc3',baseline),('current',current)]:
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path=f'{root.as_posix()}/src/?.lua;{root.as_posix()}/tests/?.lua;'+lua.globals().package.path
    lua.globals().Anchor=lua.execute(source)
    run=lua.execute('''
        local ffi=require('ffi')
        local Fixture=require('native_transition_fixture')
        local HudFixture=require('hud_fixture')
        local Windows=require('platform').new()
        ffi.cdef[[void *VirtualAlloc(void *,size_t,uint32_t,uint32_t); int VirtualFree(void *,size_t,uint32_t);]]
        local kernel=ffi.load('kernel32')
        return function(extra)
            local f=Fixture.new();local pages,allocations={},{}
            local function put(at,bytes)
                local page=math.floor(at/4096)*4096
                assert(at+#bytes<=page+4096)
                if not pages[page]then
                    local p=assert(kernel.VirtualAlloc(nil,4096,0x3000,4))
                    pages[page]=tonumber(ffi.cast('uintptr_t',p));allocations[#allocations+1]=p
                end
                ffi.copy(ffi.cast('void *',pages[page]+at-page),bytes,#bytes)
            end
            local l=HudFixture.populate(put,f.G,{backpack=true})
            if extra>0 then
                local first=0x88000000
                put(l.b,HudFixture.widget(210,90,30,24,l.row,nil,first,7,true))
                for i=0,extra-1 do
                    put(first+i*256,HudFixture.widget(210+i,90,30,24,l.row,nil,
                        i+1<extra and first+(i+1)*256 or nil,7,true))
                end
            end
            f.platform.clock_us=function()return Windows:clock_us()end
            f.platform.read=function(_,at,n)
                local page=math.floor(at/4096)*4096
                assert(pages[page] and at+n<=page+4096)
                return Windows:read(pages[page]+at-page,n)
            end
            f.platform.query_region=function(_,at)
                local page=math.floor(at/4096)*4096
                local r=assert(Windows:query_region(pages[page]+at-page))
                return {base=page,size=4096,state=r.state,protect=r.protect}
            end
            local anchor=Anchor.new(f.host)
            local good,result=pcall(function()
                for i=1,100 do assert(anchor:sample(1920,1080))end
                local trials={}
                for trial=1,7 do
                    local reads,queries=f.host.reads,f.host.queries
                    local started=Windows:clock_us()
                    for i=1,2000 do
                        local a=assert(anchor:sample(1920,1080))
                        assert(a.nodes==6+extra and a.y==107 and a.scale==1)
                    end
                    trials[trial]={elapsed_us=Windows:clock_us()-started,
                        samples=2000,reads=f.host.reads-reads,queries=f.host.queries-queries}
                end
                return trials
            end)
            for _,p in ipairs(allocations)do assert(kernel.VirtualFree(p,0,0x8000)~=0)end
            assert(good,tostring(result));return result
        end
    ''')
    def plain(t):
        return {str(k):plain(v) if hasattr(v,'items') else v for k,v in t.items()}
    results[label]={}
    for extra in (0,34):
        trials=list(plain(run(extra)).values())
        us=statistics.median(t['elapsed_us']/t['samples'] for t in trials)
        results[label][str(6+extra)]={'median_us_per_sample':us,
            'equivalent_ms_per_second_at_120_hz':us*120/1000,
            'reads_per_sample':trials[0]['reads']/2000,'trials':trials}
report={'kind':'own-process Windows RPM, simulated HUD topology, real FAA lifecycle reads',
    'game_accessed':False,'live_watchdog_after':None,'source_sha256':hashlib.sha256(current.encode()).hexdigest(),
    'results':results}
out.mkdir(exist_ok=True)
(out/'HUD-MEASUREMENTS.json').write_text(json.dumps(report,indent=2)+'\n')
for label,scenarios in results.items():
    for count,r in scenarios.items():
        print(label,count,'nodes:',round(r['median_us_per_sample'],2),'us/sample;',r['reads_per_sample'],'reads/sample')
