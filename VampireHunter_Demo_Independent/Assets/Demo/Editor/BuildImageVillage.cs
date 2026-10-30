using UnityEngine; using UnityEditor; using UnityEditor.SceneManagement; using System;
public static class BuildImageVillage {
 static Vector3 P(float x,float z,float y=0){return new Vector3(x-60,y,z-32);}
 [MenuItem("Vampire Demo/Build Image Village Review")]
 public static void Run(){
 var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueCarriedDarkReview.unity");
 if(!EditorSceneManager.SaveScene(s,"Assets/Demo/Scenes/PrologueVillageImageReview.unity",true))throw new Exception("Copy failed"); s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueVillageImageReview.unity");
 var root=new GameObject("Designed Village Review");
 foreach(string n in new[]{"Village house A","Village house B","Village house C","Village square well marker","Forest entrance north","Forest entrance south"}){var o=GameObject.Find(n);if(o)o.SetActive(false);}
 var vegetation=GameObject.Find("Forest review - placed vegetation"); if(vegetation){int removed=0;foreach(Transform t in vegetation.transform){var q=t.position;float x=q.x+60,z=q.z+32;if((x>48 && x<67 && z>25 && z<39)||(x>84 && x<103 && z>32 && z<49)){t.gameObject.SetActive(false);removed++;}}Debug.Log("VILLAGE vegetation hidden "+removed);}
 string[] files={"House_1","Inn","House_2","House_4","House_3","Blacksmith","Bell_Tower","Mill","Stable","Viking/pf_build_bighouse_01","Viking/pf_build_small_house_01","Viking/pf_build_small_house_straw_roof_01"};
 float[,] xy={{20,18},{40,32},{28,34},{32,42},{52,18},{44,14},{28,12},{16,50},{48,50},{72,44},{72,28},{86,28}};
 for(int i=0;i<files.Length;i++){string path=files[i].StartsWith("Viking/")?"Assets/Viking Village/Prefabs/Buildings/"+files[i].Substring(7)+".prefab":"Assets/Demo/ThirdParty/VillageBuildings/FBX/"+files[i]+".fbx";var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path);if(!prefab)throw new Exception("Missing "+path);var go=(GameObject)PrefabUtility.InstantiatePrefab(prefab);go.name="B"+(i+1).ToString("00")+"_"+files[i].Replace("Viking/","");go.transform.SetParent(root.transform);go.transform.position=P(xy[i,0],xy[i,1]);go.transform.rotation=Quaternion.Euler(0,0,0)*prefab.transform.rotation;var rs=go.GetComponentsInChildren<Renderer>(); if(rs.Length>0){Bounds b=rs[0].bounds;foreach(var r in rs)b.Encapsulate(r.bounds);float[] target={9,12,9,7,8,9,4,8,11,12,8,8}; float factor=target[i]/Mathf.Max(b.size.x,b.size.z);go.transform.localScale*=factor; b=rs[0].bounds;foreach(var r in rs)b.Encapsulate(r.bounds);go.transform.position+=new Vector3(P(xy[i,0],xy[i,1]).x-b.center.x,-b.min.y,P(xy[i,0],xy[i,1]).z-b.center.z);Debug.Log("VILLAGE B"+(i+1)+" adjusted "+b);}}
 var player=GameObject.Find("Player");if(player){var agent=player.GetComponent<UnityEngine.AI.NavMeshAgent>();if(agent)agent.enabled=false;player.transform.position=P(8,29,1);if(agent)agent.enabled=true;}
 var carried=GameObject.Find("Carried Warm Light");if(carried){var l=carried.GetComponent<Light>();l.range=16;l.intensity=5;var f=carried.GetComponent<CarriedFogClear>();if(f){f.clearRadius=5;f.fadeRadius=12;}}
 float[,] lamps={{23,35},{43,47},{63,48},{81,41},{38,21}};for(int i=0;i<5;i++){var o=new GameObject("Village lamp "+(i+1));o.transform.SetParent(root.transform);o.transform.position=P(lamps[i,0],lamps[i,1],2.5f);var l=o.AddComponent<Light>();l.type=LightType.Point;l.range=7;l.intensity=i==2?1.2f:3;l.color=new Color(1,.58f,.23f);if(i==1||i==3||i==4){l.enabled=false;var sw=o.AddComponent<VillageLampSwitch>();sw.lamp=l;sw.reach=2.5f;}}
 EditorSceneManager.MarkSceneDirty(s);EditorSceneManager.SaveScene(s);Debug.Log("DESIGNED_VILLAGE_SAVED"); }
}
