-- Full Auto Assist Windows reads, module fingerprints and toggle input only.
local function integer(v,lo,hi)return type(v)=='number' and v==v and v%1==0 and v>=lo and v<=hi end
local M = {}
local Windows = {}
Windows.__index = Windows
local SENTINEL="hd2_faa_platform2_region"

local DECLARATIONS = [[
    uint32_t hd2_faa_platform2_GetCurrentProcessId(void) __asm__("GetCurrentProcessId");
    short hd2_faa_platform2_GetAsyncKeyState(int key) __asm__("GetAsyncKeyState");
    void *hd2_faa_platform2_GetForegroundWindow(void) __asm__("GetForegroundWindow");
    uint32_t hd2_faa_platform2_GetWindowThreadProcessId(void *window, uint32_t *process) __asm__("GetWindowThreadProcessId");
    void *hd2_faa_platform2_GetModuleHandleA(const char *name) __asm__("GetModuleHandleA");
    uint32_t hd2_faa_platform2_GetModuleFileNameW(void *module, uint16_t *path, uint32_t capacity) __asm__("GetModuleFileNameW");
    void *hd2_faa_platform2_GetCurrentProcess(void) __asm__("GetCurrentProcess");
    uint64_t hd2_faa_platform2_GetTickCount64(void) __asm__("GetTickCount64");
    int hd2_faa_platform2_QueryPerformanceCounter(void *counter) __asm__("QueryPerformanceCounter");
    int hd2_faa_platform2_QueryPerformanceFrequency(void *frequency) __asm__("QueryPerformanceFrequency");
    int hd2_faa_platform2_ReadProcessMemory(void *process, const void *address, void *buffer,
        size_t size, size_t *read) __asm__("ReadProcessMemory");
    typedef struct {
        void *base; void *allocation_base; uint32_t allocation_protection;
        uint16_t partition; uint16_t reserved; size_t size;
        uint32_t state; uint32_t protection; uint32_t type;
    } hd2_faa_platform2_region;
    size_t hd2_faa_platform2_VirtualQuery(const void *address, void *region, size_t size) __asm__("VirtualQuery");
    void *hd2_faa_platform2_CreateFileW(const uint16_t *path, uint32_t access, uint32_t share,
        void *security, uint32_t disposition, uint32_t flags, void *template_file) __asm__("CreateFileW");
    int hd2_faa_platform2_ReadFile(void *file, void *buffer, uint32_t size, uint32_t *read,
        void *overlapped) __asm__("ReadFile");
    int hd2_faa_platform2_CloseHandle(void *handle) __asm__("CloseHandle");
    int32_t hd2_faa_platform2_BCryptOpenAlgorithmProvider(void **algorithm, const uint16_t *name,
        const uint16_t *provider, uint32_t flags) __asm__("BCryptOpenAlgorithmProvider");
    int32_t hd2_faa_platform2_BCryptCloseAlgorithmProvider(void *algorithm, uint32_t flags) __asm__("BCryptCloseAlgorithmProvider");
    int32_t hd2_faa_platform2_BCryptCreateHash(void *algorithm, void **hash, void *object,
        uint32_t object_size, const void *secret, uint32_t secret_size,
        uint32_t flags) __asm__("BCryptCreateHash");
    int32_t hd2_faa_platform2_BCryptHashData(void *hash, const void *data, uint32_t size,
        uint32_t flags) __asm__("BCryptHashData");
    int32_t hd2_faa_platform2_BCryptFinishHash(void *hash, void *digest, uint32_t size,
        uint32_t flags) __asm__("BCryptFinishHash");
    int32_t hd2_faa_platform2_BCryptDestroyHash(void *hash) __asm__("BCryptDestroyHash");
]]

function M.new()
    local ffi = require('ffi')
    assert(ffi.abi('64bit'), 'Full Auto Assist requires Windows x64 LuaJIT')
    if not pcall(ffi.typeof,SENTINEL) then
        local declared, why = pcall(ffi.cdef, DECLARATIONS)
        assert(declared, 'Windows FFI declaration failed: '..tostring(why))
    end
    -- Bind private symbols once. Plain Windows names remain untouched in the shared VM.
    local kernel_dll,bcrypt_dll=ffi.load('kernel32'),ffi.load('bcrypt')
    local kernel,bcrypt={},{}
    for _,name in ipairs({'GetCurrentProcessId','GetModuleHandleA','GetModuleFileNameW','GetCurrentProcess','GetTickCount64','QueryPerformanceCounter','QueryPerformanceFrequency','ReadProcessMemory','VirtualQuery','CreateFileW','ReadFile','CloseHandle'})do kernel[name]=kernel_dll['hd2_faa_platform2_'..name]end
    for _,name in ipairs({'BCryptOpenAlgorithmProvider','BCryptCloseAlgorithmProvider','BCryptCreateHash','BCryptHashData','BCryptFinishHash','BCryptDestroyHash'})do bcrypt[name]=bcrypt_dll['hd2_faa_platform2_'..name]end
    local frequency = ffi.new('uint32_t[2]')
    local query_counter = kernel.QueryPerformanceCounter
    local query_frequency = kernel.QueryPerformanceFrequency
    local precise = query_frequency(frequency) ~= 0
    local ticks_per_second = frequency[0] + frequency[1] * 4294967296
    precise = precise and ticks_per_second > 0
    local scratch=ffi.new('uint8_t[32768]')
    return setmetatable({ffi=ffi, kernel=kernel, bcrypt=bcrypt,
        safe_cached_reads=true, -- RPM checks current access and length on every read.
        process=kernel.GetCurrentProcess(),
        query=kernel.VirtualQuery,
        count=ffi.new('size_t[1]'), scratch=scratch,
        scratch_words=ffi.cast('const uint32_t *',scratch),
        region=ffi.new('hd2_faa_platform2_region[1]'),
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
        local dll=self.ffi.load('user32')
        self.user32={GetAsyncKeyState=dll.hd2_faa_platform2_GetAsyncKeyState,
            GetForegroundWindow=dll.hd2_faa_platform2_GetForegroundWindow,
            GetWindowThreadProcessId=dll.hd2_faa_platform2_GetWindowThreadProcessId}
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

-- Expected bytes belong to a retained identity certificate. Both views below
-- are aligned, owned buffers; game addresses are passed only to guarded RPM.
function Windows:prepare_match(bytes)
    assert(type(bytes)=='string' and #bytes>0 and #bytes<=32768,'Invalid expected span')
    local buffer=self.ffi.new('uint32_t[?]',math.ceil(#bytes/4))
    self.ffi.copy(buffer,bytes,#bytes)
    return {words=buffer,size=#bytes}
end
function Windows:read_matches(address,expected,size)
    if not integer(address,0x10000,0x7fffffffffff) or
        not integer(size,1,32768) then return nil,'invalid read arguments' end
    local ffi=self.ffi
    assert(type(expected)=='table' and expected.size==size,'Expected buffer size changed')
    if self.kernel.ReadProcessMemory(self.process,ffi.cast('const void *',address),
        self.scratch,size,self.count)==0 or self.count[0]~=size then
        return nil,'ReadProcessMemory failed or short read'
    end
    local actual=self.scratch_words
    local wanted=expected.words
    for i=0,math.floor(size/4)-1 do
        if actual[i]~=wanted[i] then return false end
    end
    if size%4~=0 then
        local tail=ffi.cast('const uint8_t *',wanted)
        for i=size-size%4,size-1 do
            if self.scratch[i]~=tail[i] then return false end
        end
    end
    return true
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
