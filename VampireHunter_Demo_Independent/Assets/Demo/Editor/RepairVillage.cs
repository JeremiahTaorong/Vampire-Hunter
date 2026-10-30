using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using UnityEngine.Rendering;using UnityEngine.AI;
public static class RepairVillage {
 [MenuItem("Vampire Demo/Repair Village Layout")]
 public static void Run(){var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueDesignedVillageCorrected.unity");EditorSceneManager.SaveScene(s,"Assets/Demo/Scenes/PrologueVillagePlayableReview.unity",true);s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueVillagePlayableReview.unity");
 var root=GameObject.Find("Designed Village Review"); if(!root)throw new System.Exception("root missing");
 RenderSettings.ambientMode=AmbientMode.Flat;RenderSettings.ambientLight=new Color(.17f,.19f,.24f);RenderSettings.reflectionIntensity=.3f;
 var sun=new GameObject("Village soft moonlight");sun.transform.SetParent(root.transform);sun.transform.rotation=Quaternion.Euler(50,-35,0);var dl=sun.AddComponent<Light>();dl.type=LightType.Directional;dl.color=new Color(.47f,.56f,.75f);dl.intensity=.45f;dl.shadows=LightShadows.None;
 var vegetation=GameObject.Find("Forest review - placed vegetation");int hidden=0;if(vegetation)foreach(Transform t in vegetation.transform){if(!t.gameObject.activeSelf)continue;bool overlap=false;foreach(Transform b in root.transform){if(!b.name.StartsWith("B0")&&!b.name.StartsWith("B10"))continue;var rs=b.GetComponentsInChildren<Renderer>();if(rs.Length==0)continue;var bounds=rs[0].bounds;foreach(var r in rs)bounds.Encapsulate(r.bounds);var p=t.position;if(p.x>bounds.min.x-2 && p.x<bounds.max.x+2 && p.z>bounds.min.z-2 && p.z<bounds.max.z+2){overlap=true;break;}}if(overlap){t.gameObject.SetActive(false);hidden++;}}Debug.Log("VILLAGE overlap trees removed "+hidden);
 var old=GameObject.Find("Test Village House");if(old)old.SetActive(false);
 var player=GameObject.Find("Player");var agent=player.GetComponent<NavMeshAgent>();if(agent)agent.enabled=false;player.transform.position=new Vector3(-52,1,-3);if(agent)agent.enabled=true;
 var l=GameObject.Find("Carried Warm Light");if(l){var light=l.GetComponent<Light>();light.range=18;light.intensity=6;var fog=l.GetComponent<CarriedFogClear>();if(fog){fog.clearRadius=7;fog.fadeRadius=15;}}
 EditorSceneManager.MarkSceneDirty(s);EditorSceneManager.SaveScene(s);Debug.Log("VILLAGE_REPAIR_SAVED");}
}
