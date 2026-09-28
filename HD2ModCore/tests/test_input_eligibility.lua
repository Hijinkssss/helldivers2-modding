local guard=require('hd2modcore.input_eligibility')
local function ok(v)return {ok=true,value=v}end
local base,ui=0x10000000,0x20000000
local values,focus,cursor,unreadable,changed={},true,false,false,false
local receiver,receiver_changed,anchor_changed=string.rep('\0',8),false,false
local receiver_reads=0
local function pack(v)return string.char(v%256,math.floor(v/256)%256,math.floor(v/65536)%256,math.floor(v/16777216)%256)end
local reads=0
local memory={read_pointer=function()return ok(ui)end,read=function(_,at,n)
    if at==base+0x14aeb30 then return ok(anchor_changed and string.rep('x',n) or '\x48\x89\x74\x24\x10\x57\x48\x83\xec\x30') end
    if at==ui then
        assert(n==8);receiver_reads=receiver_reads+1
        if unreadable then return {ok=false}end
        return ok(receiver_changed and receiver_reads%2==0 and string.rep('\0',8) or receiver)
    end
    assert(at==ui+0x4294 and n==0x90);reads=reads+1
    if unreadable then return {ok=false}end
    local text=''
    for offset=0,0x8c,4 do text=text..pack(values[offset] or 0)end
    if changed and reads%2==0 then text='x'..text:sub(2)end
    return ok(text)
end}
local platform={module_address=function(_,name)assert(name=='game.dll');return base end}
local engine={Window={has_focus=function()return focus end,show_cursor=function()return cursor end}}
local profile={id='steam-25480438-v02-candidate'}
local function sample()return guard.sample(platform,memory,profile,engine)end
assert(sample().value.allowed)
receiver='\1'..string.rep('\0',7)
assert(sample().value.reason=='text_entry_active' and sample().value.text_entry_active)
receiver_reads=0;receiver_changed=true;assert(not sample().ok);receiver_changed=false
receiver=string.rep('\0',8)
assert(not sample().value.text_entry_active and sample().value.allowed)
anchor_changed=true;assert(not sample().ok);anchor_changed=false
cursor=true;assert(sample().value.reason=='ui_cursor_visible');cursor=false
focus=false;assert(sample().value.reason=='game_focus_lost');focus=true
for _,offset in ipairs({0,4,0x84,0x8c})do
    values[offset]=1;assert(not sample().value.allowed,'busy UI field');values[offset]=0
end
values[0x1c],values[8]=1,5;assert(sample().value.reason=='ui_busy');values={}
values[0x1c]=6;assert(not sample().ok);values={}
values[0x84]=26;assert(not sample().ok);values={}
unreadable=true;assert(not sample().ok);unreadable=false
reads=0;changed=true;assert(not sample().ok);changed=false
cursor='unknown';assert(not sample().ok);cursor=false
assert(not guard.sample(platform,memory,profile,{}).ok)
assert(not guard.sample(platform,memory,{id='other'},engine).ok)
assert(sample().value.allowed)
return true
