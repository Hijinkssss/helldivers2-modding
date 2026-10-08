-- Optional adapter for CowboyBingus Mod Options Menu API 1.
-- Applied menu values are authoritative. Legacy config only seeds missing values.
local M={}
local Catalog=require('menu_catalog')
local ENABLED_ID='codex.full_auto_assist.enabled'
local PREFIX='codex.full_auto_assist.'
local function report(log,event,fields)
    if type(log)=='function' then pcall(log,event,fields or {}) end
end
function M.new(settings,handlers,log)
    local self={registered=false,failed=false,api=nil,option_count=0}
    local function apply(callback,...)
        if type(callback)~='function' then return end
        local ok,reason=pcall(callback,...)
        if not ok then report(log,'mod_menu_callback_failed',{reason=tostring(reason)}) end
    end
    function self:step()
        -- No API queries, allocations or file I/O after registration.
        if self.registered or self.failed then return end
        local api=rawget(_G,'ModOptionsMenu')
        if type(api)~='table' or api.api~=1 or type(api.register_option)~='function' or
            type(api.get)~='function' or type(api.set)~='function' or type(api.on_change)~='function' then return end
        local rows={
            {id=ENABLED_ID,spec={type='toggle',label='FAA Enabled',default=settings.user_enabled==true,
                description='Turn Full Auto Assist on or off. The = hotkey remains available.'},
                callback=function(value)
                    if type(value)=='boolean' then apply(handlers.set_enabled,value) end
                end},
        }
        for _,def in ipairs(Catalog.profiles)do
            local labels={}
            for i,choice in ipairs(def.choices)do labels[i]=choice.label end
            rows[#rows+1]={id=PREFIX..def.key,spec={type='choice',label=def.label,choices=labels,
                default=Catalog.default_index(def,settings),description=def.description,gap=true},
                callback=function(value)
                    if type(value)~='number' or value%1~=0 then return end
                    local choice=def.choices[value]
                    if choice then apply(handlers.set_profile,choice.value,def.weapon) end
                end}
        end
        -- Complete registrations before applying state. Refused registrations
        -- preserve fallback config and leave any partial callbacks inert.
        for _,row in ipairs(rows)do
            row.spec.mod='Full Auto Assist';row.spec.mod_id='codex.full_auto_assist'
            local ok,result,reason=pcall(api.register_option,row.id,row.spec)
            if not ok or result~=true then
                self.failed=true
                report(log,'mod_menu_registration_failed',{option=row.id,reason=tostring(ok and reason or result)})
                return
            end
        end
        for _,row in ipairs(rows)do
            local ok,result=pcall(api.on_change,row.id,function(value)
                if self.registered and not self.failed then row.callback(value) end
            end)
            if not ok or result~=true then
                self.failed=true
                report(log,'mod_menu_callback_registration_failed',{option=row.id})
                return
            end
        end
        self.api,self.registered,self.option_count=api,true,#rows
        for _,row in ipairs(rows)do
            local ok,value=pcall(api.get,row.id)
            if not ok or value==nil then value=row.spec.default end
            if row.id==ENABLED_ID and self.pending_enabled~=nil then value=self.pending_enabled end
            row.callback(value)
            -- Persist defaults/imports through the menu's supported save path.
            -- API set does not invoke callbacks and skips unchanged saved values.
            local saved,result=pcall(api.set,row.id,value)
            if not saved or result~=true then report(log,'mod_menu_seed_failed',{option=row.id}) end
        end
        report(log,'mod_menu_registered',{api=api.api,options=#rows})
        self.pending_enabled=nil
    end
    function self:set_enabled(value)
        -- Also keep the seed current when the menu has not loaded yet.
        settings.user_enabled=value==true
        if not self.registered then self.pending_enabled=value==true;return false end
        local ok,result=pcall(self.api.set,ENABLED_ID,value==true)
        return ok and result==true
    end
    return self
end
M.ENABLED_ID=ENABLED_ID
M.PEACEMAKER_ID=PREFIX..'peacemaker_profile'
return M
