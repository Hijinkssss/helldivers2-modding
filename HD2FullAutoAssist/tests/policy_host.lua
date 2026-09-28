-- Synthetic metadata fixtures, not live game evidence.
-- Updated to include all weapons in the classification table for policy tests.
-- Resource hashes are verified from identity-validation evidence where available;
-- others are placeholders (marked PLACEHOLDER) pending live validation.
function policy_fixture()
    local metadata = {
        -- Verified hashes (from identity-validation.json)
        ['P-2 Peacemaker']      = { name = 'P-2 Peacemaker',      resources = { '0x05E4E5C2DB6E44A2' } },
        ['AR-23 Liberator']     = { name = 'AR-23 Liberator',      resources = { '0x968211C0033DCE64' } },
        ['R-2 Amendment']       = { name = 'R-2 Amendment',        resources = { '0x0F83639AB8C86165' } }, -- from identity evidence
        ['APW-1 Anti-Materiel Rifle'] = {
            catalogIdentity       = 'APW-1 Anti-Materiel Rifle',
            resourceHashes        = { '0x89C5493E08CA4207' },
            canonicalResourceHash = '0x89C5493E08CA4207',
            identityResolution    = 'UNIQUE',
        },
        ['LAS-99 Quasar Cannon'] = {
            catalogIdentity       = 'LAS-99 Quasar Cannon',
            resourceHashes        = { '0x35A61296619CC47E' },
            canonicalResourceHash = '0x35A61296619CC47E',
            identityResolution    = 'UNIQUE',
        },
        ['LAS-98 Laser Cannon'] = {
            catalogIdentity       = 'LAS-98 Laser Cannon',
            resourceHashes        = { '1111111111111111', '2222222222222222' },
        },
        -- PLACEHOLDER hashes – not yet live-validated; used for classification checks only
        ['M6C/SOCOM Pistol']    = { name = 'M6C/SOCOM Pistol',    resources = { '0xAAAAAAAAAAAA0001' } }, -- PLACEHOLDER
        ['P-69 Veto']           = { name = 'P-69 Veto',           resources = { '0xAAAAAAAAAAAA0002' } }, -- PLACEHOLDER
        ['LAS-58 Talon']        = { name = 'LAS-58 Talon',        resources = { '0xAAAAAAAAAAAA0003' } }, -- PLACEHOLDER
        ['P-113 Verdict']       = { name = 'P-113 Verdict',       resources = { '0xAAAAAAAAAAAA0004' } }, -- PLACEHOLDER
        ['R-63 Diligence']      = { name = 'R-63 Diligence',      resources = { '0xAAAAAAAAAAAA0005' } }, -- PLACEHOLDER
        ['R-63CS Diligence Counter Sniper'] = {
            name      = 'R-63CS Diligence Counter Sniper',
            resources = { '0xAAAAAAAAAAAA0006' },                                                         -- PLACEHOLDER
        },
    }
    local modes = {
        -- Verified or well-established fire-mode vectors
        ['P-2 Peacemaker']      = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 },    nativeModeVector = { 2, 0, 0 } },
        ['M6C/SOCOM Pistol']    = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 },    nativeModeVector = { 2, 0, 0 } },
        ['P-69 Veto']           = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 },    nativeModeVector = { 2, 0, 0 } },
        ['LAS-58 Talon']        = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 },    nativeModeVector = { 2, 0, 0 } },
        -- Amendment: burst-fire only, no native full-auto (mode id 1 absent from vector)
        ['R-2 Amendment']       = { defaultModeSemantics = 'burst_fire', allowedModes = { 3 },    nativeModeVector = { 3, 0, 0 } },
        -- AR-23 Liberator: has native Full Auto (mode id 1 present)
        ['AR-23 Liberator']     = { defaultModeSemantics = 'full_auto',  allowedModes = { 1, 2 }, nativeModeVector = { 1, 2, 3 } },
        -- Sniper rifles: semi-auto but REVIEW pending verification
        ['R-63 Diligence']               = { defaultModeSemantics = 'semi_auto', allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        ['R-63CS Diligence Counter Sniper'] = { defaultModeSemantics = 'semi_auto', allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        -- Verdict: REVIEW – include a plausible fixture so runtime lookup does not error
        ['P-113 Verdict']       = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 },    nativeModeVector = { 2, 0, 0 } },
        -- AMR: support weapon with no R-menu mode selector; fire_modes returns nil/false
        -- (nil simulates a nil fire_modes result; SPECIAL category allows this)
        ['APW-1 Anti-Materiel Rifle'] = false,  -- nil modes => bridge returns false
    }
    local bridge = { imports = 0, targets = 0 }
    function bridge:Connect()
        self.imports = self.imports + 1; return { ok = true }
    end
    function bridge:Status()
        return { state = 'connected', version = '0.24.0',
                 capabilities = { weapon = true, support_weapon = true } }
    end
    function bridge:Target(kind, name)
        self.targets = self.targets + 1
        if not metadata[name] then return { ok = false } end
        local m = metadata[name]
        local mo = modes[name]  -- may be nil or false
        return { ok = true, value = {
            describe    = function() return m end,
            fire_modes  = function() return mo end,
        }}
    end
    return bridge, metadata, modes
end
