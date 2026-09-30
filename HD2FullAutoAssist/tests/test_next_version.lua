local Policy=require('weapon_policy')
local Fixture=require('native_transition_fixture')
local Hud=require('hud_indicator')
local Cycle=require('charge_cycle')
local Observer=require('charge_observer')
NEXT_RESEARCH_BUDGETS={}
-- Exact policy values, actual native lease and unchanged generic scheduler.
local eruptor='b6aff2195568767f'
for profile,rpm in pairs({stable_26=26,balanced_27=27,fast_28=28,max_32=32,balanced=26,full_auto=32})do
    for _,mode in ipairs({'balanced','native_cap'})do
        local policy=Policy.new(mode,'balanced',{eruptor_profile=profile})
        local decision=policy:classify(eruptor)
        assert(decision.max_repeat_rpm==rpm and decision.repeat_seconds==60/rpm)
        assert(policy:classify('7b75e5132ffd4ca6').max_repeat_rpm==60,'Constitution changed')
        local f=Fixture.new('fire_rate_mode='..mode..'\neruptor_profile='..profile)
        f:weapon(eruptor);f:tick();f:fire(true);f:tick();f:healthy()
        assert(f.backend.lease and f.backend.repeat_seconds==60/rpm)
        f:fire(false);f:tick();assert(f:restored());assert(f.consumer:stop().ok)
    end
end
local charge_hashes={'96de9cd50f7306e6','fb3a19078694708a','aa69a60d74a3ec54','6cfcc7f8801a0266'}
for _,hash in ipairs(charge_hashes)do
    assert(not Policy.new():classify(hash).allowed,'Unverified charge automation enabled')
    local f=Fixture.new();f:weapon(hash);f:tick();f:fire(true);f:tick()
    assert(not f.backend.lease and f.writes==0 and not f.consumer:get_hud_state().visible)
    assert(f.consumer:stop().ok)
end
-- Shared semantic machine. These observations are synthetic, not native proof.
local function observation(identity,state)
    return {identity=identity,state=state,valid=true,enabled=true,can_fire=true,physical_held=true}
end
for _,weapon in ipairs({'Arc','Purifier','Loyalist'})do
    local c=Cycle.new('release_at_ready')
    for _=1,4 do
        assert(c:step(observation(weapon,'charging')).action=='hold')
        assert(c:step(observation(weapon,'ready')).action=='release')
        assert(c:step(observation(weapon,'firing')).action=='release')
        assert(c:step(observation(weapon,'recovering')).action=='release')
        assert(c:step(observation(weapon,'idle')).action=='press')
    end
    assert(c:step(observation('swapped','charging')).action=='stop' and c.wait_release)
    assert(c:step(observation(weapon,'charging')).action=='stop')
    assert(c:step({physical_held=false}).action=='stop' and not c.wait_release)
    assert(c:step(observation('swapped','charging')).action=='hold')
end
local c=Cycle.new('restart_after_beam')
for _=1,4 do
    assert(c:step(observation('Melta','charging')).action=='hold')
    assert(c:step(observation('Melta','firing')).action=='hold')
    assert(c:step(observation('Melta','firing')).action=='hold')
    assert(c:step(observation('Melta','recovering')).action=='release')
    assert(c:step(observation('Melta','idle')).action=='press')
end
assert(c:step(observation('Melta','reload_required')).action=='stop' and c.wait_release)
for _,behavior in ipairs({'release_at_ready','restart_after_beam'})do
    for _,phase in ipairs({'charging','ready','firing','recovering','idle'})do
        c=Cycle.new(behavior);c:step(observation('one',phase))
        assert(c:step({physical_held=false}).action=='stop' and not c.identity)
        assert(c:step(observation('one','charging')).action=='hold')
        for _,reason in ipairs({'death','ship','unsupported','read_failure','unknown','reload_required'})do
            local o=observation('one',reason);o.valid=false
            assert(c:step(o).action=='stop' and c.wait_release)
            assert(c:step(observation('one','charging')).action=='stop')
            c:step({physical_held=false})
        end
    end
end
-- Retained GUI, resize, world rebuild, cleanup and isolation from renderer faults.
local created,destroyed,rects,updates=0,0,0,0
local ui={};local main={};local worlds={main,ui};local width,height=1920,1080
local engine={Application={worlds=function()return worlds end,main_world=function()return main end},
    World={create_screen_gui=function(world)assert(world==ui);created=created+1;return {}end,
        destroy_gui=function(world)assert(world==ui);destroyed=destroyed+1 end},
    Gui={resolution=function()return width,height end,
        rect=function(_,pos,size)assert(size[1]<=4 and size[2]<=9);rects=rects+1;return rects end,
        update_rect=function()updates=updates+1 end},
    Vector2=function(...)return {...}end,Vector3=function(...)return {...}end,Color=function(...)return {...}end}
