local Util = require('hd2modcore.util')

local M = {}
local Logger = {}
Logger.__index = Logger

local LEVEL = {trace=1, debug=2, info=3, warning=4, error=5, fatal=6}

local function clean(value)
    return tostring(value):gsub('[\r\n]', ' '):gsub('%z', ' '):sub(1, 512)
end

function M.new(loader, clock_ms, level)
    assert(type(loader) == 'table', 'loader required')
    local self = setmetatable({loader=loader, clock=clock_ms or function() return 0 end,
        level=level or 'info', recent={}, maximum=64, history=nil, errors=0,
        last_status=nil}, Logger)
    assert(LEVEL[self.level], 'invalid log level')
    if type(loader.open_log) == 'function' then
        local ok, handle = pcall(loader.open_log, 'HD2ModCoreEvents.log')
        if ok and handle then self.history=handle else self.errors=self.errors+1 end
    end
    return self
end

function Logger:set_level(level)
    if not LEVEL[level] then return false end
    self.level=level
    return true
end

function Logger:emit(level, category, event, fields)
    if not LEVEL[level] then return false end
    if LEVEL[level] < LEVEL[self.level] then return true end
    local parts = {string.format('%.3f', self.clock()), clean(level),
        clean(category or 'core'), clean(event or '')}
    if type(fields)=='table' then
        for _, key in ipairs(Util.sorted_keys(fields)) do
            parts[#parts+1]=clean(key)..'='..clean(fields[key])
        end
    end
    local line=table.concat(parts,' ')..'\n'
    self.recent[#self.recent+1]=line:sub(1,-2)
    if #self.recent>self.maximum then table.remove(self.recent,1) end
    if self.history then
        local ok=pcall(function() assert(self.history:write(line)) end)
        if not ok then
            self.errors=self.errors+1
            pcall(function() self.history:close() end)
            self.history=nil
        end
    elseif (level=='error' or level=='fatal') and type(self.loader.print)=='function' then
        pcall(self.loader.print, '[HD2ModCore] '..line)
    end
    return true
end

-- Loader.open_log uses 'w': this is a whole status snapshot, not append history.
function Logger:status_snapshot(text)
    self.last_status=text
    if type(self.loader.open_log)~='function' then return false end
    local ok=pcall(function()
        local file=assert(self.loader.open_log('HD2ModCoreStatus.log'))
        assert(file:write(text))
        assert(file:close())
    end)
    if not ok then self.errors=self.errors+1 end
    return ok
end

function Logger:close()
    if self.history then
        local ok=pcall(function()
            if self.history.flush then self.history:flush() end
            assert(self.history:close())
        end)
        self.history=nil
        if not ok then self.errors=self.errors+1 end
        return ok
    end
    return true
end

function Logger:status()
    return {level=self.level, history_open=self.history~=nil,
        errors=self.errors, recent=Util.copy(self.recent)}
end

return M
