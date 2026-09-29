local Config=require('config')
local Policy=require('weapon_policy')
local profile_values={['']=true,balanced=true,full_auto=true,efficiency=true,fuller_auto=true}
local schema={fire_rate_mode={type='string',default='balanced',max_length=16,
        values={balanced=true,native_cap=true}},
    talon_mode={type='string',default='balanced',max_length=16,values=profile_values},
    peacemaker_profile={type='string',default='',max_length=16,values=profile_values},
    socom_profile={type='string',default='',max_length=16,values=profile_values},
    veto_profile={type='string',default='',max_length=16,values=profile_values},
    talon_profile={type='string',default='',max_length=16,values=profile_values},
    amr_profile={type='string',default='',max_length=16,values=profile_values}}

local ini=Config.load(schema,'fire_rate_mode=native_cap\npeacemaker_profile=full_auto\nveto_profile=full_auto')
assert(ini.peacemaker_profile=='full_auto' and ini.veto_profile=='full_auto')
local selected=Config.load(schema,'fire_rate_mode=native_cap\npeacemaker_profile=full_auto',
    {peacemaker_profile='balanced',socom_profile='balanced',veto_profile='balanced',
        talon_profile='balanced',amr_profile='balanced'})
assert(selected.peacemaker_profile=='balanced','Arsenal must override explicit INI fallback')
local policy=Policy.new(selected.fire_rate_mode,selected.talon_mode,selected)
local expected={
    ['05e4e5c2db6e44a2']=380,['4d58c77087b774c5']=380,['c780bcd79547da0f']=380,
    ['416d053372c4e433']=210,['89c5493e08ca4207']=120}
for hash,rpm in pairs(expected)do
    local row=policy:classify(hash);assert(row.allowed and row.max_repeat_rpm==rpm,hash..' selected default')
end

local choices={
    {peacemaker_profile='full_auto',hash='05e4e5c2db6e44a2',rpm=900},
    {socom_profile='full_auto',hash='4d58c77087b774c5',rpm=900},
    {veto_profile='full_auto',hash='c780bcd79547da0f',rpm=750},
    {talon_profile='efficiency',hash='416d053372c4e433',rpm=60},
    {talon_profile='full_auto',hash='416d053372c4e433',rpm=380},
    {talon_profile='fuller_auto',hash='416d053372c4e433',rpm=750},
    {amr_profile='full_auto',hash='89c5493e08ca4207',rpm=400},
}
for _,choice in ipairs(choices)do
    local row=Policy.new('balanced','balanced',choice):classify(choice.hash)
    assert(row.allowed and row.max_repeat_rpm==choice.rpm,choice.hash..' selected profile')
end
local fallback=Policy.new(ini.fire_rate_mode,ini.talon_mode,ini)
assert(fallback:classify('05e4e5c2db6e44a2').max_repeat_rpm==900)
assert(fallback:classify('c780bcd79547da0f').max_repeat_rpm==750)
local good=pcall(Config.load,schema,'',{unknown_profile='full_auto'})
assert(not good,'Unknown Arsenal settings must fail closed')
print('test_arsenal_profiles: all checks passed')
