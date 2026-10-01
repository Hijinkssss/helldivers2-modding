"""Exercise the actual ZIP's bundled factories with its diagnostics-off INI."""
from pathlib import Path
import hashlib,importlib.util,json,zipfile
from lupa.luajit21 import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('faa_builder',ROOT/'scripts/build.py')
builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
package=builder.OUTPUT/builder.PACKAGE
source=(builder.OUTPUT/'hd2_full_auto_assist.lua').read_bytes()
assert source==builder.bundle()
entry="return own_require('lifecycle').start(_G)"
assert source.decode().count(entry)==1
lua=LuaRuntime(unpack_returned_tuples=True)
lua.globals().package.path=(ROOT/'tests').as_posix()+'/?.lua;'+lua.globals().package.path
lua.globals().bundled_require=lua.execute(source.decode().replace(entry,'return own_require'))
lua.execute('''
for _,name in ipairs({'lifecycle','native_fire','full_auto_assist'})do
    package.preload[name]=function()return bundled_require(name)end
end
bundled_require('performance_profile').new=function()error('Profiler must stay OFF')end
bundled_require('validation_trace').new=function()error('Trace must stay OFF')end
''')
with zipfile.ZipFile(package) as z:
    lua.globals().delivered_config=z.read('HD2FullAutoAssist.example.ini').decode()
lua.execute('''
local f=require('native_transition_fixture').new(delivered_config)
for _,hash in ipairs({'b6aff2195568767f','416d053372c4e433','1a437158e1b8d2a1','d323de60855898ac'})do
    f:fire(false);f:tick();f:weapon(hash);f:tick();f:fire(true);f:tick()
    f:healthy();assert(f.backend.lease and f.consumer:get_state().weapon.resource_hash==hash)
    for _=1,10 do f:tick(5000);assert(f.backend.lease)end
    assert(f.host.profiler==nil and f.physical_samples==0)
    f:fire(false);f:tick();assert(f:restored())
end
assert(f.consumer:stop().ok)
for _,line in ipairs(f.logs)do
    assert(not line:find('"event":"hold_started"',1,true))
    assert(not line:find('"event":"held_identity_changed"',1,true))
end
''')
lua=LuaRuntime(unpack_returned_tuples=True)
lua.globals().package.path=(ROOT/'tests').as_posix()+'/?.lua;'+lua.globals().package.path
lua.globals().bundled_require=lua.execute(source.decode().replace(entry,'return own_require'))
for name in ('lifecycle','native_fire','full_auto_assist','hud_anchor','hud_indicator','validation_trace','assist_state','weapon_policy','performance_profile'):
    lua.globals().package.preload[name]=lua.eval('function(name)return function()return bundled_require(name)end end')(name)
for name in ('test_hud_anchor.lua','test_off_native.lua','test_restore_ownership.lua','test_fire_audit.lua','test_off_trace.lua','test_behavior_roles.lua','test_hud_work_budget.lua'):
    lua.execute((ROOT/'tests'/name).read_text())
result={'packaged_hud_off_ownership_audit_and_trace_tests_passed':True,'actual_delivered_bundle_exercised':True,'delivered_ini_used':True,
    'profiling_off':True,'validation_logging_off':True,'debug_logging_off':True,
    'forbidden_profiler_and_trace_constructors_not_called':True,
    'Eruptor_Talon_Verdict_Cookout_native_leases_and_exact_restoration':True,
    'live_gameplay_validated':False,'live_performance_validated':False,
    'package_sha256':hashlib.sha256(package.read_bytes()).hexdigest()}
(builder.OUTPUT/'delivery-checks.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
