local F=require('native_transition_fixture')
local Signals=require('charge_signals')
local Observer=require('charge_observer')
local Research=require('charge_research')
local function tables(f)
    local function row(rva,manager,mapoff,rowoff,stride,raw,entityoff,commandoff,extraoff)
        local map,rows=manager+0x1000,manager+0x2000
        f:put(f.G+rva,f.ptr(manager));f:put(manager+mapoff,f.ptr(map)..f.u32(8)..f.u32(0xffffffff)..f.u32(1))
        f:put(map+0xa9%8*8,f.u32(0xa9)..f.u32(0));f:put(manager+rowoff,f.ptr(rows));f:put(rows,raw)
        if entityoff then f:put(manager+entityoff,f.ptr(manager+0x3000));f:put(manager+0x3000,f.ptr(f.ERECORD))end
        if commandoff then f:put(manager+commandoff,f.ptr(manager+0x4000));f:put(manager+0x4000,'\1')end
        if extraoff then f:put(manager+extraoff,f.ptr(manager+0x5000));f:put(manager+0x5000,string.rep('\0',12))end
        return rows,map
    end
    local trigger,tmap=row(0x3326660,0x91000000,40,80,40,f.u32(0x6000)..string.rep('\0',36),64,88)
    local beam,bmap=row(0x33266d8,0x92000000,80,120,168,'\1\1\0\0'..f.u32(1)..f.float(.75))
    local ammo,amap=row(0x3326648,0x93000000,32,72,16,f.u32(3)..string.rep('\0',12),nil,nil,80)
    return trigger,beam,ammo,tmap,bmap,amap
end
local f=F.new();f:weapon('6cfcc7f8801a0266');f:tick()
local trigger,beam,ammo,tmap,bmap=tables(f)
local signals=Signals.new(f.host);local state=f.consumer:get_state()
local sample=signals:sample(state)
assert(sample.fire.state=='observed' and sample.fire.physical_binding_verified==false)
assert(sample.trigger.command==1 and #sample.trigger.raw_hex==80)
assert(sample.beam.current_flag==1 and sample.beam.request_flag==1 and sample.beam.timer==.75)
assert(#sample.ammo.raw_hex==32 and #sample.ammo.extra_hex==24)
local discoveries=signals.discoveries;local reads=f.host.reads
for _=1,100 do signals:sample(state)end
assert(signals.discoveries==discoveries and signals.cache_hits==300 and f.writes==0)
assert(f.host.reads-reads<=5000,'Targeted signals exceed read budget')
-- A native beam end and empty count are observations only, never a Fire lease.
f:put(beam,'\0\0\0\0'..f.u32(1)..f.float(0));f:put(ammo,f.u32(0))
sample=signals:sample(state);assert(sample.beam.current_flag==0 and sample.beam.timer==0)
assert(sample.ammo.raw_hex:sub(1,8)=='00000000' and f.writes==0 and not f.backend.lease)
-- A relocated runtime array is followed, not reused; racing parents fail closed.
local moved=0x94000000;f:put(moved,f:bytes(beam,12));f:put(0x92000000+120,f.ptr(moved))
assert(signals:sample(state).beam.timer==0)
f.failed_read=0x92000000+80;assert(signals:sample(state).beam.state=='unavailable');f.failed_read=nil
f:put(bmap+0xa9%8*8,f.u32(0xffffffff)..f.u32(0))
assert(signals:sample(state).beam.state=='row_absent');discoveries=signals.discoveries
for _=1,100 do signals:sample(state)end
assert(signals.discoveries==discoveries,'Absent beam binding rediscovered each update')
f.now=f.now+250000;signals:sample(state);assert(signals.discoveries==discoveries+1)
-- Generation changes reject even if the same entity address and ID survived.
f:put(f.ERECORD+16,'\1');assert(signals:sample(state).trigger.state=='unavailable')
assert(signals:sample(state).trigger.state=='unavailable','Clearing cache must not accept a stale generation token')
assert(f.consumer:stop().ok and f.writes==0)
-- No beam read occurs for the three charge-release weapons; Arc has no ammo read.
for _,hash in ipairs({'96de9cd50f7306e6','fb3a19078694708a','aa69a60d74a3ec54'})do
    f=F.new();f:weapon(hash);f:tick();tables(f);signals=Signals.new(f.host)
    sample=signals:sample(f.consumer:get_state());assert(sample.beam==nil)
    assert((sample.ammo~=nil)==(hash~='96de9cd50f7306e6'));assert(f.writes==0)
    assert(f.consumer:stop().ok)
end
-- File rejection/failure is informative, and even failed flush always closes.
f=F.new()
local ok,why=pcall(Research.new,f.host,function()return {}end,{open_log=function(name)
    assert(name:match('^[%w_-]+%.log$'));return nil
end})
assert(not ok and tostring(why):find(Research.filename,1,true))
local closed=0;local failed=false
local fake={write=function(self)return self end,flush=function()if failed then error('disk failed')end;return true end,
    close=function()closed=closed+1;return true end}
local research=Research.new(f.host,function()return {identity_observed=false}end,{open_log=function()return fake end})
failed=true;assert(not pcall(research.close,research) and closed==1 and research.closed)
research:close();assert(closed==1)
-- Sample limit closes once, including the tail. No waits or gameplay are involved.
local old_new=Observer.new
Observer.new=function()return {sample=function()return {state='raw_observed',identity_token='fixture'}end}end
local old_signals=Signals.new;Signals.new=function()return {sample=function()return {}end}end
local texts={};fake={write=function(self,s)texts[#texts+1]=s;return self end,flush=function()return true end,close=function()return true end}
research=Research.new(f.host,function()return {}end,{open_log=function()return fake end})
Observer.new=old_new;Signals.new=old_signals
for _=1,6001 do f.now=f.now+1000;research:tick()end
assert(research.closed and research.samples==6000 and table.concat(texts):find('research_end',1,true))
assert(f.consumer:stop().ok)
print('PASS targeted charge probe: native snapshots, cache, absence backoff, zero writes, logger failures and bounded cleanup')
