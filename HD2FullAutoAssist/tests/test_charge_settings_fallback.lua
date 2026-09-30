local Observer=require('charge_observer')
local function u32(n)return string.char(n%256,math.floor(n/256)%256,math.floor(n/65536)%256,math.floor(n/16777216)%256)end
local function ptr(n)return u32(n)..u32(0)end
local function hash(s)local out={};for i=8,1,-1 do out[#out+1]=string.format('%02x',s:byte(i))end;return table.concat(out)end
local function hash_bytes(text)local out={};for i=16,2,-2 do out[#out+1]=string.char(tonumber(text:sub(i-1,i),16))end;return table.concat(out)end
local function float(n)local ffi=require('ffi');local v=ffi.new('float[1]',n);return ffi.string(v,4)end
local function fixture()
    local f={base=0x10000000,now=0,bytes={}}
    function f:put(at,s)for i=1,#s do self.bytes[at+i-1]=s:sub(i,i)end end
    function f:read(at,n)
        if self.on_read then local value,handled=self.on_read(at,n);if handled then return value end end
        local out={};for i=0,n-1 do assert(self.bytes[at+i],'Unmapped fixture address '..string.format('%x',at+i));out[#out+1]=self.bytes[at+i]end;return table.concat(out)
    end
    function f:build_status()return {id='steam-25480438-v02-candidate'}end
    function f:clock_us()return self.now end
    local resource='6cfcc7f8801a0266';local id=0xa9
    local manager,entities,entry_rows=0x91000000,0x92000000,0x93000000
    local override_map,override_rows=0x94000000,0x95000000
    local owner,resource_table,record_table=0x96000000,0x97000000,0x97000140
    local identity=hash_bytes(resource)..u32(id)..string.rep('\x13',16)
    f.token=string.rep('a',32)..hash(identity:sub(9,16))..hash(identity:sub(17,24))
    f:put(f.base+0x3326c20,ptr(manager))
    f:put(manager+16,u32(1)..string.rep('\0',36)..ptr(entities)..ptr(entry_rows))
    f:put(entities,ptr(0x98000000));f:put(0x98000000,identity)
    f:put(entry_rows,string.rep('\0',40))
    f:put(manager+80,ptr(override_map)..u32(8)..u32(0xffffffff)..u32(1))
    f:put(manager+144,ptr(override_rows))
    f:put(override_map+((id%8)*8),u32(0xffffffff)..u32(0))
    f:put(f.base+0x346bf98,ptr(owner));f:put(owner+0xf12ad8,ptr(resource_table))
    f:put(resource_table,string.rep('\0',20*16))
    local rseed=(tonumber(resource:sub(1,8),16)%20*16+tonumber(resource:sub(9),16)%20)%20
    f.resource_slot=(rseed+3)%20 -- force a bounded collision chain
    f:put(resource_table+rseed*16,hash_bytes('0000000000000001')..u32(2)..u32(0))
    f:put(resource_table+((rseed+1)%20)*16,hash_bytes('0000000000000002')..u32(2)..u32(0))
    f:put(resource_table+((rseed+2)%20)*16,hash_bytes('0000000000000003')..u32(2)..u32(0))
    f:put(resource_table+f.resource_slot*16,hash_bytes(resource)..u32(3)..u32(0))
    local settings= float(.25)..string.rep('\0',20)..float(.4)..string.rep('\0',20)..float(.5)..string.rep('\0',132)..'\1\2\3\4\5\6\7\8\9\10\11\12'..string.rep('\0',20)
    assert(#settings==216)
    f.expected=settings:sub(1,4)..settings:sub(25,28)..settings:sub(49,52)..settings:sub(185,196)
    f:put(record_table+3*216,settings)
    f.state={identity_observed=true,weapon={resource_hash=resource,entity_id=id,identity_token=f.token}}
    return f,manager,owner,resource_table,override_map,record_table
end
local f,manager,owner,resource_table,override_map,record_table=fixture()
local observer=Observer.new(f)
local row=observer:sample(f.state)
assert(row.state=='raw_observed',row.reason)
assert(row.settings_state=='observed' and row.settings_source=='resource_default')
assert(row.settings_hex==row.settings_hex and #row.settings_hex==48)
local first=row.settings_hex
assert(observer.resource_settings_scans==1 and observer.resource_settings_cache_hits==0)
for _=1,20 do row=observer:sample(f.state);assert(row.settings_hex==first)end
assert(observer.resource_settings_scans==1 and observer.resource_settings_cache_hits==20,
    'Validated resource settings location was not reused')
-- Cache reuse does not cache the fallback result; relocated roots are followed.
local moved=0x99000000;f:put(moved,f:read(resource_table,20*16));f:put(owner+0xf12ad8,ptr(moved))
local moved_record=moved+0x140;f:put(moved_record+3*216,f:read(record_table+3*216,216))
row=observer:sample(f.state);assert(row.settings_source=='resource_default' and row.settings_hex==first)
assert(observer.resource_settings_scans==2,'Resource table relocation reused a stale settings certificate')
-- Existing per-entity override takes precedence over the resource default.
local override_record=0x9a000000;f:put(manager+144,ptr(override_record));f:put(override_map+((0xa9%8)*8),u32(0xa9)..u32(0))
local override=float(.75)..string.rep('\0',20)..float(.8)..string.rep('\0',20)..float(.9)..string.rep('\0',132)..'\12\11\10\9\8\7\6\5\4\3\2\1'
f:put(override_record,override)
row=observer:sample(f.state);assert(row.settings_source=='instance_override' and row.settings_hex~=first)
-- A native table with no matching key remains an explicit not-found result.
f:put(override_map+((0xa9%8)*8),u32(0xffffffff)..u32(0))
f:put(moved+f.resource_slot*16,string.rep('\0',16))
row=observer:sample(f.state);assert(row.state=='raw_observed' and row.settings_state=='not_found')
-- Resource-table movement during a settings read invalidates the sample.
local f2,m2,o2,t2,_,_=fixture()
f2.on_read=function(at,n)
    if not f2.raced and at==t2+f2.resource_slot*16 then
        f2.raced=true;f2:put(o2+0xf12ad8,ptr(t2+0x10000));return f2:read(at,n),true
    end
end
row=Observer.new(f2):sample(f2.state)
assert(row.state=='unavailable' and row.reason:find('Resource charge settings changed',1,true))
-- Charge-row root changes invalidate cached identity certificates.
f:put(f.base+0x3326c20,ptr(manager+0x1000))
row=observer:sample(f.state);assert(row.state=='unavailable')
print('PASS charge settings fallback: collisions, missing keys, override precedence, relocation and read-race invalidation')
