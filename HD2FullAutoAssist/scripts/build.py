"""Build the Shared Loader-only Full Auto Assist 1.0.0 Arsenal package."""
from pathlib import Path
import hashlib,json,struct,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
VERSION='1.0.1-WARRANT-RC1'
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



def bundle(module: str = MODULE):
    lines=[f'-- HD2-Addon: {module}','local factories,loaded={},{}','local builtin_require=require',
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

def option_bundle(module: str, setting: str, profile: str) -> bytes:
    source=(f'-- HD2-Addon: {module}\n'
        "local options=rawget(_G,'FullAutoAssistArsenalOptions')\n"
        "if type(options)~='table' then options={};rawset(_G,'FullAutoAssistArsenalOptions',options) end\n"
        f"if options[{setting!r}]~=nil and options[{setting!r}]~={profile!r} then error('Conflicting Full Auto Assist Arsenal profiles: {setting}') end\n"
        f"options[{setting!r}]={profile!r}\n")
    return source.encode('utf-8')

OPTIONS=[
    ('peacemaker_profile','P-2 Peacemaker',[
        ('Balanced','Fast automatic fire with a more manageable cadence.', 'balanced',380),
        ('Full Auto',"Uses the Peacemaker's native fire-rate ceiling.",'full_auto',900)]),
    ('socom_profile','M6C/SOCOM Pistol',[
        ('Balanced','Fast automatic fire with a more manageable cadence.','balanced',380),
        ('Full Auto',"Uses the SOCOM's native fire-rate ceiling.",'full_auto',900)]),
    ('veto_profile','P-69 Veto',[
        ('Balanced','Fast automatic fire with a controlled default cadence.','balanced',380),
        ('Full Auto',"Uses the Veto's native fire-rate ceiling.",'full_auto',750)]),
    ('talon_profile','LAS-58 Talon',[
        ('Balanced','Tuned for roughly eight shots before overheating.','balanced',210),
        ('Efficiency','Slow cadence that gives the heatsink substantially more time to cool between shots.','efficiency',60),
        ('Full Auto','Fast automatic fire with significantly increased heat buildup.','full_auto',380),
        ('FULLER AUTO',"Uses the Talon's native fire-rate ceiling. Expect extremely rapid heat buildup.",'fuller_auto',750)]),
    ('amr_profile','APW-1 Anti-Materiel Rifle',[
        ('Balanced','Current validated assisted cadence with time for recoil recovery.','balanced',120),
        ('Full Auto',"Uses the AMR's native fire-rate ceiling.",'full_auto',400)]),
    ('hyena_profile','R-4 Hyena',[
        ('Balanced','Slower assisted cadence intended to give the weapon time to settle between shots.','balanced',120),
        ('Full Auto',"Uses the Hyena's native fire-rate ceiling.",'full_auto',190)]),
    ('bushwhacker_profile','SG-22 Bushwhacker',[
        ('Balanced','Deliberate slow cadence that avoids dumping the entire load immediately while Fire is held.','balanced',90),
        ('Full Auto',"Uses the Bushwhacker's native fire-rate ceiling.",'full_auto',650)]),
]

def option_module(setting: str, profile: str) -> str:
    return f'mods/codex/hd2_full_auto_assist_option_{setting}_{profile}'

def main():
    source=bundle();archive=archive_resource(source);verify_archive(archive,source)
    option_archives={}
    for setting,_,profiles in OPTIONS:
        for _,_,profile,_ in profiles:
            module=option_module(setting,profile)
            content=option_bundle(module,setting,profile)
            packed=archive_resource(content,module);verify_archive(packed,content,module)
            option_archives[(setting,profile)]=packed
    out=OUTPUT;out.mkdir(parents=True,exist_ok=True)
    (out/'hd2_full_auto_assist.lua').write_bytes(source);(out/ARCHIVE).write_bytes(archive)
    description='An accessibility-focused QoL mod that lets supported semi-auto, burst, and game-cycled weapons continue firing while Fire is held, without altering damage, recoil, ammo, projectiles, or native weapon stats.'
    groups=[{'Name':'Full Auto Assist','Description':'Required. The assistance feature and its supported-weapon policy.',
        'Include':['Core'],'Image':'thumbnail.png'}]
    files={'thumbnail.png':(ROOT/'thumbnail.png').read_bytes(),
        'Core/'+ARCHIVE:archive,'Core/'+ARCHIVE+'.stream':b'','Core/'+ARCHIVE+'.gpu_resources':b''}
    for setting,title,profiles in OPTIONS:
        children=[]
        for label,help_text,profile,rpm in profiles:
            folder=f'Options/{setting.removesuffix("_profile")}/{profile}'
            children.append({'Name':f'{label} ({rpm} RPM)','Description':help_text,'Include':[folder]})
            packed=option_archives[(setting,profile)]
            files[folder+'/'+ARCHIVE]=packed
            files[folder+'/'+ARCHIVE+'.stream']=b''
            files[folder+'/'+ARCHIVE+'.gpu_resources']=b''
        groups.append({'Name':title,'Description':'Select one assisted fire-rate profile. Balanced is the default.',
            'SubOptions':children})
    files['manifest.json']=(json.dumps({'Version':1,'Guid':'cf368f5c-f686-453f-a566-435b4b7fcf26',
        'Name':'Full Auto Assist','Description':description,'Options':groups},indent=2)+'\n').encode()
    for name in ('README.md','CHANGELOG.md','HD2FullAutoAssist.example.ini'):
        files[name]=(ROOT/name).read_bytes()
    with zipfile.ZipFile(out/PACKAGE,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED
            info.external_attr=0o100644<<16;z.writestr(info,raw)
    package_hash=hashlib.sha256((out/PACKAGE).read_bytes()).hexdigest()
    (out/(PACKAGE+'.sha256')).write_text(f'{package_hash}  {PACKAGE}\n',encoding='ascii')
    checks=ROOT/'build'/'standalone-checks.json'
    hashes={f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}
    tested=json.loads(checks.read_text()) if checks.exists() else {}
    report={'version':VERSION,'supported_build':'25480438','name':'Full Auto Assist',
        'description':description,'configuration_precedence':'Arsenal selected profile > explicit per-weapon INI profile > legacy INI mode > built-in Balanced policy',
        'external_dependencies':['Bingus Shared Loader v18 / API 1'],
        'source_sha256':hashlib.sha256(source).hexdigest(),'archive_sha256':hashlib.sha256(archive).hexdigest(),
        'package_sha256':package_hash,
        'offline_tested':tested.get('offline_passed') is True and tested.get('source_sha256')==hashes,
        'live_standalone_validated':True,'live_validation_source':'user_reported_complete',
        'rc8_diagnostic_cleanup':{'removed':['startup_diagnostic.lua','RC8_DIAGNOSTIC.md','test_startup_diagnostic.lua',
            'phase/restore/toggle/avatar/hold diagnostic taps','lifecycle activation counters and diagnostic status',
            'native diagnostic sampling and mapping records'],
            'retained':['existing opt-in validation_trace.lua; disabled unless validation_logging=true']},
        'identity_observer_sha256':hashes['identity.lua'],'source_files':hashes,
        'embedded_core':False,'embedded_hd2runtime':False,'package':PACKAGE,
        'cadence':{'balanced_ceiling_rpm':380,'profiles':{title:{label:rpm for label,_,_,rpm in profiles}
            for _,title,profiles in OPTIONS},'input_attempts_are_not_shots':True},
        'artwork':'thumbnail.png','arsenal_option_groups':[{'name':title,'profiles':[{'label':label,'mode':profile,'rpm':rpm}
            for label,_,profile,rpm in profiles]} for _,title,profiles in OPTIONS]}
    (out/'build-report.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('Built unpublished Full Auto Assist '+VERSION+': '+PACKAGE+'; Shared Loader v18 / API 1 only.')
if __name__=='__main__':main()
