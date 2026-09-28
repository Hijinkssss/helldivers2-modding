local Input=require('hd2modcore.input')
local now,focused,down,reads=0,true,false,0
local p={clock_us=function()return now end,prepare_input=function()return true end,
    input_focused=function()return focused end,input_down=function()reads=reads+1;return down end}
for _,key in ipairs({'A','z','0','F1','F24',' f10 ','SPACE','VK_7A'}) do assert(Input.parse(key).ok,key) end
for _,key in ipairs({'','CTRL+F10','F0','F25','F01','VK_00','VK_FF','unknown',42}) do assert(not Input.parse(key).ok,tostring(key)) end
local i=Input.new(p);local calls=0
local token=assert(i:subscribe('test','F10',{debounce_ms=150},function()calls=calls+1 end).value)
assert(not i:subscribe('test','F10',{},function()end).ok)
local function tick(t,d,f)now=t*1000;down=d;if f~=nil then focused=f end;i:tick()end
tick(0,true);tick(100,true);assert(calls==0,'held at registration')
tick(200,false);tick(300,true);assert(calls==1)
for n=1,100 do tick(300+n,true) end;assert(calls==1,'hold spam')
tick(410,false);tick(420,true);assert(calls==1,'bounce inside 150ms')
tick(500,false);tick(600,true);assert(calls==2,'second legitimate press')
tick(700,true,false);local before=reads;tick(800,true,false);assert(reads==before,'no unfocused polling')
tick(900,true,true);assert(calls==2,'held during focus return')
tick(1000,false);tick(1100,true);assert(calls==3)
assert(i:remove(token));assert(not i:remove(token));tick(1200,false);assert(i.active==0)
local one=i:subscribe('one','A',{},function()end).value
local two=i:subscribe('one','B',{},function()end).value
i:remove_owner('one');assert(i.active==0,'owner revokes every key')
assert(not i:subscribe('bad','F10',false,function()end).ok)
assert(not Input.new({}):subscribe('test','F10',{},function()end).ok)
local shared=Input.new(p);reads=0;focused=true;down=false
shared:subscribe('a','F10',{},function()end);shared:subscribe('b','F10',{},function()end)
shared:tick();assert(reads==1,'one poll per unique key')
local broken=Input.new(p);down=false;broken:subscribe('a','F10',{},function()error('failure')end)
broken:tick();down=true;broken:tick();assert(broken.active==0 and broken.callback_failures==1)
local cleared=Input.new(p);down=false
cleared:subscribe('a','F10',{},function()cleared:clear()end)
cleared:subscribe('b','A',{},function()error('cleared callback executed')end)
cleared:tick();down=true;cleared:tick();assert(cleared.active==0 and cleared.callback_failures==0)
local bound=Input.new(p)
for n=1,32 do assert(bound:subscribe('owner'..n,'F10',{},function()end).ok) end
assert(not bound:subscribe('extra','F10',{},function()end).ok);bound:clear()
-- After subscription, ordinary release/hold ticks must not grow retained Lua memory.
local noalloc=Input.new(p);down=false;noalloc:subscribe('perf','F10',{},function()end);noalloc:tick()
for n=1,1000 do noalloc:tick()end
collectgarbage('collect');collectgarbage('stop');local start=collectgarbage('count')
for n=1,10000 do noalloc:tick()end
local growth=collectgarbage('count')-start;collectgarbage('restart')
assert(growth<16,'polling allocation growth: '..growth)
print('Input parsing, focus, edges, debounce, shared polling, failures, bounds and cleanup: PASS')
