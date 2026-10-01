-- Single Full Auto Assist INI; no namespaces or runtime reconfiguration service.
local M={}
-- Only compatibility parsing retains RC1 names; there is no old cadence option.
function M.eruptor_profile(value)
    return ({stable_26='balanced_28',['26']='balanced_28',balanced='balanced_28',
        balanced_27='slower_27',fast_28='balanced_28',full_auto='max_32'})[value] or value
end
function M.load(schema,text,arsenal_options)
    assert(type(text)=='string' and #text<=8192,'Configuration exceeds 8192 bytes')
    local values,seen={},{}
    for key,rule in pairs(schema)do values[key]=rule.default end
    for line in (text..'\n'):gmatch('(.-)\r?\n')do
        if line:match('%S') and not line:match('^%s*[#;]')then
            local key,raw=line:match('^%s*([%a][%w_]*)%s*=%s*(.-)%s*$')
            assert(key and schema[key] and not seen[key],'Unknown, duplicate or malformed setting')
            seen[key]=true;local rule=schema[key];local value
            if key=='eruptor_profile' then raw=M.eruptor_profile(raw) end
            if rule.type=='boolean'then
                if raw=='true' or raw=='1'then value=true elseif raw=='false' or raw=='0'then value=false end
            elseif rule.type=='integer'then
                local n=tonumber(raw)
                if n and n==n and n%1==0 and n>=rule.min and n<=rule.max then value=n end
            elseif rule.type=='string' and #raw<=rule.max_length then value=raw end
            if value~=nil and rule.values then assert(rule.values[value],'Invalid setting: '..key); end
            assert(value~=nil,'Invalid setting: '..key);values[key]=value
        end
    end
    for key,value in pairs(arsenal_options or {}) do
        if key=='eruptor_profile' then value=M.eruptor_profile(value) end
        local rule=schema[key]
        assert(rule and rule.type=='string' and rule.values and rule.values[value],
            'Invalid Arsenal option: '..tostring(key))
        values[key]=value
    end
    return values
end
return M
