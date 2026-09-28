-- Minimal independent consumer: no native calls or gameplay action.
local M = {}
local OWNER, CHANNEL = 'hd2_mod_template', 'hd2_mod_template.heartbeat'

local function must(result)
    assert(result and result.ok,
        result and result.error and result.error.detail or 'Core operation failed')
    return result.value
end

local function config_text()
    local root = assert(os.getenv('LOCALAPPDATA'), 'LOCALAPPDATA unavailable')
    local file, reason, number = io.open(root..'/CowboyBingus/Helldivers2/HD2ModTemplate.ini', 'rb')
    if not file then
        if number == 2 then return '' end
        error(reason)
    end
    local text = file:read(8193)
    assert(file:close())
    assert(text and #text <= 8192, 'Configuration exceeds 8192 bytes')
    return text
end

function M.install(core, read_config)
    assert(core.api == 1 and core.Config and core.Logger and core.Hooks and core.Events
        and core.Input and type(core.Input.ShortcutEligibility) == 'function',
        'HD2ModCore v0.3.0-dev / API 1 input eligibility required')
    local scheduler, event, input, closed
    local function emit(name, fields)
        core.Logger:Emit('info', OWNER, name, fields or {})
    end
    must(core:OnUnload(OWNER, function()
        if closed then return end
        closed = true
        if input then core.Input:Remove(input); input = nil end
        if scheduler then core.Hooks:Remove(scheduler); scheduler = nil end
        if event then core.Events:Remove(event); event = nil end
        emit('stopped')
    end))
    local loaded = core:OnLoad(OWNER, function()
        must(core.Config:Register(OWNER, {
            enabled={type='boolean',default=true},
            hotkey={type='string',default='F11',max_length=16}
        }))
        local settings = must(core.Config:Load(OWNER, (read_config or config_text)()))
        must(core.Input:ParseKey(settings.hotkey))
        if not settings.enabled then emit('disabled'); return end
        event = must(core.Events:Subscribe(OWNER, CHANNEL, function(change)
            emit('heartbeat_changed', {ticks=change.current.ticks})
        end))
        local ticks = 0
        scheduler = must(core.Hooks:Subscribe(OWNER, 'after_update',
            {every_ms=1000,budget_us=500,error_policy='disable'}, function()
                ticks = ticks + 1
                must(core.Events:Observe(CHANNEL, ticks, {ticks=ticks}))
            end))
        input = must(core.Input:SubscribePressed(OWNER, settings.hotkey,
            {debounce_ms=150}, function()
                local result = core.Input:ShortcutEligibility()
                if not result.ok or result.value.allowed ~= true then return end
                emit('eligible_hotkey') -- Replace with a separately validated action.
            end))
        emit('started', {hotkey=settings.hotkey})
    end)
    if not loaded.ok then
        core:Unregister(OWNER)
        error(loaded.error.detail)
    end
    return {name=OWNER, stop=function() return core:Unregister(OWNER) end}
end

return M
