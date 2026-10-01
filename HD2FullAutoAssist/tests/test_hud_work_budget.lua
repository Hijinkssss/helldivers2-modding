local Fixture=require('hud_fixture')
local Anchor=require('hud_anchor')
local Profile=require('performance_profile')
local host=Fixture.host({backpack=true})
host.profiler=Profile.new(function()return host.reads end,'hud-budget')
local anchor=Anchor.new(host)
for _=1,120 do
    host.now_us=host.now_us+8333
    assert(anchor:sample(1920,1080).x==340)
end
local summary=host.profiler:summary()
assert(summary.phases.hud_anchor.count==120)
assert(summary.counters.hud_anchor_full_scans==4 and summary.counters.hud_anchor_cache_hits==116)
assert(summary.counters.hud_anchor_reads==528 and summary.counters.hud_anchor_nodes==720,
    'Cached HUD sampling exceeded the 250ms rescan budget')
assert(summary.phases.hud_owner_check.count==120 and summary.phases.hud_ammo_row_check.count==120 and
    summary.phases.hud_cached_verify.count==116,'HUD owner/ammo instrumentation missed cached samples')
assert(summary.counters.hud_owner_reads==120 and summary.counters.hud_ammo_row_reads==120 and
    summary.counters.hud_cached_verify_owner_reads==116 and summary.counters.hud_cached_verify_row_reads==116,
    'HUD owner/ammo read counters do not match the update path')
-- Recheck flags and links even when the owned strings are typed views.
for _,change in ipairs({'flags','links'})do
    Fixture.populate(function(at,v)host:put(at,v)end,host.base)
    host.now_us=host.now_us+250000
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
host.now_us=host.now_us+250000
assert(anchor:sample(1920,1080).x==246,'Failed sample left a stale native extent')
local first=0x88000000
host:put(host.layout.b,Fixture.widget(210,90,30,24,host.layout.row,nil,first,7,true))
for i=0,185 do
    host:put(first+i*256,Fixture.widget(210,90,30,24,host.layout.row,nil,
        i<185 and first+(i+1)*256 or nil,7,true))
end
local reads=host.reads
host.now_us=host.now_us+250000
local full=assert(anchor:sample(1920,1080))
assert(full.nodes==192 and host.reads-reads==388,'Maximum tree work is no longer bounded')
assert(host.writes==0)
print('HUD 16-read stable budget, 388-read maximum, topology/flags race checks and opt-in in-memory profiling passed')
