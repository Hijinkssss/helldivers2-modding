local Catalog=require('menu_catalog')
local Menu=require('mod_options_menu')
local Policy=require('weapon_policy')
local Config=require('config')
local Fixture=require('menu_fixture')
local prefix='codex.full_auto_assist.'
local function setup(settings,saved,refuse,callback_refuse)
    local f=Fixture.new(saved,refuse,callback_refuse)
    _G.ModOptionsMenu=f.api
    local policy=Policy.new(settings.fire_rate_mode,settings.talon_mode,settings)
    local enabled=settings.user_enabled
    local events={}
    local bridge=Menu.new(settings,{
        set_enabled=function(v)enabled=v;events[#events+1]='enabled' end,
        set_profile=function(v,weapon)assert(policy:set_profile(weapon,v));events[#events+1]=weapon end})
    bridge:step()
    return f,policy,bridge,events,function()return enabled end
end

local defaults={user_enabled=true,fire_rate_mode='balanced',talon_mode='balanced'}
local f,policy,bridge,events,enabled=setup(defaults)
assert(bridge.registered and bridge.option_count==10 and enabled())
assert(f.specs[Menu.ENABLED_ID].default==true)
assert(f.specs[prefix..'fire_rate_mode']==nil,'no global cadence menu row')
local hashes={['P-2 Peacemaker']='05e4e5c2db6e44a2',['M6C/SOCOM Pistol']='4d58c77087b774c5',
 ['P-69 Veto']='c780bcd79547da0f',['LAS-58 Talon']='416d053372c4e433',
 ['APW-1 Anti-Materiel Rifle']='89c5493e08ca4207',['MLS-4X Commando']='5990123d142b16cb',
 ['R-4 Hyena']='e5796355a8fd67e0',['SG-22 Bushwhacker']='2b28e17ffed05f7c',['R-36 Eruptor']='b6aff2195568767f'}
local choices=0
for _,def in ipairs(Catalog.profiles)do
    local id=prefix..def.key
    assert(f.specs[id].default==1)
    assert(policy:classify(hashes[def.weapon]).max_repeat_rpm==def.choices[1].rpm)
    for index,choice in ipairs(def.choices)do
        f:apply(id,index)
        assert(policy:classify(hashes[def.weapon]).max_repeat_rpm==choice.rpm,def.weapon..' mapping')
        -- No arbitrary/out-of-range/fractional/NaN/string callback is accepted.
        for _,bad in ipairs({0,#def.choices+1,1.5,'2',0/0})do
            f.callbacks[id](bad)
            assert(policy:classify(hashes[def.weapon]).max_repeat_rpm==choice.rpm)
        end
        choices=choices+1
    end
end
assert(choices==21)
local registrations,gets,sets=f.registrations,f.gets,f.sets
for _=1,10000 do bridge:step()end
assert(f.registrations==registrations and f.gets==gets and f.sets==sets,'no per-frame API work')
assert(policy:classify('1a437158e1b8d2a1').max_repeat_rpm==380,'non-selector cadence unchanged by all menu choices')
f:apply(Menu.ENABLED_ID,false);assert(not enabled())
assert(bridge:set_enabled(true) and f.values[Menu.ENABLED_ID]==true)
assert(not policy:classify('076dd5d4f4360204').allowed)
assert(not policy:classify('0000000000000001').allowed)

-- A new menu/controller instance sees saved selections despite conflicting INI.
local saved=f.saved
saved[Menu.ENABLED_ID]=false
saved[prefix..'fire_rate_mode']=2 -- Obsolete candidate key must never affect runtime.
local restart,p2,b2,_,e2=setup({user_enabled=true,fire_rate_mode='balanced',talon_mode='balanced',
    peacemaker_profile='balanced',eruptor_profile='slower_27'},saved)
assert(b2.registered and not e2())
for _,def in ipairs(Catalog.profiles)do
    assert(p2:classify(hashes[def.weapon]).max_repeat_rpm==def.choices[#def.choices].rpm)
end
assert(p2:classify('1a437158e1b8d2a1').max_repeat_rpm==380,'obsolete saved general mode ignored')
-- Missing/invalid values seed legacy values and persist once through menu.set.
local seed={user_enabled=false,fire_rate_mode='native_cap',talon_mode='efficiency',eruptor_profile='balanced_27',
    bushwhacker_profile='balanced',peacemaker_profile='balanced'}
local seeded,p3,b3,_,e3=setup(seed,{[prefix..'veto_profile']=99})
assert(b3.registered and not e3())
assert(p3:classify(hashes['P-2 Peacemaker']).max_repeat_rpm==380)
assert(p3:classify(hashes['M6C/SOCOM Pistol']).max_repeat_rpm==900)
assert(p3:classify(hashes['LAS-58 Talon']).max_repeat_rpm==60)
assert(p3:classify(hashes['R-36 Eruptor']).max_repeat_rpm==27)
assert(p3:classify(hashes['SG-22 Bushwhacker']).max_repeat_rpm==90)
assert(seeded.saved[prefix..'socom_profile']==2)
-- Partial registration and callback refusal cannot apply any runtime state.
for refused=1,10 do
    local partial,_,b,ev=setup({user_enabled=true,fire_rate_mode='balanced'},nil,refused)
    assert(b.failed and not b.registered and #ev==0)
    b:step();assert(partial.registrations==refused)
end
for refused=1,10 do
    local partial,_,b,ev=setup({user_enabled=true,fire_rate_mode='balanced'},nil,nil,refused)
    assert(b.failed and not b.registered and #ev==0)
    for id,callback in pairs(partial.callbacks)do callback(partial.values[id])end
    assert(#ev==0,'partial callbacks remain inert')
end
-- Optional absence preserves fallback; a pre-registration hotkey seeds latest state.
_G.ModOptionsMenu=nil
local waiting=Menu.new({user_enabled=true,fire_rate_mode='balanced'}, {})
waiting:step();assert(not waiting.registered)
waiting:set_enabled(false)
local late=Fixture.new();_G.ModOptionsMenu=late.api
waiting:step();assert(waiting.registered and late.values[Menu.ENABLED_ID]==false)
_G.ModOptionsMenu=nil
local before_saved=Menu.new({user_enabled=false,fire_rate_mode='balanced'}, {})
before_saved:set_enabled(true)
local saved_off=Fixture.new({[Menu.ENABLED_ID]=false});_G.ModOptionsMenu=saved_off.api
before_saved:step();assert(before_saved.registered and saved_off.values[Menu.ENABLED_ID]==true,
    'physical hotkey after startup must supersede a late-loaded saved master choice')
_G.ModOptionsMenu=nil
print('PASS full menu: 10 options, 21 choices, saved precedence, legacy seeds, late hotkey, API failures and zero registered-frame queries')
