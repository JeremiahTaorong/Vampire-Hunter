#!/usr/bin/env python3
"""Reassemble private Release attachment parts; validate every SHA-256."""
from pathlib import Path
import argparse,hashlib,json,sys
root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser();p.add_argument('--parts-folder',type=Path,default=Path.home()/'Downloads');p.add_argument('--verify-only',action='store_true');p.add_argument('--output',type=Path);args=p.parse_args()
m=json.loads((root/'OptionalPackages/DungeonEnvironment.manifest.json').read_text())
dest=args.output or root/'Assets'/m['source_name']
def sha(path):
 h=hashlib.sha256()
 with path.open('rb') as f:
  for b in iter(lambda:f.read(4*1024*1024),b''):h.update(b)
 return h.hexdigest()
if dest.exists() and not args.verify_only:
 if dest.stat().st_size==m['source_bytes'] and sha(dest)==m['source_sha256']:
  print('Package already restored and SHA-256 verified:',dest);sys.exit(0)
 sys.exit('Output exists with different content; select a different --output path.')
whole=hashlib.sha256();out=None;partial=dest.with_name(dest.name+'.partial')
try:
 if not args.verify_only:
  dest.parent.mkdir(parents=True,exist_ok=True);out=partial.open('xb')
 for row in m['parts']:
  part=args.parts_folder/row['name']
  if not part.is_file() or part.stat().st_size!=row['bytes']:raise RuntimeError('Missing/wrong-size part: '+str(part))
  h=hashlib.sha256()
  with part.open('rb') as stream:
   for b in iter(lambda:stream.read(4*1024*1024),b''):
    h.update(b);whole.update(b)
    if out:out.write(b)
  if h.hexdigest()!=row['sha256']:raise RuntimeError('SHA-256 mismatch: '+row['name'])
 if whole.hexdigest()!=m['source_sha256']:raise RuntimeError('Combined package SHA-256 mismatch')
 if out:out.close();out=None;partial.rename(dest)
 print('PASS: all parts and the combined original package SHA-256 match.')
 if not args.verify_only:print('Restored:',dest)
except Exception as exc:
 if out:out.close()
 print(str(exc),file=sys.stderr);sys.exit(1)
