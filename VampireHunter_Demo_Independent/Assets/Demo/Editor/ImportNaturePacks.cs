using UnityEditor;using UnityEngine;
public static class ImportNaturePacks {
 [MenuItem("Vampire Demo/Import Nature Packs")]
 public static void Run(){
 AssetDatabase.ImportPackage("/Users/dorimiah/Library/Unity/Asset Store-5.x/Polyeler/3D ModelsEnvironments/Essential Nature Pack.unitypackage",false);
 AssetDatabase.ImportPackage("/Users/dorimiah/Library/Unity/Asset Store-5.x/TriForge Assets/3D ModelsEnvironmentsFantasy/Fantasy Forest Environment - Free Demo.unitypackage",false);
 AssetDatabase.ImportPackage("/Users/dorimiah/Library/Unity/Asset Store-5.x/forst/3D ModelsVegetationTrees/Conifers BOTD.unitypackage",false);
 Debug.Log("NATURE_PACK_IMPORT_REQUESTED");
 }
}
