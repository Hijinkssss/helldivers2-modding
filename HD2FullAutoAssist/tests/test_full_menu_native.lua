local NativeFixture=require('native_transition_fixture')
local MenuFixture=require('menu_fixture')
local Menu=require('mod_options_menu')
local hashes={peacemaker_profile='05e4e5c2db6e44a2',socom_profile='4d58c77087b774c5',
    veto_profile='c780bcd79547da0f',talon_profile='416d053372c4e433',
    amr_profile='89c5493e08ca4207',commando_profile='5990123d142b16cb',
    hyena_profile='e5796355a8fd67e0',bushwhacker_profile='2b28e17ffed05f7c',eruptor_profile='b6aff2195568767f'}
local menu=MenuFixture.new();_G.ModOptionsMenu=menu.api
local f=NativeFixture.new()
f:tick()
local count=0
for index,def in ipairs(require('menu_catalog').profiles)do
    f:fire(false);f:tick();f:weapon(hashes[def.key],0xa9+index);f:tick()
    f:fire(true);f:tick();assert(f.backend.lease)
    for selected,choice in ipairs(def.choices)do
        menu:apply('codex.full_auto_assist.'..def.key,selected);f:tick()
        assert(not f.backend.lease and f:restored(),def.weapon..' exact restored bytes')
        f:tick();assert(not f.backend.lease and f:restored())
        f:fire(false);f:tick();f:fire(true);f:tick()
        assert(f.backend.lease and math.abs(f.backend.repeat_seconds-60/choice.rpm)<1e-7)
        menu:apply(Menu.ENABLED_ID,false);f:tick()
        assert(not f.backend.lease and f:restored())
        menu:apply(Menu.ENABLED_ID,true);f:tick();assert(not f.backend.lease and f:restored())
        f:fire(false);f:tick();f:fire(true);f:tick();assert(f.backend.lease)
        count=count+1
    end
end
assert(count==21 and f.consumer:stop().ok and f:restored())
assert(not f.consumer:status().counters.active_lease)
_G.ModOptionsMenu=nil
print('PASS full menu actual native adapter: all 21 choices restore exact Fire bytes, require physical release and reacquire at the selected interval')
