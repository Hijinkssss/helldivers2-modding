local Anchor=require('hud_anchor')
local Hud=require('hud_indicator')
local Fixture=require('hud_fixture')
local ffi=require('ffi')
local host=Fixture.host();local anchor=Anchor.new(host)
local plain=assert(anchor:sample(1920,1080))
assert(plain.right==240 and plain.x==246 and plain.y==107 and plain.scale==1)
assert(plain.nodes==6 and host.reads==16 and host.writes==0)
local pack=host.layout.pack
host:put(pack,Fixture.widget(270,90,64,48,host.layout.panel,nil,nil,2,true))
local wide=assert(anchor:sample(1920,1080));assert(wide.right==334 and wide.x==340 and wide.y==plain.y)
for _=1,100 do assert(anchor:sample(1920,1080).x==wide.x)end
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
assert(anchor:sample(1920,1080).x==plain.x,'Backpack removal left a stale extent')
-- Swaps/layout changes use current native text/icon widths, not weapon/backpack offsets.
host:put(host.layout.b,Fixture.widget(210,90,100,24,host.layout.row,nil,nil,7,true))
assert(anchor:sample(1920,1080).x==316)
local small=Fixture.host({scale=.75,backpack=true})
local scaled=assert(Anchor.new(small):sample(1280,720))
assert(scaled.right==318 and scaled.gap==4.5 and scaled.scale==720/1080)
-- A hidden wide sibling contributes nothing; a visible child beyond its parent does.
host:put(host.layout.b,Fixture.widget(210,90,400,24,host.layout.row,nil,nil,7,false))
assert(anchor:sample(1920,1080).right==200)
host:put(host.layout.b,Fixture.widget(610,90,30,24,host.layout.row,nil,nil,7,true))
assert(anchor:sample(1920,1080).right==640)
-- Faults/races/cycles never reuse the last successful position; next clean sample recovers.
host.failed=host.layout.a;assert(anchor:sample(1920,1080)==nil);host.failed=nil
assert(anchor:sample(1920,1080).right==640)
host:put(host.layout.b,Fixture.widget(210,90,30,24,host.layout.row,nil,host.layout.a,7,true))
assert(anchor:sample(1920,1080)==nil)
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
host:put(host.layout.b,Fixture.widget(210,90,30,24,host.layout.weapon,nil,nil,7,true))
assert(anchor:sample(1920,1080)==nil)
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
local once=false
host.after_read=function(at,n)
    if at==host.layout.b and not once then
        once=true;local p=ffi.new('uint64_t[1]',Fixture.OWNER+0x100000)
        host:put(host.base+0x346d538,ffi.string(p,8))
    end
end
assert(anchor:sample(1920,1080)==nil);host.after_read=nil
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
host:put(host.layout.row,Fixture.widget(180,90,56,48,host.layout.weapon,host.layout.a,nil,1,false))
assert(anchor:sample(1920,1080)==nil)
Fixture.populate(function(at,value)host:put(at,value)end,host.base,{backpack=true,pack_x=1890})
assert(anchor:sample(1920,1080)==nil,'Offscreen placement accepted')
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
local nan=ffi.new('float[1]',0/0);host:put(host.layout.a+148,ffi.string(nan,4))
assert(anchor:sample(1920,1080)==nil)
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
local shear=ffi.new('float[1]',.25);host:put(host.layout.a+108,ffi.string(shear,4))
assert(anchor:sample(1920,1080)==nil,'Sheared bounds accepted')
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
-- Bound traversal even when a corrupt tree has valid pointers and no cycles.
local first=0x88000000
host:put(host.layout.a,Fixture.widget(180,90,20,24,host.layout.row,first,host.layout.b,1,true))
for i=0,16 do
    local at=first+i*256
    host:put(at,Fixture.widget(180,90,20,24,i==0 and host.layout.a or at-256,
        i<16 and at+256 or nil,nil,1,true))
end
assert(anchor:sample(1920,1080)==nil,'Excessive depth accepted')
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
host:put(host.layout.b,Fixture.widget(210,90,30,24,host.layout.row,nil,first,7,true))
for i=0,192 do
    local at=first+i*256
    host:put(at,Fixture.widget(210,90,30,24,host.layout.row,nil,i<192 and at+256 or nil,7,true))
end
assert(anchor:sample(1920,1080)==nil,'Excessive node count accepted')
Fixture.populate(function(at,value)host:put(at,value)end,host.base)
-- Projection preserves support/identity gates while OFF keeps supported weapons visible.
for _,category in ipairs({'ASSIST','SPECIAL','CHARGE'})do
    local state={user_enabled=true,effective=true,identity_valid=true,identity_observed=true,eligibility={category=category}}
    assert(Hud.project(state).visible and Hud.project(state).enabled)
    state.user_enabled=false;state.effective=false
    assert(Hud.project(state).visible and not Hud.project(state).enabled)
    state.identity_valid=false;assert(not Hud.project(state).visible)
    state.identity_valid=true;state.identity_observed=false;assert(not Hud.project(state).visible)
end
for _,category in ipairs({'REVIEW','VANILLA','UNSUPPORTED'})do
    assert(not Hud.project({user_enabled=true,effective=true,identity_valid=true,identity_observed=true,
        eligibility={category=category}}).visible)
end
local created,destroyed,updates=0,0,0;local drawn={};local ui,main={},{}
local engine={Application={worlds=function()return {main,ui}end,main_world=function()return main end},
    World={create_screen_gui=function()created=created+1;return {}end,destroy_gui=function()destroyed=destroyed+1 end},
    Gui={set_visible=function()end,resolution=function()return 1920,1080 end,rect=function(_,p,s,c)
        drawn[#drawn+1]={p=p,s=s,c=c};return #drawn end,
        update_rect=function(_,id,p,s,c)updates=updates+1;drawn[id]={p=p,s=s,c=c}end},
    Vector2=function(...)return {...}end,Vector3=function(...)return {...}end,Color=function(...)return {...}end}
local hud=Hud.new(engine,function(w,h)return anchor:sample(w,h)end)
hud:present({visible=true,enabled=true});assert(created==1 and #drawn==9)
local x,y=drawn[1].p[1],drawn[1].p[2]
assert(drawn[1].c[1]==230 and drawn[1].c[2]==255 and drawn[1].c[3]==213 and drawn[1].c[4]==0)
hud:present({visible=true,enabled=false});assert(created==1 and destroyed==0 and updates==9)
for _,shape in ipairs(drawn)do for _,channel in ipairs(shape.c)do assert(channel==255)end end
assert(drawn[1].p[1]==x and drawn[1].p[2]==y,'OFF moved the glyph')
hud:present({visible=true,enabled=false});assert(updates==9,'Stable presentation changed geometry')
host:put(host.layout.pack,Fixture.widget(270,90,64,48,host.layout.panel,nil,nil,2,true))
hud:present({visible=true,enabled=false});assert(updates==18 and drawn[1].p[1]>x and drawn[1].p[2]==y)
hud:present({visible=true,enabled=true});assert(updates==27 and drawn[1].c[1]==230)
host.failed=host.layout.a;hud:present({visible=true,enabled=true})
assert(not hud.gui and hud.available,'Transient anchor fault permanently disabled HUD')
host.failed=nil;hud:present({visible=true,enabled=true});assert(hud.gui and created==2)
local reads=host.reads;hud:present({visible=false});assert(not hud.gui and host.reads==reads)
print('HUD three states, opaque white OFF, native extents, backpack changes, scale, stale/fault guards passed')
