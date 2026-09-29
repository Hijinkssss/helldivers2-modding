-- Synthetic metadata fixtures, not live game evidence.
-- Resource hashes are sourced from selective-checks.json runtime metadata
-- where available, or marked PLACEHOLDER pending live identity validation.
-- The three promoted weapons match docs/weapon-policy-evidence.json.
-- These fixtures exercise the controller; they do not prove successful shots.
function policy_fixture()
    local metadata = {
        -- ── Hashes from selective-checks.json runtime metadata (authoritative) ──
        ['P-2 Peacemaker']      = { name = 'P-2 Peacemaker',      resources = { '0x05E4E5C2DB6E44A2' } },
        ['R-2 Amendment']       = { name = 'R-2 Amendment',        resources = { '0x0F83639AB8C86165' } },
        ['AR-23 Liberator']     = { name = 'AR-23 Liberator',      resources = { '0x968211C0033DCE64' } },
        ['P-113 Verdict']       = { name = 'P-113 Verdict',        resources = { '0x1A437158E1B8D2A1' } },
        ['P-69 Veto']           = { name = 'P-69 Veto',            resources = { '0xC780BCD79547DA0F' } },
        ['M6C/SOCOM Pistol']    = { name = 'M6C/SOCOM Pistol',     resources = { '0x4D58C77087B774C5' } },
        ['LAS-58 Talon']        = { name = 'LAS-58 Talon',         resources = { '0x416D053372C4E433' } },
        ['R-63 Diligence']      = { name = 'R-63 Diligence',       resources = { '0x03E67A19B07C6523' } },
        ['R-63CS Diligence Counter Sniper'] = {
            name      = 'R-63CS Diligence Counter Sniper',
            resources = { '0x4C786785C79D44E7' },
        },
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
        -- LAS-98 has multiple resource hashes and fails single(); it ends up in notes.
        -- Represented here but will not map cleanly (matches real runtime behaviour).
        ['LAS-98 Laser Cannon'] = {
            catalogIdentity = 'LAS-98 Laser Cannon',
            resourceHashes  = { '0x1980D92B619FF5FE', '0x56070F36CFFFA8A8', '0xD54B9505C0F72873' },
        },
    }

    local modes = {
        -- Semi-auto pistols / energy pistol (single semi-auto mode, no full-auto)
        ['P-2 Peacemaker']   = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        ['M6C/SOCOM Pistol'] = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        ['P-69 Veto']        = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        ['LAS-58 Talon']     = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        -- Runtime reports semi/burst vector; allowedModes exposes only semi.
        ['R-2 Amendment']    = { defaultModeSemantics = 'semi_auto', allowedModes = { 2 }, nativeModeVector = { 2, 3, 0 } },
        -- Liberator: has native full-auto (mode id 1 present) -> IGNORE_NATIVE_AUTO
        ['AR-23 Liberator']  = { defaultModeSemantics = 'full_auto',  allowedModes = { 1, 2 }, nativeModeVector = { 1, 2, 3 } },
        -- Promoted using reviewed Runtime snapshot metadata, not these fixtures.
        ['R-63 Diligence']               = { defaultModeSemantics = 'semi_auto', allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        ['R-63CS Diligence Counter Sniper'] = { defaultModeSemantics = 'semi_auto', allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        -- Verdict: reviewed semi-only Runtime vector.
        ['P-113 Verdict']    = { defaultModeSemantics = 'semi_auto',  allowedModes = { 2 }, nativeModeVector = { 2, 0, 0 } },
        -- AMR: SPECIAL; no R-menu mode selector -> fire_modes returns false (nil equivalent)
        ['APW-1 Anti-Materiel Rifle'] = false,
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
        local m  = metadata[name]
        local mo = modes[name]  -- may be nil or false
        return { ok = true, value = {
            describe   = function() return m end,
            fire_modes = function() return mo end,
        }}
    end
    return bridge, metadata, modes
end
