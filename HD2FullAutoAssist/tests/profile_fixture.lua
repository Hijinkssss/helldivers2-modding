-- Offline known-profile issuer. Never bundled in the runtime archive.
return function(base)
    local c=require('compatibility');local k=c.known_profile()
    local token=assert(c.select({module_hash=function(_,name)return name and k.dll or k.exe end}))
    return c.resolve(token,base,0x4000000)
end
