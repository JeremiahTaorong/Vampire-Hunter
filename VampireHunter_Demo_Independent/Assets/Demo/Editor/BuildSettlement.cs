using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
public static class BuildSettlement {
 public static void Run(){
 var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueCarriedDarkReview.unity");
 var player=GameObject.Find("Player"); if(!player) throw new System.Exception("Player missing");
 var carried=GameObject.Find("Carried Warm Light"); if(!carried) throw new System.Exception("Carried light missing");
 var light=carried.GetComponent<Light>(); light.range=16; light.intensity=5;
 var clear=carried.GetComponent<CarriedFogClear>(); clear.clearRadius=5; clear.fadeRadius=12;
 var root=new GameObject("Settlement Review"); var p=player.transform.position; Debug.Log("SETTLEMENT PLAYER "+p);
 string[] names={"pf_build_small_house_01","pf_build_small_house_straw_roof_01","pf_build_small_house_tall_roof_01","pf_build_bighouse_01","pf_build_bighouse_02"};
 Vector3[] offsets={new Vector3(-9,0,-10),new Vector3(2,0,-13),new Vector3(12,0,-10),new Vector3(-10,0,12),new Vector3(11,0,12)};
 for(int i=0;i<names.Length;i++){
 var prefab=AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Viking Village/Prefabs/Buildings/"+names[i]+".prefab"); if(!prefab) throw new System.Exception("Missing "+names[i]);
 var go=(GameObject)PrefabUtility.InstantiatePrefab(prefab); go.transform.SetParent(root.transform); go.transform.position=new Vector3(p.x+offsets[i].x,0,p.z+offsets[i].z); go.transform.rotation=Quaternion.Euler(0,i<3?0:180,0);
 var rs=go.GetComponentsInChildren<Renderer>(); Bounds b=new Bounds(go.transform.position,Vector3.zero); foreach(var r in rs)b.Encapsulate(r.bounds); Debug.Log("HOUSE "+names[i]+" bounds "+b);
 if(i<3){var lamp=new GameObject("House lantern "+(i+1));lamp.transform.SetParent(root.transform);lamp.transform.position=new Vector3(go.transform.position.x,2.5f,go.transform.position.z+(i<3?4:-4)); var l=lamp.AddComponent<Light>();l.type=LightType.Point;l.range=10;l.intensity=3;l.color=new Color(1,.6f,.25f);l.enabled=true; var sw=lamp.AddComponent<VillageLampSwitch>();sw.lamp=l;}
 }
 if(!EditorSceneManager.SaveScene(s,"Assets/Demo/Scenes/PrologueSettlementReview.unity")) throw new System.Exception("Save failed");
 }
}
