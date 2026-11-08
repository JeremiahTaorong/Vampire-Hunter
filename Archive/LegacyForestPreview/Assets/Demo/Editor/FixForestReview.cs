using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class FixForestReview {
 const string Scene="Assets/Demo/Scenes/PrologueForestAtmosphereReview.unity";
 static double started;
 public static void Build() {
  if(File.Exists(Scene)) throw new Exception("refuse overwrite");
  var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReview.unity");
  if(!EditorSceneManager.SaveScene(s,Scene,true)) throw new Exception("copy failed");
  s=EditorSceneManager.OpenScene(Scene);
  var root=GameObject.Find("Forest review - placed vegetation"); if(!root) throw new Exception("forest root absent");
  var rng=new System.Random(54321); var mat=AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/Atmosphere/ForestReviewVertex.mat");
  var treepaths=AssetDatabase.FindAssets("t:Prefab",new[]{"Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Trees"}).Select(AssetDatabase.GUIDToAssetPath).OrderBy(x=>x).ToArray();
  foreach(Transform t in root.transform) {
   if(t.name.StartsWith("Evergreen")||t.name.StartsWith("Dead")) ResizeTree(t.gameObject,7+(float)rng.NextDouble()*7);
   else { var rs=t.GetComponentsInChildren<Renderer>(); if(rs.Length>0 && rs[0].bounds.size.magnitude>6f) t.gameObject.SetActive(false); }
  }
  for(int i=0;i<180;i++) {
   float x=-3+(float)rng.NextDouble()*54, z=(rng.Next(2)==0?-1:1)*(5.2f+(float)rng.NextDouble()*20f);
   var p=AssetDatabase.LoadAssetAtPath<GameObject>(treepaths[rng.Next(treepaths.Length)]); var g=(GameObject)PrefabUtility.InstantiatePrefab(p); g.transform.SetParent(root.transform); g.transform.position=new Vector3(x,0,z); g.transform.rotation=Quaternion.Euler(0,(float)rng.NextDouble()*360,0);
   foreach(var r in g.GetComponentsInChildren<Renderer>()) r.sharedMaterials=Enumerable.Repeat(mat,r.sharedMaterials.Length).ToArray();
   foreach(var c in g.GetComponentsInChildren<Collider>()) UnityEngine.Object.DestroyImmediate(c); ResizeTree(g,7+(float)rng.NextDouble()*7);
  }
  var player=GameObject.Find("Player"); player.transform.position=new Vector3(20,1,0);
  var camera=GameObject.Find("Demo camera"); var follow=camera.GetComponent<DemoCamera>(); camera.transform.position=player.transform.position+follow.offset; camera.transform.LookAt(player.transform.position);
  EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets();
  Debug.Log("FOREST_V2_SAVED count="+root.transform.childCount+" player="+player.transform.position);
  EditorApplication.update += Begin; started=EditorApplication.timeSinceStartup;
 }
 static void ResizeTree(GameObject g,float target) { var rs=g.GetComponentsInChildren<Renderer>(); if(rs.Length==0) return; var b=rs[0].bounds; foreach(var r in rs.Skip(1)) b.Encapsulate(r.bounds); if(b.size.y>.01f) g.transform.localScale*=target/b.size.y; }
 public static void Audit(){ EditorSceneManager.OpenScene(Scene); var root=GameObject.Find("Forest review - placed vegetation"); foreach(Transform t in root.transform) { var rs=t.GetComponentsInChildren<Renderer>(); if(rs.Length==0) continue; var b=rs[0].bounds; foreach(var r in rs.Skip(1)) b.Encapsulate(r.bounds); if(b.Contains(new Vector3(20,11,-10)) || b.size.magnitude>30) Debug.Log("BIG_TREE "+t.name+" pos="+t.position+" size="+b.size+" scale="+t.localScale); } EditorApplication.Exit(0); }
 public static void BuildV6() { if(File.Exists(Scene)) throw new Exception("refuse overwrite"); var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReviewV5.unity"); EditorSceneManager.SaveScene(s,Scene,true); s=EditorSceneManager.OpenScene(Scene); var root=GameObject.Find("Forest review - placed vegetation"); foreach(Transform t in root.transform) if(t.name.StartsWith("Dead")) t.gameObject.SetActive(false); EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets(); Verify(); }
 public static void BuildV5() { if(File.Exists(Scene)) throw new Exception("refuse overwrite"); var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReviewV4.unity"); EditorSceneManager.SaveScene(s,Scene,true); s=EditorSceneManager.OpenScene(Scene); var root=GameObject.Find("Forest review - placed vegetation"); var sh=Shader.Find("VampireDemo/ForestFadeVertex"); if(!sh)throw new Exception("missing fade shader"); var mat=new Material(sh); mat.SetColor("_Tint",new Color(.34f,.40f,.38f,1)); AssetDatabase.CreateAsset(mat,"Assets/Demo/Atmosphere/ForestFadeVertex.mat"); foreach(Transform t in root.transform) { if(t.name=="Dead" || t.name=="Dead1") t.gameObject.SetActive(false); foreach(var r in t.GetComponentsInChildren<Renderer>(true)) r.sharedMaterials=Enumerable.Repeat(mat,r.sharedMaterials.Length).ToArray(); } var camera=GameObject.Find("Demo camera"); var fade=camera.AddComponent<ForestCameraFade>(); fade.target=GameObject.Find("Player").transform; fade.vegetationRoot=root.transform; EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets(); Verify(); }
 public static void BuildV4() { if(File.Exists(Scene)) throw new Exception("refuse overwrite"); var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReviewV3.unity"); EditorSceneManager.SaveScene(s,Scene,true); s=EditorSceneManager.OpenScene(Scene); var root=GameObject.Find("Forest review - placed vegetation"); foreach(Transform t in root.transform) { var rs=t.GetComponentsInChildren<Renderer>(); if(rs.Length==0) continue; var b=rs[0].bounds; foreach(var r in rs.Skip(1)) b.Encapsulate(r.bounds); var max=Mathf.Max(b.size.x,b.size.z); if(max>9) t.localScale*=9/max; } EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets(); Verify(); }
 public static void BuildV3() { if(File.Exists(Scene)) throw new Exception("refuse overwrite"); var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReviewV2.unity"); EditorSceneManager.SaveScene(s,Scene,true); s=EditorSceneManager.OpenScene(Scene); var root=GameObject.Find("Forest review - placed vegetation"); foreach(Transform t in root.transform) { if((t.name.StartsWith("Evergreen")||t.name.StartsWith("Dead")) && t.position.z < -5) { var p=t.position; p.z=-26-(Mathf.Abs(p.z)%5); t.position=p; } } EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets(); Verify(); }
 public static void Verify() { EditorSceneManager.OpenScene(Scene); EditorSettings.enterPlayModeOptionsEnabled=true; EditorSettings.enterPlayModeOptions=EnterPlayModeOptions.DisableDomainReload; EditorApplication.update += Begin; started=EditorApplication.timeSinceStartup; }
 static void Begin(){ if(EditorApplication.timeSinceStartup-started<1) return; EditorApplication.update-=Begin; EditorApplication.isPlaying=true; EditorApplication.update+=Capture; started=EditorApplication.timeSinceStartup; }
 static void Capture(){ if(!EditorApplication.isPlaying || EditorApplication.timeSinceStartup-started<5) return; EditorApplication.update-=Capture;
  try { var cam=Camera.main; var player=GameObject.Find("Player"); var root=GameObject.Find("Forest review - placed vegetation"); if(!cam||!player||!root) throw new Exception("missing runtime elements");
   var rt=new RenderTexture(1600,900,24); cam.targetTexture=rt; cam.Render(); RenderTexture.active=rt; var img=new Texture2D(1600,900,TextureFormat.RGB24,false); img.ReadPixels(new Rect(0,0,1600,900),0,0); img.Apply(); File.WriteAllBytes("ForestAtmosphereReview_Play.png",img.EncodeToPNG()); cam.targetTexture=null; RenderTexture.active=null;
   Debug.Log("FOREST_PLAY_CAPTURE player="+player.transform.position+" trees="+root.transform.childCount+" nav="+player.GetComponent<NavMeshAgent>().isOnNavMesh); EditorApplication.isPlaying=false; EditorApplication.Exit(0);
  } catch(Exception e){ Debug.LogException(e); EditorApplication.Exit(1); }
 }
}
