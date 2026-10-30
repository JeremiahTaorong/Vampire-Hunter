using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
public static class BuildVillageReview {
 public static void Run() {
  var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueCarriedDarkReview.unity");
  var root=new GameObject("Viking Village - Review");
  string[] names={"pf_build_small_house_01","pf_build_small_house_straw_roof_01","pf_build_small_house_tall_roof_01","pf_build_bighouse_01","pf_build_bighouse_02"};
  Vector3[] pos={new Vector3(-48,0,-18),new Vector3(-35,0,19),new Vector3(-23,0,-17),new Vector3(-54,0,16),new Vector3(-12,0,18)};
  for(int i=0;i<names.Length;i++){var prefab=AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Viking Village/Prefabs/Buildings/"+names[i]+".prefab"); if(!prefab) throw new System.Exception("Missing "+names[i]); var go=(GameObject)PrefabUtility.InstantiatePrefab(prefab); go.transform.SetParent(root.transform); go.transform.position=pos[i]; go.transform.rotation=Quaternion.Euler(0,i%2==0?0:180,0);}
  EditorSceneManager.SaveScene(scene,"Assets/Demo/Scenes/PrologueVillageReview.unity");
 }
}
