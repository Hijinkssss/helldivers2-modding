local Result=require('hd2modcore.result')
local Symbols=require('hd2modcore.symbols')
local GameState=require('hd2modcore.game_state')

local function u32(n)
    local b={}
    for i=1,4 do b[i]=string.char(n%256);n=math.floor(n/256) end
    return table.concat(b)
end
local function u64(n)
    return u32(n%4294967296)..u32(math.floor(n/4294967296))
end
local function row(k,v)return u32(k)..u32(v)end
local function map(bytes,header,rows,key,index,cap)
    cap=cap or 8
    bytes[header]=u64(rows)..u32(cap)..u32(0xffffffff)..u32(1)
    bytes[rows+(key%cap)*8]=row(key,index)
end
local function avatar_record(id)
    return '\151\250\077\041\077\051\028\077'..u32(id)..u32(0x42)..
        string.rep('\0',4)..'\1'..string.rep('\0',3)
end

local G,PM,PLAYER,OWNER,AM,WM,EM=0x10000000,0x20000000,0x21000000,
    0x30000000,0x40000000,0x50000000,0x60000000
local AVATAR=OWNER+0xf32f18+2*24
local BACKS,ROWS,EBACK,ERECORD=0x51000000,0x52000000,0x61000000,0x62000000
local symbol_address={player_manager=G+0x3326468,entity_owner=G+0x346bf98,
    avatar_manager=G+0x3326d20,weapon_wielder=G+0x3326420,
    equipment_manager=G+0x3326dc0}
local pointers={player_manager=PM,entity_owner=OWNER,avatar_manager=AM,
    weapon_wielder=WM,equipment_manager=EM}
local bytes={}
for name,address in pairs(symbol_address)do bytes[address]=u64(pointers[name])end
bytes[PM+0x84]=u32(1)..u32(1)
bytes[PM+0xe8]=u64(PLAYER)
bytes[PLAYER]=string.rep('\0',20)..'\1'..string.rep('\0',3)
bytes[PM+0x3a8]=u32(0x42)
map(bytes,OWNER+0xf22ec8,0x31000000,0x42,2)
bytes[AVATAR]=avatar_record(0x98)
map(bytes,AM+0xf8,0x41000000,0x98,1)
bytes[AM+0x6c]=u32(2)
bytes[AM+0x118]=u64(AVATAR)
map(bytes,WM+48,0x53000000,0x98,0)
bytes[WM+72]=u64(BACKS)
bytes[BACKS]=u64(AVATAR)
bytes[WM+96]=u64(ROWS)
bytes[ROWS]=u32(0xa9)
map(bytes,EM+32,0x63000000,0xa9,1)
bytes[EM+56]=u64(EBACK)
bytes[EBACK+8]=u64(ERECORD)
bytes[ERECORD]=u64(0x12345678)..u32(0xa9)..string.rep('\0',12)

local memory={read=function(_,address,size)
    local got=bytes[address]
    if got and #got==size then return Result.ok(got) end
    return Result.err('ReadFailed','fixture','unmapped fixture address')
end}
local symbols={resolve=function(_,name)
    local address=symbol_address[name]
    if not address then return Result.err('UnsupportedSymbol','fixture',name) end
    return Result.ok({address=address})
end}
local observer=GameState.new(memory,symbols)
local valid=observer:snapshot()
assert(valid.ok,valid.error and valid.error.detail)
assert(valid.value.avatar_id==0x98 and valid.value.unit_ref==0x42)
assert(valid.value.held.state=='present' and valid.value.held.entity_id==0xa9)
assert(valid.value.held.resource_hash=='0000000012345678')
assert(valid.value.evidence=='source_candidate')
assert(observer:status().reads<=96)

-- Linear probing must find a displaced key without choosing the first bucket.
local owner_rows,slot=0x31000000,0x42%8
bytes[owner_rows+slot*8]=row(0x777,5)
bytes[owner_rows+((slot+1)%8)*8]=row(0x42,2)
assert(observer:snapshot().ok)
bytes[owner_rows+slot*8]=row(0x42,2)
bytes[owner_rows+((slot+1)%8)*8]=nil

bytes[ROWS]=u32(0)
local absent=observer:snapshot()
assert(absent.ok and absent.value.held.state=='absent')
bytes[ROWS]=u32(0xa9)
bytes[BACKS]=u64(PLAYER)
assert(observer:snapshot().error.code=='SnapshotChanged')
bytes[BACKS]=u64(AVATAR)
bytes[OWNER+0xf22ec8]=u64(0x31000000)..u32(7)..u32(0xffffffff)..u32(1)
assert(observer:snapshot().error.code=='InvalidLayout')
map(bytes,OWNER+0xf22ec8,0x31000000,0x42,2)
bytes[PM+0x84]=u32(0)..u32(0)
assert(observer:snapshot().error.code=='Unavailable')
bytes[PM+0x84]=u32(1)..u32(1)

local profiles={selected={id='fixture',symbols={foo={module='game.dll',rva=0x20,
    kind='data_pointer',evidence='source_candidate'},bad={module='game.dll',
    rva=0x20000,kind='data_pointer',evidence='source_candidate'}}}}
local platform={module_address=function()return 0x70000000 end,
    module_image_size=function()return 0x10000 end}
local symbol_memory={read=function()return Result.ok(string.rep('\0',8))end}
local book=Symbols.new(platform,symbol_memory,profiles)
local address=book:resolve('foo')
assert(address.ok and address.value.address==0x70000020)
assert(address.value.evidence=='source_candidate')
assert(book:resolve('bad').error.code=='InvalidLayout')
assert(book:resolve('missing').error.code=='UnsupportedSymbol')
profiles.selected=nil
assert(book:resolve('foo').error.code=='UnsupportedBuild')
print('game state: bounded avatar/held fixture and symbol failure gates OK')
