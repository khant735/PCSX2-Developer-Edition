#!/usr/bin/env python3
"""Repackage the linked executable using the frozen Batch 25 Windows runtime."""
import pathlib
import sys
import zipfile

base = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
exe = base / "build/pcsx2-qt/pcsx2-qt.exe"
reference = pathlib.Path("/mnt/data/PCSX2_Developer_Windows_x64_Batch25_Compiled.zip")
if not reference.is_file():
    raise SystemExit("Missing frozen Batch 25 Windows runtime ZIP")
if not exe.is_file():
    raise SystemExit("Missing newly linked pcsx2-qt.exe")
out.parent.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(reference) as src, zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as dst:
    for item in src.infolist():
        if item.filename == "pcsx2-qt.exe":
            continue
        dst.writestr(item, src.read(item.filename))
    dst.write(exe, "pcsx2-qt.exe")
with zipfile.ZipFile(out) as archive:
    if archive.testzip() is not None:
        raise SystemExit("ZIP integrity verification failed")
print(f"Packaged {out} ({out.stat().st_size} bytes)")
