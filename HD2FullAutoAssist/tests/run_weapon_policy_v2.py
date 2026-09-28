"""
Offline test runner for weapon_policy v2 classification and fire-rate mode tests.
Requires lupa (LuaJIT) on PYTHONPATH; never accesses game memory.

Usage:
    py -m pytest tests/run_weapon_policy_v2.py       # auto-discover
    py tests/run_weapon_policy_v2.py                 # direct run

If lupa is not installed the tests are skipped automatically.
"""
import sys
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE_SRC = ROOT.parent / 'HD2ModCore' / 'src'

try:
    from lupa.luajit21 import LuaRuntime
    LUPA_AVAILABLE = True
except ImportError:
    LUPA_AVAILABLE = False

# ── Helpers ──────────────────────────────────────────────────────────────────

def make_lua():
    """Return a LuaRuntime with src/ and HD2ModCore/src on the package path."""
    if not LUPA_AVAILABLE:
        raise RuntimeError('lupa not installed')
    lua = LuaRuntime(unpack_returned_tuples=True)
    paths = [
        (ROOT / 'src' / '?.lua').as_posix(),
        (ROOT / 'tests' / '?.lua').as_posix(),
        (CORE_SRC / '?.lua').as_posix() if CORE_SRC.exists() else None,
        lua.globals().package.path,
    ]
    lua.globals().package.path = ';'.join(p for p in paths if p)
    # Load policy_host fixture so policy_fixture() is available globally.
    lua.execute((ROOT / 'tests' / 'policy_host.lua').read_text(encoding='utf-8'))
    return lua


def run_lua_test(test_name: str) -> dict:
    """Load and execute a Lua test file; return a result dict."""
    lua = make_lua()
    src = ROOT / 'tests' / (test_name + '.lua')
    try:
        lua.execute(src.read_text(encoding='utf-8'))
        return {'name': test_name, 'passed': True}
    except Exception as exc:
        return {'name': test_name, 'passed': False, 'error': str(exc)}


# ── Test cases ───────────────────────────────────────────────────────────────

TESTS = [
    'test_weapon_policy_v2',
]


def main() -> int:
    if not LUPA_AVAILABLE:
        print('SKIP: lupa not installed – install lupa to run offline Lua tests')
        return 0

    results = []
    all_passed = True
    for name in TESTS:
        result = run_lua_test(name)
        results.append(result)
        if result['passed']:
            print(f'PASS  {name}')
        else:
            all_passed = False
            print(f'FAIL  {name}')
            print(f'      {result.get("error", "(no detail)")}')

    print()
    passed = sum(1 for r in results if r['passed'])
    print(f'Results: {passed}/{len(results)} passed')

    # Write JSON summary next to this script for CI consumption.
    out = ROOT / 'tests' / 'weapon_policy_v2_results.json'
    out.write_text(json.dumps(results, indent=2) + '\n', encoding='utf-8')
    print(f'Written: {out}')

    return 0 if all_passed else 1


if __name__ == '__main__':
    sys.exit(main())


# ── pytest integration (optional) ────────────────────────────────────────────

def pytest_collect_file(parent, file_path):
    """Collected by pytest if this file is in the test directory."""
    pass  # nothing extra; pytest finds test_ functions below.


def test_weapon_policy_v2():
    if not LUPA_AVAILABLE:
        import pytest
        pytest.skip('lupa not installed')
    result = run_lua_test('test_weapon_policy_v2')
    assert result['passed'], result.get('error', 'unknown error')
