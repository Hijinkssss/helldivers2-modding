-- Single Full Auto Assist INI; no namespaces or runtime reconfiguration service.
local M={}
function M.load(schema,text)
    assert(type(text)=='string' and #text<=8192,'Configuration exceeds 8192 bytes')
    local values,seen={},{}
    for key,rule in pairs(schema)do values[key]=rule.default end
    for line in (text..'\n'):gmatch('(.-)\r?\n')do
        if line:match('%S') and not line:match('^%s*[#;]')then
            local key,raw=line:match('^%s*([%a][%w_]*)%s*=%s*(.-)%s*$')
            assert(key and schema[key] and not seen[key],'Unknown, duplicate or malformed setting')
            seen[key]=true;local rule=schema[key];local value
            if rule.type=='boolean'then
                if raw=='true' or raw=='1'then value=true elseif raw=='false' or raw=='0'then value=false end
            elseif rule.type=='integer'then
                local n=tonumber(raw)
                if n and n==n and n%1==0 and n>=rule.min and n<=rule.max then value=n end
            elseif rule.type=='string' and #raw<=rule.max_length then value=raw end
            assert(value~=nil,'Invalid setting: '..key);values[key]=value
        end
    end
    assert(values.fire_rate_mode=='balanced' or values.fire_rate_mode=='native_cap','Invalid fire_rate_mode')
    assert(values.talon_mode=='balanced' or values.talon_mode=='efficiency' or
        values.talon_mode=='full_auto' or values.talon_mode=='fuller_auto','Invalid talon_mode')
    return values
end
return M
