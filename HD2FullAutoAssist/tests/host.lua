local ffi=require('ffi')
local function ok(v)return {ok=true,value=v}end
now,focused,key_down,chat,menu,fire,gameplay,unit,avatar_ok=0,true,false,false,false,false,true,123,true
entity_id,resource_hash,identity_calls=1001,'05e4e5c2db6e44a2',0
logs={}
local loader={api=1,open_log=function()return {
    write=function(self,t)logs[#logs+1]=t;return self end,flush=function()return true end,close=function()return true end}end}
stingray={Window={has_focus=function()return focused end,show_cursor=function()return menu end}}
local platform={clock_us=function()return now end,module_hash=function(_,name)
    local p=require('hd2modcore.example_profile');return name and p.identity.dll_sha256 or p.identity.exe_sha256 end,
    query_region=function()return {base=0x10000000,size=0x30000000,state=0x1000,protect=4}end,
    module_address=function()return 0x10000000 end,
    read=function(_,at,n)
        if at==0x10000000+0x347ce28 then return '\0\0\0\32\0\0\0\0' end
        if at==0x10000000+0x14aeb30 then return '\x48\x89\x74\x24\x10\x57\x48\x83\xec\x30' end
        if at==0x20000000 and chat then return '\1'..string.rep('\0',7) end
        return string.rep('\0',n)
    end,prepare_input=function()return true end,input_focused=function()return focused end,input_down=function()return key_down end}
update=function()end;shutdown=function()end
core=assert(require('hd2modcore.entry').install(_G,{platform=platform,loader=loader,config_text=''}))
core.Diagnostic.LocalAvatar=function()
    identity_calls=identity_calls+1
    return avatar_ok and ok({state='present',unit_ref=unit,held={state='present',entity_id=entity_id,resource_hash=resource_hash}}) or {ok=false}
end
bridge,metadata,modes=policy_fixture();core.Integrations.HD2Runtime=bridge
backend={writes=0,restored=0,repeat_seconds=.125,starts=0,stops=0,
    clock_us=function()return now end,
    sample=function()return {owner=100,held=fire,gameplay=gameplay,unit_ref=unit,pressed=true,trigger=8}end,
    begin=function(self,row,seconds)self.repeat_seconds=seconds;self.lease={};self.starts=self.starts+1;self.writes=self.writes+1;return 1 end,
    restore=function(self)self.lease=nil;self.stops=self.stops+1;self.restored=self.restored+1;return true end,
    refresh=function()end}
function tick(ms,key)now=ms*1000;if key~=nil then key_down=key end;update(.016)end
