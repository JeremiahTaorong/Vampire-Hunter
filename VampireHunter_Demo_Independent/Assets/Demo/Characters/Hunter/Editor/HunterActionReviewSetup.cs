using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;
[InitializeOnLoad]public static class HunterActionReviewSetup{
 static HunterActionReviewSetup(){EditorApplication.delayCall+=Build;}
 static void Build(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-action-review-setup.txt")||!File.Exists("Evidence/hunter-actions-setup.txt"))return;
 var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/HunterCharacterReview_Armored.unity");string path=AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Scenes/HunterActionReview.unity");EditorSceneManager.SaveScene(scene,path);var old=Object.FindObjectOfType<HunterReview>();var a=old.animator;var camera=old.reviewCamera;var root=old.gameObject;Object.DestroyImmediate(old);a.runtimeAnimatorController=AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>("Assets/Demo/Characters/Hunter/Hunter_Gameplay.controller");
 var hand=a.GetBoneTransform(HumanBodyBones.RightHand);var w=Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/SopaDopa/URP_Medieval_Fantasy/Dynamic_parts/Prefs/Dagger_U.prefab"));w.name="DaggerGripCandidate";w.transform.position=hand.position+hand.rotation*new Vector3(0,.025f,.015f);w.transform.rotation=hand.rotation*Quaternion.Euler(0,0,180);w.transform.SetParent(hand,true);
 var review=root.AddComponent<HunterActionReview>();review.animator=a;review.view=camera;EditorSceneManager.SaveScene(scene);File.WriteAllText("Evidence/hunter-action-review-setup.txt",path);}
}
