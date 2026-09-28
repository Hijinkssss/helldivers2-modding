local Memory=require('hd2modcore.memory')
local bytes=string.char(0x34,0x12,0,0,1,0,0,0)
local platform={
    query_region=function(self,address)
        if address<0x10000 or address>=0x12000 then return nil,'outside fixture' end
        if address<0x11000 then
            return {base=0x10000,size=0x1000,state=0x1000,protect=4}
        end
        return {base=0x11000,size=0x1000,state=0x1000,protect=2}
    end,
    read=function(self,address,size)
        if address==0x10000 and size==8 then return bytes end
        if address==0x10000 and size==4 then return bytes:sub(1,4) end
        if address==0x10fff and size==2 then return 'ab' end
        return nil,'unmapped bytes'
    end
}
local memory=Memory.new(platform)
assert(memory:read(0x10000,8).value==bytes)
assert(memory:read_u32(0x10000).value==0x1234)
assert(memory:read_pointer(0x10000).value==0x100001234)
assert(memory:read(0x10fff,2).value=='ab') -- validates both regions
for _,pair in ipairs({{0,1},{0x10000,0},{0x10000,32769},
    {0x7fffffffffff,2},{0x10000,1.5}}) do
    assert(not memory:read(pair[1],pair[2]).ok)
end
platform.query_region=function()return {base=0x10000,size=4096,
    state=0x1000,protect=0x104}end
assert(not memory:read(0x10000,4).ok) -- guard page
platform.query_region=function()return {base=0x10000,size=4096,
    state=0x1000,protect=4}end
assert(not memory:read(0x10004,4).ok) -- short/failed native read
local many=0
platform.query_region=function(self,address)
    many=many+1
    return {base=address,size=1,state=0x1000,protect=4}
end
assert(memory:read(0x10000,100).error.code=='BudgetExceeded')
assert(many==64)
assert(memory:status().failures>=6)
local tick=0
local timed=Memory.new({
    clock_us=function() tick=tick+5;return tick end,
    query_region=function() return {base=0x10000,size=4096,
        state=0x1000,protect=4} end,
    read=function() return 'abcd' end
})
assert(timed:read(0x10000,4).ok)
local timing=timed:status()
assert(timing.queries==1 and timing.query_us_total==5 and
    timing.query_us_max==5 and timing.native_reads==1 and
    timing.native_read_us_total==5 and timing.native_read_us_max==5)
local scoped_queries=0
local scoped_platform={
    query_region=function()
        scoped_queries=scoped_queries+1
        return {base=0x10000,size=4096,state=0x1000,protect=4}
    end,
    read=function(_,_,size)return string.rep('x',size)end
}
local scoped=Memory.new(scoped_platform)
scoped:with_region_cache(function()
    for i=1,3 do assert(scoped:read(0x10000+i,4).ok) end
end)
assert(scoped_queries==1 and scoped:status().region_cache_hits==2)
assert(scoped:read(0x10008,4).ok and scoped_queries==2)
local ok=pcall(function()
    scoped:with_region_cache(function()
        assert(scoped:read(0x10009,4).ok)
        error('fixture abort')
    end)
end)
assert(not ok and scoped.region_cache==nil)
assert(scoped:read(0x1000a,4).ok and scoped_queries==4)
local guarded_queries=0
local guarded=Memory.new({
    query_region=function()
        guarded_queries=guarded_queries+1
        return {base=0x10000,size=4096,state=0x1000,protect=0x104}
    end,
    read=function()error('guarded region reached native read')end
})
guarded:with_region_cache(function()
    assert(not guarded:read(0x10000,4).ok)
    assert(not guarded:read(0x10004,4).ok)
end)
assert(guarded_queries==2 and guarded:status().region_cache_hits==0)
local first,second,third=scoped:with_region_cache(function()return nil,'axis',false end)
assert(first==nil and second=='axis' and third==false,'Preserve nil-containing callback results')
local contents='old!';local changing=Memory.new({
    query_region=function()return {base=0x10000,size=4096,state=0x1000,protect=4}end,
    read=function()return contents end})
changing:with_region_cache(function()
    assert(changing:read(0x10000,4).value=='old!');contents='new!'
    assert(changing:read(0x10000,4).value=='new!','Memory contents must never be cached')
    changing:with_region_cache(function()assert(changing:read(0x10000,4).ok)end)
end)
assert(changing:status().queries==1 and changing:status().native_reads==3 and changing.region_cache==nil)
print('memory: bounds, cross-region, typed read, guard and short read OK')
