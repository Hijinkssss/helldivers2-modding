-- Read-only solved native HUD geometry. The host has already fingerprinted
-- Steam build 25480438. No native calls, widget writes or retained pointers.
local ffi=require('ffi')
local M={}
local ROOT=0x346d538
local PANEL=0x24e340+0x60
local AMMO=0x3220
local LIMIT,DEPTH=192,16
local FULL_SCAN_INTERVAL_US=250000
local WORD=ffi.typeof('const uint32_t *')
local FLOAT=ffi.typeof('const float *')
local function number(bytes,offset,kind)
    -- These are already-owned Lua strings, never live pointers. Typed views
    -- avoid an allocation, substring and copy for every field of every node.
    return tonumber(ffi.cast(kind=='float' and FLOAT or WORD,bytes)[offset/4])
end
local function pointer(bytes,offset)
    local lo=number(bytes,offset,'uint32_t')
    local hi=number(bytes,offset+4,'uint32_t')
    local value=lo+hi*4294967296
    assert(value==0 or (value>=0x10000 and value<=0x7fffffffffff),'Invalid HUD pointer')
    return value
end
local function same_row(a,b)
    return a:sub(1,4)==b:sub(1,4) and a:sub(85,88)==b:sub(85,88) and
        a:sub(37,44)==b:sub(37,44) and a:sub(101,112)==b:sub(101,112) and
        a:sub(133,160)==b:sub(133,160) and a:sub(225,248)==b:sub(225,248)
end
local function finite(value,lo,hi)
    return type(value)=='number' and value==value and value>=lo and value<=hi
end
local function rectangle(bytes,width,height)
    local function f(at)return number(bytes,at,'float')end
    local sx,sy=f(100),f(140)
    assert(finite(sx,.1,8) and finite(sy,.1,8) and math.abs(sx-sy)<.01,
        'Unsupported HUD scale')
    -- This HUD is axis aligned. Reject rotation/shear instead of a wrong AABB.
    -- Native UI lies in the X/Z plane of this matrix.
    assert(math.abs(f(108))<.001 and math.abs(f(132))<.001,'Unsupported HUD transform')
    local x,y,w,h=f(148),f(156),f(36)*sx,f(40)*sy
    assert(finite(x,0,width) and finite(y,0,height) and
        finite(w,0,width) and finite(h,0,height) and x+w<=width and y+h<=height,
        'Invalid solved HUD rectangle')
    return {x=x,y=y,w=w,h=h,scale=sx}
