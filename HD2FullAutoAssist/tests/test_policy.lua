local Policy=require('weapon_policy')
local function verify(bridge,hash,expected)
    local policy=Policy.new(bridge);local result=policy:classify(hash)
    assert(result.category==expected and result.allowed==(expected=='ASSIST' or expected=='SPECIAL'))
    return policy,result
end
local bridge,metadata,modes=policy_fixture()
local p,r=verify(bridge,'0x05E4E5C2DB6E44A2','ASSIST')
assert(r.semantic_id=='weapon:P-2 Peacemaker' and r.max_repeat_rpm==380)
verify(bridge,'968211c0033dce64','IGNORE_NATIVE_AUTO');verify(bridge,'35a61296619cc47e','EXCLUDE_CHARGE_HOLD')
for _,hash in ipairs({'1111111111111111','unknown','0000000000000000',1234})do
    assert(not p:classify(hash).allowed)
end
local imports,targets=bridge.imports,bridge.targets
for _=1,1000 do p:classify('05e4e5c2db6e44a2')end
assert(bridge.imports==imports and bridge.targets==targets,'No runtime metadata lookup while classifying')
r.category='IGNORE';assert(p:classify('05e4e5c2db6e44a2').allowed,'Returned metadata detached')
for _,bad in ipairs({{allowedModes={1,2},defaultModeSemantics='semi_auto',nativeModeVector={2,1,0}},
    {allowedModes={2},defaultModeSemantics='semi_auto',nativeModeVector={2,0,3}},
    {allowedModes={[1]=2,[4]=1},defaultModeSemantics='semi_auto',nativeModeVector={2,0,0}},
    {allowedModes={2},defaultModeSemantics='charge',nativeModeVector={2,0,0}},false})do
    bridge,metadata,modes=policy_fixture();modes['P-2 Peacemaker']=bad
    verify(bridge,'05e4e5c2db6e44a2','REVIEW')
end
for _,bad in ipairs({false,{}, {name='P-2 Peacemaker',resources={'broken'}},
    {name='wrong',resources={'05e4e5c2db6e44a2'}},
    {name='P-2 Peacemaker',resources={[1]='05e4e5c2db6e44a2',[3]='0000000000000001'}}})do
    bridge,metadata,modes=policy_fixture();metadata['P-2 Peacemaker']=bad
    verify(bridge,'05e4e5c2db6e44a2','REVIEW')
end
bridge,metadata,modes=policy_fixture()
metadata['AR-23 Liberator'].resources={'05e4e5c2db6e44a2'}
p,r=verify(bridge,'05e4e5c2db6e44a2','REVIEW');assert(r.reason=='semantic_hash_collision')
bridge,metadata,modes=policy_fixture();metadata['LAS-99 Quasar Cannon'].canonicalResourceHash='0000000000000001'
verify(bridge,'35a61296619cc47e','REVIEW')
for _,bad in ipairs({{}, {Connect=function()error('missing')end,Target=function()end},
    {Connect=function()return nil end,Target=function()end},
    {Connect=function()return {ok=false}end,Target=function()end}})do
    p=Policy.new(bad);assert(not p.available and not p:classify('05e4e5c2db6e44a2').allowed)
end
bridge,metadata,modes=policy_fixture();bridge.Target=function()error('malformed dependency')end
p=Policy.new(bridge);assert(not p:classify('05e4e5c2db6e44a2').allowed)
