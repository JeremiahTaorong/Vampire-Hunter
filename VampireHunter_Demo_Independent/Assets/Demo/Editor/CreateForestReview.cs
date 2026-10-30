using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class CreateForestReview {
 const string Base="Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/";
 const string Scene="Assets/Demo/Scenes/PrologueForestReview.unity";
 public static void Build() {
  if (File.Exists(Scene)) throw new Exception("Refusing to overwrite existing review scene");
  var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueSoftFog.unity");
  if (!EditorSceneManager.SaveScene(s,Scene,true)) throw new Exception("Scene copy failed");
  s=EditorSceneManager.OpenScene(Scene);
  var shader=Shader.Find("VampireDemo/ForestPreviewVertex"); if (!shader) throw new Exception("missing shader");
  var mat=new Material(shader); mat.SetColor("_Tint",new Color(.34f,.40f,.38f,1));
  AssetDatabase.CreateAsset(mat,"Assets/Demo/Atmosphere/ForestReviewVertex.mat");
  var root=new GameObject("Forest review - placed vegetation");
  var rng=new System.Random(7621);
  var trees=AssetDatabase.FindAssets("t:Prefab",new[]{Base+"Trees"}).Select(AssetDatabase.GUIDToAssetPath).OrderBy(x=>x).ToArray();
  var bushes=AssetDatabase.FindAssets("t:Prefab",new[]{Base+"Bushes"}).Select(AssetDatabase.GUIDToAssetPath).OrderBy(x=>x).ToArray();
  var ground=AssetDatabase.FindAssets("t:Prefab",new[]{Base+"GroundCover"}).Select(AssetDatabase.GUIDToAssetPath).OrderBy(x=>x).ToArray();
  if(trees.Length==0||bushes.Length==0||ground.Length==0) throw new Exception("prefabs missing");
  for(int i=0;i<90;i++) {float x=1+(float)rng.NextDouble()*43; float z=(rng.Next(2)==0?-1:1)*(6+(float)rng.NextDouble()*20); Place(trees[rng.Next(trees.Length)],root.transform,x,z,.8f+(float)rng.NextDouble()*.75f,mat,rng);}
  for(int i=0;i<85;i++) {float x=1+(float)rng.NextDouble()*43; float z=(rng.Next(2)==0?-1:1)*(4.5f+(float)rng.NextDouble()*18); Place(bushes[rng.Next(bushes.Length)],root.transform,x,z,.7f+(float)rng.NextDouble()*.6f,mat,rng);}
  for(int i=0;i<110;i++) {float x=1+(float)rng.NextDouble()*43; float z=(rng.Next(2)==0?-1:1)*(4.4f+(float)rng.NextDouble()*18); Place(ground[rng.Next(ground.Length)],root.transform,x,z,.7f+(float)rng.NextDouble()*.7f,mat,rng);}
  foreach(var n in new[]{"Forest tree marker A","Forest tree marker B","Forest tree marker C","Forest tree marker D","Forest tree marker E"}) {var g=GameObject.Find(n); if(g) g.SetActive(false);}
  EditorSceneManager.SaveScene(s); AssetDatabase.SaveAssets();
  var cam=GameObject.Find("Demo camera").GetComponent<Camera>(); var player=GameObject.Find("Player");
  var oldPos=player.transform.position; var oldCam=cam.transform.position; var oldRot=cam.transform.rotation;
  player.transform.position=new Vector3(20,1,0); cam.transform.position=new Vector3(20,15,-15); cam.transform.LookAt(new Vector3(20,0,0));
  var rt=new RenderTexture(1600,900,24); cam.targetTexture=rt; cam.Render(); RenderTexture.active=rt;
  var img=new Texture2D(1600,900,TextureFormat.RGB24,false); img.ReadPixels(new Rect(0,0,1600,900),0,0); img.Apply(); File.WriteAllBytes("ForestReview.png",img.EncodeToPNG());
  cam.targetTexture=null; RenderTexture.active=null; UnityEngine.Object.DestroyImmediate(rt); UnityEngine.Object.DestroyImmediate(img);
  player.transform.position=oldPos; cam.transform.position=oldCam; cam.transform.rotation=oldRot;
  Debug.Log("FOREST_REVIEW_CREATED trees="+trees.Length+" bushes="+bushes.Length+" ground="+ground.Length);
 }
 static void Place(string path,Transform root,float x,float z,float scale,Material mat,System.Random rng) {
  var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path); var go=(GameObject)PrefabUtility.InstantiatePrefab(prefab); go.transform.SetParent(root); go.transform.position=new Vector3(x,0,z); go.transform.rotation=Quaternion.Euler(0,(float)rng.NextDouble()*360,0); go.transform.localScale*=scale;
  foreach(var r in go.GetComponentsInChildren<Renderer>()) r.sharedMaterials=Enumerable.Repeat(mat,r.sharedMaterials.Length).ToArray();
  foreach(var c in go.GetComponentsInChildren<Collider>()) UnityEngine.Object.DestroyImmediate(c);
 }
}
