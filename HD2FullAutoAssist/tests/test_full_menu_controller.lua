local Catalog=require('menu_catalog')
local Menu=require('mod_options_menu')
local fixture=require('menu_fixture').new({['codex.full_auto_assist.fire_rate_mode']=2})
_G.ModOptionsMenu=fixture.api
_G.FullAutoAssistArsenalOptions=nil -- Core-only runtime, no option addon required.
local assist=app.install(standalone_host,function()return backend end,function()return ''end)
tick(0,false)
local hashes={['P-2 Peacemaker']='05e4e5c2db6e44a2',['M6C/SOCOM Pistol']='4d58c77087b774c5',
 ['P-69 Veto']='c780bcd79547da0f',['LAS-58 Talon']='416d053372c4e433',
 ['APW-1 Anti-Materiel Rifle']='89c5493e08ca4207',['MLS-4X Commando']='5990123d142b16cb',
 ['R-4 Hyena']='e5796355a8fd67e0',['SG-22 Bushwhacker']='2b28e17ffed05f7c',['R-36 Eruptor']='b6aff2195568767f'}
local ms=0
local function step()ms=ms+200;tick(ms,false)end
local function close_fire()fire=false;step();assert(not backend.lease)end
local cases=0
for index,def in ipairs(Catalog.profiles)do
    close_fire();resource_hash=hashes[def.weapon];entity_id=1000+index;step()
    fire=true;step();assert(backend.lease)
    for choice_index,choice in ipairs(def.choices)do
        fixture:apply('codex.full_auto_assist.'..def.key,choice_index)
        step()
        assert(not backend.lease and assist:status().wait_release,def.weapon..' active-lease retirement')
        step();assert(not backend.lease,'held Fire does not reacquire before physical release')
        close_fire();fire=true;step()
        assert(backend.lease and math.abs(backend.repeat_seconds-60/choice.rpm)<1e-7,def.weapon..' cadence')
        -- Menu OFF/ON while held keeps physical release required and profile cached.
        fixture:apply(Menu.ENABLED_ID,false);step()
        assert(not backend.lease and not assist:get_state().user_enabled)
        fixture:apply(Menu.ENABLED_ID,true);step();assert(not backend.lease)
        close_fire();fire=true;step()
        assert(backend.lease and math.abs(backend.repeat_seconds-60/choice.rpm)<1e-7)
        cases=cases+1
    end
end
assert(cases==21)
-- Non-selector cadence stays at the shipped default after every menu choice.
close_fire();resource_hash='1a437158e1b8d2a1';entity_id=1301;step();fire=true;step()
assert(math.abs(backend.repeat_seconds-60/380)<1e-7)
close_fire()
-- Releasing before a per-weapon Apply is safe too.
resource_hash=hashes['P-2 Peacemaker'];entity_id=1302;step()
fixture:apply(Menu.PEACEMAKER_ID,1);step();fire=true;step();assert(backend.lease)
assert(math.abs(backend.repeat_seconds-60/380)<1e-7);close_fire()
-- Unsupported/unknown identities remain unaffected even with all maximum choices.
for _,hash in ipairs({'076dd5d4f4360204','0000000000000001','1980d92b619ff5fe','6cfcc7f8801a0266'})do
    resource_hash=hash;entity_id=entity_id+1;step();fire=true;step();assert(not backend.lease)
    close_fire()
end
-- Menu -> hotkey -> menu, both directions, profile choices retained.
fixture:apply(Menu.ENABLED_ID,false);step()
ms=ms+300;tick(ms,true);assert(assist:get_state().user_enabled and fixture.values[Menu.ENABLED_ID])
step();ms=ms+300;tick(ms,true);assert(not assist:get_state().user_enabled and not fixture.values[Menu.ENABLED_ID])
step();fixture:apply(Menu.ENABLED_ID,true);step()
local registrations,gets,sets=fixture.registrations,fixture.gets,fixture.sets
for _=1,1000 do step()end
assert(fixture.registrations==registrations and fixture.gets==gets and fixture.sets==sets)
assert(assist:stop().ok and not backend.lease)
_G.ModOptionsMenu=nil
print('PASS full controller: all 21 profiles, both live directions, held/released OFF/ON, unsupported identities, hotkey and no menu polling')
