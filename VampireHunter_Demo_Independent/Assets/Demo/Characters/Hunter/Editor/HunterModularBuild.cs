using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
[InitializeOnLoad] public static class HunterModularBuild {
 static HunterModularBuild(){EditorApplication.delayCall+=Audit;}
 static void Audit(){if(File.Exists("Evidence/hunter-modular-audit.txt"))return; var lines=new System.Collections.Generic.List<string>();
 foreach(var p in AssetDatabase.FindAssets("t:AnimationClip").Select(AssetDatabase.GUIDToAssetPath).Distinct()) {foreach(var c in AssetDatabase.LoadAllAssetsAtPath(p).OfType<AnimationClip>())lines.Add("CLIP "+p+" | "+c.name+" | "+c.length+" human="+c.humanMotion);}
 var obj=Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>("Assets/SopaDopa/URP_Medieval_Fantasy/Constructor_URP.prefab"));
 foreach(var a in obj.GetComponentsInChildren<Animator>(true))lines.Add("AVATAR "+a.name+" "+a.avatar+" valid="+(a.avatar&&a.avatar.isValid)+" human="+(a.avatar&&a.avatar.isHuman));
 foreach(var r in obj.GetComponentsInChildren<SkinnedMeshRenderer>(true))lines.Add("MESH "+r.name+" active="+r.gameObject.activeSelf+" verts="+r.sharedMesh.vertexCount+" bones="+r.bones.Length+" missing="+r.bones.Count(b=>!b)+" root="+r.rootBone);
 Object.DestroyImmediate(obj);Directory.CreateDirectory("Evidence");File.WriteAllLines("Evidence/hunter-modular-audit.txt",lines);
 }
}