local hud=Hud.new(engine);local f=Fixture.new();f:tick()
local reads,queries=f.host.reads,#f.queries
for _=1,1000 do hud:present(f.consumer:get_hud_state())end
assert(f.host.reads==reads and #f.queries==queries and created==1 and rects==9 and updates==0)
height=720;hud:present(f.consumer:get_hud_state());assert(updates==9)
ui={};worlds={main,ui};hud:present(f.consumer:get_hud_state());assert(created==2)
f:weapon('968211c0033dce64');f:tick();hud:present(f.consumer:get_hud_state());assert(not hud.gui and destroyed==1)
f:weapon(eruptor);f:tick();assert(f.consumer:get_hud_state().visible)
f:game_state(1);f:tick();assert(not f.consumer:get_hud_state().visible)
f:game_state(4);f:respawn(0x44,0x99);f:tick();assert(f.consumer:get_hud_state().visible)
hud:present(f.consumer:get_hud_state());hud:clear();assert(not hud.gui)
local view={user_enabled=true,effective=true,identity_valid=true,identity_observed=true,eligibility={category='CHARGE'}}
assert(Hud.project(view).visible);view.user_enabled=false;assert(not Hud.project(view).visible)
assert(not Hud.project(nil).visible)
-- Actual lifecycle callback wiring preserves stock return values and cleans GUI on stop.
local wired=Fixture.new();engine.Window=wired.env.stingray.Window;wired.env.stingray=engine
wired.host:set_hud_provider(function()return wired.consumer:get_hud_state()end)
local initial_created=created;wired:tick();assert(created==initial_created+1)
wired:game_state(1);wired:tick();assert(destroyed>=2)
wired:game_state(4);wired:tick();assert(wired.consumer:get_hud_state().visible)
assert(wired.consumer:stop().ok)
engine.Gui.rect=function()error('GUI fault')end
hud=Hud.new(engine);hud:present({visible=true});assert(hud.failures==1 and not hud.gui)
f:fire(true);f:tick();f:healthy();assert(f.backend.lease,'HUD failure disabled assistance')
f:fire(false);f:tick();assert(f:restored() and f.consumer:stop().ok)
-- Read-only observer cache, native-work bounds and failure before stale access.
for _,hash in ipairs(charge_hashes)do
    f=Fixture.new();f:weapon(hash);f:tick()
    local manager,entities,entries,map,settings=0x81000000,0x82000000,0x83000000,0x84000000,0x85000000
    f:put(f.G+0x3326c20,f.ptr(manager))
    f:put(manager+16,f.u32(1)..string.rep('\0',36)..f.ptr(entities)..f.ptr(entries))
    f:put(entities,f.ptr(f.ERECORD));f:put(entries,string.rep('\0',12)..'\1'..string.rep('\0',27))
    f:put(manager+80,f.ptr(map)..f.u32(8)..f.u32(0xffffffff)..f.u32(1))
    f:put(map+0xa9%8*8,f.u32(0xa9)..f.u32(0));f:put(manager+144,f.ptr(settings));f:put(settings,string.rep('\0',216))
    local observer=Observer.new(f.host);local state=f.consumer:get_state()
    local sample=observer:sample(state);assert(sample.state=='raw_observed' and #sample.runtime_hex==80 and #sample.settings_hex==48)
    if hash==charge_hashes[1]then
        local lines,flushes,closes={},0,0
        local logger={open_log=function(name)
            assert(name=='HD2FullAutoAssist-charge-probe.log' and name:match('^[%w_-]+%.log$'))
            return {write=function(self,text)lines[#lines+1]=text;return self end,
                flush=function()flushes=flushes+1;return true end,
                close=function()closes=closes+1;return true end}
        end}
        local research=require('charge_research').new(f.host,function()return state end,logger)
        research:tick();local samples=research.samples
        for _=1,100 do research:tick()end
        assert(research.samples==samples,'Research sampling limit missing')
        f.now=f.now+20000;research:tick();assert(research.samples==samples+1 and f.writes==0)
        research:close();assert(research.closed and closes==1 and flushes>=2)
        local joined=table.concat(lines)
        assert(joined:find('research_start',1,true) and joined:find('runtime_hex',1,true) and joined:find('physical_binding_verified',1,true))
    end
    local before=f.host.reads
    for _=1,100 do assert(observer:sample(state).state=='raw_observed')end
    assert(observer.discoveries==1 and observer.cache_hits==100 and observer.expensive_scans==0)
    assert(f.host.reads-before<=2400 and f.writes==0,'Read-only research budget violated')
    NEXT_RESEARCH_BUDGETS[hash]={samples=100,native_reads=f.host.reads-before,
        identity_rediscoveries=0,charge_slot_discoveries=observer.discoveries,
        expensive_scans=observer.expensive_scans,cache_hits=observer.cache_hits,weapon_writes=f.writes,
        scope='read-only synthetic observer; not automated firing'}
    f.failed_read=manager+16;assert(observer:sample(state).state=='unavailable' and not observer.cached)
    f.failed_read=nil;assert(observer:sample(state).state=='raw_observed')
    f:put(f.ERECORD+16,'\1');assert(observer:sample(state).state=='unavailable')
    assert(observer:sample(state).state=='unavailable','Stale generation must stay rejected after invalidation')
    observer:invalidate();local idle={identity_observed=false};before=f.host.reads
    assert(observer:sample(idle)==nil and f.host.reads==before)
    f:fire(true);f:tick();assert(f.writes==0 and not f.backend.lease)
    assert(f.consumer:stop().ok)
end
-- A developer trace failing on close cannot strand a conventional Fire lease.
local research_module=require('charge_research');local saved_new=research_module.new
research_module.new=function()return {close=function()error('disk failure')end}end
local cleanup=Fixture.new();cleanup:fire(true);cleanup:tick();assert(cleanup.backend.lease)
cleanup.host:set_charge_research(function()return cleanup.consumer:get_state()end)
research_module.new=saved_new
assert(cleanup.consumer:stop().ok and cleanup:restored() and not cleanup.backend.lease)
print('Next-version profiles, semantic cycles, retained HUD and read-only charge research passed')
