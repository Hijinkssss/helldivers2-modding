-- Consumer whitelist. Metadata can veto approval; it can never grant approval.
local M={}
local ENTRIES={
    {kind='weapon',name='P-2 Peacemaker',category='ASSIST',max_repeat_rpm=480,
        notes='Provisional 125 ms ceiling retained from previous candidate; selective cadence unvalidated.'},
    {kind='weapon',name='P-113 Verdict',category='REVIEW'},
    {kind='weapon',name='P-69 Veto',category='REVIEW'},
    {kind='weapon',name='M6C/SOCOM Pistol',category='REVIEW'},
    {kind='weapon',name='LAS-58 Talon',category='REVIEW'},
    {kind='weapon',name='R-63 Diligence',category='REVIEW'},
    {kind='weapon',name='R-63CS Diligence Counter Sniper',category='REVIEW'},
    {kind='support_weapon',name='APW-1 Anti-Materiel Rifle',category='REVIEW'},
    {kind='weapon',name='AR-23 Liberator',category='REVIEW'},
    {kind='weapon',name='R-2 Amendment',category='REVIEW',notes='Authored vector includes another mode; leave vanilla.'},
    {kind='support_weapon',name='LAS-99 Quasar Cannon',category='IGNORE'},
    {kind='support_weapon',name='LAS-98 Laser Cannon',category='IGNORE'}
}
function M.hash(value)
    if type(value)~='string' then return nil end
    value=value:lower():gsub('^0x','')
    if #value~=16 or value:find('[^0-9a-f]') then return nil end
    return value
end
local function single(values)
    if type(values)~='table' or values[1]==nil then return false end
    for key in pairs(values)do if key~=1 then return false end end
    return true
end
local function copy(entry)
    local result={};for key,value in pairs(entry)do result[key]=value end;return result
end
function M.new(bridge)
    local by_hash,notes={},{}
    local self={available=false,reason='optional_runtime_bridge_unavailable'}
    function self:classify(resource_hash,selected_mode)
        -- selected_mode is reserved for a future proven mode observer.
        local key=M.hash(resource_hash)
        local entry=key and by_hash[key]
        if not entry then return {category='REVIEW',allowed=false,reason='unknown_or_ambiguous_weapon'} end
        return copy(entry)
    end
    function self:status()
        local count=0;for _ in pairs(by_hash)do count=count+1 end
        local detached={};for i,note in ipairs(notes)do detached[i]=copy(note) end
        return {available=self.available,reason=self.reason,mapped_resources=count,notes=detached}
    end
    if type(bridge)~='table' or type(bridge.Connect)~='function' or type(bridge.Target)~='function' then return self end
    local connected,result=pcall(bridge.Connect,bridge)
    if not connected or type(result)~='table' or result.ok~=true then
        self.reason='runtime_unavailable';return self
    end
    self.available=true;self.reason='ready'
    for _,entry in ipairs(ENTRIES)do
        local ok,metadata,modes=pcall(function()
            local result=bridge:Target(entry.kind,entry.name)
            assert(type(result)=='table' and result.ok==true and type(result.value)=='table','Target unavailable')
            local target=result.value
            return target:describe(),type(target.fire_modes)=='function' and target:fire_modes() or nil
        end)
        local resources=ok and type(metadata)=='table' and (metadata.resources or metadata.resourceHashes)
        local identity=ok and type(metadata)=='table' and (metadata.name or metadata.catalogIdentity)
        if not single(resources) or not M.hash(resources[1]) or identity~=entry.name then
            notes[#notes+1]={name=entry.name,category='REVIEW',reason='semantic_identity_not_unique_or_malformed'}
        else
            local key=M.hash(resources[1]);local category=entry.category;local reason='explicit_consumer_policy'
            if entry.kind=='support_weapon' and (metadata.identityResolution~='UNIQUE' or
                M.hash(metadata.canonicalResourceHash)~=key) then
                category='REVIEW';reason='semantic_identity_not_unique'
            end
            if category=='ASSIST' and (type(modes)~='table' or
                modes.defaultModeSemantics~='semi_auto' or not single(modes.allowedModes) or modes.allowedModes[1]~=2 or
                type(modes.nativeModeVector)~='table' or modes.nativeModeVector[1]~=2 or
                modes.nativeModeVector[2]~=0 or modes.nativeModeVector[3]~=0) then
                category='REVIEW';reason='single_semi_auto_mode_not_proven'
            end
            if by_hash[key] then
                by_hash[key]={category='REVIEW',allowed=false,reason='semantic_hash_collision'}
            else
                by_hash[key]={name=identity,semantic_id=entry.kind..':'..identity,category=category,
                    allowed=category=='ASSIST',max_repeat_rpm=category=='ASSIST' and entry.max_repeat_rpm or nil,
                    resource_hash=key,reason=reason,notes=entry.notes}
            end
        end
    end
    return self
end
return M
