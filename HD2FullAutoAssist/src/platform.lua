-- Full Auto Assist Windows reads, module fingerprints and toggle input only.
local function integer(v,lo,hi)return type(v)=='number' and v==v and v%1==0 and v>=lo and v<=hi end
local M = {}
local Windows = {}
Windows.__index = Windows
local declarations_done=false

local DECLARATIONS = [[
    uint32_t GetCurrentProcessId(void);
    short GetAsyncKeyState(int key);
    void *GetForegroundWindow(void);
    uint32_t GetWindowThreadProcessId(void *window, uint32_t *process);
    void *GetModuleHandleA(const char *name);
    uint32_t GetModuleFileNameW(void *module, uint16_t *path, uint32_t capacity);
    void *GetCurrentProcess(void);
    uint64_t GetTickCount64(void);
    int QueryPerformanceCounter(void *counter);
    int QueryPerformanceFrequency(void *frequency);
    int ReadProcessMemory(void *process, const void *address, void *buffer,
        size_t size, size_t *read);
    typedef struct {
        void *base; void *allocation_base; uint32_t allocation_protection;
        uint16_t partition; uint16_t reserved; size_t size;
        uint32_t state; uint32_t protection; uint32_t type;
    } HD2FAAMemoryRegionV1;
    size_t VirtualQuery(const void *address, void *region, size_t size);
    void *CreateFileW(const uint16_t *path, uint32_t access, uint32_t share,
        void *security, uint32_t disposition, uint32_t flags, void *template_file);
    int ReadFile(void *file, void *buffer, uint32_t size, uint32_t *read,
        void *overlapped);
    int CloseHandle(void *handle);
    int32_t BCryptOpenAlgorithmProvider(void **algorithm, const uint16_t *name,
        const uint16_t *provider, uint32_t flags);
    int32_t BCryptCloseAlgorithmProvider(void *algorithm, uint32_t flags);
    int32_t BCryptCreateHash(void *algorithm, void **hash, void *object,
        uint32_t object_size, const void *secret, uint32_t secret_size,
        uint32_t flags);
    int32_t BCryptHashData(void *hash, const void *data, uint32_t size,
        uint32_t flags);
    int32_t BCryptFinishHash(void *hash, void *digest, uint32_t size,
        uint32_t flags);
    int32_t BCryptDestroyHash(void *hash);
]]

function M.new()
    local ffi = require('ffi')
    assert(ffi.abi('64bit'), 'Full Auto Assist requires Windows x64 LuaJIT')
    if not declarations_done then
        local declared, why = pcall(ffi.cdef, DECLARATIONS)
        assert(declared, 'Windows FFI declaration failed: '..tostring(why))
        declarations_done=true
    end
    local kernel, bcrypt = ffi.load('kernel32'), ffi.load('bcrypt')
    local frequency = ffi.new('uint32_t[2]')
    local query_counter = ffi.cast('int (*)(void *)', kernel.QueryPerformanceCounter)
    local query_frequency = ffi.cast('int (*)(void *)', kernel.QueryPerformanceFrequency)
    local precise = query_frequency(frequency) ~= 0
    local ticks_per_second = frequency[0] + frequency[1] * 4294967296
    precise = precise and ticks_per_second > 0
    return setmetatable({ffi=ffi, kernel=kernel, bcrypt=bcrypt,
        safe_cached_reads=true, -- RPM checks current access and length on every read.
        process=kernel.GetCurrentProcess(),
        query=ffi.cast('size_t (*)(const void *, void *, size_t)',kernel.VirtualQuery),
        count=ffi.new('size_t[1]'), scratch=ffi.new('uint8_t[32768]'),
        region=ffi.new('HD2FAAMemoryRegionV1[1]'),
        counter=ffi.new('uint32_t[2]'), query_counter=query_counter,
        ticks_per_second=ticks_per_second, precise_clock=precise}, Windows)
end

function Windows:clock_us()
    if self.precise_clock and self.query_counter(self.counter) ~= 0 then
        local ticks=self.counter[0]+self.counter[1]*4294967296
        return ticks*1000000/self.ticks_per_second
    end
    return tonumber(self.kernel.GetTickCount64())*1000
end

function Windows:prepare_input()
    if self.user32 then return true end
    local ok,why=pcall(function()
        self.user32=self.ffi.load('user32')
        self.input_pid=tonumber(self.kernel.GetCurrentProcessId())
        self.foreground_pid=self.ffi.new('uint32_t[1]')
    end)
    if not ok then self.user32=nil;return nil,tostring(why) end
    return true
end
function Windows:input_focused()
    local window=self.user32.GetForegroundWindow()
    if window==nil then return false end
    self.foreground_pid[0]=0
    if self.user32.GetWindowThreadProcessId(window,self.foreground_pid)==0 then return false end
    return tonumber(self.foreground_pid[0])==self.input_pid
end
function Windows:input_down(key)
    -- A negative SHORT means the high bit is set. Ignore the unreliable low bit.
    return self.user32.GetAsyncKeyState(key)<0
