from pathlib import Path
import struct,json,zipfile,hashlib,datetime
root=Path('/Users/dorimiah/Desktop/Vampire');p=root/'VampireHunter_Demo_Independent';source=p/'Assets/Demo/Characters/MidnightGunslinger/Source/model.glb';raw=source.read_bytes();length=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+length]);start=20+length;blen,tag=struct.unpack_from('<II',raw,start);binary=memoryview(raw)[start+8:start+8+blen]
stamp=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y%m%d-%H%M%S');work=root/'CharacterRiggingWork'/('Hunter_'+stamp);work.mkdir(parents=True);(Path('/private/tmp/hunter-rigging/work.txt')).write_text(str(work))
backup=work/'OriginalBackup';backup.mkdir();(backup/'model.glb').write_bytes(raw)
protected={}
for path in [source,p/'Assets/Demo/Scenes/PrologueSettlement.unity',p/'Assets/Demo/Scenes/MidnightGunslingerImportReview.unity',p/'Assets/Demo/Characters/MidnightGunslinger/GunslingerURP.mat']:
 protected[str(path)]=hashlib.sha256(path.read_bytes()).hexdigest()
(work/'protected-hashes.json').write_text(json.dumps(protected,indent=2))
folder=work/'MixamoUpload';folder.mkdir()
def accessor(i,components):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];offset=v.get('byteOffset',0)+a.get('byteOffset',0);fmt={5126:'f',5125:'I'}[a['componentType']];stride=v.get('byteStride',4*components)
 for j in range(a['count']):yield struct.unpack_from('<'+fmt*components,binary,offset+j*stride)
primitive=g['meshes'][0]['primitives'][0];at=primitive['attributes']
with (folder/'Hunter_Upload.obj').open('w') as f:
 f.write('# Original full-resolution hunter, independent Mixamo upload copy\n# Units: centimeters; height 190cm; original topology preserved\nmtllib Hunter_Upload.mtl\no Hunter\n')
 for x,y,z in accessor(at['POSITION'],3):f.write('v %.7g %.7g %.7g\n'%(x*95,(y+1)*95,z*95))
 for u,v in accessor(at['TEXCOORD_0'],2):f.write('vt %.8g %.8g\n'%(u,1-v))
 for x,y,z in accessor(at['NORMAL'],3):f.write('vn %.8g %.8g %.8g\n'%(x,y,z))
 f.write('usemtl Hunter\ns 1\n');it=iter(accessor(primitive['indices'],1))
 for a in it:
  b=next(it)[0]+1;c=next(it)[0]+1;a=a[0]+1;f.write(f'f {a}/{a}/{a} {b}/{b}/{b} {c}/{c}/{c}\n')
mat=g['materials'][0];texture_indices={'BaseColor.jpg':mat['pbrMetallicRoughness']['baseColorTexture']['index'],'Normal.jpg':mat['normalTexture']['index'],'MetallicRoughness.jpg':mat['pbrMetallicRoughness']['metallicRoughnessTexture']['index']}
for name,index in texture_indices.items():
 image=g['images'][g['textures'][index]['source']];view=g['bufferViews'][image['bufferView']];offset=view.get('byteOffset',0);(folder/name).write_bytes(binary[offset:offset+view['byteLength']])
(folder/'Hunter_Upload.mtl').write_text('newmtl Hunter\nKa 0.2 0.2 0.2\nKd 1 1 1\nKs 0.1 0.1 0.1\nNs 16\nd 1\nillum 2\nmap_Kd BaseColor.jpg\nmap_Bump Normal.jpg\n')
with zipfile.ZipFile(work/'Hunter_MixamoUpload.zip','w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for file in folder.iterdir():z.write(file,file.name)
(work/'preparation.json').write_text(json.dumps({'original_vertex_count':397113,'original_triangle_count':687137,'skins':0,'upload':'ZIP containing OBJ+MTL+original textures','height_cm':190,'decimation':False,'original_pose_retained':True,'blender_required':False},indent=2))
print('Work folder:',work);print('ZIP bytes:',(work/'Hunter_MixamoUpload.zip').stat().st_size)
