using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;using System.Linq;
[InitializeOnLoad]public static class HunterArmorRevision{
 static HunterArmorRevision(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-armor-revision.txt"))return;var r=Object.FindObjectOfType<HunterReview>();if(!r)return;
 var chosen=new[]{"Body_Base","Body_Hands","Robe","Steel_cuiras_2","Steel_Collar_2","Steel_Sholder_plate_1(left)","Steel_Sholder_plate_1(right)","Steel_pauldron_1(left)","Steel_pauldron_1(right)","Steel_bracer_1(left)","Steel_bracer_1(right)","Lether_pants","Steel_legs_protection(left)","Steel_legs_protection(right)","Steel_kneecap(left)","Steel_kneecap(right)","Steel_boot(left)","Steel_boot(right)","Lether_wide_belt","Hood_Cloth_1","Cape_3"};
 foreach(var mesh in r.GetComponentsInChildren<SkinnedMeshRenderer>(true)){
 mesh.gameObject.SetActive(chosen.Contains(mesh.name));if(!mesh.gameObject.activeSelf)continue;
 bool steel=mesh.name.StartsWith("Steel");bool cloth=mesh.name=="Robe"||mesh.name.StartsWith("Hood")||mesh.name.StartsWith("Cape");
 if(steel||cloth){mesh.sharedMaterials=mesh.sharedMaterials.Select(old=>{var m=new Material(old);m.name=mesh.name+(steel?"_DarkSilver":"_Black");if(m.HasProperty("_BaseColor"))m.SetColor("_BaseColor",steel?new Color(.64f,.67f,.70f):new Color(.075f,.075f,.08f));if(m.HasProperty("_Metallic"))m.SetFloat("_Metallic",steel?.88f:0);if(m.HasProperty("_Smoothness"))m.SetFloat("_Smoothness",steel?.72f:.25f);AssetDatabase.CreateAsset(m,AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Characters/Hunter/"+m.name+".mat"));return m;}).ToArray();}}
 var lights=Object.FindObjectsOfType<Light>();var fill=new GameObject("Silver rim").AddComponent<Light>();fill.type=LightType.Directional;fill.intensity=.8f;fill.transform.rotation=Quaternion.Euler(25,-50,0);
 PrefabUtility.SaveAsPrefabAsset(r.gameObject,"Assets/Demo/Characters/Hunter/Hunter_Modular_Armored.prefab");EditorSceneManager.SaveScene(r.gameObject.scene,"Assets/Demo/Scenes/HunterCharacterReview_Armored.unity");AssetDatabase.SaveAssets();File.WriteAllText("Evidence/hunter-armor-revision.txt",string.Join("\n",chosen));
 }
}
