using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
public static class CreateFogLightDemo {
 const string dir="Assets/Demo/FogLightDemo";
 const string scenePath="Assets/Demo/Scenes/PrologueFogLightDemo.unity";
 public static void Build() {
  if (File.Exists(scenePath) || AssetDatabase.IsValidFolder(dir)) throw new Exception("Target already exists; refusing overwrite");
  AssetDatabase.CreateFolder("Assets/Demo","FogLightDemo");
  var sourcePipeline=QualitySettings.renderPipeline as UniversalRenderPipelineAsset ?? GraphicsSettings.defaultRenderPipeline as UniversalRenderPipelineAsset;
  if(!sourcePipeline) throw new Exception("URP pipeline not found");
  var pso=new SerializedObject(sourcePipeline); var list=pso.FindProperty("m_RendererDataList");
  var sourceRenderer=list.GetArrayElementAtIndex(pso.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue as ScriptableRendererData;
  if(!sourceRenderer) throw new Exception("Renderer not found");
  AssetDatabase.CopyAsset(AssetDatabase.GetAssetPath(sourceRenderer),dir+"/FogRenderer.asset");
  AssetDatabase.CopyAsset(AssetDatabase.GetAssetPath(sourcePipeline),dir+"/FogPipeline.asset");
  var renderer=AssetDatabase.LoadAssetAtPath<ScriptableRendererData>(dir+"/FogRenderer.asset");
  var feature=ScriptableObject.CreateInstance<VolumetricFogRendererFeature>(); feature.name="Volumetric Fog"; AssetDatabase.AddObjectToAsset(feature,renderer); renderer.rendererFeatures.Add(feature); feature.Create(); EditorUtility.SetDirty(renderer);
  var pipeline=AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>(dir+"/FogPipeline.asset"); var so=new SerializedObject(pipeline); var renderers=so.FindProperty("m_RendererDataList"); renderers.GetArrayElementAtIndex(so.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue=renderer; so.ApplyModifiedPropertiesWithoutUndo(); EditorUtility.SetDirty(pipeline);
  var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestFinalReview.unity"); if(!EditorSceneManager.SaveScene(scene,scenePath,true)) throw new Exception("Copy scene failed"); scene=EditorSceneManager.OpenScene(scenePath);
  var go=new GameObject("Fog Demo Pipeline"); go.AddComponent<FogDemoPipeline>().pipeline=pipeline;
  var volGo=new GameObject("Volumetric Fog Demo Volume"); var volume=volGo.AddComponent<Volume>(); volume.isGlobal=true; var profile=ScriptableObject.CreateInstance<VolumeProfile>(); AssetDatabase.CreateAsset(profile,dir+"/FogProfile.asset"); volume.sharedProfile=profile;
  var fog=profile.Add<VolumetricFogVolumeComponent>(true); fog.enabled.Override(true); fog.distance.Override(65); fog.baseHeight.Override(0); fog.maximumHeight.Override(12); fog.density.Override(.12f); fog.attenuationDistance.Override(65); fog.enableMainLightContribution.Override(true); fog.scattering.Override(.3f); fog.enableAdditionalLightsContribution.Override(true); fog.maxSteps.Override(48); fog.blurIterations.Override(2);
  foreach(var light in UnityEngine.Object.FindObjectsOfType<Light>()) if(light.type==LightType.Point && !light.GetComponent<VolumetricAdditionalLight>()) light.gameObject.AddComponent<VolumetricAdditionalLight>();
  foreach(var r in UnityEngine.Object.FindObjectsOfType<Renderer>()) if(r.sharedMaterial && r.sharedMaterial.shader && r.sharedMaterial.shader.name=="VampireDemo/SoftMist") r.gameObject.SetActive(false);
  var cam=GameObject.Find("Demo camera").GetComponent<Camera>(); cam.GetUniversalAdditionalCameraData().renderPostProcessing=true;
  var house=AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Demo/ThirdParty/VillageBuildings/FBX/House_1.fbx"); if(house) { var obj=(GameObject)PrefabUtility.InstantiatePrefab(house); obj.name="Test Village House"; obj.transform.position=new Vector3(19,0,7); }
  var mat=AssetDatabase.LoadAssetAtPath<Material>("Assets/AkiDevCat/MicroAVL/Examples/Materials/M_Light_Orange.mat"); if(mat) { var sphere=GameObject.CreatePrimitive(PrimitiveType.Sphere); sphere.name="MicroAVL warm light test"; sphere.transform.position=new Vector3(22,2,2); sphere.transform.localScale=Vector3.one*4; UnityEngine.Object.DestroyImmediate(sphere.GetComponent<Collider>()); sphere.GetComponent<Renderer>().sharedMaterial=mat; }
  EditorSceneManager.MarkSceneDirty(scene); EditorSceneManager.SaveScene(scene); AssetDatabase.SaveAssets();
  var oldG=GraphicsSettings.defaultRenderPipeline; var oldQ=QualitySettings.renderPipeline; try { GraphicsSettings.defaultRenderPipeline=pipeline; QualitySettings.renderPipeline=pipeline; var player=GameObject.Find("Player"); var pos=player.transform.position; cam.transform.position=pos+new Vector3(0,10,-10); cam.transform.rotation=Quaternion.LookRotation(pos+Vector3.up*.9f-cam.transform.position); Directory.CreateDirectory("Art_Direction/FogLightDemo"); CreateForestFinalReview.Render(cam,"Art_Direction/FogLightDemo/preview.png",1600,900,1); } finally { GraphicsSettings.defaultRenderPipeline=oldG; QualitySettings.renderPipeline=oldQ; }
  Debug.Log("FOG_DEMO_BUILD_SUCCESS");
 }
}
