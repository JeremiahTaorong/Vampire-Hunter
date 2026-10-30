using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;using System.Linq;
public static class HunterGameplaySetup{
 [MenuItem("Vampire Demo/Hunter/Create Gameplay Compatibility Scene")]
 public static void Build(){if(EditorApplication.isPlaying)throw new System.Exception("Exit Play Mode first");
 string scenePath=AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Scenes/HunterGameplayCompatibility.unity");
 var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");EditorSceneManager.SaveScene(scene,scenePath);
 var player=Object.FindObjectOfType<DemoMovement>();if(!player)throw new System.Exception("No prototype player");
 var old=player.GetComponent<Renderer>();if(old)old.enabled=false;
 var visual=(GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Demo/Characters/Hunter/Hunter_Modular_Armored.prefab"));visual.transform.SetParent(player.transform,false);visual.transform.localPosition=Vector3.down;
 foreach(var review in visual.GetComponentsInChildren<HunterReview>(true))Object.DestroyImmediate(review);
 var bridge=player.gameObject.AddComponent<HunterGameplayAnimator>();bridge.animator=visual.GetComponentInChildren<Animator>();bridge.animator.applyRootMotion=false;
 var cam=player.viewCamera;var follow=cam.GetComponent<DemoCamera>();if(follow)follow.offset=new Vector3(0,3,-5);cam.transform.position=player.transform.position+new Vector3(0,3,-5);cam.transform.LookAt(player.transform.position);
 PrefabUtility.SaveAsPrefabAsset(player.gameObject,AssetDatabase.GenerateUniqueAssetPath("Assets/Demo/Characters/Hunter/Hunter_PlayerCandidate.prefab"));EditorSceneManager.SaveScene(scene);File.WriteAllText("Evidence/hunter-gameplay-setup.txt",scenePath+"\nOriginal scene and DemoMovement unchanged. Capsule collider retained; renderer disabled.\n");
 }
}
