local ffi=require('ffi')
local function packed(n)local v=ffi.new('uint32_t[1]',n);return ffi.string(v,4)end
local function ptr(n)return packed(n)..packed(0)end
local function fbytes(n)local v=ffi.new('float[1]',n);return ffi.string(v,4)end
local function ok(v)return {ok=true,value=v}end
local base,owner,state,pm,table_at,bucket=0x10000000,0x20000000,0x21000000,0x22000000,0x23000000,0x23000000+9*328
store={};write_count=0;fail_write=false
function put(at,s)for i=1,#s do store[at+i-1]=s:sub(i,i)end end
function read(at,n)local r={};for i=0,n-1 do assert(store[at+i],'Unmapped fixture read');r[#r+1]=store[at+i]end;return table.concat(r)end
put(base+0x347cf18,ptr(owner));put(base+0x3326340,ptr(state));put(base+0x3326468,ptr(pm))
put(state+0xac21c,packed(4));put(pm+0x3a8,packed(123))
put(owner+0x1c88,'\1\0\0\0'..fbytes(1)..fbytes(.1)..string.rep('\0',12)..packed(0)..packed(0))
put(owner+0xa7ad0,ptr(table_at)..packed(256)..packed(0xffffffff)..packed(1))
put(bucket,packed(0x20009)..packed(2))
original=packed(0x0010ff43)..string.char(1,0,0,0)..packed(0)..fbytes(0)..fbytes(.5)
put(bucket+8,original..original)
put(base+0x12fc180,'\x48\x8b\xc4\x48\x89\x58\x08\x48\x89\x68\x10\x48')
put(base+0x12fc44c,'\x41\x0f\x5a\xc3\x0f\x5a\xcf\xe8\x58\xcb\xe0\x00')
put(base+0x12fa3b3,'\xe8\xc8\xb7\x28\xff\x44\x8b\x8e\xd8\x7a\x0a\x00')
fake={Build={Status=function()return {id='steam-25480438-v02-candidate'}end},
    Symbols={Resolve=function()return ok({address=base+0x3326468})end},Memory={
        Read=function(_,at,n)return ok(read(at,n))end,
        ReadPointer=function(_,at)return ok(tonumber(ffi.cast('uint64_t *',ffi.new('uint8_t[8]',{read(at,8):byte(1,8)}))[0]))end,
        ReadU32=function(_,at)local s=read(at,4);local a,b,c,d=s:byte(1,4);return ok(a+b*256+c*65536+d*16777216)end}}
local function factory()return {base=base,clock_us=function()return 0 end,float_bytes=fbytes,
    float=function(s,at)local f=ffi.new('float[1]');ffi.copy(f,s:sub(at+1,at+4),4);return tonumber(f[0])end,
    write=function(at,s)write_count=write_count+1;if fail_write and write_count==2 then error('failed second write')end;put(at,s)end}end
b=native.new(fake,factory);local row=b:sample();assert(row.held and row.gameplay and row.unit_ref==123)
assert(b:begin(row)==2);assert(read(bucket+8,20)~=original)
assert(b:sample().held,'Repeat binding preserves held observation')
b:refresh(row);assert(b:restore());assert(read(bucket+8,40)==original..original,'Exact restoration')
b:begin(row);put(bucket+4,packed(3));put(bucket+48,original)
assert(b:restore() and read(bucket+8,60)==original..original..original,'Added mapping must not strand old leased rows')
put(bucket+4,packed(2))
-- A user's edit must survive restoration while unaffected leased mappings restore.
b:begin(row);local user_edit=original:sub(1,4)..'\2\0\0\0'..original:sub(9)
put(bucket+8,user_edit);assert(not pcall(b.refresh,b,row),'Edited leased mapping rejected during hold')
assert(not b:restore());assert(read(bucket+8,20)==user_edit and read(bucket+28,20)==original)
put(bucket+8,original);write_count=0;fail_write=true
assert(not pcall(b.begin,b,row));assert(b.lease,'Failure retains rollback state')
fail_write=false;assert(b:restore());assert(read(bucket+8,40)==original..original,'Partial write rollback')
-- Unknown mapping refuses before either write.
put(bucket+28,packed(0x0010ff73)..original:sub(5));write_count=0
assert(not pcall(b.begin,b,row) and write_count==0 and b.lease==nil)
-- A default controller axis does not prevent mouse assistance and remains untouched.
local axis=packed(0x0010ff83)..original:sub(5);put(bucket+28,axis)
assert(b:begin(row)==1);assert(read(bucket+28,20)==axis)
row.mapping_index=1;assert(b:refresh(row)==false,'Switch to axis remains detectable in batched snapshot')
row.mapping_index=0;assert(b:restore())
row.mapping_index=1;write_count=0
assert(b:begin(row)==nil and b.lease==nil and write_count==0,'Axis hold remains vanilla')
row.mapping_index=0
put(bucket+28,original)
put(owner+0x1c88,'\0\0\0\0'..fbytes(0)..fbytes(0)..string.rep('\0',12)..packed(0)..packed(0))
assert(not b:sample().held,'Release observed natively')
-- Exact build and native code anchors are mandatory.
fake.Build.Status=function()return {id='unknown'}end;assert(not pcall(native.new,fake,factory))
fake.Build.Status=function()return {id='steam-25480438-v02-candidate'}end
put(base+0x12fc180,string.rep('\0',12));assert(not pcall(native.new,fake,factory))
