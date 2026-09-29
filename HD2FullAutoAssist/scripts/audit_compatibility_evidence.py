"""Bounded offline anchor inventory; never opens a process or authorizes FAA.

Optional input must be a module-RVA-indexed game.dll capture, not a disk PE.
Only four retained fixed windows are read. Matching them is NOT layout proof.
Uses the same profile as FAA rather than copying native constants into Python.
"""
from pathlib import Path
import argparse
import hashlib
import json
from lupa.luajit21 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]


def inventory(image=None, sample_build=None):
    lua = LuaRuntime(encoding=None, unpack_returned_tuples=True)
    lua.globals().package.path = (ROOT / 'src/?.lua').as_posix().encode()
    profile = lua.eval(b"require('compatibility').known_profile()")
    anchors = [(f'fire_{i}', profile[b'fire_anchors'][i]) for i in range(1, 4)]
    anchors.append(('text_registration', profile[b'text_anchor']))
    result = {
        'purpose': 'offline evidence inventory only',
        'runtime_authorized': False,
        'dynamic_compatibility_implemented': False,
        'profile_build': profile[b'build'].decode(),
        'sample_build_label': sample_build,
        'sample_provenance_verified': False,
        'input_format': 'module-RVA-indexed capture; caller must establish provenance',
        'anchor_source': 'HD2FullAutoAssist/src/compatibility.lua; inherited v1.0.0 checks',
        'historical_disassembly_build': '25327279 (validation/provenance.json)',
        'scan_performed': False,
        'anchors': [],
        'required_evidence': [
            'Current and second-build code windows with module identity and capture coverage',
            'Unique masked xrefs for all eight globals, plus semantic relationship checks',
            'Identity offset and ownership/back-reference equivalence on both samples',
            'Fire action lookup, bucket stride, record width, flags, trigger and timing field consumers',
            'UI text receiver, stack and game-state layout semantics',
            'Weapon resource policy semantics on the second build',
            'Negative fixtures for missing/ambiguous anchors and invalid layouts',
        ],
    }
    if image:
        image = Path(image)
        with image.open('rb') as stream:
            result['sample_sha256'] = hashlib.file_digest(stream, 'sha256').hexdigest()
        result['sample_size'] = image.stat().st_size
    for name, anchor in anchors:
        rva, expected = anchor[1], anchor[2]
        row = {'name': name, 'rva': hex(rva), 'length': len(expected),
               'pattern_hex': expected.hex(), 'mask': 'x' * len(expected),
               'role': 'fixed-location regression check, not a discovery signature',
               'expected_match_count': None,
               'ambiguity_check': 'not established; no scanning authorized',
               'target_conversion': 'known module base plus RVA only',
               'status': 'not_sampled'}
        if image:
            with image.open('rb') as stream:
                stream.seek(rva)
                actual = stream.read(len(expected))
            row['status'] = ('out_of_capture' if len(actual) != len(expected) else
                             'fixed_bytes_match' if actual == expected else 'fixed_bytes_differ')
        result['anchors'].append(row)
    result['globals'] = {name.decode(): hex(rva) for name, rva in profile[b'globals'].items()}
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path)
    parser.add_argument('--sample-build', help='Unverified caller-provided build label')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = inventory(args.image, args.sample_build)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    print('Wrote offline evidence inventory. This does not authorize unknown-build support.')


if __name__ == '__main__':
    main()
