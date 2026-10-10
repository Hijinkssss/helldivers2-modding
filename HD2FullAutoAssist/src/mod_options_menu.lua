-- Optional CB Mod Options Menu API 1 adapter. One category, one row per weapon.
local M={}
local Catalog=require('menu_catalog')
local Policy=require('weapon_policy')
local PREFIX='codex.full_auto_assist.'
local GLOBAL_ID=PREFIX..'enabled'
local special={}
for _,def in ipairs(Catalog.profiles)do special[def.weapon]=def end
local function option_id(group,key)return PREFIX..group..'.'..key end
local function selection_id(name)
    local def=special[name]
    if def then return PREFIX..'selection_v130.'..def.key end
    for _,group in ipairs(Policy.WEAPON_MENU_GROUPS)do
        for _,weapon in ipairs(group.weapons)do
            if weapon==name then return option_id(group.key,Policy.WEAPON_SETTINGS[name])end
        end
    end
end
local function report(log,event,fields)
    if type(log)=='function' then pcall(log,event,fields or {})end
end
local function apply(log,callback,...)
    if type(callback)~='function' then return end
    local ok,reason=pcall(callback,...)
    if not ok then report(log,'mod_menu_callback_failed',{reason=tostring(reason)})end
end
-- API get exposes registered values only. Read legacy keys once, without
-- registering obsolete rows or writing the menu-owned file. All saves use set.
-- Match CB's documented path and primary/backup selection exactly.
local function legacy_values()
    local loader=rawget(_G,'CowboyBingusModLoader')
    local directory=type(loader)=='table' and loader.log_directory
    if type(directory)~='string' or directory=='' then
        local base=os.getenv('LOCALAPPDATA')
        if not base then return {} end
        directory=base..'/CowboyBingus/Helldivers2/Logs'
    end
    local function read(path)
        local file=io.open(path,'rb');if not file then return nil end
        local text=file:read('*a');file:close()
        local values,found={},false
        for id,value in (text or ''):gmatch('([^\t\r\n]+)\t([^\r\n]*)')do
            values[id]=value;found=true
        end
        return found and values or nil
    end
    local path=directory..'/ModOptionsMenu.values'
    return read(path) or read(path..'.bak') or {}
end
local function migrated_default(def,name,group,settings,saved)
    local enabled=settings[Policy.WEAPON_SETTINGS[name]]~=false
    local previous=saved[option_id(group,Policy.WEAPON_SETTINGS[name])]
    if previous=='false' then enabled=false elseif previous=='true' then enabled=true end
    if not def then return enabled end
    local current=saved[selection_id(name)]
    if current~=nil then
        local index=tonumber(current)
        if not index or index%1~=0 or index<1 or index>#def.choices+1 then return 2 end
    end
    if not enabled then return 1 end
    local old=saved[PREFIX..def.key]
    if old~=nil then
        local index=tonumber(old)
        if index and index%1==0 and def.choices[index] then return index+1 end
        return 2 -- corrupt saved profile uses the established default
    end
    return Catalog.default_index(def,settings)+1
