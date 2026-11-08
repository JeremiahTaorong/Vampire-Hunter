using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
public static class ForestAtmosphereReview {
 public static void Build(){const string dst="Assets/Demo/Scenes/PrologueForestAtmosphereReview.unity";if(File.Exists(dst))throw new Exception("scene exists");var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestDetailReview.unity");EditorSceneManager.SaveScene(s,dst,true);s=EditorSceneManager.OpenScene(dst);
 var shader=Shader.Find("VampireDemo/ForestAtmosphereReview");if(!shader)throw new Exception("missing shader");var mat=new Material(shader);AssetDatabase.CreateAsset(mat,"Assets/Demo/Atmosphere/ForestAtmosphereReview.mat");var root=GameObject.Find("Forest review - placed vegetation");foreach(var r in root.GetComponentsInChildren<Renderer>(true))r.sharedMaterials=Enumerable.Repeat(mat,r.sharedMaterials.Length).ToArray();
 RenderSettings.fog=true;RenderSettings.fogMode=FogMode.Linear;RenderSettings.fogColor=new Color(.025f,.032f,.037f);RenderSettings.fogStartDistance=9;RenderSettings.fogEndDistance=50;RenderSettings.ambientLight=new Color(.11f,.13f,.14f);
 var cam=GameObject.Find("Demo camera").GetComponent<Camera>();cam.backgroundColor=RenderSettings.fogColor;
 var sun=GameObject.Find("Directional Light").GetComponent<Light>();sun.color=new Color(.63f,.72f,.79f);sun.intensity=.45f;
 var fill=GameObject.Find("Hunter visibility fill").GetComponent<Light>();fill.intensity=1.0f;fill.range=8;
 string[] names={"Near ground fog","Mid-height drifting fog","Upper sparse fog"};float[] alpha={.13f,.11f,.07f};for(int i=0;i<names.Length;i++){var go=GameObject.Find(names[i]);if(!go)continue;var old=go.GetComponent<Renderer>().sharedMaterial;var fog=new Material(old);fog.SetColor("_FogColor",new Color(.42f,.50f,.52f,alpha[i]));AssetDatabase.CreateAsset(fog,"Assets/Demo/Atmosphere/ForestReviewFog"+i+".mat");go.GetComponent<Renderer>().sharedMaterial=fog;}
 var light=new GameObject("Forest moon rim review").AddComponent<Light>();light.type=LightType.Point;light.transform.position=new Vector3(20,6,7);light.color=new Color(.48f,.65f,.74f);light.intensity=1.8f;light.range=22;light.shadows=LightShadows.None;
 EditorSceneManager.SaveScene(s);AssetDatabase.SaveAssets();EditorApplication.Exit(0); }
}
