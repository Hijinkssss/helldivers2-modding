"""Bundle HD2ModCore into one plaintext Bingus Shared Loader resource.

This builder does not install the archive or claim any game validation.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src" / "hd2modcore"
BUILD = ROOT / "build"
MODULE = "mods/codex/hd2_mod_core"
ARCHIVE = "9ba626afa44a3aa3.patch_0"
PACKAGE = "HD2ModCore-v0.3.0-dev-Arsenal.zip"
PACKAGE_GUID = "4fe9d7b8-d25e-4ac2-82b5-d35190168c70"
LUA_TYPE = 0xA14E8DFA2CD117E2
MIX = 0xC6A4A7935BD1E995
MASK = (1 << 64) - 1


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


def bundle() -> bytes:
    sources = sorted(SRC.glob("*.lua"))
    if not sources or not any(path.name == "entry.lua" for path in sources):
        raise ValueError("framework sources missing")
    lines = [f"-- HD2-Addon: {MODULE}",
             "-- HD2ModCore v0.3.0-dev Developer Preview; generated from independent source modules.",
             "local factories, loaded = {}, {}",
             "local builtin_require = require",
             "local function local_require(name)",
             "  if name == 'ffi' then return builtin_require(name) end",
             "  if loaded[name] then return loaded[name] end",
             "  local factory = assert(factories[name], 'module unavailable: '..tostring(name))",
             "  local value = assert(factory(local_require), 'module returned nil: '..name)",
             "  loaded[name] = value",
             "  return value",
             "end"]
    for path in sources:
        raw = path.read_bytes()
        if raw.startswith(b"\xef\xbb\xbf") or b"\0" in raw or b"\r" in raw:
            raise ValueError(f"{path.name} must be LF UTF-8 without BOM/NUL")
        source = raw.decode("utf-8")
        name = f"hd2modcore.{path.stem}"
        lines += [f"factories[{name!r}] = function(require)", source, "end"]
    lines += [
        "local entry = local_require('hd2modcore.entry')",
        "local core, failure = entry.install(_G)",
        "if not core then error('HD2ModCore initialization failed: '..",
        "  tostring(failure and failure.error and failure.error.detail or failure), 0) end",
        "return core",
        "",
    ]
    result = "\n".join(lines).encode("utf-8")
    declaration = f"-- HD2-Addon: {MODULE}\n".encode()
    if not result.startswith(declaration) or len(declaration) > 256:
        raise ValueError("loader declaration invalid")
    return result


def archive_resource(source: bytes) -> bytes:
    payload = struct.pack("<II", len(source), 2) + source
    offset = (104 + 80 + 15) & ~15
    header = struct.pack("<III20sQQ24s", 0xF0000011, 1, 1,
                         b"", 0, 0, b"")
    type_row = struct.pack("<IIQIIII", 0, 0, LUA_TYPE, 1, 0, 16, 16)
    file_row = struct.pack("<7Q6I", resource_hash(MODULE), LUA_TYPE,
                           offset, 0, 0, 0, 0, len(payload), 0, 0,
                           16, 16, 0)
    body = bytearray(header + type_row + file_row)
    body.extend(b"\0" * (offset - len(body)))
    body.extend(payload)
    body.extend(b"\0" * (-len(body) % 16))
    struct.pack_into("<Q", body, 32, len(body))
    return bytes(body)


def verify_archive(data: bytes, source: bytes) -> None:
    magic, types, count = struct.unpack_from("<III", data, 0)
    if (magic, types, count) != (0xF0000011, 1, 1):
        raise ValueError("archive header mismatch")
    name_hash, kind, offset = struct.unpack_from("<QQQ", data, 104)
    if name_hash != resource_hash(MODULE) or kind != LUA_TYPE:
        raise ValueError("archive resource identity mismatch")
    size, flag = struct.unpack_from("<II", data, offset)
    if flag != 2 or size != len(source) or data[offset + 8:offset + 8 + size] != source:
        raise ValueError("archive Lua resource mismatch")


def zip_member(package, name, data):
    info=zipfile.ZipInfo(name, date_time=(1980,1,1,0,0,0))
    info.compress_type=zipfile.ZIP_DEFLATED
    info.external_attr=0o100644 << 16
    package.writestr(info,data)


def main() -> None:
    BUILD.mkdir(parents=True, exist_ok=True)
    source = bundle()
    archive = archive_resource(source)
    verify_archive(archive, source)
    (BUILD / "hd2modcore.lua").write_bytes(source)
    (BUILD / ARCHIVE).write_bytes(archive)
    for suffix in (".stream", ".gpu_resources"):
        (BUILD / (ARCHIVE + suffix)).write_bytes(b"")
    manifest = {
        "Version": 1,
        "Guid": PACKAGE_GUID,
        "Name": "HD2ModCore v0.3.0-dev Developer Preview (read-only diagnostic)",
        "Description": "Requires Bingus Shared Loader v18 / API 1. Developer Preview infrastructure and experimental read-only game-state observer.",
        "Options": [{
            "Name": "HD2ModCore v0.3.0-dev Developer Preview",
            "Description": "Shared lifecycle, config, logging, scheduler, events and guarded keyboard input",
            "Include": ["Addon"],
        }],
    }
    with zipfile.ZipFile(BUILD / PACKAGE, "w", compression=zipfile.ZIP_DEFLATED) as package:
        zip_member(package,"manifest.json", json.dumps(manifest, indent=2) + "\n")
        zip_member(package,"Addon/" + ARCHIVE, archive)
        for suffix in (".stream", ".gpu_resources"):
            zip_member(package,"Addon/" + ARCHIVE + suffix, b"")
    with zipfile.ZipFile(BUILD/PACKAGE, 'a') as release_zip:
        for document in ('README.md','LICENSE','THIRD_PARTY.md'):
            zip_member(release_zip,document,(ROOT/document).read_bytes())
    (BUILD/'SHA256SUMS.txt').write_text(hashlib.sha256((BUILD/PACKAGE).read_bytes()).hexdigest()+'  '+PACKAGE+'\n',encoding='utf-8')
    report = {
        "version": "0.3.0-dev",
        "module": MODULE,
        "archive": ARCHIVE,
        "arsenal_package": PACKAGE,
        "package_guid": PACKAGE_GUID,
        "resource_hash": hex(resource_hash(MODULE)),
        "source_sha256": hashlib.sha256(source).hexdigest().upper(),
        "archive_sha256": hashlib.sha256(archive).hexdigest().upper(),
        "package_sha256": hashlib.sha256((BUILD / PACKAGE).read_bytes()).hexdigest().upper(),
        "unit_tested": False,
        "loader_tested": False,
        "loader_discovery_tested": False,
        "isolated_bundle_tested": False,
        "consumer_order_fixture_tested": False,
        "windows_adapter_smoke_tested": False,
        "peer_ffi_order_tested": False,
        "in_game_tested": False,
        "gameplay_validated": False,
    }
    (BUILD / "build-report.json").write_text(
        json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"Built plaintext loader resource, {ARCHIVE} and Arsenal ZIP; no installation performed.")


if __name__ == "__main__":
    main()
