local Fixture=require('hud_fixture')
local Anchor=require('hud_anchor')
local Profile=require('performance_profile')
local host=Fixture.host({backpack=true})
host.profiler=Profile.new(function()return host.reads end,'hud-budget')
local anchor=Anchor.new(host)
for _=1,120 do
    local before=host.reads
    assert(anchor:sample(1920,1080).x==340)
    assert(host.reads-before==16,'Stable six-node HUD exceeded its checked-read budget')
end
local summary=host.profiler:summary()
assert(summary.phases.hud_anchor.count==120)
assert(summary.counters.hud_anchor_reads==1920 and summary.counters.hud_anchor_nodes==720)
-- Recheck flags and links even when the owned strings are typed views.
for _,change in ipairs({'flags','links'})do
    Fixture.populate(function(at,v)host:put(at,v)end,host.base)
    local changed=false
    host.after_read=function(at)
        if at==host.layout.b and not changed then
            changed=true
            local sibling=host.layout.b
            if change=='links' then sibling=nil end
            host:put(host.layout.a,Fixture.widget(180,90,20,24,host.layout.row,nil,
                sibling,2,change~='flags'))
        end
    end
    assert(anchor:sample(1920,1080)==nil,'HUD verification missed '..change..' race')
    host.after_read=nil
end
Fixture.populate(function(at,v)host:put(at,v)end,host.base)
assert(anchor:sample(1920,1080).x==246,'Failed sample left a stale native extent')
local first=0x88000000
host:put(host.layout.b,Fixture.widget(210,90,30,24,host.layout.row,nil,first,7,true))
for i=0,185 do
    host:put(first+i*256,Fixture.widget(210,90,30,24,host.layout.row,nil,
        i<185 and first+(i+1)*256 or nil,7,true))
end
local reads=host.reads
local full=assert(anchor:sample(1920,1080))
assert(full.nodes==192 and host.reads-reads==388,'Maximum tree work is no longer bounded')
assert(host.writes==0)
print('HUD 16-read stable budget, 388-read maximum, topology/flags race checks and opt-in in-memory profiling passed')
