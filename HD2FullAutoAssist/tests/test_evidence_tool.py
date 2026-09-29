"""No live process: test the bounded inventory with sparse synthetic captures."""
import importlib.util
from pathlib import Path
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('evidence', ROOT / 'scripts/audit_compatibility_evidence.py')
evidence = importlib.util.module_from_spec(spec)
spec.loader.exec_module(evidence)


def main():
    inventory = evidence.inventory()
    assert not inventory['runtime_authorized'] and not inventory['scan_performed']
    assert len(inventory['anchors']) == 4 and len(inventory['globals']) == 8
    with tempfile.TemporaryDirectory() as tmp:
        image = Path(tmp) / 'synthetic-rva-image.bin'
        with image.open('wb') as stream:
            for anchor in inventory['anchors']:
                stream.seek(int(anchor['rva'], 16))
                stream.write(bytes.fromhex(anchor['pattern_hex']))
        matching = evidence.inventory(image, 'synthetic-unknown')
        assert all(a['status'] == 'fixed_bytes_match' for a in matching['anchors'])
        assert not matching['runtime_authorized'] and not matching['sample_provenance_verified']
        with image.open('r+b') as stream:
            stream.seek(int(inventory['anchors'][0]['rva'], 16))
            stream.write(b'\0')
        changed = evidence.inventory(image)
        assert changed['anchors'][0]['status'] == 'fixed_bytes_differ'
        image.write_bytes(b'MZ')
        assert all(a['status'] == 'out_of_capture' for a in evidence.inventory(image)['anchors'])
    print('PASS: bounded evidence inventory: matching, changed and truncated samples never authorize runtime')


if __name__ == '__main__':
    main()
