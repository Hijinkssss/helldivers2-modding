-- Whole standalone host with synthetic memory and callbacks. No game access.
local Life=require('lifecycle')
local function u32(n)return string.char(n%256,math.floor(n/256)%256,math.floor(n/65536)%256,math.floor(n/16777216)%256)end
local function ptr(n)return u32(n)..u32(0)end
local G,PM,PLAYER,OWNER,AM,WM,EM=0x10000000,0x20000000,0x21000000,0x30000000,0x40000000,0x50000000,0x60000000
local AVATAR=OWNER+0xf32f18+2*24
local BACKS,ROWS,EBACK,ERECORD=0x51000000,0x52000000,0x61000000,0x62000000
local UI=0x22000000
local bytes={}
local function put(at,s)for i=1,#s do bytes[at+i-1]=s:sub(i,i)end end
local function read(at,n)local r={};for i=0,n-1 do assert(bytes[at+i],'unmapped fixture');r[#r+1]=bytes[at+i]end;return table.concat(r)end
local function map(header,rows,key,index,cap)
    cap=cap or 8;put(header,ptr(rows)..u32(cap)..u32(0xffffffff)..u32(1))
    put(rows+(key%cap)*8,u32(key)..u32(index))
end
put(G,'MZ');put(G+0x3c,u32(128));put(G+128,'PE\0\0');put(G+152,'\x0b\x02');put(G+208,u32(0x4000000))
put(G+0x3326468,ptr(PM));put(G+0x346bf98,ptr(OWNER));put(G+0x3326d20,ptr(AM));put(G+0x3326420,ptr(WM));put(G+0x3326dc0,ptr(EM))
put(PM+0x84,u32(1)..u32(1));put(PM+0xe8,ptr(PLAYER));put(PLAYER,string.rep('\0',20)..'\1'..string.rep('\0',3));put(PM+0x3a8,u32(0x42))
map(OWNER+0xf22ec8,0x31000000,0x42,2)
local avatar='\151\250\077\041\077\051\028\077'..u32(0x98)..u32(0x42)..string.rep('\0',4)..'\1'..string.rep('\0',3)
put(AVATAR,avatar);map(AM+0xf8,0x41000000,0x98,1);put(AM+0x6c,u32(2));put(AM+0x118,ptr(AVATAR))
map(WM+48,0x53000000,0x98,0);put(WM+72,ptr(BACKS));put(BACKS,ptr(AVATAR));put(WM+96,ptr(ROWS));put(ROWS,u32(0xa9))
map(EM+32,0x63000000,0xa9,1);put(EM+56,ptr(EBACK));put(EBACK+8,ptr(ERECORD))
local peace='\xa2\x44\x6e\xdb\xc2\xe5\xe4\x05'
put(ERECORD,peace..u32(0xa9)..string.rep('\0',12))
put(G+0x347ce28,ptr(UI));put(UI,string.rep('\0',8));put(UI+0x4294,string.rep('\0',0x90))
put(G+0x14aeb30,'\x48\x89\x74\x24\x10\x57\x48\x83\xec\x30')
local now,focused,cursor,down,held=0,true,false,false,false
local bad_hash,bad_page=false,false
local page_queries=0
local p={clock_us=function()return now end,module_hash=function(_,name)
    if bad_hash then return 'bad'end
    return name and '2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E' or
        'F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06'
    end,module_address=function()return G end,query_region=function()
        page_queries=page_queries+1
        return {base=G,size=0x60000000,state=0x1000,protect=bad_page and 0x104 or 4}
    end,read=function(_,at,n)return read(at,n)end,prepare_input=function()return true end,
    input_focused=function()return focused end,input_down=function(_,key)assert(key==0xbb,'default must use VK_OEM_PLUS');return down end}
local log_closed=0
local lifecycle_log_lines={}
local loader={api=1,open_log=function()return {write=function(self,text)lifecycle_log_lines[#lifecycle_log_lines+1]=text;return self end,flush=function()return true end,
    close=function()log_closed=log_closed+1;return true end}end}
local stock_calls=0
local stock=function(marker)assert(marker=='fixture');stock_calls=stock_calls+1;return 'stock',nil,7 end
local stock_stop=function(marker)assert(marker=='fixture');return 'stopped',nil,9 end
local selected_module='mods/codex/hd2_full_auto_assist_option_peacemaker_profile_full_auto'
local env={CowboyBingusModLoader=loader,stingray={Window={has_focus=function()return focused end,show_cursor=function()return cursor end},
    Application={can_get=function(kind,name)assert(kind=='lua');return name==selected_module end}},update=stock,shutdown=stock_stop}
local b={writes=0,restored=0,clock_us=function()return now end,repeat_seconds=.125,
    sample=function()return {owner=42,held=held,gameplay=true,unit_ref=0x42,pressed=true,trigger=8}end,
    begin=function(self,row,seconds)self.lease={};self.repeat_seconds=seconds;self.writes=self.writes+1;return 1 end,
    refresh=function()return true end,
    restore=function(self)if self.lease then self.restored=self.restored+1 end;self.lease=nil;return true end}
local options={platform=p,loader=loader,read_config=function()return ''end,backend_factory=function()return b end}
package.preload[selected_module]=function()
    local selected=rawget(_G,'FullAutoAssistArsenalOptions') or {}
    rawset(_G,'FullAutoAssistArsenalOptions',selected);selected.peacemaker_profile='full_auto'
    return true
end
bad_hash=true;assert(not pcall(Life.start,env,options) and env.update==stock and b.writes==0);bad_hash=false
bad_page=true;assert(not pcall(Life.start,env,options) and env.update==stock);bad_page=false
local h=Life.new(env,options)
local before_identity=h:diagnostics()
assert(h:local_avatar().value.held.resource_hash=='05e4e5c2db6e44a2')
local after_identity=h:diagnostics()
assert(after_identity.memory.reads-before_identity.memory.reads==
    after_identity.observer.reads-before_identity.observer.reads,
    'Identity symbol resolution must not duplicate its guarded global reads')
assert(h:eligibility().value.allowed)
assert(h:parse_key('=')==0xbb and h:parse_key('+')==0xbb)
assert(not pcall(h.read,h,0,4) and not pcall(h.read,h,G,32769))
assert(not pcall(h.symbol,h,'unknown'))
assert(not pcall(h.read_scope,h,function()error('scope failure')end) and h.regions==nil)
assert(h:stop().ok)
-- Identity and Fire share page information only until the stock update.
local shared=Life.new(env,options)
shared:on_identity(function()shared:read(G,2)end)
shared:on_fire(function()shared:read(G,2)end)
shared:attach()
local before_update=page_queries
env.update('fixture')
assert(page_queries-before_update==1 and shared.regions==nil,
    'Same-update callbacks should share one page query and clear the scope')
before_update=page_queries
env.update('fixture')
assert(page_queries-before_update==1,'Next update must revalidate the page')
bad_page=true;env.update('fixture');bad_page=false
assert(env.update==stock and shared.regions==nil,
    'A newly guarded page must fail and clear the update scope')
options.read_config=function()return 'enabled=bad'end
assert(not pcall(Life.start,env,options) and env.update==stock and b.writes==0)
options.read_config=function()return ''end
local a=Life.start(env,options);assert(Life.start(env,options)==a)
assert(rawget(_G,'FullAutoAssistArsenalOptions').peacemaker_profile=='full_auto',
    'The selected Arsenal module must load before runtime configuration')
local function tick(ms)now=ms*1000;local x,y,z=env.update('fixture');assert(x=='stock' and y==nil and z==7)end
tick(0);assert(a:get_state().effective)
held=true;tick(20);assert(b.lease)
held=false;tick(40);assert(not b.lease)
held=true;tick(60);put(UI,'\1'..string.rep('\0',7));tick(80);assert(not b.lease)
put(UI,string.rep('\0',8));tick(100);assert(not b.lease)
held=false;tick(120);held=true;tick(140);assert(b.lease)
cursor=true;tick(160);assert(not b.lease);cursor=false
held=false;tick(180);held=true;tick(200);focused=false;tick(220);assert(not b.lease)
focused=true;down=true;tick(400);assert(a:get_state().user_enabled,'Held key after focus return must not toggle')
down=false;held=false;tick(420);held=true;tick(440);down=true;tick(600)
assert(not a:get_state().user_enabled and not b.lease and a:status().counters.toggles==1)
down=false;tick(620);down=true;tick(800);assert(a:get_state().user_enabled)
held=false;tick(820);held=true;tick(840);assert(b.lease)
put(BACKS,ptr(PLAYER));tick(860);assert(not b.lease and not a:get_state().identity_valid)
put(BACKS,ptr(AVATAR));held=false;tick(880);held=true;tick(900);assert(b.lease)
local native_down,registrations=false,0
env.ModBindingsMenu={register_binding=function(id,label,slot,options)
    assert(id=='codex.full_auto_assist.toggle' and label=='Toggle Full Auto Assist' and slot==2)
    assert(options.category=='Full Auto Assist');registrations=registrations+1;return true
end,is_down=function(id)assert(id=='codex.full_auto_assist.toggle');return native_down end}
down=false;tick(1010);assert(registrations==1,'registration count '..registrations)
down=true;tick(1020);assert(a:get_state().user_enabled,'fallback key disabled after native registration')
down=false;tick(1030);native_down=true;tick(1040);assert(not a:get_state().user_enabled,'native binding toggles OFF')
native_down=false;tick(1210);native_down=true;tick(1240);assert(a:get_state().user_enabled,'native binding toggles ON')
assert(a:status().counters.toggles==4,'Fallback and registered bindings update the same preference exactly once')
held=false;tick(1260);held=true;tick(1280);assert(b.lease)
env.ModBindingsMenu=nil
local original_restore=b.restore;local transient=true
b.restore=function(self)if transient then error('transient restoration failure')end;return original_restore(self)end
assert(not a:stop().ok and b.lease,'Failed cleanup must retain restoration state')
transient=false;tick(1300);assert(a:stop().ok and not b.lease)
assert(env.update==stock and env.shutdown==stock_stop)
assert(stock_calls>0 and log_closed>0)
local x,y,z=env.shutdown('fixture');assert(x=='stopped' and y==nil and z==9)
-- A stock update error also restores the native mapping before propagation.
env.HD2FullAutoAssistStandalone=nil
env.update=function()error('stock failure')end
held=false;local c=Life.start(env,options);assert(not pcall(env.update,'fixture'));assert(not b.lease and not c:get_state().effective)
assert(c:get_state().user_enabled,'A lifecycle failure must not rewrite the saved preference')
env.update=stock;env.HD2FullAutoAssistStandalone=nil
options.read_config=function()return 'performance_profile=true\nperformance_label=fixture\n' end
local profiled=Life.start(env,options);tick(1400)
local writes_before_updates=#lifecycle_log_lines
for i=1,8 do tick(1400+i)end
assert(#lifecycle_log_lines==writes_before_updates,'Profiling must not write a log on gameplay updates')
held=true;tick(1410);assert(b.lease)
tick(1420);assert(b.lease)
held=false;tick(1430);assert(not b.lease)
assert(#lifecycle_log_lines==writes_before_updates,'Held-Fire profiling still defers log output')
assert(profiled:stop().ok)
assert(#lifecycle_log_lines==writes_before_updates+1,'Profiling summary is written once at shutdown')
assert(lifecycle_log_lines[#lifecycle_log_lines]:find('performance',1,true) and
    lifecycle_log_lines[#lifecycle_log_lines]:find('fixture',1,true),
    'Shutdown log includes the requested profiler label and summary')
for _,phase in ipairs({'update_wrapper','native_input_sample','input_eligibility',
    'identity_snapshot','policy_resolution','native_fire_begin','native_fire_refresh'})do
    assert(lifecycle_log_lines[#lifecycle_log_lines]:find(phase,1,true),'Missing phase '..phase)
end
print('standalone host and native identity integration passed')
