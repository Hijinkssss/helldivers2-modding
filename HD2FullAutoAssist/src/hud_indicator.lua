-- Pure, read-only presentation projection for a future HUD renderer.
-- This module deliberately does not create a widget or read game memory.
local M={}

local function finite_number(value)
    return type(value)=='number' and value==value and value~=math.huge and value~=-math.huge
end

function M.project(snapshot,weapon_hud_opacity)
    local hidden={state='HIDDEN',visible=false,slash=false,opacity=0}
    if type(snapshot)~='table' or snapshot.identity_valid~=true or snapshot.identity_observed~=true then
        return hidden
    end
    local category=type(snapshot.eligibility)=='table' and snapshot.eligibility.category
    if category~='ASSIST' and category~='SPECIAL' then return hidden end
    if type(snapshot.weapon)~='table' or type(snapshot.weapon.semantic_id)~='string' or snapshot.weapon.semantic_id=='' then
        return hidden
    end

    -- The renderer will pass the native weapon-HUD alpha when it can read it.
    -- Until then, nil means fully active. Invalid values fail closed for presentation.
    local opacity=1
    if weapon_hud_opacity~=nil then
        if not finite_number(weapon_hud_opacity) then return hidden end
        opacity=math.max(0,math.min(1,weapon_hud_opacity))
    end
    if opacity<=0 then return hidden end
    local enabled=snapshot.user_enabled==true
    local dim=opacity<0.999
    local state=enabled and (dim and 'ENABLED_DIM' or 'ENABLED') or
        (dim and 'DISABLED_DIM' or 'DISABLED')
    return {state=state,visible=true,slash=not enabled,opacity=opacity}
end

return M
