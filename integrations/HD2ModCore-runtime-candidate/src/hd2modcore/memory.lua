local Result = require('hd2modcore.result')
local Util = require('hd2modcore.util')

local M = {}
local Memory = {}
Memory.__index = Memory

local MIN_ADDRESS, MAX_ADDRESS = 0x10000, 0x7fffffffffff
local READABLE = {[2]=true, [4]=true, [8]=true, [32]=true, [64]=true, [128]=true}

function M.new(platform, maximum)
    assert(type(platform) == 'table' and type(platform.read) == 'function'
        and type(platform.query_region) == 'function', 'memory platform unavailable')
    maximum = maximum or 32768
    assert(Util.integer(maximum, 1, 32768), 'invalid read ceiling')
    local clock=type(platform.clock_us)=='function'
        and function() return platform:clock_us() end or nil
    return setmetatable({platform=platform, maximum=maximum, calls=0, bytes=0,
        failures=0, queries=0, query_us_total=0, query_us_max=0,
        native_reads=0, native_read_us_total=0, native_read_us_max=0,
        region_cache_hits=0, clock=clock}, Memory)
end

-- Cache only regions verified during this synchronous snapshot. Native reads
-- still go through ReadProcessMemory, so a page that changes later fails safe.
function Memory:with_region_cache(callback)
    assert(type(callback)=='function','region cache callback required')
    if self.region_cache then return callback() end
    self.region_cache={}
    local values=Util.pack(pcall(callback))
    self.region_cache=nil
    if not values[1] then error(values[2],0) end
    return Util.unpack(values,2)
end

function Memory:read(address, size)
    if not Util.integer(address, MIN_ADDRESS, MAX_ADDRESS) or
        not Util.integer(size, 1, self.maximum) or size - 1 > MAX_ADDRESS - address then
        self.failures = self.failures + 1
        return Result.err('InvalidRead', 'memory', 'address, size or end out of range')
    end
    local cursor, last, regions = address, address + size, 0
    while cursor < last do
        regions=regions+1
        if regions>64 then
            self.failures=self.failures+1
            return Result.err('BudgetExceeded','region','region-walk limit')
        end
        local region,why
        if self.region_cache then
            for _,cached in ipairs(self.region_cache) do
                if cursor>=cached.base and cursor<cached.base+cached.size then
                    region=cached
                    self.region_cache_hits=self.region_cache_hits+1
                    break
                end
            end
        end
        if not region then
            local query_started=self.clock and self.clock() or nil
            region,why=self.platform:query_region(cursor)
            self.queries=self.queries+1
            if query_started then
                local elapsed=math.max(0,self.clock()-query_started)
                self.query_us_total=self.query_us_total+elapsed
                self.query_us_max=math.max(self.query_us_max,elapsed)
            end
        end
        if not region or not Util.integer(region.base, 0, MAX_ADDRESS) or
            not Util.integer(region.size, 1, MAX_ADDRESS) or
            not Util.integer(region.protect,0,0xffffffff) or
            cursor < region.base or region.size > MAX_ADDRESS - region.base + 1 then
            self.failures = self.failures + 1
            return Result.err('ReadFailed', 'region', why or 'invalid region')
        end
        local region_end = region.base + region.size
        if cursor>=region_end then
            self.failures=self.failures+1
            return Result.err('ReadFailed','region','region does not contain cursor')
        end
        local protection = region.protect % 256
        if region.state ~= 0x1000 or not READABLE[protection] or
            math.floor((region.protect or 0) / 0x100) % 2 == 1 then
            self.failures = self.failures + 1
            return Result.err('ReadFailed', 'region', 'unreadable or guarded page')
        end
        if self.region_cache and not why and #self.region_cache<64 then
            local seen=false
            for _,cached in ipairs(self.region_cache) do
                if cached==region then seen=true;break end
            end
            if not seen then self.region_cache[#self.region_cache+1]=region end
        end
        cursor = math.min(last, region_end)
    end
    local read_started=self.clock and self.clock() or nil
    local bytes, why = self.platform:read(address, size)
    self.native_reads=self.native_reads+1
    if read_started then
        local elapsed=math.max(0,self.clock()-read_started)
        self.native_read_us_total=self.native_read_us_total+elapsed
        self.native_read_us_max=math.max(self.native_read_us_max,elapsed)
    end
    self.calls = self.calls + 1
    if type(bytes) ~= 'string' or #bytes ~= size then
        self.failures = self.failures + 1
        return Result.err('ReadFailed', 'read', why or 'short or failed read')
    end
    self.bytes = self.bytes + size
    return Result.ok(bytes)
end

function Memory:read_u32(address)
    local result = self:read(address, 4)
    if not result.ok then return result end
    local a,b,c,d = result.value:byte(1,4)
    return Result.ok(a + b*256 + c*65536 + d*16777216)
end

function Memory:read_pointer(address)
    local result = self:read(address, 8)
    if not result.ok then return result end
    local b = {result.value:byte(1,8)}
    local low = b[1]+b[2]*256+b[3]*65536+b[4]*16777216
    local high = b[5]+b[6]*256+b[7]*65536+b[8]*16777216
    local value = high*4294967296+low
    if not Util.integer(value, MIN_ADDRESS, MAX_ADDRESS) then
        return Result.err('InvalidPointer', 'decode', 'pointer outside user range')
    end
    return Result.ok(value)
end

function Memory:status()
    return {calls=self.calls, bytes=self.bytes, failures=self.failures,
        maximum=self.maximum, queries=self.queries,
        query_us_total=self.query_us_total, query_us_max=self.query_us_max,
        region_cache_hits=self.region_cache_hits,
        native_reads=self.native_reads,
        native_read_us_total=self.native_read_us_total,
        native_read_us_max=self.native_read_us_max}
end

return M
