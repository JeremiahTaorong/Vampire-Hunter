using System;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
public static class SettlementSmoothFadeShaders {
 const string Folder="Assets/Demo/SettlementAtmosphere/Vegetation";
 public static string PatchInclude(string code){
  code=Regex.Replace(code,@"\s*SettlementDither\([^;]+\);", "");
  if(code.Contains("outColor = color;")&&!code.Contains("color.a *= saturate(_Visibility);"))code=code.Replace("outColor = color;","color.a *= saturate(_Visibility);\n    outColor = color;");
  return code;
 }
 public static string PatchShader(string text){
  if(!text.Contains("_SettlementSrcBlend("))text=new Regex(@"Properties\s*\{").Replace(text,"Properties { [HideInInspector]_SettlementSrcBlend(\"Fade Source\", Float)=1 [HideInInspector]_SettlementDstBlend(\"Fade Destination\", Float)=0 [HideInInspector]_SettlementZWrite(\"Fade Depth\", Float)=1",1);
  // Only forward color passes blend. Full-visibility materials keep their opaque depth passes.
  text=Regex.Replace(text,@"(""LightMode""\s*=\s*""UniversalForward(?:Only)?""[\s\S]*?)(HLSLPROGRAM)",m=>{
   string state=m.Groups[1].Value;
   state=Regex.Replace(state,@"(?m)^\s*Blend[^\r\n]*", "\nBlend [_SettlementSrcBlend] [_SettlementDstBlend]");
   state=Regex.Replace(state,@"(?m)^\s*ZWrite[^\r\n]*", "\nZWrite [_SettlementZWrite]");
   state=Regex.Replace(state,@"(?m)^\s*AlphaToMask[^\r\n]*", "\nAlphaToMask Off");
   return state+m.Groups[2].Value;
  });return text;
 }
 public static void ConfigureAll(){
  File.WriteAllText(Folder+"/Fade.hlsl","#ifndef SETTLEMENT_FADE_INCLUDED\n#define SETTLEMENT_FADE_INCLUDED\nfloat _Visibility;\n#endif\n");
  foreach(var path in Directory.GetFiles(Folder,"*.hlsl")){var old=File.ReadAllText(path);var updated=PatchInclude(old);if(old!=updated)File.WriteAllText(path,updated);}
  foreach(var path in Directory.GetFiles(Folder,"Shader_*.shader")){var old=File.ReadAllText(path);var updated=PatchShader(old);if(old!=updated)File.WriteAllText(path,updated);AssetDatabase.ImportAsset(path,ImportAssetOptions.ForceSynchronousImport);}
  AssetDatabase.Refresh();
  foreach(var guid in AssetDatabase.FindAssets("t:Material",new[]{Folder})){
   var mat=AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(guid));if(!mat||!mat.HasProperty("_Visibility"))continue;
   mat.SetFloat("_SettlementSrcBlend",1);mat.SetFloat("_SettlementDstBlend",0);mat.SetFloat("_SettlementZWrite",1);mat.SetFloat("_Visibility",1);EditorUtility.SetDirty(mat);
  }
  AssetDatabase.SaveAssets();Debug.Log("SETTLEMENT_SMOOTH_FADE_SHADER_READY");
 }
}
