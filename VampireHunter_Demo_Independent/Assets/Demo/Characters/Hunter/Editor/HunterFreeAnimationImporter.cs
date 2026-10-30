using UnityEngine;using UnityEditor;using System.Linq;using System.IO;
public class HunterFreeAnimationImporter:AssetPostprocessor{
 void OnPreprocessModel(){if(!assetPath.StartsWith("Assets/Demo/ThirdParty/QuaterniusHunterAnimations/"))return;var i=(ModelImporter)assetImporter;i.animationType=ModelImporterAnimationType.Human;i.avatarSetup=ModelImporterAvatarSetup.CreateFromThisModel;i.importAnimation=true;i.materialImportMode=ModelImporterMaterialImportMode.None;}
}
[InitializeOnLoad]public static class HunterFreeAnimationAudit{
 static HunterFreeAnimationAudit(){EditorApplication.delayCall+=Run;}
 static void Run(){if(!Directory.Exists("Assets/Demo/ThirdParty/QuaterniusHunterAnimations"))return;string s="";foreach(var id in AssetDatabase.FindAssets("t:Model",new[]{"Assets/Demo/ThirdParty/QuaterniusHunterAnimations"})){string p=AssetDatabase.GUIDToAssetPath(id);foreach(var a in AssetDatabase.LoadAllAssetsAtPath(p)){if(a is Avatar av)s+="AVATAR "+p+" valid="+av.isValid+" human="+av.isHuman+"\n";if(a is AnimationClip c && !c.name.StartsWith("__"))s+="CLIP "+p+" | "+c.name+" | "+c.length+" human="+c.humanMotion+"\n";}}File.WriteAllText("Evidence/hunter-free-animations-audit.txt",s);}
}
