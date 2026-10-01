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
    amr_profile={type='string',default='',max_length=16,values=profile_values},
    hyena_profile={type='string',default='',max_length=16,values=profile_values},
    bushwhacker_profile={type='string',default='',max_length=16,values=profile_values}}

local ini=Config.load(schema,'fire_rate_mode=native_cap\npeacemaker_profile=full_auto\nveto_profile=full_auto')
assert(ini.peacemaker_profile=='full_auto' and ini.veto_profile=='full_auto')
local selected=Config.load(schema,'fire_rate_mode=native_cap\npeacemaker_profile=full_auto',
    {peacemaker_profile='balanced',socom_profile='balanced',veto_profile='balanced',
        talon_profile='balanced',amr_profile='balanced',hyena_profile='balanced',bushwhacker_profile='balanced'})
assert(selected.peacemaker_profile=='balanced','Arsenal must override explicit INI fallback')
local policy=Policy.new(selected.fire_rate_mode,selected.talon_mode,selected)
local expected={
    ['05e4e5c2db6e44a2']=380,['4d58c77087b774c5']=380,['c780bcd79547da0f']=380,
    ['416d053372c4e433']=210,['89c5493e08ca4207']=120,
    ['e5796355a8fd67e0']=120,['2b28e17ffed05f7c']=90}
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
    {hyena_profile='full_auto',hash='e5796355a8fd67e0',rpm=190},
    {bushwhacker_profile='full_auto',hash='2b28e17ffed05f7c',rpm=650},
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
local expansion={
    {'R-2124 Constitution','7b75e5132ffd4ca6',60},
    {'R-6 Deadeye','e6d932be83729076',100},
    {'R-4 Hyena','e5796355a8fd67e0',190,120},
    {'R-72 Censor','f0338468dcdb6a6c',400,380},
    {'SG-8 Punisher','41eac4a03987faa0',80},
    {'SG-8S Slugger','4f749e2ee26f532d',80},
    {'SG-20 Halt','4e310b1fe4c52b52',80},
    {'SG-451 Cookout','d323de60855898ac',80},
    {'M90A Shotgun','90ddc374f4e3d756',80},
    {'SG-225IE Breaker Incendiary','c12a34f375bd5a87',300},
    {'CB-9 Exploding Crossbow','f49227a0630a3f7f',50},
    {'R-36 Eruptor','b6aff2195568767f',32,28},
    {'SG-8P Punisher Plasma','05d8d8c073b9d502',80},
    {'R/40-K Hot-Shot Marksman Rifle','1abbff60d26ba391',210},
    {'JAR-5 Dominator','80f1a156d9fa1e36',250},
    {'P-4 Senator','8d3d52a3b2f19402',200},
    {'P-11 Stim Pistol','d6b1fb05b9109353',70},
    {'SG-22 Bushwhacker','2b28e17ffed05f7c',650,90},
    {'P-35 Re-Educator','0b882808c6f498e8',110},
    {'P/40-K Bolt Pistol','dbb6c961c59fadc1',150},
    {'P-92 Warrant','cf8934ff6567a42d',450,380},
    {'MLS-4X Commando','5990123d142b16cb',240,240},
}
local baseline=Policy.new('balanced','balanced')
for _,row in ipairs(expansion)do
    local got=baseline:classify(row[2])
    assert(got.allowed and got.name==row[1] and got.native_cap_rpm==row[3],row[1]..' identity/cap')
    assert(got.native_cap_status=='RUNTIME_SNAPSHOT',row[1]..' snapshot provenance')
    assert(got.max_repeat_rpm==(row[4] or math.min(row[3],380)),row[1]..' balanced cadence')
    assert(not baseline:classify('0000000000000001').allowed,row[1]..' unknown fail-closed')
end
local hyena=Policy.new('balanced','balanced'):classify('e5796355a8fd67e0')
assert(hyena.allowed and hyena.native_cap_rpm==190 and hyena.max_repeat_rpm==120)
local bush=Policy.new('balanced','balanced'):classify('2b28e17ffed05f7c')
assert(bush.allowed and bush.native_cap_rpm==650 and bush.max_repeat_rpm==90)
local blitzer=Policy.new('balanced','balanced'):classify('076dd5d4f4360204')
assert(not blitzer.allowed and blitzer.category=='IGNORE_NATIVE_AUTO')
local warrant=Policy.new('balanced','balanced'):classify('0xCF8934FF6567A42D')
assert(warrant.allowed and warrant.name=='P-92 Warrant' and warrant.category=='ASSIST')
assert(warrant.native_cap_rpm==450 and warrant.max_repeat_rpm==380)
assert(not Policy.new('balanced','balanced'):classify('cf8934ff6567a42e').allowed,
    'Incorrect Warrant identity remains fail-closed')
print('test_arsenal_profiles: all checks passed')
