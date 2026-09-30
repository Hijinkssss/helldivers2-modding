-- Exercise the actual observer and recorder, including excluded weapons.
local F=require('native_transition_fixture')
local Observer=require('charge_observer')
local Research=require('charge_research')
local Targets=require('charge_probe_targets')
local expected={['6cfcc7f8801a0266']='40-K Meltagun'}
local count=0
for hash,name in pairs(Targets.names)do assert(expected[hash]==name);count=count+1 end
assert(count==1 and Targets.names['30061f91af477f5e']==nil,'RC4 must target Meltagun only')

local f=F.new();local texts,closes={},0
local provider=function()return f.consumer:get_state()end
local logger={open_log=function(name)
    assert(name=='HD2FullAutoAssist-charge-probe.log')
    return {write=function(self,s)texts[#texts+1]=s;return self end,
        flush=function()return true end,close=function()closes=closes+1;return true end}
end}
local research=Research.new(f.host,provider,logger)
local manager,entities,entries,map,settings=0x81000000,0x82000000,0x83000000,0x84000000,0x85000000
local resource_table=0x86000000
f:put(f.G+0x346bf98,f.ptr(f.OWNER));f:put(f.OWNER+0xf12ad8,f.ptr(resource_table))
f:put(resource_table,string.rep('\0',20*16))
f:put(f.G+0x3326c20,f.ptr(manager))
f:put(manager+16,f.u32(1)..string.rep('\0',36)..f.ptr(entities)..f.ptr(entries))
f:put(entities,f.ptr(f.ERECORD));f:put(entries,string.rep('\0',40))
f:put(manager+80,f.ptr(map)..f.u32(8)..f.u32(0xffffffff)..f.u32(1))
f:put(map+0xa9%8*8,f.u32(0xa9)..f.u32(0))
f:put(manager+144,f.ptr(settings));f:put(settings,string.rep('\0',216))

for index,hash in ipairs({'6cfcc7f8801a0266'})do
    -- Distinct native entity IDs, rather than mutating one entity's resource.
    local id=0xa9+index
    f:put(map+id%8*8,f.u32(id)..f.u32(0))
    f:weapon(hash,id);f:tick()
    local row=research.observer:sample(provider())
    assert(row and row.state=='raw_observed' and row.resource_hash==hash and row.name==expected[hash])
    assert(row.settings_state=='observed' and row.settings_source=='instance_override' and not f.backend.lease)
    local before=research.samples;research:tick()
    assert(research.samples==before+1 and research.samples_by_weapon[expected[hash]]==1)
    assert(research.seen[hash] and f.writes==0)
end

for _,hash in ipairs({'96de9cd50f7306e6','fb3a19078694708a','aa69a60d74a3ec54',
                     '05e4e5c2db6e44a2','968211c0033dce64','0000000000000001'})do
    f:weapon(hash);f:tick()
    local reads,before=f.host.reads,research.samples
    assert(research.observer:sample(provider())==nil and f.host.reads==reads)
    research:tick()
    assert(research.samples==before and f.host.reads==reads,'Excluded weapon consumed reads or sample budget')
end
research:close();assert(closes==1 and research.samples==1 and f.writes==0)
local joined=table.concat(texts)
for hash,name in pairs(expected)do
    assert(joined:find('"resource_hash":"'..hash..'"',1,true) and joined:find(name,1,true))
end
assert(joined:find('charge_probe_target_seen',1,true) and joined:find('samples_by_weapon',1,true))
assert(joined:find('"sample_limit_hit":false',1,true))
for _,name in ipairs({'ARC-3 Arc Thrower','PLAS-101 Purifier','PLAS-15 Loyalist'})do
    assert(not joined:find(name,1,true),'Excluded charge weapon appeared as target/sample')
end
-- Missing settings now carry an explicit availability field, without guessed values.
f:weapon('6cfcc7f8801a0266');f:tick()
f:put(map+0xa9%8*8,f.u32(0xffffffff)..f.u32(0))
local row=Observer.new(f.host):sample(provider())
assert(row.state=='raw_observed' and row.settings_state=='not_found' and row.settings_hex==nil and row.native_boundaries==nil)
assert(f.consumer:stop().ok and f.writes==0)
print('PASS RC4 recorder target: Meltagun only; all other weapons excluded with zero probe reads and samples')
