local Hud=require('hud_indicator')
local Fixture=require('native_transition_fixture')
local Config=require('config')
local Policy=require('weapon_policy')
-- RC1 configuration and Arsenal selections migrate at both actual config boundaries.
for old,wanted in pairs({stable_26='balanced_28',['26']='balanced_28',balanced='balanced_28',
    balanced_27='slower_27',fast_28='balanced_28',full_auto='max_32'})do
    local schema={eruptor_profile={type='string',default='',max_length=16,
        values={['']=true,slower_27=true,balanced_28=true,max_32=true}}}
    assert(Config.load(schema,'eruptor_profile='..old).eruptor_profile==wanted)
    assert(Config.load(schema,'',{eruptor_profile=old}).eruptor_profile==wanted)
    local f=Fixture.new('eruptor_profile='..old);f:weapon('b6aff2195568767f');f:tick();f:fire(true);f:tick()
    assert(f.backend.lease and f.backend.repeat_seconds==60/({slower_27=27,balanced_28=28,max_32=32})[wanted])
    f:fire(false);f:tick();assert(f:restored() and f.consumer:stop().ok)
end
-- Both Commando profiles reach native input with unchanged HUD eligibility and release safety.
for profile,rpm in pairs({balanced=120,full_auto=240})do
    for _,mode in ipairs({'balanced','native_cap'})do
        local c=Fixture.new('fire_rate_mode='..mode..'\ncommando_profile='..profile)
        c:weapon('5990123d142b16cb');c:tick();assert(c.consumer:get_hud_state().visible)
        c:fire(true);c:tick();assert(c.backend.lease and c.backend.repeat_seconds==60/rpm)
        c:fire(false);c:tick();assert(c:restored() and c.consumer:stop().ok)
    end
