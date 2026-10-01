"""Build unpublished next-version candidates. Never changes release artifacts."""
from pathlib import Path
import argparse,hashlib,json,struct,subprocess,zipfile
ROOT=Path(__file__).resolve().parents[1]
MODULE='mods/codex/hd2_full_auto_assist'
ARCHIVE='9ba626afa44a3aa3.patch_0'
VERSION='1.1.0-final-rc'
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



def bundle(module: str = MODULE, research: bool = False):
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
    options=',{charge_research=true}' if research else ''
    lines += [f"return own_require('lifecycle').start(_G{options})",'']
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
    ('commando_profile','MLS-4X Commando',[
        ('Balanced','Slower assisted cadence with time between rockets.','balanced',120),
        ('Full Auto',"Uses the Commando's native fire-rate ceiling.",'full_auto',240)]),
    ('hyena_profile','R-4 Hyena',[
        ('Balanced','Slower assisted cadence intended to give the weapon time to settle between shots.','balanced',120),
        ('Full Auto',"Uses the Hyena's native fire-rate ceiling.",'full_auto',190)]),
    ('bushwhacker_profile','SG-22 Bushwhacker',[
        ('Balanced','Deliberate slow cadence that avoids dumping the entire load immediately while Fire is held.','balanced',90),
        ('Full Auto',"Uses the Bushwhacker's native fire-rate ceiling.",'full_auto',650)]),
    ('eruptor_profile','R-36 Eruptor',[
        ('Balanced / default','Default assisted cadence.','balanced_28',28),
        ('Slower Cadence','Deliberately slower assisted cadence.','slower_27',27),
        ('Maximum / native-speed cadence',"Retains the Eruptor's maximum native cadence.",'max_32',32)]),
]

