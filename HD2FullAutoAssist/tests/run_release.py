from pathlib import Path
import importlib.util,hashlib,json,zipfile,subprocess
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
D=ROOT
spec=importlib.util.spec_from_file_location('b',ROOT/'scripts/build.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
source=b.bundle()
lua=LuaRuntime(unpack_returned_tuples=True)
assert lua.eval('loadstring')(source.decode()) is not None
for p in (ROOT/'src').glob('*.lua'):assert lua.eval('loadstring')(p.read_text()) is not None
lua.globals().package.path=f'{(ROOT/"src").as_posix()}/?.lua;{(D/"tests").as_posix()}/?.lua;'+lua.globals().package.path
for test in ['test_mod_options_runtime.lua','test_full_menu_runtime.lua']:
    vm=LuaRuntime(unpack_returned_tuples=True);vm.globals().package.path=lua.globals().package.path
    vm.execute((D/'tests'/test).read_text());print('PASS '+test)
policy=lua.execute("return require('weapon_policy').new('balanced')")
roster=json.loads((ROOT/'docs/supported-weapons-1.2.0.json').read_text())
assert len(roster)==31
for row in roster:
    result=policy.classify(policy,row['hash']);assert result.allowed and result.max_repeat_rpm==row['balanced_rpm']
for ident in ('96de9cd50f7306e6','fb3a19078694708a','aa69a60d74a3ec54','30061f91af477f5e','6cfcc7f8801a0266','ffffffffffffffff'):
    assert not policy.classify(policy,ident).allowed
print('PASS all 31 supported defaults and unsupported exclusions')
sys_tail="return own_require('lifecycle').start(_G)"
# Use the verified Candidate D test host against the shipped release bundle.
import sys
sys.path.insert(0,str(D/'tests'));import run_standalone
legacy_lua_at=run_standalone.lua_at
def release_lua_at(path):
    vm=legacy_lua_at(path)
    vm.globals().package.path=(ROOT/'tests').as_posix()+'/?.lua;'+vm.globals().package.path
    return vm
run_standalone.lua_at=release_lua_at
host=run_standalone.host(ROOT/'src',True)
host.globals().app=host.execute(source.decode().replace(sys_tail,"return own_require('full_auto_assist')"))
host.execute((D/'tests/test_full_menu_controller.lua').read_text())
print('PASS packaged controller, all profiles, toggles and restoration')
for test in ('test_full_menu_native.lua','test_native_transitions.lua','test_restore_ownership.lua','test_page_scope.lua','test_hud_anchor.lua'):
    run_standalone.native_transition_checks(test)
b.main()
package=ROOT/'build/1.2.0'/b.PACKAGE
with zipfile.ZipFile(package) as z:
    assert z.testzip() is None
    names=z.namelist();assert len(names)==11
    assert not any('..' in Path(n).parts or n.startswith('/') for n in names)
    assert not any(any(s in n.lower() for s in ('private','profile-use','live_test','evidence','backup','candidate')) for n in names)
    b.verify_archive(z.read('Core/'+b.ARCHIVE),source)
    manifest=json.loads(z.read('manifest.json'));assert manifest['Guid']=='cf368f5c-f686-453f-a566-435b4b7fcf26' and len(manifest['Options'])==1
    assert source.startswith(b'-- HD2-Addon: mods/codex/hd2_full_auto_assist')
    assert b'force_performance_profile=true' not in source and b"factories['charge_" not in source
    ini=z.read('HD2FullAutoAssist.example.ini')
    for key in ('performance_profile','validation_logging','hud_diagnostics','debug_logging'):assert (key+' = false').encode() in ini
digest=hashlib.sha256(package.read_bytes()).hexdigest();b.main()
assert hashlib.sha256((ROOT/'build/1.2.0'/b.PACKAGE).read_bytes()).hexdigest()==digest
print('PASS ZIP integrity, declaration, GUID, public defaults, exact D bytes and deterministic rebuild')
