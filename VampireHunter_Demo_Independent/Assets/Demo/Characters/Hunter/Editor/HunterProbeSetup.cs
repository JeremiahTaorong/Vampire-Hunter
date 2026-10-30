using UnityEngine;using UnityEditor;using UnityEditor.SceneManagement;using System.IO;using System.Linq;
[InitializeOnLoad]public static class HunterProbeSetup{
 static HunterProbeSetup(){EditorApplication.delayCall+=Run;}
 static void Run(){if(EditorApplication.isPlayingOrWillChangePlaymode||File.Exists("Evidence/hunter-probe-setup.txt"))return;var p=Object.FindObjectOfType<HunterGameplayAnimator>();if(!p)return;p.gameObject.AddComponent<HunterCompatibilityProbe>();EditorSceneManager.SaveScene(p.gameObject.scene);
 var weapon=Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/SopaDopa/URP_Medieval_Fantasy/Dynamic_parts/Prefs/Dagger_U.prefab"));string s="";foreach(var r in weapon.GetComponentsInChildren<Renderer>())s+=r.name+" bounds="+r.bounds+" local="+r.transform.localPosition+" scale="+r.transform.lossyScale+"\n";Object.DestroyImmediate(weapon);File.WriteAllText("Evidence/hunter-probe-setup.txt",s);}
}
