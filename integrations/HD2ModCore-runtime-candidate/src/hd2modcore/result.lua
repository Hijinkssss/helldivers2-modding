local M = {}

function M.ok(value)
    return {ok = true, value = value}
end

function M.err(code, stage, detail)
    return {ok = false, error = {
        code = assert(code), stage = stage or 'unknown', detail = tostring(detail or '')
    }}
end

return M
