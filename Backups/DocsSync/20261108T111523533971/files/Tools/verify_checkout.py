#!/usr/bin/env python3
"""Verify the byte-preserving Git/LFS transfer manifest (Python stdlib only)."""
import hashlib,json,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
manifest=json.loads((root/'TransferManifest.json').read_text(encoding='utf-8'))
errors=[]
for row in manifest['files']:
    path=root/row['path']
    if not path.is_file():
        errors.append(f"MISSING {row['path']}");continue
    if path.stat().st_size!=row['bytes']:
        errors.append(f"SIZE {row['path']} (run git lfs pull if this is a pointer)");continue
    digest=hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda:f.read(1024*1024),b''):digest.update(chunk)
    if digest.hexdigest()!=row['sha256']:errors.append(f"HASH {row['path']}")
if errors:
    print('\n'.join(errors[:40]));print(f'FAIL {len(errors)} files');sys.exit(1)
print(f"PASS {len(manifest['files'])} files, sizes and SHA-256 match the transfer manifest.")
print('File restoration only; not a Unity or Windows gameplay test.')