end
local function make_rows(settings,handlers,log,saved)
    local rows={{id=GLOBAL_ID,spec={type='toggle',label='FAA Enabled',default=settings.user_enabled==true,
        description='ON enables FAA for weapons whose selection is not OFF. OFF overrides all weapon selections without changing them. The = hotkey toggles this same setting.'},
        callback=function(value)
            if type(value)=='boolean' then settings.user_enabled=value;apply(log,handlers.set_enabled,value)end
        end}}
    local prefixes={primary='Primary: ',secondary='Secondary: ',support='Support: '}
    for group_index,group in ipairs(Policy.WEAPON_MENU_GROUPS)do
        for weapon_index,weapon in ipairs(group.weapons)do
            local name,def=weapon,special[weapon]
            local setting=Policy.WEAPON_SETTINGS[name]
            local row={id=selection_id(name),name=name,def=def,spec={label=prefixes[group.key]..name,
                gap=group_index>1 and weapon_index==1,
                default=migrated_default(def,name,group.key,settings,saved)}}
            if def then
                local labels={'OFF'}
                for _,choice in ipairs(def.choices)do labels[#labels+1]=string.upper(choice.label)end
                row.spec.type='choice';row.spec.choices=labels
                row.spec.description='OFF: disable FAA for this weapon. '..def.description
                row.callback=function(value)
                    if type(value)~='number' or value%1~=0 or value<1 or value>#labels then return end
                    local enabled=value~=1
                    settings[setting]=enabled
                    if enabled then
                        local profile=def.choices[value-1].value
                        settings[def.key]=profile
                        apply(log,handlers.set_profile,profile,name)
                    end
                    apply(log,handlers.set_weapon_enabled,name,enabled)
                end
            else
                row.spec.type='toggle'
                row.spec.description='OFF disables FAA for this weapon. ON enables its existing normal held-fire assistance. FAA repeats normal Fire input; accepted shots remain subject to the game\'s firing restrictions.'
                row.callback=function(value)
                    if type(value)~='boolean' then return end
                    settings[setting]=value;apply(log,handlers.set_weapon_enabled,name,value)
                end
            end
            rows[#rows+1]=row
        end
    end
    for _,row in ipairs(rows)do row.spec.mod='FULL AUTO ASSIST';row.spec.mod_id='codex.full_auto_assist'end
    return rows
end
function M.new(settings,handlers,log)
    local self={registered=false,failed=false,api=nil,option_count=0}
    local pending={}
    function self:step()
        if self.registered or self.failed then return end
        local api=rawget(_G,'ModOptionsMenu')
        if type(api)~='table' or api.api~=1 or type(api.register_option)~='function' or
            type(api.get)~='function' or type(api.set)~='function' or type(api.on_change)~='function' then return end
        local rows=make_rows(settings,handlers,log,legacy_values())
        if type(api.max_options)=='number' and #rows>api.max_options then
            self.failed=true;report(log,'mod_menu_capacity_blocked',{required=#rows,available=api.max_options});return
        end
        -- Complete schema and callbacks before applying any runtime setting.
        for _,row in ipairs(rows)do
            local ok,result,reason=pcall(api.register_option,row.id,row.spec)
            if not ok or result~=true then
                self.failed=true;report(log,'mod_menu_registration_failed',{option=row.id,reason=tostring(ok and reason or result)});return
            end
        end
        for _,row in ipairs(rows)do
            local current=row
            local ok,result=pcall(api.on_change,current.id,function(value)
                if self.registered and not self.failed then current.callback(value)end
            end)
            if not ok or result~=true then self.failed=true;report(log,'mod_menu_callback_registration_failed',{option=current.id});return end
        end
        self.api,self.registered=api,true
        for _,row in ipairs(rows)do
            local ok,value=pcall(api.get,row.id)
            if not ok or value==nil then value=row.spec.default end
            if pending[row.id]~=nil then value=pending[row.id]end
            row.callback(value)
            local saved,result=pcall(api.set,row.id,value)
            if not saved or result~=true then report(log,'mod_menu_seed_failed',{option=row.id})end
            self.option_count=self.option_count+1
        end
        pending={}
        report(log,'mod_menu_registered',{api=api.api,options=self.option_count,categories=1})
    end
    function self:set_enabled(value)
        value=value==true;settings.user_enabled=value
        if not self.registered then pending[GLOBAL_ID]=value;return false end
        local ok,result=pcall(self.api.set,GLOBAL_ID,value);return ok and result==true
    end
    function self:set_weapon_enabled(name,value)
        local setting=Policy.WEAPON_SETTINGS[name]
        if not setting or type(value)~='boolean' then return false end
        settings[setting]=value
        local def=special[name]
        local selected=value
        if def then selected=value and (Catalog.default_index(def,settings)+1) or 1 end
        local id=selection_id(name)
        if not self.registered then pending[id]=selected;return false end
        local ok,result=pcall(self.api.set,id,selected);return ok and result==true
    end
    return self
end
M.GLOBAL_ID=GLOBAL_ID;M.ENABLED_ID=GLOBAL_ID
M.PEACEMAKER_ID=selection_id('P-2 Peacemaker')
M.option_id=option_id;M.selection_id=selection_id;M.category_count=1
return M
