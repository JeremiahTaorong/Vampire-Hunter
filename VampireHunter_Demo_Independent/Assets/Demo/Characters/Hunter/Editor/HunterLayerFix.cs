using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;
[InitializeOnLoad]public static class HunterLayerFix{
 static HunterLayerFix(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-layer-fix.txt"))return;var r=Object.FindObjectOfType<HunterReview>();if(!r)return;
 foreach(var t in r.GetComponentsInChildren<Transform>(true))if(t.name.StartsWith("Hunter Dagger"))t.gameObject.SetActive(false);
 foreach(var m in r.GetComponentsInChildren<SkinnedMeshRenderer>(true)){
 if(m.name=="Steel_cuiras_2")m.gameObject.SetActive(false);
 if(m.name=="Steel_cuirass_1"||m.name=="Chain_Mail_Chest"){m.gameObject.SetActive(true);var mats=m.sharedMaterials;for(int i=0;i<mats.Length;i++){var n=new Material(mats[i]);n.SetColor("_BaseColor",new Color(.45f,.48f,.51f));n.SetFloat("_Metallic",.85f);n.SetFloat("_Smoothness",.6f);AssetDatabase.CreateAsset(n,AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Characters/Hunter/LayerSilver.mat"));mats[i]=n;}m.sharedMaterials=mats;}}
 PrefabUtility.SaveAsPrefabAsset(r.gameObject,"Assets/Demo/Characters/Hunter/Hunter_Modular_Armored.prefab");EditorSceneManager.SaveScene(r.gameObject.scene);AssetDatabase.SaveAssets();File.WriteAllText("Evidence/hunter-layer-fix.txt","Full cuirass and chainmail underlayer enabled; invalid dagger attachment disabled pending correction.");
 }
}
