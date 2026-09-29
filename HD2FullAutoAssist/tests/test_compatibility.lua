local c=require('compatibility')
local known=c.known_profile()
local function platform(exe,dll)
    return {module_hash=function(_,name)return name and dll or exe end}
end
local token,diagnostic=c.select(platform(known.exe,known.dll))
assert(token and diagnostic.compatibility=='known_profile' and diagnostic.build=='25480438')
local p=c.resolve(token,0x10000000,0x4000000)
assert(c.supported(p) and c.status(p).known_build)
for name,rva in pairs(known.globals)do assert(p.globals[name]==p.base+rva)end
assert(p.fire.state_offset==0x1c88 and p.fire.map_offset==0xa7ad0 and p.fire.action==0x20009)
assert(not c.supported({id=known.id}) and not c.supported(nil))
assert(not pcall(c.resolve,{},p.base,p.size))
assert(not pcall(c.resolve,token,p.base,4096))
assert(not pcall(c.resolve,token,0x7ffffffff000,p.size))
assert(c.select(platform(known.exe:lower(),known.dll:lower())))
-- Mutated identities never get a known-RVA fallback, even if a caller supplies
-- claimed signatures, a plausible layout, or a resolver callback.
local bad=string.rep('A',64)
for _,pair in ipairs({{bad,known.dll},{known.exe,bad},{bad,bad}})do
    local adapter=platform(pair[1],pair[2])
    adapter.resolve=function()error('Unreviewed resolver must not run')end
    local result,why=c.select(adapter)
    assert(not result and why.reason=='capability_evidence_missing' and #why.missing==12)
end
for _,adapter in ipairs({platform(nil,known.dll),platform(known.exe,'bad'),
    {module_hash=function()error('hash failure')end}})do
    local result,why=c.select(adapter)
    assert(not result and why.reason=='module_fingerprint_unavailable')
end
-- Integration: unknown identities stop before module addresses, native reads,
-- backend creation, callback changes, or native writes. Diagnostic is closed
-- even when logging fails. A populated synthetic layout cannot override this.
local Life=require('lifecycle')
for _,log_failure in ipairs({false,true})do
    local logs,closed={},0
    local stock=function()end
    local env={update=stock,shutdown=stock}
    local adapter=platform(bad,bad)
    adapter.read=function()error('Native read forbidden')end
    adapter.module_address=function()error('Stale RVA resolution forbidden')end
    local loader={api=1,open_log=function()return {
        write=function(_,line)logs[#logs+1]=line;if log_failure then error('log failure')end;return true end,
        flush=function()return true end,close=function()closed=closed+1 end}end}
    local good,why=pcall(Life.start,env,{platform=adapter,loader=loader,
        backend_factory=function()error('Backend must not be created')end})
    assert(not good and tostring(why):find('reason=capability_evidence_missing',1,true))
    assert(env.update==stock and env.shutdown==stock and not env.HD2FullAutoAssistStandalone)
    assert(closed==1 and #logs==1 and logs[1]:find('input_mapping_layout_evidence_missing',1,true))
end
print('compatibility: known profile, rejected identities, provenance boundary and zero-write startup passed')
