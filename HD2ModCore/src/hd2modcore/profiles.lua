local Result = require('hd2modcore.result')

local M = {}
local Registry = {}
Registry.__index = Registry

local function digest(value)
    return type(value) == 'string' and #value == 64 and
        value:match('^[0-9A-Fa-f]+$') ~= nil
end

function M.new(definitions)
    local profiles, ids, identities = {}, {}, {}
    for _, profile in ipairs(definitions or {}) do
        assert(type(profile) == 'table' and (profile.schema == 1 or profile.schema == 2) and
            type(profile.id) == 'string' and profile.id:match('^[%w_-]+$') and
            not ids[profile.id], 'invalid or duplicate profile')
        assert(type(profile.identity) == 'table' and
            digest(profile.identity.exe_sha256) and
            digest(profile.identity.dll_sha256), 'invalid profile digest')
        assert(profile.evidence == 'source_only' or profile.evidence == 'runtime_observed',
            'invalid profile evidence')
        assert(type(profile.symbols) == 'table', 'profile symbols must be explicit')
        assert(type(profile.capabilities)=='table' and
            next(profile.capabilities)==nil, 'unvalidated capabilities forbidden')
        if profile.schema==1 then
            assert(next(profile.symbols)==nil,'v0.1 symbols forbidden')
        else
            for name,symbol in pairs(profile.symbols) do
                assert(type(name)=='string' and name:match('^[%w_]+$') and
                    type(symbol)=='table' and symbol.module=='game.dll' and
                    type(symbol.rva)=='number' and symbol.rva==math.floor(symbol.rva) and
                    symbol.rva>=0 and symbol.rva<=0x7fffffff and
                    symbol.kind=='data_pointer' and
                    symbol.evidence=='source_candidate',
                    'invalid v0.2 symbol')
            end
        end
        local key=profile.identity.exe_sha256:upper()..':'..
            profile.identity.dll_sha256:upper()
        assert(not identities[key], 'duplicate build identity')
        identities[key]=true
        ids[profile.id] = true
        profiles[#profiles + 1] = profile
    end
    return setmetatable({profiles = profiles, selected = nil, state = 'unidentified'}, Registry)
end

function Registry:select(identity)
    self.selected, self.state = nil, 'unsupported'
    if type(identity) ~= 'table' or not digest(identity.exe_sha256)
        or not digest(identity.dll_sha256) then
        return Result.err('BuildIdentityFailed', 'profile', 'both module digests required')
    end
    local exe, dll = identity.exe_sha256:upper(), identity.dll_sha256:upper()
    for _, profile in ipairs(self.profiles) do
        if profile.identity.exe_sha256:upper() == exe and
            profile.identity.dll_sha256:upper() == dll then
            self.selected = profile
            self.state = profile.evidence == 'runtime_observed'
                and 'runtime_observed' or 'source_known'
            return Result.ok({id = profile.id, evidence = profile.evidence,
                state = self.state})
        end
    end
    return Result.err('UnsupportedBuild', 'profile', 'no exact EXE and DLL match')
end

function Registry:status()
    return {state = self.state, id = self.selected and self.selected.id or nil,
        evidence = self.selected and self.selected.evidence or nil}
end

return M
