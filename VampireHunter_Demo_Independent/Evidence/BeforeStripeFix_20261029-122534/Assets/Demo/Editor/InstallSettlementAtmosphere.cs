using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using Object=UnityEngine.Object;
public static class InstallSettlementAtmosphere {
 public const string Dir="Assets/Demo/SettlementAtmosphere";
 const string ScenePath="Assets/Demo/Scenes/PrologueSettlement.unity";
 static readonly Dictionary<Shader,Shader> shaders=new Dictionary<Shader,Shader>();
 static readonly Dictionary<Material,Material> materials=new Dictionary<Material,Material>();
 [MenuItem("Vampire Demo/Restore Settlement Atmosphere")]
 public static void Run(){
  if(EditorApplication.isPlaying || EditorSceneManager.GetActiveScene().isDirty)throw new Exception("Stop play and save current scene before migration");
  EditorSceneManager.OpenScene(ScenePath);Install();EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene());AssetDatabase.SaveAssets();
  Debug.Log("SETTLEMENT_ATMOSPHERE_INSTALLED");
 }
 public static void Install(){
  shaders.Clear();materials.Clear();
  Directory.CreateDirectory(Dir);Directory.CreateDirectory(Dir+"/Vegetation");AssetDatabase.Refresh();
  var scene=EditorSceneManager.GetActiveScene();
  if(GameObject.Find("Settlement atmosphere"))throw new Exception("Atmosphere already installed; avoid duplicate migration");
  var roots=scene.GetRootGameObjects();var player=GameObject.Find("Player");var camera=Object.FindObjectOfType<DemoCamera>().GetComponent<Camera>();
  if(!player || !camera)throw new Exception("Player/camera missing");
  // Read the approved scene additively and copy actual serialized configuration.
  var sourceScene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueCarriedDarkReview.unity",OpenSceneMode.Additive);
  var sourceObjects=sourceScene.GetRootGameObjects().SelectMany(x=>x.GetComponentsInChildren<Transform>(true)).ToArray();
  var sourcePipeline=sourceObjects.Select(x=>x.GetComponent<FogDemoPipeline>()).First(x=>x);
  var sourceVolume=sourceObjects.Select(x=>x.GetComponent<Volume>()).First(x=>x && x.sharedProfile && x.sharedProfile.Has<VolumetricFogVolumeComponent>());
  var sourceLight=sourceObjects.First(x=>x.name=="Carried Warm Light").GetComponent<Light>();
  var sourceClear=sourceLight.GetComponent<CarriedFogClear>();
  var sourceGlow=sourceObjects.First(x=>x.name=="Carried MicroAVL Glow");
  Copy(AssetDatabase.GetAssetPath(sourcePipeline.pipeline),Dir+"/Pipeline.asset");
  Copy(AssetDatabase.GetAssetPath(sourceVolume.sharedProfile),Dir+"/Profile.asset");
  var srcSO=new SerializedObject(sourcePipeline.pipeline);var srcRenderer=srcSO.FindProperty("m_RendererDataList").GetArrayElementAtIndex(srcSO.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue;
  Copy(AssetDatabase.GetAssetPath(srcRenderer),Dir+"/Renderer.asset");
  var root=new GameObject("Settlement atmosphere");UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(root,scene);
  var pipeline=AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>(Dir+"/Pipeline.asset");
  var renderer=AssetDatabase.LoadAssetAtPath<ScriptableRendererData>(Dir+"/Renderer.asset");
  foreach(var previous in renderer.rendererFeatures.ToArray())if(previous&&AssetDatabase.GetAssetPath(previous)==AssetDatabase.GetAssetPath(renderer))Object.DestroyImmediate(previous,true);
  renderer.rendererFeatures.Clear();var feature=ScriptableObject.CreateInstance<SettlementFogRendererFeature>();feature.name="Settlement multi light fog";AssetDatabase.AddObjectToAsset(feature,renderer);renderer.rendererFeatures.Add(feature);
  var rs=new SerializedObject(renderer);var map=rs.FindProperty("m_RendererFeatureMap");map.arraySize=1;string guid;long localId;AssetDatabase.TryGetGUIDAndLocalFileIdentifier(feature,out guid,out localId);map.GetArrayElementAtIndex(0).longValue=localId;rs.ApplyModifiedPropertiesWithoutUndo();EditorUtility.SetDirty(renderer);
  var ps=new SerializedObject(pipeline);ps.FindProperty("m_RendererDataList").GetArrayElementAtIndex(ps.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue=renderer;ps.FindProperty("m_MSAA").intValue=1;
  ps.FindProperty("m_AdditionalLightsRenderingMode").intValue=1;ps.FindProperty("m_AdditionalLightsPerObjectLimit").intValue=8;ps.ApplyModifiedPropertiesWithoutUndo();EditorUtility.SetDirty(pipeline);
  root.AddComponent<FogDemoPipeline>().pipeline=pipeline;
  var volume=root.AddComponent<Volume>();volume.isGlobal=true;volume.priority=2;volume.sharedProfile=AssetDatabase.LoadAssetAtPath<VolumeProfile>(Dir+"/Profile.asset");
  // Keep the approved fog component only; settlement's existing volume controls post processing.
  foreach(var component in volume.sharedProfile.components)if(!(component is VolumetricFogVolumeComponent)){component.active=false;EditorUtility.SetDirty(component);} 
  var lantern=roots.SelectMany(x=>x.GetComponentsInChildren<Light>(true)).First(x=>x.name=="Carried lantern");
  EditorUtility.CopySerialized(sourceLight,lantern);lantern.enabled=true;
  var clear=lantern.gameObject.AddComponent<SettlementFogLight>();clear.source=lantern;clear.innerRadius=sourceClear.clearRadius;clear.outerRadius=sourceClear.fadeRadius;clear.minimumDensity=0;clear.referenceIntensity=lantern.intensity;
  var flicker=lantern.GetComponent<LanternFlicker>();if(flicker)flicker.baseIntensity=lantern.intensity;
  var glow=Object.Instantiate(sourceGlow.gameObject,lantern.transform,false);glow.name="Settlement carried MicroAVL glow";
  var glowMat=sourceGlow.GetComponent<Renderer>().sharedMaterial;Copy(AssetDatabase.GetAssetPath(glowMat),Dir+"/CarriedGlow.mat");glow.GetComponent<Renderer>().sharedMaterial=AssetDatabase.LoadAssetAtPath<Material>(Dir+"/CarriedGlow.mat");
  EditorSceneManager.CloseScene(sourceScene,true);UnityEngine.SceneManagement.SceneManager.SetActiveScene(scene);
  var locals=new List<SettlementFogLight>();foreach(var l in roots.SelectMany(x=>x.GetComponentsInChildren<Light>(true))){if(l.type!=LightType.Point && l.type!=LightType.Spot)continue;
   l.enabled=true;var item=l.GetComponent<SettlementFogLight>();if(!item){item=l.gameObject.AddComponent<SettlementFogLight>();item.source=l;item.innerRadius=l.range*.15f;item.outerRadius=l.range*.45f;item.referenceIntensity=Mathf.Max(l.intensity,.001f);}
   var scattering=l.GetComponent<VolumetricAdditionalLight>();if(!scattering)scattering=l.gameObject.AddComponent<VolumetricAdditionalLight>();scattering.Scattering=.45f;locals.Add(item);
  }
  if(locals.Count>64)throw new Exception("More than 64 local lights");
  var manager=root.AddComponent<SettlementFogManager>();manager.lights=locals.ToArray();manager.Upload(1);
  GraphicsSettings.defaultRenderPipeline=pipeline;QualitySettings.renderPipeline=pipeline;RenderSettings.fog=false;camera.allowMSAA=false;var data=camera.GetUniversalAdditionalCameraData();data.renderPostProcessing=true;data.SetRenderer(-1);
  var forest=GameObject.Find("Forest").transform;var plants=new List<Transform>();
  foreach(Transform plant in forest){var renderers=plant.GetComponentsInChildren<Renderer>(true);if(renderers.Length==0)continue;
   Bounds bounds=renderers[0].bounds;foreach(var r in renderers)bounds.Encapsulate(r.bounds);
   if(bounds.size.y<.8f || Regex.IsMatch(plant.name,"grass|fern|mugwort|leaves|rock|decayed|fallen|stump",RegexOptions.IgnoreCase))continue;
   plants.Add(plant);foreach(var r in renderers){var mats=r.sharedMaterials;for(int i=0;i<mats.Length;i++)if(mats[i])mats[i]=FadeMaterial(mats[i]);r.sharedMaterials=mats;EditorUtility.SetDirty(r);PrefabUtility.RecordPrefabInstancePropertyModifications(r);}
  }
  var fade=camera.gameObject.AddComponent<SettlementVegetationFade>();fade.target=player.transform;fade.plants=plants.ToArray();
  AssetDatabase.SaveAssets();Debug.Log("SETTLEMENT_ATMOSPHERE lights="+locals.Count+" plants="+plants.Count+" shaders="+shaders.Count+" materials="+materials.Count);
 }
 static void Copy(string src,string dst){if(AssetDatabase.LoadMainAssetAtPath(dst))return;if(!AssetDatabase.CopyAsset(src,dst))throw new Exception("Copy failed "+src);}
 static string Read(string path){if(path.StartsWith("Packages/")){var p=UnityEditor.PackageManager.PackageInfo.FindForAssetPath(path);return File.ReadAllText(p.resolvedPath+path.Substring(p.assetPath.Length));}return File.ReadAllText(path);}
 static Material FadeMaterial(Material src){Material result;if(materials.TryGetValue(src,out result))return result;
  Shader shader;if(!shaders.TryGetValue(src.shader,out shader)){
   string path=AssetDatabase.GetAssetPath(src.shader),text;
   if(path.EndsWith(".shadergraph")){
    var type=AppDomain.CurrentDomain.GetAssemblies().Select(x=>x.GetType("UnityEditor.ShaderGraph.ShaderGraphImporter")).First(x=>x!=null);
    var method=type.GetMethods(BindingFlags.Static|BindingFlags.NonPublic).First(x=>x.Name=="GetShaderText"&&x.GetParameters().Length==4);
    object[] args={path,null,null,null};text=(string)method.Invoke(null,args);
   }else text=Read(path);
   string name="VampireDemo/SettlementFade/"+src.shader.name;
   text=new Regex("Shader\\s+\"[^\"]+\"").Replace(text,"Shader \""+name+"\"",1);
   text=new Regex(@"Properties\s*\{").Replace(text,"Properties { _Visibility(\"Visibility\", Range(0,1)) = 1",1);
   text=Regex.Replace(text,"#include\\s+\"([^\"]+)\"",m=>{
    string include=m.Groups[1].Value;if(!include.StartsWith("Packages/"))return m.Value;
    string code=Read(include);if(!code.Contains("UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX("))return m.Value;
    code="#include \"Assets/Demo/SettlementAtmosphere/Vegetation/Fade.hlsl\"\n"+code;
    code=Regex.Replace(code,@"UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX\((\w+)\);",x=>x.Value+"\n SettlementDither("+x.Groups[1].Value+".positionCS.xy);");
    string target=Dir+"/Vegetation/"+include.Replace("/","_");if(File.Exists(target)&&File.ReadAllText(target)!=code)throw new Exception("Include collision "+include);File.WriteAllText(target,code);return "#include \""+target+"\"";
   });
   string shaderPath=Dir+"/Vegetation/Shader_"+shaders.Count+".shader";File.WriteAllText(shaderPath,text);AssetDatabase.ImportAsset(shaderPath,ImportAssetOptions.ForceSynchronousImport);shader=AssetDatabase.LoadAssetAtPath<Shader>(shaderPath);if(!shader)throw new Exception("Generated shader missing "+src.shader.name);shaders[src.shader]=shader;
  }
  result=new Material(src.shader);result.CopyPropertiesFromMaterial(src);result.name=src.name+" Settlement Fade";result.shader=shader;result.SetFloat("_Visibility",1);string matPath=Dir+"/Vegetation/Material_"+materials.Count+".mat";var existing=AssetDatabase.LoadAssetAtPath<Material>(matPath);if(existing){EditorUtility.CopySerialized(result,existing);Object.DestroyImmediate(result);result=existing;EditorUtility.SetDirty(result);}else AssetDatabase.CreateAsset(result,matPath);materials[src]=result;return result;
 }
}
