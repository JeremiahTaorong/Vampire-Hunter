using System;
using System.IO;
using System.Linq;
using System.Text;
using Newtonsoft.Json.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using Object=UnityEngine.Object;
public static class ImportMidnightGunslinger {
 const string Dir="Assets/Demo/Characters/MidnightGunslinger";
 const string Source=Dir+"/Source/model.glb";
 const string ScenePath="Assets/Demo/Scenes/MidnightGunslingerImportReview.unity";
 const string Evidence="Evidence/gunslinger-import-20261029";
 static JObject json;static byte[] bin;
 [MenuItem("Vampire Demo/Import Midnight Gunslinger Review")]
 public static void Run(){
  if(EditorApplication.isPlaying || EditorSceneManager.GetActiveScene().isDirty)throw new Exception("Stop play and save the current scene before importing");
  if(AssetDatabase.LoadAssetAtPath<GameObject>(Dir+"/MidnightGunslinger_StaticReview.prefab"))throw new Exception("Review already exists; preserve user edits");
  Directory.CreateDirectory(Dir+"/Textures");Directory.CreateDirectory(Evidence);AssetDatabase.Refresh();
  using(var reader=new BinaryReader(File.OpenRead(Source))){if(reader.ReadUInt32()!=0x46546C67||reader.ReadUInt32()!=2)throw new Exception("Expected GLB2");reader.ReadUInt32();int length=reader.ReadInt32();if(reader.ReadUInt32()!=0x4E4F534A)throw new Exception("Missing JSON chunk");json=JObject.Parse(Encoding.UTF8.GetString(reader.ReadBytes(length)));length=reader.ReadInt32();if(reader.ReadUInt32()!=0x004E4942)throw new Exception("Missing BIN chunk");bin=reader.ReadBytes(length);}
  // This importer deliberately accepts only this inspected static, uncompressed GLB.
  if(json["skins"]?.Any()==true || json["animations"]?.Any()==true)throw new Exception("Rigged source requires the rig-aware importer");
  var primitive=json["meshes"][0]["primitives"][0];if((int?)primitive["mode"]!=4)throw new Exception("Expected triangles");
  var positions=ReadFloats((int)primitive["attributes"]["POSITION"],3);var normals=ReadFloats((int)primitive["attributes"]["NORMAL"],3);var texcoords=ReadFloats((int)primitive["attributes"]["TEXCOORD_0"],2);int count=positions.Length/3;
  var vertices=new Vector3[count];var vertexNormals=new Vector3[count];var uv=new Vector2[count];
  for(int i=0;i<count;i++){vertices[i]=new Vector3(-positions[i*3],positions[i*3+1],positions[i*3+2]);vertexNormals[i]=new Vector3(-normals[i*3],normals[i*3+1],normals[i*3+2]);uv[i]=new Vector2(texcoords[i*2],1-texcoords[i*2+1]);}
  int accessor=(int)primitive["indices"];var indexInfo=json["accessors"][accessor];if((int)indexInfo["componentType"]!=5125)throw new Exception("Expected uint32 indices");int indexCount=(int)indexInfo["count"],offset=AccessorOffset(accessor);var triangles=new int[indexCount];for(int i=0;i<indexCount;i+=3){triangles[i]=(int)BitConverter.ToUInt32(bin,offset+i*4);triangles[i+1]=(int)BitConverter.ToUInt32(bin,offset+(i+2)*4);triangles[i+2]=(int)BitConverter.ToUInt32(bin,offset+(i+1)*4);}
  var mesh=new Mesh{name="Midnight Gunslinger Static Mesh",indexFormat=IndexFormat.UInt32};mesh.vertices=vertices;mesh.normals=vertexNormals;mesh.uv=uv;mesh.triangles=triangles;mesh.RecalculateBounds();mesh.RecalculateTangents();AssetDatabase.CreateAsset(mesh,Dir+"/GunslingerMesh.asset");
  var materialInfo=json["materials"][0];var pbr=materialInfo["pbrMetallicRoughness"];
  string basePath=ExtractTexture((int)pbr["baseColorTexture"]["index"],"BaseColor.jpg");string ormPath=ExtractTexture((int)pbr["metallicRoughnessTexture"]["index"],"MetallicRoughnessSource.jpg");string normalPath=ExtractTexture((int)materialInfo["normalTexture"]["index"],"Normal.jpg");
  ConfigureTexture(basePath,true,false,false);ConfigureTexture(ormPath,false,false,true);ConfigureTexture(normalPath,false,true,false);
  var orm=AssetDatabase.LoadAssetAtPath<Texture2D>(ormPath);var pixels=orm.GetPixels32();for(int i=0;i<pixels.Length;i++){var q=pixels[i];pixels[i]=new Color32(q.b,q.r,0,(byte)(255-q.g));}
  var mask=new Texture2D(orm.width,orm.height,TextureFormat.RGBA32,false,true);mask.SetPixels32(pixels);mask.Apply();string maskPath=Dir+"/Textures/MetallicOcclusionSmoothness.png";File.WriteAllBytes(maskPath,mask.EncodeToPNG());Object.DestroyImmediate(mask);AssetDatabase.ImportAsset(maskPath);ConfigureTexture(maskPath,false,false,false);
  var mat=new Material(Shader.Find("Universal Render Pipeline/Lit")){name="Midnight Gunslinger URP"};mat.SetTexture("_BaseMap",AssetDatabase.LoadAssetAtPath<Texture2D>(basePath));mat.SetColor("_BaseColor",Color.white);mat.SetTexture("_BumpMap",AssetDatabase.LoadAssetAtPath<Texture2D>(normalPath));mat.EnableKeyword("_NORMALMAP");mat.SetFloat("_BumpScale",1);mat.SetTexture("_MetallicGlossMap",AssetDatabase.LoadAssetAtPath<Texture2D>(maskPath));mat.EnableKeyword("_METALLICSPECGLOSSMAP");mat.SetFloat("_Smoothness",1);mat.SetTexture("_OcclusionMap",AssetDatabase.LoadAssetAtPath<Texture2D>(maskPath));mat.EnableKeyword("_OCCLUSIONMAP");mat.SetFloat("_OcclusionStrength",1);mat.SetFloat("_Cull",0);mat.doubleSidedGI=true;AssetDatabase.CreateAsset(mat,Dir+"/GunslingerURP.mat");
  var root=new GameObject("Midnight Gunslinger - Static Review");var visual=new GameObject("Visual - unrigged source");visual.transform.SetParent(root.transform,false);visual.AddComponent<MeshFilter>().sharedMesh=mesh;visual.AddComponent<MeshRenderer>().sharedMaterial=mat;
  float scale=1.9f/mesh.bounds.size.y;visual.transform.localScale=Vector3.one*scale;visual.transform.localPosition=Vector3.up*(-mesh.bounds.min.y*scale);
  PrefabUtility.SaveAsPrefabAsset(root,Dir+"/MidnightGunslinger_StaticReview.prefab");Object.DestroyImmediate(root);
  var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single);RenderSettings.fog=false;RenderSettings.skybox=null;RenderSettings.ambientMode=AmbientMode.Flat;RenderSettings.ambientLight=new Color(.42f,.45f,.5f);
  var floor=GameObject.CreatePrimitive(PrimitiveType.Plane);floor.name="Preview floor";floor.transform.localScale=Vector3.one*1.2f;var floorMat=new Material(Shader.Find("Universal Render Pipeline/Lit")){name="Preview Floor"};floorMat.color=new Color(.16f,.18f,.21f);AssetDatabase.CreateAsset(floorMat,Dir+"/PreviewFloor.mat");floor.GetComponent<Renderer>().sharedMaterial=floorMat;
  var character=(GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>(Dir+"/MidnightGunslinger_StaticReview.prefab"));
  var reference=GameObject.CreatePrimitive(PrimitiveType.Capsule);reference.name="1.8 m height reference";reference.transform.position=new Vector3(1.25f,.9f,0);reference.transform.localScale=new Vector3(.4f,.9f,.4f);reference.GetComponent<Renderer>().sharedMaterial=floorMat;
  var key=new GameObject("Preview key").AddComponent<Light>();key.type=LightType.Directional;key.intensity=1.5f;key.transform.rotation=Quaternion.Euler(35,-30,0);key.shadows=LightShadows.Soft;
  var fill=new GameObject("Preview fill").AddComponent<Light>();fill.type=LightType.Directional;fill.intensity=.65f;fill.color=new Color(.68f,.8f,1);fill.transform.rotation=Quaternion.Euler(25,135,0);
  var camera=new GameObject("Review camera").AddComponent<Camera>();camera.tag="MainCamera";camera.fieldOfView=38;camera.clearFlags=CameraClearFlags.SolidColor;camera.backgroundColor=new Color(.055f,.065f,.085f);camera.GetUniversalAdditionalCameraData().renderPostProcessing=false;camera.allowMSAA=false;camera.nearClipPlane=.05f;
  camera.transform.position=new Vector3(2.6f,1.55f,4.6f);camera.transform.LookAt(new Vector3(.35f,1,0));EditorSceneManager.SaveScene(scene,ScenePath);AssetDatabase.SaveAssets();
  CreateForestFinalReview.Render(camera,Evidence+"/front.png",1100,900,1);camera.transform.position=new Vector3(-2.2f,1.5f,-4.6f);camera.transform.LookAt(new Vector3(0,1,0));CreateForestFinalReview.Render(camera,Evidence+"/back.png",1100,900,1);
  string report="Unity="+Application.unityVersion+"\nsource="+Source+"\nvertices="+count+"\ntriangles="+indexCount/3+"\nsource-height="+mesh.bounds.size.y+"\nreview-height=1.9m (includes hat)\nskins=0\nJOINTS_0=absent\nWEIGHTS_0=absent\nanimations=0\nrig-status=Static mesh, cannot build valid Humanoid avatar or retarget actions\nAnimator/action controller=not fabricated\nmaterial=URP Lit, embedded textures, metallic=B, occlusion=R, smoothness=1-G\nNo changes to settlement scene or player. No runtime movement/combat/animation test executed.\n";
  File.WriteAllText(Evidence+"/import-audit.txt",report);Debug.Log("GUNSLINGER_STATIC_IMPORT_DONE vertices="+count+" triangles="+indexCount/3+" rig=absent");
 }
 static int AccessorOffset(int index){var a=json["accessors"][index];var v=json["bufferViews"][(int)a["bufferView"]];return ((int?)v["byteOffset"]??0)+((int?)a["byteOffset"]??0);}
 static float[] ReadFloats(int index,int dimensions){var a=json["accessors"][index];if((int)a["componentType"]!=5126)throw new Exception("Expected f32 accessor");int count=(int)a["count"],start=AccessorOffset(index),stride=(int?)json["bufferViews"][(int)a["bufferView"]]["byteStride"]??dimensions*4;var data=new float[count*dimensions];for(int i=0;i<count;i++)for(int j=0;j<dimensions;j++)data[i*dimensions+j]=BitConverter.ToSingle(bin,start+i*stride+j*4);return data;}
 static string ExtractTexture(int index,string name){int image=(int)json["textures"][index]["source"];var view=json["bufferViews"][(int)json["images"][image]["bufferView"]];string path=Dir+"/Textures/"+name;int offset=(int?)view["byteOffset"]??0,length=(int)view["byteLength"];var bytes=new byte[length];Array.Copy(bin,offset,bytes,0,length);File.WriteAllBytes(path,bytes);AssetDatabase.ImportAsset(path);return path;}
 static void ConfigureTexture(string path,bool srgb,bool normal,bool readable){var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=normal?TextureImporterType.NormalMap:TextureImporterType.Default;importer.sRGBTexture=srgb;importer.isReadable=readable;importer.maxTextureSize=4096;importer.textureCompression=TextureImporterCompression.Uncompressed;if(normal)importer.flipGreenChannel=true;importer.SaveAndReimport();}
}