end
function M.new(host)
    local self={samples=0,unavailable=0,nodes=0,cache=nil}
    function self:sample(width,height,weapon_key)
        self.samples=self.samples+1
        local profiler=host.profiler
        local started=profiler and profiler:start()
        local reads=0
        local cache_hit=false
        local good,result=pcall(function()
            local function read(at,n)
                reads=reads+1
                local bytes=host:read_live(at,n)
                assert(type(bytes)=='string' and #bytes==n,'HUD read unavailable')
                return bytes
            end
            local now=host:clock_us()
            local owner_started=profiler and profiler:start()
            local root_bytes=read(host.base+ROOT,8)
            local owner=pointer(root_bytes,0);assert(owner~=0,'Native HUD absent')
            if profiler then profiler:finish('hud_owner_check',owner_started);profiler:increment('hud_owner_reads')end
            local panel=owner+PANEL
            local row_started=profiler and profiler:start()
            local row_bytes=read(panel+AMMO,248)
            local row=rectangle(row_bytes,width,height)
            assert(row.w>0 and row.h>=14*height/1080,'Ammo row unavailable')
            local row_flags=number(row_bytes,0,'uint32_t')
            local row_opacity=number(row_bytes,84,'float')
            assert(row_flags%32>=16 and finite(row_opacity,0,1.01) and row_opacity>0.001,
                'Native ammo row hidden')
            if profiler then profiler:finish('hud_ammo_row_check',row_started);profiler:increment('hud_ammo_row_reads')end
            local cached=self.cache
            if cached and cached.width==width and cached.height==height and
                cached.weapon_key==weapon_key and cached.root_bytes==root_bytes and
                same_row(cached.row_bytes,row_bytes) and now-cached.sampled_at<FULL_SCAN_INTERVAL_US then
                local verify_started=profiler and profiler:start()
                local verify_row=read(panel+AMMO,248)
                assert(same_row(row_bytes,verify_row) and root_bytes==read(host.base+ROOT,8),
                    'Native HUD changed during cached sample')
                if profiler then
                    profiler:finish('hud_cached_verify',verify_started)
                    profiler:increment('hud_cached_verify_row_reads')
                    profiler:increment('hud_cached_verify_owner_reads')
                end
                cache_hit=true
                return cached.anchor
            end
            local seen,count,right,row_seen={},0,nil,false
            local links={}
            local function walk(at,parent,depth)
                assert(depth<=DEPTH and count<LIMIT and not seen[at],'HUD tree limit or cycle')
                seen[at]=true;count=count+1
                local bytes=read(at,248)
                local first,next_node,actual_parent=pointer(bytes,224),pointer(bytes,232),pointer(bytes,240)
                assert(parent==nil or actual_parent==parent,'HUD parent changed')
                links[#links+1]={at=at,bytes=bytes}
                local flags=number(bytes,0,'uint32_t')
                local opacity=number(bytes,84,'float')
                assert(finite(opacity,0,1.01),'Invalid HUD opacity')
                local shown=flags%32>=16 and opacity>0.001
                if at==panel+AMMO then
                    assert(bytes==row_bytes,'Ammo row changed during sample')
                    row_seen=shown
                end
                if shown then
                    -- Type 1 is the structural widget initialized at 0x1446840.
                    -- Ignore its reserved padding, count rendered children instead.
                    if math.floor(flags/262144)%16~=1 then
                        local box=rectangle(bytes,width,height)
                        if box.w>0 and box.h>0 then right=math.max(right or 0,box.x+box.w)end
                    end
                    local child=first
                    while child~=0 do child=walk(child,at,depth+1)end
                end
                return next_node
            end
            local tree_started=profiler and profiler:start()
            walk(panel,nil,0)
            if profiler then profiler:finish('hud_tree_refresh',tree_started)end
            assert(row_seen and right,'Native weapon HUD not visible')
            -- Recheck owner, row and topology; never return a partially sampled tree.
            local revalidate_started=profiler and profiler:start()
            assert(read(host.base+ROOT,8)==root_bytes and read(panel+AMMO,248)==row_bytes,
                'Native HUD changed during sample')
            for _,link in ipairs(links)do
                -- One checked read replaces separate link and flag reads.
                -- Keep exactly the existing flag/topology race predicates.
                local current=read(link.at,248)
                assert(current:sub(225,248)==link.bytes:sub(225,248) and
                    current:sub(1,4)==link.bytes:sub(1,4),
                    'Native HUD tree changed during sample')
            end
            if profiler then profiler:finish('hud_tree_revalidate',revalidate_started)end
            self.nodes=count
            local s=height/1080 -- Preserve RC1 cartridge size, independent of native scale.
            local x=right+6*row.scale
            local y=row.y+row.h/2-7*s
            assert(x+17*s<=width and y>=0 and y+14*s<=height,'No room after native HUD')
            local anchor={x=x,y=y,scale=s,right=right,gap=6*row.scale,nodes=count}
            self.cache={width=width,height=height,weapon_key=weapon_key,root_bytes=root_bytes,
                row_bytes=row_bytes,sampled_at=now,anchor=anchor}
            return anchor
        end)
        if profiler then
            profiler:finish('hud_anchor',started)
            profiler:increment('hud_anchor_reads',reads)
            profiler:increment(good and 'hud_anchor_successes' or 'hud_anchor_failures')
            profiler:increment(cache_hit and 'hud_anchor_cache_hits' or 'hud_anchor_full_scans')
            if good then profiler:increment('hud_anchor_nodes',result.nodes)end
        end
        if not good then self.cache=nil;self.unavailable=self.unavailable+1;self.nodes=0;return nil end
        return result
    end
    return self
end
return M