end

function Windows:module_address(name)
    if name ~= nil and (type(name)~='string' or #name>128) then
        return nil,'invalid module name'
    end
    local handle=self.kernel.GetModuleHandleA(name)
    if handle==nil then return nil,'module unavailable' end
    local address=tonumber(self.ffi.cast('uintptr_t',handle))
    if not integer(address,0x10000,0x7fffffffffff) then
        return nil,'module address outside user range'
    end
    return address
end

local function uint32(bytes,at)
    local a,b,c,d=bytes:byte(at+1,at+4)
    if not d then return nil end
    return a+b*256+c*65536+d*16777216
end

function Windows:module_image_size(name)
    local base,why=self:module_address(name)
    if not base then return nil,why end
    local dos=self:read(base,64)
    if not dos or dos:sub(1,2)~='MZ' then return nil,'invalid DOS header' end
    local pe_at=uint32(dos,0x3c)
    if not pe_at or pe_at<64 or pe_at>4096 then return nil,'invalid PE offset' end
    local pe=self:read(base+pe_at,0x60)
    if not pe or pe:sub(1,4)~='PE\0\0' or pe:byte(25)~=0x0b or
        pe:byte(26)~=0x02 then return nil,'invalid PE32+ header' end
    local size=uint32(pe,24+56)
    if not size or size<4096 or size>0x80000000 then
        return nil,'invalid image size'
    end
    return size
end

function Windows:query_region(address)
    if not integer(address,0x10000,0x7fffffffffff) then
        return nil,'invalid address'
    end
    local ffi=self.ffi
    if self.query(ffi.cast('const void *',address),self.region,
        ffi.sizeof(self.region[0])) ~= ffi.sizeof(self.region[0]) then
        return nil,'VirtualQuery failed'
    end
    local row=self.region[0]
    return {base=tonumber(ffi.cast('uintptr_t',row.base)),
        size=tonumber(row.size),state=tonumber(row.state),
        protect=tonumber(row.protection),type=tonumber(row.type)}
end

function Windows:read(address,size)
    if not integer(address,0x10000,0x7fffffffffff) or
        not integer(size,1,32768) then return nil,'invalid read arguments' end
    local ffi=self.ffi
    if self.kernel.ReadProcessMemory(self.process,ffi.cast('const void *',address),
        self.scratch,size,self.count)==0 or self.count[0]~=size then
        return nil,'ReadProcessMemory failed or short read'
    end
    return ffi.string(self.scratch,size)
end

function Windows:module_hash(name)
    local address,why=self:module_address(name)
    if not address then return nil,why end
    local ffi,kernel,bcrypt=self.ffi,self.kernel,self.bcrypt
    local path=ffi.new('uint16_t[32768]')
    local length=kernel.GetModuleFileNameW(ffi.cast('void *',address),path,32768)
    if length==0 or length>=32768 then return nil,'module file path unavailable' end
    local file=kernel.CreateFileW(path,0x80000000,7,nil,3,0x08000000,nil)
    if file==ffi.cast('void *',-1) then return nil,'module file open failed' end
    local algorithm,hash=ffi.new('void *[1]'),ffi.new('void *[1]')
    local ok,result=pcall(function()
        local name_u16=ffi.new('uint16_t[7]',{83,72,65,50,53,54,0})
        assert(bcrypt.BCryptOpenAlgorithmProvider(algorithm,name_u16,nil,0)==0,
            'SHA-256 provider unavailable')
        assert(bcrypt.BCryptCreateHash(algorithm[0],hash,nil,0,nil,0,0)==0,
            'SHA-256 context unavailable')
        local buffer,count=ffi.new('uint8_t[1048576]'),ffi.new('uint32_t[1]')
        while true do
            assert(kernel.ReadFile(file,buffer,1048576,count,nil)~=0,'module file read failed')
            if count[0]==0 then break end
            assert(bcrypt.BCryptHashData(hash[0],buffer,count[0],0)==0,
                'SHA-256 update failed')
        end
        local digest=ffi.new('uint8_t[32]')
        assert(bcrypt.BCryptFinishHash(hash[0],digest,32,0)==0,'SHA-256 finish failed')
        local hex={}
        for index=0,31 do hex[#hex+1]=string.format('%02X',digest[index]) end
        return table.concat(hex)
    end)
    local cleanup_ok=true
    if hash[0]~=nil then
        cleanup_ok=bcrypt.BCryptDestroyHash(hash[0])==0 and cleanup_ok
    end
    if algorithm[0]~=nil then
        cleanup_ok=bcrypt.BCryptCloseAlgorithmProvider(algorithm[0],0)==0 and cleanup_ok
    end
    cleanup_ok=kernel.CloseHandle(file)~=0 and cleanup_ok
    if not cleanup_ok then return nil,'module hash cleanup failed' end
    if not ok then return nil,tostring(result) end
    return result
end

return M
