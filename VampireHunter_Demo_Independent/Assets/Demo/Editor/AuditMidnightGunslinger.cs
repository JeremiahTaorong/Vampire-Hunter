using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Object=UnityEngine.Object;
public static class AuditMidnightGunslinger {
 public static void Run(){
  const string dir="Assets/Demo/Characters/MidnightGunslinger";
  var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(dir+"/MidnightGunslinger_StaticReview.prefab");if(!prefab)throw new Exception("Prefab missing");
  var mesh=prefab.GetComponentInChildren<MeshFilter>().sharedMesh;var renderer=prefab.GetComponentInChildren<MeshRenderer>();var mat=renderer.sharedMaterial;
  if(mesh.vertexCount!=397113 || mesh.triangles.Length/3!=687137)throw new Exception("Mesh count differs from source");
  if(ShaderUtil.ShaderHasError(mat.shader)||!mat.GetTexture("_BaseMap")||!mat.GetTexture("_BumpMap")||!mat.GetTexture("_MetallicGlossMap"))throw new Exception("Material incomplete");
  if(prefab.GetComponentsInChildren<SkinnedMeshRenderer>(true).Length!=0 || prefab.GetComponentsInChildren<Animator>(true).Length!=0)throw new Exception("Unexpected rig or animator");
  EditorSceneManager.OpenScene("Assets/Demo/Scenes/MidnightGunslingerImportReview.unity");
  var subject=Object.FindObjectsOfType<MeshFilter>().First(x=>x.sharedMesh==mesh).GetComponent<Renderer>();if(Mathf.Abs(subject.bounds.size.y-1.9f)>.001f || Mathf.Abs(subject.bounds.min.y)>.001f)throw new Exception("Scale/grounding failed");
  File.WriteAllText("Evidence/gunslinger-import-20261029/reload-check.txt","PASS prefab and mesh survive reload\nPASS 397113 vertices / 687137 triangles\nPASS shader compiles and textures assigned\nPASS height=1.9m (hat included), feet at y=0\nCONFIRMED no rig/skin/Animator; no action retargeting performed\n");Debug.Log("GUNSLINGER_RELOAD_AUDIT_PASS");
 }
}
