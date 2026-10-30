from pathlib import Path
import struct,json,math,zipfile
w=Path(Path('/private/tmp/hunter-rigging/work.txt').read_text());raw=(w/'OriginalBackup/model.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+n]);start=28+n;data=memoryview(raw)[start:];a=g['accessors'][0];v=g['bufferViews'][a['bufferView']];offset=v.get('byteOffset',0);positions=[struct.unpack_from('<fff',data,offset+i*12) for i in range(a['count'])]
size=.012
cells={};sums=[];mapping=[]
for x,y,z in positions:
 key=(round(x/size),round(y/size),round(z/size))
 if key not in cells:cells[key]=len(sums);sums.append([0.,0.,0.,0])
 idx=cells[key];s=sums[idx];s[0]+=x;s[1]+=y;s[2]+=z;s[3]+=1;mapping.append(idx)
proxy=[(s[0]/s[3],s[1]/s[3],s[2]/s[3]) for s in sums];prim=g['meshes'][0]['primitives'][0];a=g['accessors'][prim['indices']];v=g['bufferViews'][a['bufferView']];off=v.get('byteOffset',0)+a.get('byteOffset',0);faces=[];seen=set()
for i in range(0,a['count'],3):
 tri=tuple(mapping[j] for j in struct.unpack_from('<III',data,off+i*4))
 if len(set(tri))!=3:continue
 key=tuple(sorted(tri))
 if key in seen:continue
 seen.add(key);faces.append(tri)
folder=w/'ProxyUpload';folder.mkdir(exist_ok=True)
with (folder/'Hunter_Proxy.obj').open('w') as f:
 f.write('# Rig solving proxy only. Original high-resolution model preserved separately.\nmtllib Hunter_Proxy.mtl\no Hunter_Proxy\n')
 for x,y,z in proxy:f.write('v %.7g %.7g %.7g\n'%(x*95,(y+1)*95,z*95))
 # Encode proxy vertex ID in UV for reliable full-resolution weight transfer after FBX reindexing.
 for idx in range(len(proxy)):f.write('vt %.10g 0.5\n'%((idx+.5)/len(proxy)))
 f.write('usemtl RigProxy\ns 1\n')
 for tri in faces:f.write('f '+' '.join(f'{i+1}/{i+1}' for i in tri)+'\n')
(folder/'Hunter_Proxy.mtl').write_text('newmtl RigProxy\nKd 0.55 0.58 0.62\nKa 0.1 0.1 0.1\nKs 0 0 0\nd 1\nillum 2\n')
with zipfile.ZipFile(w/'Hunter_ProxyUpload.zip','w',zipfile.ZIP_DEFLATED) as z:
 for file in folder.iterdir():z.write(file,file.name)
with (w/'full-to-proxy.bin').open('wb') as f:
 f.write(struct.pack('<I',len(mapping)));f.write(struct.pack('<'+'I'*len(mapping),*mapping))
with (w/'proxy-source.bin').open('wb') as f:
 f.write(struct.pack('<II',len(proxy),len(faces)));f.write(struct.pack('<'+'f'*len(proxy)*3,*(q for v in proxy for q in v)));f.write(struct.pack('<'+'I'*len(faces)*3,*(q for tri in faces for q in tri)))
(w/'proxy-preparation.json').write_text(json.dumps({'vertices':len(proxy),'triangles':len(faces),'voxel_source_units':size,'full_model_retained':True,'UV_contains_vertex_ids':True,'purpose':'rig solver only; not final visual model'},indent=2))
print('proxy vertices',len(proxy),'triangles',len(faces),'ZIP bytes',(w/'Hunter_ProxyUpload.zip').stat().st_size)