def option_module(setting: str, profile: str) -> str:
    return f'mods/codex/hd2_full_auto_assist_option_{setting}_{profile}'

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--research',action='store_true');args=parser.parse_args()
    package_name=PACKAGE.replace('-Arsenal.zip','-Charge-Research-Arsenal.zip') if args.research else PACKAGE
    out=OUTPUT/'charge-research' if args.research else OUTPUT
    source=bundle(research=args.research);archive=archive_resource(source);verify_archive(archive,source)
    option_archives={}
    for setting,_,profiles in OPTIONS:
        for _,_,profile,_ in profiles:
            module=option_module(setting,profile)
            content=option_bundle(module,setting,profile)
            packed=archive_resource(content,module);verify_archive(packed,content,module)
            option_archives[(setting,profile)]=packed
    out.mkdir(parents=True,exist_ok=True)
    (out/'hd2_full_auto_assist.lua').write_bytes(source);(out/ARCHIVE).write_bytes(archive)
    description=('Read-only RC4 charge and independent left-mouse probe: 40-K Meltagun only. Charge automation remains disabled.'
        if args.research else 'Full Auto Assist 1.1.0 Final RC for live validation: 31 supported weapons, finalized HUD indicator, and Eruptor Cadence Control. Five charge Special weapons remain intentionally unsupported.')
    groups=[{'Name':'Full Auto Assist','Description':'Required. The assistance feature and its supported-weapon policy.',
        'Include':['Core'],'Image':'thumbnail.png'}]
    files={'thumbnail.png':(ROOT/'thumbnail.png').read_bytes(),
        'Core/'+ARCHIVE:archive,'Core/'+ARCHIVE+'.stream':b'','Core/'+ARCHIVE+'.gpu_resources':b''}
    for setting,title,profiles in OPTIONS:
        children=[]
        for label,help_text,profile,rpm in profiles:
            folder=f'Options/{setting.removesuffix("_profile")}/{profile}'
            children.append({'Name':(f'{rpm} RPM - {label}' if setting=='eruptor_profile' else f'{label} ({rpm} RPM)'),'Description':help_text,'Include':[folder]})
            packed=option_archives[(setting,profile)]
            files[folder+'/'+ARCHIVE]=packed
            files[folder+'/'+ARCHIVE+'.stream']=b''
            files[folder+'/'+ARCHIVE+'.gpu_resources']=b''
        groups.append({'Name':title,'Description':'Select one assisted fire-rate profile. '+('Balanced 28 RPM is the default.' if setting=='eruptor_profile' else 'Balanced is the default.'),
            'SubOptions':children})
    files['manifest.json']=(json.dumps({'Version':1,'Guid':'cf368f5c-f686-453f-a566-435b4b7fcf26',
        'Name':'Full Auto Assist RC4 Meltagun Probe' if args.research else 'Full Auto Assist',
        'Description':description,'Options':groups},indent=2)+'\n').encode()
    for name in ('HD2FullAutoAssist.example.ini',):
        files[name]=(ROOT/name).read_bytes()
    files['README.md']=((ROOT/'docs/RC4_CHARGE_PROBE.md') if args.research else (ROOT/'README.md')).read_bytes()
    files['LIVE_TEST.md']=(ROOT/'docs'/('RC4_LIVE_TEST.md' if args.research else 'RELEASE_1.1.0_LIVE_REVIEW.md')).read_bytes()
    if args.research:
        files['CHARGE_REASSESSMENT.md']=(ROOT/'docs/CHARGE_REASSESSMENT.md').read_bytes()
    else:
        files['CHANGELOG.md']=(ROOT/'CHANGELOG.md').read_bytes()
        files['RELEASE_NOTES.md']=(ROOT/'docs/RELEASE_1.1.0.md').read_bytes()
        files['SUPPORTED_WEAPONS.md']=(ROOT/'docs/SUPPORTED_WEAPONS_1.1.0.md').read_bytes()
    with zipfile.ZipFile(out/package_name,'w',zipfile.ZIP_DEFLATED) as z:
        for name,raw in sorted(files.items()):
            info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED
            info.external_attr=0o100644<<16;z.writestr(info,raw)
    package_hash=hashlib.sha256((out/package_name).read_bytes()).hexdigest()
    (out/(package_name+'.sha256')).write_text(f'{package_hash}  {package_name}\n',encoding='ascii')
    checks=ROOT/'build'/'standalone-checks.json'
    hashes={f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted((ROOT/'src').glob('*.lua'))}
    tested=json.loads(checks.read_text()) if checks.exists() else {}
    b3_path=ROOT/'build/b3-checks.json'
    b3=json.loads(b3_path.read_text()) if b3_path.exists() else {}
    b3_passed=bool(b3.get('passed')) and b3.get('source_sha256')==hashes
    next_path=ROOT/'build/next-version-checks.json'
    next_checks=json.loads(next_path.read_text()) if next_path.exists() else {}
    next_passed=next_checks.get('passed') is True and next_checks.get('source_sha256')==hashes
    report={'version':VERSION,'target_release_version':'1.1.0','supported_weapon_count':31,'charge_factories_packaged':args.research,'supported_build':'25480438','name':'Full Auto Assist',
        'description':description,'configuration_precedence':'Arsenal selected profile > explicit per-weapon INI profile > legacy INI mode > built-in Balanced policy',
        'external_dependencies':['Bingus Shared Loader v18 / API 1'],
        'source_sha256':hashlib.sha256(source).hexdigest(),'archive_sha256':hashlib.sha256(archive).hexdigest(),
        'package_sha256':package_hash,
        'offline_tested':tested.get('offline_passed') is True and tested.get('source_sha256')==hashes and b3_passed and next_passed,
        'next_version_regressions_and_evidence_gates_passed':next_passed,
        'b3_regressions_and_work_budgets_passed':b3_passed,
        'live_standalone_validated':False,'live_validation_source':None,
        'release_status':'Final RC prepared for live validation; publication gates remain open',
        'final_private_rc_ready':False,
        'remaining_release_gates':['live HUD validation','live Eruptor 27/28/32 RPM and recovery validation','representative live-mission sustained FAA/HUD processing below 5 ms/s'],
        'eruptor_native_behavior':'native hold-to-repeat; OFF repetition is expected',
        'hud_visual_implementation_unchanged':True,
        'source_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT.parent,text=True).strip(),
        'validated_base_commit':'9fb95cee02d097d5b3a3475cfa28585e32b651be',
        'live_validation_scope':'Eruptor OFF concern closed by user vanilla test; HUD approved by user on RC3; new HUD read optimization has offline verification only',
        'charge_research_enabled':args.research,'charge_automation_enabled':False,
        'charge_probe_filename':'HD2FullAutoAssist-charge-probe.log' if args.research else None,
        'charge_probe_sampling':'each relevant stock update, capped at 6000 samples' if args.research else None,
        'charge_probe_targets':{'6cfcc7f8801a0266':'40-K Meltagun'} if args.research else None,
        'hud_diagnostics_default':False,'hud_diagnostics_record_cap':120,'hud_force_visible_default':False,
        'profiling_default':False,'validation_logging_default':False,'debug_logging_default':False,
        'baseline_commit':'be04ea15359b505bf953ef22d747e8f5e2de013e',
        'rc8_diagnostic_cleanup':{'removed':['startup_diagnostic.lua','RC8_DIAGNOSTIC.md','test_startup_diagnostic.lua',
            'phase/restore/toggle/avatar/hold diagnostic taps','lifecycle activation counters and diagnostic status',
            'native diagnostic sampling and mapping records'],
            'retained':['existing opt-in validation_trace.lua; disabled unless validation_logging=true']},
        'identity_observer_sha256':hashes['identity.lua'],'source_files':hashes,
        'embedded_core':False,'embedded_hd2runtime':False,'package':package_name,
        'cadence':{'balanced_ceiling_rpm':380,'profiles':{title:{label:rpm for label,_,_,rpm in profiles}
            for _,title,profiles in OPTIONS},'input_attempts_are_not_shots':True},
        'artwork':'thumbnail.png','arsenal_option_groups':[{'name':title,'profiles':[{'label':label,'mode':profile,'rpm':rpm}
            for label,_,profile,rpm in profiles]} for _,title,profiles in OPTIONS]}
    (out/'build-report.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print('Built Full Auto Assist '+VERSION+': '+package_name+'; Shared Loader v18 / API 1 only.')
if __name__=='__main__':main()
