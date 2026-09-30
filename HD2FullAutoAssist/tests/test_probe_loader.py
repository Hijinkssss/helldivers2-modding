"""Exercise the real Shared Loader logging API in a filesystem/Windows fixture."""
from pathlib import Path
import argparse, hashlib, json
from run_b3 import runtime
ROOT=Path(__file__).resolve().parents[1]
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--loader-source',type=Path,required=True)
    args=parser.parse_args();source=args.loader_source.read_text(encoding='utf-8')
    # Execute the unmodified actual logging implementation, excluding unrelated loader startup.
    prefix=source.split('local jit_cache',1)[0]
    assert 'function state.open_log(name)' in prefix and 'local jit_cache' in source
    lua=runtime(ROOT/'src');lua.globals().loader_prefix=prefix
    lua.execute('''
        local dirs,opens=0,{}
        local fake={}
        fake._G=fake;fake.rawget=rawget;fake.rawset=rawset;fake.type=type;fake.pcall=pcall;fake.ipairs=ipairs
        fake.os={getenv=function(name)assert(name=='LOCALAPPDATA');return 'fixture-appdata'end}
        fake.require=function(name)
            assert(name=='ffi')
            return {cdef=function()end,load=function(name)
                assert(name=='kernel32');return {CreateDirectoryA=function()dirs=dirs+1;return 1 end}
            end}
        end
        local file={write=function(self)return self end,flush=function()return true end,close=function()return true end}
        fake.io={open=function(path,mode)assert(mode=='w');opens[#opens+1]=path;return file end}
        assert(setfenv(assert(loadstring(loader_prefix)),fake))()
        local loader=fake.CowboyBingusModLoader
        assert(loader.open_log('HD2FullAutoAssist-charge-research.jsonl')==nil and dirs==0 and #opens==0)
        local Research=require('charge_research')
        assert(loader.open_log(Research.filename)==file and dirs==3 and #opens==1)
        assert(opens[1]=='fixture-appdata/CowboyBingus/Helldivers2/Logs/'..Research.filename)
        loader.open_log('HD2FullAutoAssist.log');assert(dirs==3 and #opens==2)
        fake.io.open=function()return nil,'access denied'end
        assert(loader.open_log(Research.filename)==nil)
    ''')
    result={'passed':True,'actual_loader_log_source_sha256':hashlib.sha256(args.loader_source.read_bytes()).hexdigest(),
        'old_jsonl_rejected_before_filesystem':True,'corrected_log_accepted':True,
        'one_time_directory_initialization':True,'path_matches_probe_filename':True,
        'filesystem_failure_nonfatal':True,'game_process_accessed':False}
    (ROOT/'build/probe-loader-checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS actual Shared Loader logging API: rejected old filename, corrected file/path, one-time setup and I/O failure')
if __name__=='__main__':main()
