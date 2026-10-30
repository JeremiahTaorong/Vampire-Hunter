using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
public static class RepairSettlementFadePersistence {
 public static void Run(){
  EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueSettlement.unity");var fade=UnityEngine.Object.FindObjectOfType<SettlementVegetationFade>();int fixedCount=0;
  fade.plants=GameObject.Find("Forest").transform.Cast<Transform>().Where(t=>{var rs=t.GetComponentsInChildren<Renderer>(true);if(rs.Length==0)return false;var b=rs[0].bounds;foreach(var r in rs)b.Encapsulate(r.bounds);return b.size.y>=.8f&&!Regex.IsMatch(t.name,"grass|fern|mugwort|leaves|rock|decayed|fallen|stump",RegexOptions.IgnoreCase);}).ToArray();EditorUtility.SetDirty(fade);
  foreach(var guid in AssetDatabase.FindAssets("t:Material",new[]{InstallSettlementAtmosphere.Dir+"/Vegetation"})){
   var mat=AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(guid));if(!mat || mat.HasProperty("_Visibility"))continue;
   var shader=Shader.Find("VampireDemo/SettlementFade/"+mat.shader.name);if(!shader)throw new Exception("Missing shader "+mat.shader.name);
   var flat=new Material(mat.shader);flat.CopyPropertiesFromMaterial(mat);flat.shader=shader;flat.SetFloat("_Visibility",1);flat.name=mat.name;EditorUtility.CopySerialized(flat,mat);UnityEngine.Object.DestroyImmediate(flat);EditorUtility.SetDirty(mat);
  }
  foreach(var plant in fade.plants)foreach(var r in plant.GetComponentsInChildren<Renderer>(true)){
   var mats=r.sharedMaterials;
   for(int i=0;i<mats.Length;i++)if(mats[i]&&!mats[i].HasProperty("_Visibility")){
    var src=mats[i];var shader=Shader.Find("VampireDemo/SettlementFade/"+src.shader.name);if(!shader)throw new Exception("No fade shader for "+src.shader.name);
    string path=InstallSettlementAtmosphere.Dir+"/Vegetation/Persist_"+AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(src))+".mat";
    var clone=AssetDatabase.LoadAssetAtPath<Material>(path);if(!clone){clone=new Material(src.shader);clone.CopyPropertiesFromMaterial(src);clone.shader=shader;clone.SetFloat("_Visibility",1);AssetDatabase.CreateAsset(clone,path);}mats[i]=clone;fixedCount++;
   }
   r.sharedMaterials=mats;EditorUtility.SetDirty(r);PrefabUtility.RecordPrefabInstancePropertyModifications(r);
  }
  EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene());AssetDatabase.SaveAssets();Debug.Log("FADE_PERSISTENCE_REPAIRED slots="+fixedCount);AuditSettlementAtmosphere.Run();
 }
}
