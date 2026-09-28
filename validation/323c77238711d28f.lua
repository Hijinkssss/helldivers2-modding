local state = rawget(_G, 'HD2ModLoader')
if state then return state end
state = {modules = {}}
rawset(_G, 'HD2ModLoader', state)
function state.load(names)
    local bingus = rawget(_G, 'CowboyBingusModLoader')
    for _, name in ipairs(names) do
        if not state.modules[name] then
            if bingus and bingus.modules and bingus.modules[name] == 'loaded' then
                state.modules[name] = 'loaded'
            else
                local ok, available = pcall(function() return stingray.Application.can_get('lua', name) end)
                if ok and available then
                    state.modules[name] = 'loading'
                    local loaded, reason = pcall(require, name)
                    state.modules[name] = loaded and 'loaded' or 'load failed: ' .. tostring(reason)
                end
            end
        end
    end
end
state.load({'mods/codex/pickup_icons', 'mods/codex/gun_calibration', 'mods/codex/amr_reticle'})
return state
