local Result = require('hd2modcore.result')
local Util = require('hd2modcore.util')

local M = {}
local Config = {}
Config.__index = Config

local function valid_namespace(name)
    return type(name) == 'string' and name:match('^[%a][%w_]*$') ~= nil
end

local function decode(raw, rule)
    if rule.type == 'boolean' then
        if raw == 'true' or raw == '1' then return true end
        if raw == 'false' or raw == '0' then return false end
    elseif rule.type == 'integer' then
        local number = tonumber(raw)
        if number and number % 1 == 0 and number >= (rule.min or -math.huge)
            and number <= (rule.max or math.huge) then return number end
    elseif rule.type == 'string' then
        if #raw <= (rule.max_length or 256) and
            (not rule.pattern or raw:match(rule.pattern)) then return raw end
    elseif rule.type == 'enum' then
        for _, choice in ipairs(rule.values or {}) do
            if raw == choice then return raw end
        end
    end
    return nil
end

function M.new()
    return setmetatable({schemas = {}, values = {}, warnings = {}}, Config)
end

function Config:register(namespace, schema)
    if not valid_namespace(namespace) or self.schemas[namespace] then
        return Result.err('InvalidConfig', 'register', 'invalid or duplicate namespace')
    end
    if type(schema) ~= 'table' then
        return Result.err('InvalidConfig', 'register', 'schema must be a table')
    end
    local defaults = {}
    for key, rule in pairs(schema) do
        if not valid_namespace(key) or type(rule) ~= 'table' or
            decode(tostring(rule.default), rule) == nil then
            return Result.err('InvalidConfig', 'register', 'invalid rule ' .. tostring(key))
        end
        defaults[key] = rule.default
    end
    self.schemas[namespace] = schema
    self.values[namespace] = defaults
    return Result.ok(true)
end

-- Atomic load: malformed/unknown entries are reported and the prior values stay in use.
function Config:load(namespace, text)
    local schema = self.schemas[namespace]
    if not schema then return Result.err('InvalidConfig', 'load', 'unknown namespace') end
    if type(text) ~= 'string' or #text > 8192 then
        return Result.err('InvalidConfig', 'load', 'configuration exceeds 8192 bytes')
    end
    local next_values, seen, issues = {}, {}, {}
    for key, rule in pairs(schema) do next_values[key] = rule.default end
    local line_number = 0
    for line in (text .. '\n'):gmatch('(.-)\r?\n') do
        line_number = line_number + 1
        if line:match('%S') and not line:match('^%s*[#;]') then
            local key, raw = line:match('^%s*([%a][%w_]*)%s*=%s*(.-)%s*$')
            if not key then
                issues[#issues + 1] = 'line ' .. line_number .. ': malformed'
            elseif not schema[key] then
                issues[#issues + 1] = 'line ' .. line_number .. ': unknown key ' .. key
            elseif seen[key] then
                issues[#issues + 1] = 'line ' .. line_number .. ': duplicate key ' .. key
            else
                seen[key] = true
                local value = decode(raw, schema[key])
                if value == nil then
                    issues[#issues + 1] = 'line ' .. line_number .. ': invalid ' .. key
                else
                    next_values[key] = value
                end
            end
        end
    end
    self.warnings[namespace] = issues
    if #issues > 0 then
        return Result.err('InvalidConfig', 'load', table.concat(issues, '; '))
    end
    self.values[namespace] = next_values
    return Result.ok(Util.copy(next_values))
end

function Config:get(namespace, key)
    local group = self.values[namespace]
    if not group or group[key] == nil then
        return Result.err('InvalidConfig', 'get', 'unknown setting')
    end
    return Result.ok(group[key])
end

function Config:status()
    return {namespaces = Util.sorted_keys(self.schemas), warnings = Util.copy(self.warnings)}
end

return M
