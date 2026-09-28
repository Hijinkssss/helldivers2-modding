local M = {}

function M.integer(value, minimum, maximum)
    return type(value) == 'number' and value == value
        and value % 1 == 0 and value >= minimum and value <= maximum
end

function M.copy(value, depth, budget)
    depth, budget = depth or 0, budget or {left = 1024, bytes = 131072,
        max_depth = 12}
    local value_type = type(value)
    assert(value_type ~= 'function' and value_type ~= 'userdata' and
        value_type ~= 'thread' and value_type ~= 'cdata',
        'snapshot contains an unsafe value')
    if value_type ~= 'table' then
        if value_type == 'string' then
            budget.bytes = budget.bytes - #value
            assert(budget.bytes >= 0, 'snapshot too large')
        elseif value_type == 'number' then
            assert(value == value and value ~= math.huge and value ~= -math.huge,
                'snapshot contains a nonfinite number')
        end
        return value
    end
    assert(depth < budget.max_depth and budget.left > 0,
        'snapshot too deep or large')
    local result = {}
    for key, item in pairs(value) do
        budget.left = budget.left - 1
        assert(budget.left >= 0, 'snapshot too large')
        assert(type(key)=='string' or type(key)=='number',
            'snapshot contains an unsafe key')
        if type(key)=='string' then
            assert(#key<=128, 'snapshot key too large')
            budget.bytes=budget.bytes-#key
            assert(budget.bytes>=0, 'snapshot too large')
        else
            assert(key==key and key~=math.huge and key~=-math.huge,
                'snapshot contains a nonfinite key')
        end
        result[key] = M.copy(item, depth + 1, budget)
    end
    return result
end

function M.pack(...)
    return {n = select('#', ...), ...}
end

function M.unpack(values, first)
    return unpack(values, first or 1, values.n)
end

function M.sorted_keys(value)
    local keys = {}
    for key in pairs(value) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    return keys
end

return M
