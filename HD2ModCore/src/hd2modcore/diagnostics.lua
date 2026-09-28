local Util = require('hd2modcore.util')

local M = {}
local Diagnostics = {}
Diagnostics.__index = Diagnostics

function M.new(version)
    return setmetatable({version=version, state='uninitialized', modules={},
        profile={state='unidentified'}, validations={}, recent_error=nil,
        scheduler={}, events={}, memory={},symbols={},game_state={},input={}}, Diagnostics)
end

function Diagnostics:module(name, state, reason)
    self.modules[name]={state=state, reason=reason}
end

function Diagnostics:validation(name, state, reason)
    self.validations[name]={state=state, reason=reason}
end

function Diagnostics:error(code, stage, detail)
    self.recent_error={code=code, stage=stage, detail=tostring(detail)}
end

function Diagnostics:status()
    return Util.copy({version=self.version, state=self.state, modules=self.modules,
        profile=self.profile, validations=self.validations,
        scheduler=self.scheduler, events=self.events, memory=self.memory,
        symbols=self.symbols,game_state=self.game_state,input=self.input,
        recent_error=self.recent_error})
end

local function printable(value)
    return tostring(value or ''):gsub('[\r\n]', ' '):gsub('%z', ' '):sub(1,256)
end

function Diagnostics:render()
    local lines={'version='..printable(self.version),'state='..printable(self.state),
        'profile='..printable(self.profile.id or self.profile.state),
        'profile_state='..printable(self.profile.state)}
    for _,name in ipairs(Util.sorted_keys(self.modules)) do
        local row=self.modules[name]
        lines[#lines+1]='module.'..name..'='..printable(row.state)
        if row.reason then lines[#lines+1]='module.'..name..'.reason='..printable(row.reason) end
    end
    for _,name in ipairs(Util.sorted_keys(self.validations)) do
        local row=self.validations[name]
        lines[#lines+1]='validation.'..name..'='..printable(row.state)
        if row.reason then
            lines[#lines+1]='validation.'..name..'.reason='..printable(row.reason)
        end
    end
    for _,name in ipairs(Util.sorted_keys(self.scheduler)) do
        lines[#lines+1]='scheduler.'..name..'='..printable(self.scheduler[name])
    end
    for _,name in ipairs(Util.sorted_keys(self.memory)) do
        lines[#lines+1]='memory.'..name..'='..printable(self.memory[name])
    end
    for _,name in ipairs(Util.sorted_keys(self.symbols)) do
        lines[#lines+1]='symbols.'..name..'='..printable(self.symbols[name])
    end
    for _,name in ipairs(Util.sorted_keys(self.game_state)) do
        lines[#lines+1]='game_state.'..name..'='..printable(self.game_state[name])
    end
    for _,name in ipairs(Util.sorted_keys(self.events)) do
        lines[#lines+1]='events.'..name..'='..printable(self.events[name])
    end
    for _,name in ipairs(Util.sorted_keys(self.input)) do
        lines[#lines+1]='input.'..name..'='..printable(self.input[name])
    end
    if self.recent_error then
        lines[#lines+1]='error.code='..printable(self.recent_error.code)
        lines[#lines+1]='error.stage='..printable(self.recent_error.stage)
        lines[#lines+1]='error.detail='..printable(self.recent_error.detail)
    end
    return table.concat(lines,'\n')..'\n'
end

return M
