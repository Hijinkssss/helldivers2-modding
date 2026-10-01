"""Verify HUD field anchors against the saved exact-build image, never a process."""
import argparse,hashlib,json,re,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SHA='e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969'
SITES=[
 ('hud_owner','c780........01000000488b0d........4885c9',13,4,'rip',0x346d538),
 ('mission_hud','83fa0674..498d8a........e8........83ff06',8,4,'u',0x24e340),
 ('self_panel','498d57..498bcce8........498bcce8........f30f1005........498d8f........',3,1,'u',0x60),
 ('weapon_widget','488bcfe8........4d8daf........ba01000000498bcd',11,4,'u',0x7b0),
 ('screen_x','f30f58f0f30f1080........f30f59c3',8,4,'u',148),
 ('screen_y','f3440f10a0........f30f10b8........',5,4,'u',156),
 ('opacity','0f84........f30f1048..f30f1050..',10,1,'u',84),
 ('scale_x','f30f1070..f3440f1078..',4,1,'u',100),
 ('size_x','f30f1051..0f5715........f30f1049..',4,1,'u',36),
 ('size_y','f30f1051..0f5715........f30f1049..',16,1,'u',40),
]
# Exact instructions inspected in surrounding constructor/attach/transform code.
INSTRUCTIONS={
 0x181857c:('ammo_container_at_0x3220','498dbf20320000'),
 0x1818617:('ammo_container_attached_to_weapon_widget','488bd7498bcd'),
 0x1818921:('reserve_text_at_0x3a60','498d9f603a0000'),
 0x1818aba:('reserve_text_attached_to_ammo_container','488bd3488bcf'),
 0x144c5cc:('first_child_0xe0','488b91e0000000'),
 0x144c5ea:('next_sibling_0xe8','488b80e8000000'),
 0x144c640:('child_parent_0xf0','498999f0000000'),
 0x1446926:('widget_type_shift_18','c1e212'),
 0x144a64d:('scale_y_140','f3440f10908c000000'),
}
def main():
    p=argparse.ArgumentParser();p.add_argument('--image',type=Path,required=True);args=p.parse_args()
    raw=args.image.read_bytes();assert hashlib.sha256(raw).hexdigest()==SHA
    fields=[]
    for name,pattern,offset,size,kind,expected in SITES:
        rex=b''.join(b'.' if pattern[i:i+2]=='..' else re.escape(bytes.fromhex(pattern[i:i+2]))
            for i in range(0,len(pattern),2))
        matches=[m.start() for m in re.finditer(rex,raw[:0x2110000],re.S)]
        assert len(matches)==1,(name,matches)
        at=matches[0];value=int.from_bytes(raw[at+offset:at+offset+size],'little',signed=kind=='rip')
        if kind=='rip':value+=at+offset+size
        assert value==expected,(name,hex(value),hex(expected))
        fields.append({'name':name,'pattern':pattern,'rva':hex(at),'field':expected})
    instructions=[]
    for at,(name,encoded) in INSTRUCTIONS.items():
        expected=bytes.fromhex(encoded)
        assert raw[at:at+len(expected)]==expected,(name,raw[at:at+len(expected)].hex())
        instructions.append({'name':name,'rva':hex(at),'bytes':encoded})
    report={'passed':True,'steam_build':'25480438','image_sha256':SHA,
        'game_dll_sha256':'2e2c3b7c2500646dadd5f2b4c6e0504dbb7e7896139f64cddc0d1813c718f51e',
        'fields':fields,'instructions':instructions,'game_process_accessed':False,
        'scope':'Static field/tree/constructor proof; live backpack bounds and visual alignment pending'}
    (ROOT/'docs/hud-native-evidence.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('PASS exact-build HUD evidence: 10 fields and 9 tree/constructor instructions')
if __name__=='__main__':main()
