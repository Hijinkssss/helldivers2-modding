-- Source candidate only. These RVAs are not yet HD2ModCore runtime validated.
return {
    schema=2,
    id='steam-25480438-v02-candidate',
    evidence='source_only',
    identity={
        exe_sha256='F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06',
        dll_sha256='2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E'
    },
    symbols={
        player_manager={module='game.dll',rva=0x3326468,kind='data_pointer',evidence='source_candidate'},
        entity_owner={module='game.dll',rva=0x346bf98,kind='data_pointer',evidence='source_candidate'},
        avatar_manager={module='game.dll',rva=0x3326d20,kind='data_pointer',evidence='source_candidate'},
        weapon_wielder={module='game.dll',rva=0x3326420,kind='data_pointer',evidence='source_candidate'},
        equipment_manager={module='game.dll',rva=0x3326dc0,kind='data_pointer',evidence='source_candidate'}
    },
    capabilities={}
}
