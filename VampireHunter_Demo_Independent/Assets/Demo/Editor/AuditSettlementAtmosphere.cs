using System;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using Object=UnityEngine.Object;
public static class AuditSettlementAtmosphere {
 const string Out="Evidence/settlement-atmosphere-20261029";
 static void Require(bool condition,string message){if(!condition)throw new Exception(message);}
 public static void Run(){
  Directory.CreateDirectory(Out);EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueSettlement.unity");
  var manager=Object.FindObjectOfType<SettlementFogManager>();var fade=Object.FindObjectOfType<SettlementVegetationFade>();var camera=fade.GetComponent<Camera>();var player=fade.target;
  var pipeline=Object.FindObjectOfType<FogDemoPipeline>().pipeline;GraphicsSettings.defaultRenderPipeline=pipeline;QualitySettings.renderPipeline=pipeline;
  Require(manager&&fade&&manager.lights.Length<=64,"Atmosphere registration missing");
  var localLights=Object.FindObjectsOfType<Light>(true).Where(x=>x.type==LightType.Point||x.type==LightType.Spot).ToArray();Require(localLights.Length==manager.lights.Length,"Some lights unregistered");
  var sb=new StringBuilder("name\ttype\trange\tintensity\tinner\touter\tminimumDensity\tenabled\n");foreach(var item in manager.lights)sb.AppendLine(item.name+"\t"+item.source.type+"\t"+item.source.range+"\t"+item.source.intensity+"\t"+item.innerRadius+"\t"+item.outerRadius+"\t"+item.minimumDensity+"\t"+item.source.enabled);File.WriteAllText(Out+"/lights.tsv",sb.ToString());
  var missing=new StringBuilder();foreach(var plant in fade.plants)foreach(var r in plant.GetComponentsInChildren<Renderer>(true))foreach(var mat in r.sharedMaterials)if(mat&&!mat.HasProperty("_Visibility"))missing.AppendLine(plant.name+"/"+r.name+" => "+AssetDatabase.GetAssetPath(mat));File.WriteAllText(Out+"/missing-fade.txt",missing.ToString());Require(missing.Length==0,"Some vegetation materials lack visibility");
  var shaders=fade.plants.SelectMany(x=>x.GetComponentsInChildren<Renderer>(true)).SelectMany(x=>x.sharedMaterials).Where(x=>x).Select(x=>x.shader).Distinct().ToArray();
  var shaderLog=new StringBuilder();foreach(var shader in shaders){Require(!ShaderUtil.ShaderHasError(shader),"Shader error "+shader.name);shaderLog.AppendLine(shader.name);}
  File.WriteAllText(Out+"/shaders.txt",shaderLog.ToString());
  var approved=AssetDatabase.LoadAssetAtPath<VolumeProfile>("Assets/Demo/CarriedDarkReview/Profile.asset");var current=AssetDatabase.LoadAssetAtPath<VolumeProfile>(InstallSettlementAtmosphere.Dir+"/Profile.asset");VolumetricFogVolumeComponent a,b;Require(approved.TryGet(out a),"Approved fog profile missing");Require(current.TryGet(out b),"Fog profile missing");
  Require(EditorJsonUtility.ToJson(a)==EditorJsonUtility.ToJson(b),"Fog parameters differ from approved version");
  File.WriteAllText(Out+"/fog-profile.json",EditorJsonUtility.ToJson(b,true));
  Vector3 savedPos=camera.transform.position;Quaternion savedRot=camera.transform.rotation;Vector3 playerPos=player.position;
  string[] names={"village-entry","plaza","forest-edge"};Vector3[] coords={new Vector3(-44,0,-5.6f),new Vector3(-14.5f,0,-4.4f),new Vector3(47.4f,0,-5.8f)};
  for(int i=0;i<3;i++){var pos=coords[i];pos.y=Object.FindObjectOfType<Terrain>().SampleHeight(pos)+.95f;player.position=pos;camera.transform.position=pos+new Vector3(0,8.2f,-8.2f);camera.transform.LookAt(pos);manager.Upload(1);fade.Initialize();fade.Step(1);Shot(camera,names[i]);}
  var itemTest=manager.lights.First(x=>x.source.enabled && x.name!="Carried lantern" && !x.name.Contains("fill"));
  var lampPos=itemTest.transform.position;camera.transform.position=lampPos+new Vector3(0,7,-8);camera.transform.LookAt(lampPos+Vector3.down);player.position=lampPos+Vector3.right*2;
  manager.Upload(1);Shot(camera,"lamp-on");float on=itemTest.strength;itemTest.source.enabled=false;manager.Upload(1);Require(itemTest.strength==0,"Disabled light keeps clearing");Shot(camera,"lamp-off");itemTest.source.enabled=true;manager.Upload(1);Require(itemTest.strength>0,"Light failed to restore clear");
  // Isolate clearing contribution at identical light output.
  Shot(camera,"clear-on");Shader.SetGlobalInt("_SettlementFogCount",0);Shot(camera,"clear-off");manager.Upload(1);
  var tall=fade.plants.First(x=>x.GetComponentsInChildren<Renderer>(true).Any(r=>r.bounds.size.y>5));var bounds=tall.GetComponentsInChildren<Renderer>(true).First().bounds;
  fade.Initialize();player.position=bounds.center-Vector3.up*.9f;camera.transform.position=bounds.center-new Vector3(0,0,10);camera.transform.LookAt(bounds.center);fade.Step(1);Require(fade.MinimumVisibility<=.181f,"Occlusion did not fade");Shot(camera,"occlusion-faded");float min=fade.MinimumVisibility;
  fade.target=null;fade.Step(1);Require(fade.MinimumVisibility==1,"Missing target failed restore");Shot(camera,"occlusion-restored");fade.target=player;fade.Restore();
  player.position=playerPos;camera.transform.SetPositionAndRotation(savedPos,savedRot);manager.Upload(1);
  File.WriteAllText(Out+"/checks.txt","PASS registered local lights="+localLights.Length+"\nPASS vegetation plants="+fade.plants.Length+" shaders="+shaders.Length+"\nPASS approved fog profile exact serialized match\nPASS light off clears strength=0, light on restores\nPASS fade minimum="+min+", missing target restores=1\nNot tested: full traversal, keyboard/mouse, combat, frame rate; captures use fixed game camera poses.\n");
  Debug.Log("SETTLEMENT_ATMOSPHERE_AUDIT_PASS");
 }
 static void Shot(Camera camera,string name){for(int i=0;i<3;i++)CreateForestFinalReview.Render(camera,Out+"/"+name+".png",960,540,1);}
}
