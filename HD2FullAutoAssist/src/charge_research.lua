-- Developer-only trace; default candidate never instantiates this module.
local Observer=require('charge_observer')
local Json=require('validation_trace')
local M={}
function M.new(host,provider,loader)
    local observer=Observer.new(host)
    local file=assert(loader.open_log('HD2FullAutoAssist-charge-research.jsonl'),'Charge research log unavailable')
    local opened,reason=pcall(function()
        assert(file:write(Json.json({event='research_start',version='1.1.0-research-rc1',
            automatic_charge_fire=false,steam_build='25480438',sampling_hz=50,max_samples=10000})..'\n'))
        assert(file:flush())
    end)
    if not opened then pcall(file.close,file);error(reason,0)end
    local self={samples=0,observer=observer,closed=false,next_us=0,buffer={},last_flush=0}
    function self:close()
        if self.closed then return end
        if #self.buffer>0 then assert(file:write(table.concat(self.buffer)));self.buffer={}end
        assert(file:flush());assert(file:close());self.closed=true
    end
    function self:tick()
        if self.closed then return end
        local now=host:clock_us();if now<self.next_us then return end
        self.next_us=now+20000 -- At most 50 samples/s; stops after 10,000 relevant samples.
        local state=provider()
        local row=host:read_scope(function()return observer:sample(state)end)
        if row then
            row.time_us=now;row.assistance_enabled=false
            -- Raw processed Fire, read only. No input mapping or weapon writes.
            local ok,input=pcall(function()
                local raw=(host.read_live or host.read)(host,host.base+0x347cf18,8)
                local n=0;for i=8,1,-1 do n=n*256+raw:byte(i)end
                assert(n>=0x10000 and n<=0x7fffffffffff)
                return (host.read_live or host.read)(host,n+0x1c88,32)
            end)
            if ok then row.fire_hex=(input:gsub('.',function(c)return string.format('%02x',c:byte())end))end
            self.buffer[#self.buffer+1]=Json.json(row)..'\n';self.samples=self.samples+1
        end
        if now-self.last_flush>=1000000 and #self.buffer>0 then
            assert(file:write(table.concat(self.buffer)));assert(file:flush());self.buffer={};self.last_flush=now
        end
        if self.samples>=10000 then self:close()end
    end
    return self
end
return M
