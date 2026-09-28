"""Exercise the independent template against the actual Core facade, no game."""
from pathlib import Path
import argparse, sys

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--runtime-path', type=Path)
args = parser.parse_args()
if args.runtime_path:
    sys.path.insert(0, str(args.runtime_path.resolve()))
from lupa.luajit21 import LuaRuntime

def host(config):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().package.path = (ROOT/'src/?.lua').as_posix()+';'+lua.globals().package.path
    lua.execute('''
        now, down, prior, lines = 0, false, 0, {}
        local platform={clock_us=function() return now end,
            module_hash=function() return string.rep('0',64) end,
            module_address=function() return 0x10000000 end,
            query_region=function() return nil end, read=function() return nil end,
            prepare_input=function() return true end,
            input_focused=function() return true end,
            input_down=function() return down end}
        local loader={api=1,open_log=function() return {
            write=function(self,text) lines[#lines+1]=text; return self end,
            flush=function() return true end,close=function() return true end} end}
        update=function() prior=prior+1 end; shutdown=function() end
        core=assert(require('hd2modcore.entry').install(_G,
            {platform=platform,loader=loader,config_text=''}))
        function tick(ms,key) now=ms*1000; down=key; update(.016) end
    ''')
    lua.globals().app = lua.execute((ROOT/'template/HD2ModTemplate/src/template.lua').read_text())
    lua.globals().config = config
    return lua

lua = host('')
lua.execute("consumer=app.install(core,function() return config end); tick(0,false); tick(200,true)")
assert not any('event=eligible_hotkey' in lua.globals().lines[i] for i in range(1,len(lua.globals().lines)+1))
lua.execute('''
    core.Input.ShortcutEligibility=function() return {ok=true,value={allowed=false}} end
    tick(400,false); tick(600,true)
''')
assert not any('event=eligible_hotkey' in lua.globals().lines[i] for i in range(1,len(lua.globals().lines)+1))
lua.execute('''
    core.Input.ShortcutEligibility=function() return {ok=true,value={allowed=true}} end
    tick(800,false); tick(1000,true); tick(1200,true)
''')
lines = [lua.globals().lines[i] for i in range(1,len(lua.globals().lines)+1)]
assert sum('event=eligible_hotkey' in s for s in lines)==1
assert any('event=heartbeat_changed' in s for s in lines)
lua.execute('assert(consumer.stop().ok); tick(1400,false); tick(1600,true); shutdown()')
for service in ('input','scheduler','events'):
    assert lua.eval(f'core.Diagnostics:Status().{service}.active')==0
assert lua.eval('core:State()')=='stopped'

for config in ('enabled=false','enabled=invalid','hotkey=invalid'):
    lua=host(config)
    result=lua.eval('function() return pcall(app.install,core,function() return config end) end')()
    assert result[0] == (config=='enabled=false')
    lua.execute('shutdown()')
    for service in ('input','scheduler','events'):
        assert lua.eval(f'core.Diagnostics:Status().{service}.active')==0
print('Template real-facade config, events, scheduler, input, eligibility refusal and cleanup: PASS')
