-- On-demand shortcut eligibility, for Full Auto Assist Fire and toggle guards.
-- UI layout evidence: installed C4 Quick Actions v1.1 NativeUiGuard.
-- Text receiver: current-build chat registration -> native UI text-input service.
local Result={ok=function(v)return {ok=true,value=v}end,
    err=function(code,stage,detail)return {ok=false,error={code=code,stage=stage,detail=detail}}end}
local M={}
local Compatibility=require('compatibility')
local NO_TEXT_RECEIVER=string.rep('\0',8)
local function boolean(value)
    if value==true or value==1 then return true end
    if value==false or value==0 then return false end
    error('invalid engine window state')
end
local function u32(bytes,offset)
    local a,b,c,d=bytes:byte(offset+1,offset+4)
    return a+b*256+c*65536+d*16777216
end
local function require_value(result)
    assert(result and result.ok,'UI state read unavailable')
    return result.value
end
function M.sample(platform,memory,profile,engine)
    if not Compatibility.supported(profile) then
        return Result.err('UnsupportedBuild','input_eligibility','resolved UI capabilities required')
    end
    local ok,row=pcall(function()
        local window=assert(type(engine)=='table' and engine.Window,'engine Window unavailable')
        assert(type(window.has_focus)=='function' and type(window.show_cursor)=='function',
            'engine window readers unavailable')
        local focused,cursor=boolean(window.has_focus()),boolean(window.show_cursor())
        assert(type(platform.module_address)=='function','module address unavailable')
        local base=assert(platform:module_address('game.dll'),'game module unavailable')
        assert(base==profile.base,'UI module base changed')
        local UI=profile.globals.ui_manager
        local STATE_OFFSET,STATE_SIZE=profile.ui.state_offset,profile.ui.state_size
        local TEXT_REGISTER,TEXT_REGISTER_PREFIX=unpack(profile.text_anchor)
        assert(require_value(memory:read(TEXT_REGISTER,#TEXT_REGISTER_PREFIX))==
            TEXT_REGISTER_PREFIX,'native text-input layout anchor changed')
        local ui=require_value(memory:read_pointer(UI))
        assert(ui,'UI manager unavailable')
        -- Null receiver means no text target. Never dereference it or read typed text.
        local receiver=require_value(memory:read(ui,8))
        assert(type(receiver)=='string' and #receiver==8,'text receiver short read')
        local text_entry=receiver~=NO_TEXT_RECEIVER
        local bytes=require_value(memory:read(ui+STATE_OFFSET,STATE_SIZE))
        assert(type(bytes)=='string' and #bytes==STATE_SIZE,'UI state short read')
        local primary,modal=u32(bytes,0),u32(bytes,4)
        local count,secondary,pending=u32(bytes,0x1c),u32(bytes,0x84),u32(bytes,0x8c)
        assert(count<=5 and secondary<=25,'UI state bounds changed')
        local busy=primary~=0 or modal~=0 or secondary~=0 or pending~=0
        for i=1,count do busy=busy or u32(bytes,8+(i-1)*4)~=0 end
        assert(require_value(memory:read_pointer(UI))==ui and
            require_value(memory:read(ui,8))==receiver and
            require_value(memory:read(ui+STATE_OFFSET,STATE_SIZE))==bytes,'UI state changed during read')
        -- Re-read engine window flags too; a transition is an unavailable state.
        assert(boolean(window.has_focus())==focused and boolean(window.show_cursor())==cursor,
            'engine window state changed during read')
        local reason=not focused and 'game_focus_lost' or cursor and 'ui_cursor_visible'
            or text_entry and 'text_entry_active' or busy and 'ui_busy' or 'eligible'
        return {allowed=reason=='eligible',reason=reason,window_focused=focused,
            cursor_visible=cursor,text_entry_active=text_entry,primary=primary,modal=modal,stack_count=count,
            secondary_count=secondary,pending=pending}
    end)
    if not ok then return Result.err('Unavailable','input_eligibility',tostring(row)) end
    return Result.ok(row)
end
return M
