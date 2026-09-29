"""Build the Shared Loader-only Full Auto Assist RC3 candidate. No deployment."""
from pathlib import Path
import hashlib,json,struct,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
PACKAGE='HD2FullAutoAssist-v0.1.3-Standalone-RC3-Arsenal.zip'
LUA_TYPE=0xA14E8DFA2CD117E2
MIX=0xC6A4A7935BD1E995
MASK=(1<<64)-1
def resource_hash(name: str) -> int:
    """MurmurHash64A variant used by the game's resource directory."""
    data = name.encode("utf-8")
    value = len(data) * MIX & MASK
    block_end = len(data) & ~7
    for offset in range(0, block_end, 8):
        word = int.from_bytes(data[offset:offset + 8], "little")
        word = word * MIX & MASK
        word ^= word >> 47
        word = word * MIX & MASK
        value = (value ^ word) * MIX & MASK
    if block_end < len(data):
        value = (value ^ int.from_bytes(data[block_end:], "little")) * MIX & MASK
    value ^= value >> 47
    value = value * MIX & MASK
    return value ^ (value >> 47)


def archive_resource(source: bytes) -> bytes:
    payload = struct.pack("<II", len(source), 2) + source
    offset = (104 + 80 + 15) & ~15
    header = struct.pack("<III20sQQ24s", 0xF0000011, 1, 1,
                         b"", 0, 0, b"")
    type_row = struct.pack("<IIQIIII", 0, 0, LUA_TYPE, 1, 0, 16, 16)
    file_row = struct.pack("<7Q6I", resource_hash(MODULE), LUA_TYPE,
                           offset, 0, 0, 0, 0, len(payload), 0, 0,
                           16, 16, 0)
    body = bytearray(header + type_row + file_row)
    body.extend(b"\0" * (offset - len(body)))
    body.extend(payload)
    body.extend(b"\0" * (-len(body) % 16))
    struct.pack_into("<Q", body, 32, len(body))
    return bytes(body)


def verify_archive(data: bytes, source: bytes) -> None:
    magic, types, count = struct.unpack_from("<III", data, 0)
    if (magic, types, count) != (0xF0000011, 1, 1):
        raise ValueError("archive header mismatch")
    name_hash, kind, offset = struct.unpack_from("<QQQ", data, 104)
    if name_hash != resource_hash(MODULE) or kind != LUA_TYPE:
        raise ValueError("archive resource identity mismatch")
    size, flag = struct.unpack_from("<II", data, offset)
    if flag != 2 or size != len(source) or data[offset + 8:offset + 8 + size] != source:
        raise ValueError("archive Lua resource mismatch")



def bundle():
    lines=[f'-- HD2-Addon: {MODULE}','local factories,loaded={},{}','local builtin_require=require',
        'local function own_require(name)',
        " if name=='ffi' then return builtin_require(name) end",
        " local factory=assert(factories[name],'Full Auto Assist module unavailable: '..tostring(name))",
        ' if not loaded[name] then loaded[name]=factory(own_require) end',
        ' return loaded[name]','end']
    for f in sorted((ROOT/'src').glob('*.lua')):
        raw=f.read_bytes().replace(b'\r\n',b'\n')
        assert b'\r' not in raw and b'\0' not in raw and not raw.startswith(b'\xef\xbb\xbf')
        assert b'hd2modcore.' not in raw and b'mods/skyeshade/hd2runtime' not in raw
        lines += [f'factories[{f.stem!r}]=function(require)',raw.decode('utf-8'),'end']
    lines += ["return own_require('lifecycle').start(_G)",'']
    return '\n'.join(lines).encode('utf-8')

def main():
    source=bundle();archive=archive_resource(source);verify_archive(archive,source)
    out=ROOT/'build';out.mkdir(exist_ok=True)
    (out/'hd2_full_auto_assist.lua').write_bytes(source);(out/ARCHIVE).write_bytes(archive)
    manifest={'Version':1,'Guid':'cf368f5c-f686-453f-a566-435b4b7fcf26',
        'Name':'HD2 Full Auto Assist v0.1.3 Standalone RC3',
        'Description':'Accessibility/QoL candidate for Steam build 25480438. Requires only Bingus Shared Loader v18/API 1. Balanced default; optional Mod Bindings Menu registration and standalone = fallback; Talon profiles selectable in INI.',
        'Options':[{'Name':'Full Auto Assist standalone',
            'Description':'Reviewed weapons only. = toggle by default; Talon profiles in INI. Native auto and charge/hold remain vanilla.',
            'Include':['Addon']}]}
    files={'manifest.json':(json.dumps(manifest,indent=2)+'\n').encode(),
        'Addon/'+ARCHIVE:archive,'Addon/'+ARCHIVE+'.stream':b'','Addon/'+ARCHIVE+'.gpu_resources':b''}
    for name in ('README.md','HD2FullAutoAssist.example.ini','HD2FullAutoAssist.validation.ini',
                 'docs/RC2_NOTES.md','docs/NEXT_TEST.md','docs/VALIDATION.md','docs/DEPENDENCIES.md',
                 'docs/talon-heat-evidence.json','docs/identity-validation.json',
                 'docs/weapon-candidate-matrix.md'):
        files[name]=(ROOT/name).read_bytes()
    with zipfile.ZipFile(out/PACKAGE,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED
            info.external_attr=0o100644<<16;z.writestr(info,raw)
    checks=out/'standalone-checks.json'
    hashes={f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}
    tested=json.loads(checks.read_text()) if checks.exists() else {}
    report={'version':'0.1.3-standalone-rc3','supported_build':'25480438',
        'external_dependencies':['Bingus Shared Loader v18 / API 1'],
        'source_sha256':hashlib.sha256(source).hexdigest(),'archive_sha256':hashlib.sha256(archive).hexdigest(),
        'package_sha256':hashlib.sha256((out/PACKAGE).read_bytes()).hexdigest(),
        'offline_tested':tested.get('offline_passed') is True and tested.get('source_sha256')==hashes,
        'live_standalone_validated':False,'reference_user_reported_live_pass':True,
        'identity_observer_sha256':hashes['identity.lua'],'source_files':hashes,
        'embedded_core':False,'embedded_hd2runtime':False,'package':PACKAGE,
        'cadence':{'balanced_ceiling_rpm':380,'amr_balanced_rpm':120,'talon_balanced_rpm':210,
            'talon_profiles_rpm':{'balanced':210,'efficiency':60,'full_auto':380,'fuller_auto':750},
            'talon_live_followup_required':True,'input_attempts_are_not_shots':True}}
    (out/'build-report.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('Built standalone RC3: '+PACKAGE+'; Shared Loader only. Live follow-up pending.')
if __name__=='__main__':main()
