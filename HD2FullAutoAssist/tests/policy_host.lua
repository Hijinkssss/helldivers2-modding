-- Synthetic metadata fixtures, not live game evidence.
function policy_fixture()
    local metadata={
        ['P-2 Peacemaker']={name='P-2 Peacemaker',resources={'0x05E4E5C2DB6E44A2'}},
        ['AR-23 Liberator']={name='AR-23 Liberator',resources={'0x968211C0033DCE64'}},
        ['LAS-99 Quasar Cannon']={catalogIdentity='LAS-99 Quasar Cannon',resourceHashes={'0x35A61296619CC47E'},
            canonicalResourceHash='0x35A61296619CC47E',identityResolution='UNIQUE'},
        ['LAS-98 Laser Cannon']={catalogIdentity='LAS-98 Laser Cannon',resourceHashes={'1111111111111111','2222222222222222'}}
    }
    local modes={['P-2 Peacemaker']={defaultModeSemantics='semi_auto',allowedModes={2},nativeModeVector={2,0,0}},
        ['AR-23 Liberator']={defaultModeSemantics='full_auto',allowedModes={1,2},nativeModeVector={1,2,3}}}
    local bridge={imports=0,targets=0}
    function bridge:Connect()self.imports=self.imports+1;return {ok=true}end
    function bridge:Status()return {state='connected',version='0.24.0',capabilities={weapon=true,support_weapon=true}}end
    function bridge:Target(kind,name)
        self.targets=self.targets+1
        if not metadata[name] then return {ok=false} end
        return {ok=true,value={describe=function()return metadata[name]end,fire_modes=function()return modes[name]end}}
    end
    return bridge,metadata,modes
end
