using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;
[InitializeOnLoad]public static class HunterWeaponSetup{
 static HunterWeaponSetup(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-weapon-corrected.txt"))return;var player=Object.FindObjectOfType<HunterGameplayAnimator>();if(!player)return;var hand=player.animator.GetBoneTransform(HumanBodyBones.RightHand);
 var weapon=Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/SopaDopa/URP_Medieval_Fantasy/Dynamic_parts/Prefs/Dagger_U.prefab"));weapon.name="DaggerGripCandidate";
 weapon.transform.position=hand.position+hand.rotation*new Vector3(0,.025f,.015f);weapon.transform.rotation=hand.rotation*Quaternion.Euler(0,0,180);weapon.transform.SetParent(hand,true);
 EditorSceneManager.SaveScene(player.gameObject.scene);PrefabUtility.SaveAsPrefabAsset(player.gameObject,"Assets/Demo/Characters/Hunter/Hunter_PlayerCandidate.prefab");File.WriteAllText("Evidence/hunter-weapon-corrected.txt","World-scale preservation: hand scale="+hand.lossyScale+" weapon scale="+weapon.transform.lossyScale+" bounds="+weapon.GetComponentInChildren<Renderer>().bounds+"\nGrip is a candidate pending action inspection.");
 }
}
