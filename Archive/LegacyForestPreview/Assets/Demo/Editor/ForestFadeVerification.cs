using System;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
public static class ForestFadeVerification {
 static double stamp; static int stage; static Transform tree; static Renderer renderer; static float faded;
 public static void Run(){ EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestAtmosphereReview.unity"); EditorSettings.enterPlayModeOptionsEnabled=true; EditorSettings.enterPlayModeOptions=EnterPlayModeOptions.DisableDomainReload; EditorApplication.isPlaying=true; stamp=EditorApplication.timeSinceStartup; stage=0; EditorApplication.update+=Tick; }
 static void Tick(){ if(!EditorApplication.isPlaying || EditorApplication.timeSinceStartup-stamp<2)return; try { var cam=Camera.main; var player=GameObject.Find("Player"); var root=GameObject.Find("Forest review - placed vegetation"); if(stage==0){ foreach(Transform t in root.transform) if(t.gameObject.activeInHierarchy && t.name.StartsWith("Evergreen") && t.GetComponentInChildren<Renderer>()){tree=t;break;} if(!tree)throw new Exception("no tree"); renderer=tree.GetComponentInChildren<Renderer>(); tree.position=(cam.transform.position+player.transform.position)*.5f; stamp=EditorApplication.timeSinceStartup;stage=1;return; } var props=new MaterialPropertyBlock(); renderer.GetPropertyBlock(props); float v=props.GetFloat("_Visibility"); if(stage==1){ faded=v; tree.position=new Vector3(200,0,200); stamp=EditorApplication.timeSinceStartup;stage=2;return; } Debug.Log("FOREST_FADE_TEST faded="+faded+" restored="+v); EditorApplication.update-=Tick; EditorApplication.Exit(faded<.3f && v>.95f?0:1); } catch(Exception e){Debug.LogException(e);EditorApplication.Exit(1);} }
}
