"""Build Full Auto Assist release or isolated diagnostic packages."""
from pathlib import Path
import argparse,hashlib,json,struct,subprocess,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
VERSION='1.3.0'
PACKAGE=f'Full-Auto-Assist-{VERSION}-Arsenal.zip'
OUTPUT=ROOT/'build'/VERSION
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


def archive_resource(source: bytes, module: str = MODULE) -> bytes:
    payload = struct.pack("<II", len(source), 2) + source
    offset = (104 + 80 + 15) & ~15
    header = struct.pack("<III20sQQ24s", 0xF0000011, 1, 1,
                         b"", 0, 0, b"")
    type_row = struct.pack("<IIQIIII", 0, 0, LUA_TYPE, 1, 0, 16, 16)
    file_row = struct.pack("<7Q6I", resource_hash(module), LUA_TYPE,
                           offset, 0, 0, 0, 0, len(payload), 0, 0,
                           16, 16, 0)
    body = bytearray(header + type_row + file_row)
    body.extend(b"\0" * (offset - len(body)))
    body.extend(payload)
    body.extend(b"\0" * (-len(body) % 16))
    struct.pack_into("<Q", body, 32, len(body))
    return bytes(body)


def verify_archive(data: bytes, source: bytes, module: str = MODULE) -> None:
    magic, types, count = struct.unpack_from("<III", data, 0)
    if (magic, types, count) != (0xF0000011, 1, 1):
        raise ValueError("archive header mismatch")
    name_hash, kind, offset = struct.unpack_from("<QQQ", data, 104)
    if name_hash != resource_hash(module) or kind != LUA_TYPE:
        raise ValueError("archive resource identity mismatch")
    size, flag = struct.unpack_from("<II", data, offset)
    if flag != 2 or size != len(source) or data[offset + 8:offset + 8 + size] != source:
        raise ValueError("archive Lua resource mismatch")



def bundle(module: str = MODULE, research: bool = False, force_performance_profile: bool = False):
    lines=[f'-- HD2-Addon: {module}','local factories,loaded={},{}','local builtin_require=require',
        'local function own_require(name)',
        " if name=='ffi' then return builtin_require(name) end",
        " local factory=assert(factories[name],'Full Auto Assist module unavailable: '..tostring(name))",
        ' if not loaded[name] then loaded[name]=factory(own_require) end',
        ' return loaded[name]','end']
    for f in sorted((ROOT/'src').glob('*.lua')):
        if not research and f.stem.startswith('charge_'): continue
        raw=f.read_bytes().replace(b'\r\n',b'\n')
        assert b'\r' not in raw and b'\0' not in raw and not raw.startswith(b'\xef\xbb\xbf')
        assert b'hd2modcore.' not in raw and b'mods/skyeshade/hd2runtime' not in raw
        lines += [f'factories[{f.stem!r}]=function(require)',raw.decode('utf-8'),'end']
    if research and force_performance_profile:
        raise ValueError('Charge research and the performance diagnostic build cannot be combined')
    options=(',{charge_research=true}' if research else
        ',{force_performance_profile=true}' if force_performance_profile else '')
    lines += [f"return own_require('lifecycle').start(_G{options})",'']
    return '\n'.join(lines).encode('utf-8')

def main():
    source=bundle();archive=archive_resource(source);verify_archive(archive,source)
    expected=json.loads((ROOT/'version.json').read_text())['archive_sha256']
    assert hashlib.sha256(archive).hexdigest()==expected,'Runtime differs from release baseline'
    OUTPUT.mkdir(parents=True,exist_ok=True)
    files={'manifest.json':(ROOT/'manifest.json').read_bytes(),'thumbnail.png':(ROOT/'thumbnail.png').read_bytes(),
        'Core/'+ARCHIVE:archive,'Core/'+ARCHIVE+'.stream':b'','Core/'+ARCHIVE+'.gpu_resources':b'',
        'README.md':(ROOT/'README.md').read_bytes(),'HD2FullAutoAssist.example.ini':(ROOT/'HD2FullAutoAssist.example.ini').read_bytes(),
        'CHANGELOG.md':(ROOT/'CHANGELOG.md').read_bytes(),'RELEASE_NOTES.md':(ROOT/'docs/RELEASE_1.3.0.md').read_bytes(),
        'SUPPORTED_WEAPONS.md':(ROOT/'docs/SUPPORTED_WEAPONS_1.3.0.md').read_bytes(),'version.json':(ROOT/'version.json').read_bytes(),'CONFIGURATION.md':(ROOT/'docs/WEAPON_CONFIGURATION.md').read_bytes()}
    with zipfile.ZipFile(OUTPUT/PACKAGE,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o100644<<16;z.writestr(info,raw)
    with zipfile.ZipFile(OUTPUT/PACKAGE) as z:assert z.testzip() is None
    digest=hashlib.sha256((OUTPUT/PACKAGE).read_bytes()).hexdigest()
    (OUTPUT/(PACKAGE+'.sha256')).write_text(digest+'  '+PACKAGE+'\n',encoding='ascii')
    print('Built '+PACKAGE+' SHA-256 '+digest)
if __name__=='__main__':main()
