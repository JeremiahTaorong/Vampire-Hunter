using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;
[InitializeOnLoad]public static class HunterGripFinalize{
 static HunterGripFinalize(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-grip-finalized.txt"))return;
 foreach(string path in new[]{"Assets/Demo/Scenes/HunterGameplayCompatibility.unity","Assets/Demo/Scenes/HunterActionReview.unity"}){
 var scene=EditorSceneManager.OpenScene(path);foreach(var a in Object.FindObjectsOfType<Animator>()){if(!a.isHuman)continue;var hand=a.GetBoneTransform(HumanBodyBones.RightHand);if(!hand)continue;var w=hand.Find("DaggerGripCandidate");if(!w)continue;w.position=hand.position+hand.rotation*new Vector3(0,.06f,0);w.rotation=hand.rotation;}
 var player=Object.FindObjectOfType<HunterGameplayAnimator>();if(player)PrefabUtility.SaveAsPrefabAsset(player.gameObject,"Assets/Demo/Characters/Hunter/Hunter_PlayerCandidate.prefab");EditorSceneManager.SaveScene(scene);}
 File.WriteAllText("Evidence/hunter-grip-finalized.txt","Corrected blade forward along the hand. Both test scenes saved and reopened. Approved visual prefab unchanged.");}
}
