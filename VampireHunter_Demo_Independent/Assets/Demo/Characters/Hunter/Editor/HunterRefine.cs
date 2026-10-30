using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.Linq;using System.IO;
[InitializeOnLoad]public static class HunterRefine{
 static HunterRefine(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-refined.txt"))return;var r=Object.FindObjectOfType<HunterReview>();if(!r)return;
 foreach(var mesh in r.GetComponentsInChildren<SkinnedMeshRenderer>(true)){
 if(mesh.name=="Cape_1")mesh.gameObject.SetActive(false);if(mesh.name=="Cape_3")mesh.gameObject.SetActive(true);
 if(mesh.name.StartsWith("Hood")||mesh.name.StartsWith("Cape")){var m=new Material(mesh.sharedMaterial);m.SetColor("_BaseColor",new Color(.16f,.17f,.18f));AssetDatabase.CreateAsset(m,AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Characters/Hunter/"+mesh.name+"_Dark.mat"));mesh.sharedMaterial=m;}}
 var a=r.animator;var w=Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/SopaDopa/URP_Medieval_Fantasy/Dynamic_parts/Prefs/Dagger_U.prefab"),a.GetBoneTransform(HumanBodyBones.RightHand));w.name="Hunter Dagger - grip candidate";w.transform.localPosition=new Vector3(0,.06f,.03f);w.transform.localRotation=Quaternion.Euler(0,0,90);
 PrefabUtility.SaveAsPrefabAsset(r.gameObject,"Assets/Demo/Characters/Hunter/Hunter_Modular.prefab");EditorSceneManager.SaveScene(r.gameObject.scene);AssetDatabase.SaveAssets();File.WriteAllText("Evidence/hunter-refined.txt","Cape_3 substituted; independent hood and cape tints; dagger on Humanoid RightHand. Grip requires visual validation.");
 }
}
