-- FAA-only compatibility boundary. No resolver is authorized by the retained
-- historical evidence. Unknown builds never receive addresses or write access.
local M={}
local known={
    id='steam-25480438-v02-candidate',build='25480438',layout='faa-25480438-v1',
    exe='F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06',
    dll='2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E',
    globals={player_manager=0x3326468,entity_owner=0x346bf98,
        avatar_manager=0x3326d20,weapon_wielder=0x3326420,equipment_manager=0x3326dc0,
        controls=0x347cf18,game_state=0x3326340,ui_manager=0x347ce28},
    fire_anchors={
        {0x12fc180,'\x48\x8b\xc4\x48\x89\x58\x08\x48\x89\x68\x10\x48'},
        {0x12fc44c,'\x41\x0f\x5a\xc3\x0f\x5a\xcf\xe8\x58\xcb\xe0\x00'},
        {0x12fa3b3,'\xe8\xc8\xb7\x28\xff\x44\x8b\x8e\xd8\x7a\x0a\x00'}},
    text_anchor={0x14aeb30,'\x48\x89\x74\x24\x10\x57\x48\x83\xec\x30'},
    fire={state_offset=0x1c88,map_offset=0xa7ad0,action=0x20009,
        game_state_offset=0xac21c,unit_offset=0x3a8},
    ui={state_offset=0x4294,state_size=0x90}
}
local required={'player_manager','entity_owner','avatar_manager','weapon_wielder',
    'equipment_manager','controls','game_state','ui_manager','identity_layout',
    'input_mapping_layout','ui_input_layout','weapon_policy_semantics'}
local function copy(t)
    local out={};for k,v in pairs(t)do out[k]=type(v)=='table' and copy(v) or v end;return out
end
-- Copy for offline evidence tooling/tests; possession of this table is not a
-- runtime capability. Only profiles issued by resolve() are accepted below.
function M.known_profile()return copy(known)end
local selected=setmetatable({},{__mode='k'})
local issued=setmetatable({},{__mode='k'})
local function hash(platform,name)
    local good,value=pcall(platform.module_hash,platform,name)
    if good and type(value)=='string' and #value==64 and value:match('^%x+$')then return value:upper()end
end
function M.select(platform)
    local exe,dll=hash(platform,nil),hash(platform,'game.dll')
    if exe==known.exe and dll==known.dll then
        local token={};selected[token]=true
        return token,{compatibility='known_profile',build=known.build,known_build=true}
    end
    local missing={};for _,name in ipairs(required)do missing[#missing+1]=name..'_evidence_missing'end
    -- Do not probe old RVAs, accept externally supplied patterns or let a test
    -- resolver authorize native writes. Add a reviewed resolver here only after
    -- all capabilities have provenance and negative validation evidence.
    return nil,{compatibility='unsupported',known_build=false,
        reason=(not exe or not dll) and 'module_fingerprint_unavailable' or 'capability_evidence_missing',
        missing=missing}
end
function M.resolve(token,base,size)
    assert(selected[token],'compatibility=unsupported reason=unapproved_profile')
    assert(type(base)=='number' and base%1==0 and base>=0x10000 and base<=0x7fffffffffff,
        'Invalid module base')
    assert(type(size)=='number' and size%1==0 and size>=4096 and size<=0x80000000 and
        size<=0x7fffffffffff-base,'Invalid module extent')
    local function address(rva,length)
        assert(rva>=0 and rva<=size-length,'Compatibility address outside module image')
        return base+rva
    end
    local p={id=known.id,build=known.build,layout=known.layout,base=base,size=size,
        source='known_profile',globals={},fire=copy(known.fire),ui=copy(known.ui),fire_anchors={},
        capabilities={native_globals='known_profile',identity_layout='guarded_observer',
            input_mapping='validate_before_each_lease',ui_input='validate_each_sample'}}
    for name,rva in pairs(known.globals)do p.globals[name]=address(rva,8)end
    for _,anchor in ipairs(known.fire_anchors)do
        p.fire_anchors[#p.fire_anchors+1]={address(anchor[1],#anchor[2]),anchor[2]}
    end
    p.text_anchor={address(known.text_anchor[1],#known.text_anchor[2]),known.text_anchor[2]}
    issued[p]=true;return p
end
function M.supported(profile)return issued[profile]==true end
function M.status(profile)
    assert(M.supported(profile),'Unresolved compatibility profile')
    return {id=profile.id,state='exact_fingerprints_matched',compatibility=profile.source,
        build=profile.build,known_build=true,layout=profile.layout}
end
return M