end
-- Commando reaches guarded native mapping, HUD state and release/swap/OFF/ship gates.
local f=Fixture.new();f:weapon('5990123d142b16cb');f:tick()
local model=f.consumer:get_hud_state()
assert(model.visible and model.eligible and model.weapon=='MLS-4X Commando')
f:fire(true);f:tick();assert(f.backend.lease and f.backend.repeat_seconds==.5)
f:fire(false);f:tick();assert(f:restored())
f:fire(true);f:tick();f:weapon('968211c0033dce64');f:tick();assert(f:restored() and not f.consumer:get_hud_state().visible)
f:fire(false);f:tick();f:weapon('5990123d142b16cb');f:tick();f:fire(true);f:tick();assert(f.backend.lease)
f.host.callbacks.toggle.callback();f:tick();assert(f:restored() and f.consumer:get_hud_state().visible and not f.consumer:get_hud_state().enabled)
f:fire(false);f:tick();f.host.callbacks.toggle.callback();f:tick()
f:game_state(1);f:tick();assert(f:restored() and not f.consumer:get_hud_state().visible)
assert(f.consumer:stop().ok)
-- Multi-world renderer, coordinates, explicit visibility, probes and bounded diagnostics.
local main,ui,aux={},{},{};local worlds={main,ui,aux};local width,height=1920,1080
local logs,shown,positions={},false,{}
local engine={Application={worlds=function()return worlds end,main_world=function()return main end},
    World={create_screen_gui=function(world)assert(world==ui);return {}end,destroy_gui=function()end},
    Gui={resolution=function()return width,height end,set_visible=function(_,v)shown=v end,
        rect=function(_,pos,size,color)assert(color[1]==230);positions[#positions+1]=pos;return #positions end,
        update_rect=function()end},
    Color=function(...)return {...}end,Vector2=function(...)return {...}end,Vector3=function(...)return {...}end}
local h=Hud.new(engine,{log=function(x)logs[#logs+1]=x end},function(w,h)return {x=246,y=107,scale=h/1080}end);h:present(model)
assert(shown and h.created==1 and #h.ids==9 and h.world_count==3 and h.target_index==2)
assert(h.x==246 and h.y==107 and h.scale==1 and h.on_screen)
assert(logs[#logs].hud_visible and logs[#logs].gui_created and logs[#logs].rectangles==9)
for _=1,1000 do h:present(model)end
assert(h.created==1 and h.calls==1001 and #logs<10,'Per-frame GUI/log allocation')
-- An unchanged HUD model skips native world/viewport/anchor work between bounded refreshes.
local now_us,world_checks,resolution_checks,anchor_checks=0,0,0,0
local timed_engine={Application={worlds=function()world_checks=world_checks+1;return worlds end,
        main_world=function()return main end},
    World=engine.World,
    Gui={resolution=function()resolution_checks=resolution_checks+1;return width,height end,
        set_visible=engine.Gui.set_visible,
        rect=function(_,pos,size,color)positions[#positions+1]=pos;return #positions end,
        update_rect=engine.Gui.update_rect},
    Color=engine.Color,Vector2=engine.Vector2,Vector3=engine.Vector3}
local timed_model={visible=true,enabled=false,resource_hash='weapon-a',category='ASSIST',revision=1}
local timed=Hud.new(timed_engine,{clock_us=function()return now_us end},function(w,h)
    anchor_checks=anchor_checks+1;return {x=246,y=107,scale=h/1080}
end)
timed:present(timed_model)
for _=1,1000 do now_us=now_us+8333;timed:present(timed_model)end
assert(world_checks>=30 and world_checks<=40 and resolution_checks==world_checks and anchor_checks==world_checks,
    'Stable HUD state refresh counts: '..world_checks..'/'..resolution_checks..'/'..anchor_checks)
local optimized_world_checks=world_checks
world_checks,resolution_checks,anchor_checks=0,0,0
local uncached=Hud.new(timed_engine,{},function(w,h)
    anchor_checks=anchor_checks+1;return {x=246,y=107,scale=h/1080}
end)
for _=1,1001 do uncached:present(timed_model)end
assert(world_checks==1001 and resolution_checks==1001 and anchor_checks==1001,
    'Uncached reference path did not execute presentation work every call')
print('HUD unchanged-state fixture: 1001 baseline world/resolution/anchor calls; '
    ..optimized_world_checks..' with bounded refresh and immediate transitions')
world_checks,resolution_checks,anchor_checks=0,0,0
timed_model={visible=true,enabled=true,resource_hash='weapon-a',category='ASSIST',revision=2}
timed:present(timed_model)
assert(world_checks==1 and resolution_checks==1 and anchor_checks==1,
    'FAA ON transition did not refresh HUD immediately')
local before_hide=world_checks
timed_model={visible=false,enabled=false,resource_hash=nil,category='REVIEW',revision=3}
timed:present(timed_model)
assert(not timed.gui and world_checks==before_hide+1,'Unsupported transition did not hide HUD immediately')
h:present({visible=false});assert(not shown and not h.gui)
worlds={main};h:present(model);assert(h.reason=='ui_world_missing' and not h.gui)
worlds={main,ui,aux};h:present(model);assert(shown and h.gui)
for _=1,140 do h:present({visible=false});h:present(model)end
assert(#logs==120 and h.emitted==120);h:clear();assert(not shown)
h=Hud.new(nil,{log=function(x)assert(x.renderer_available==false)end});h:present(model)
assert(h.calls==1 and not h.gui and h.reason=='engine_api_unavailable')
-- Actual lifecycle wiring emits the implementation marker and survives renderer fault.
f=Fixture.new();engine.Window=f.env.stingray.Window;f.env.stingray=engine
require('hud_fixture').populate(function(at,bytes)f:put(at,bytes)end,f.G)
f.host:set_hud_provider(function()return f.consumer:get_hud_state()end,{hud_diagnostics=true})
f:weapon('5990123d142b16cb');f:tick()
local found=false
for _,line in ipairs(f.logs)do if line:find('hud_rc2',1,true) and line:find('1.1.0-rc3-private-off-audit',1,true) then found=true end end
assert(found)
engine.Gui.rect=function()error('injected renderer fault')end
f:game_state(1);f:tick();f:game_state(4);f:tick();f:fire(false);f:tick()
f:fire(true);f:tick();f:healthy();assert(f.backend.lease)
f:fire(false);f:tick();assert(f:restored() and f.consumer:stop().ok)
print('PASS RC2 migration, Commando guarded input/HUD, multi-world render, diagnostics and HUD fault isolation')
