using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
public static class CreateDarkFogReview {
 const string folder="Assets/Demo/DarkFogReview"; const string target="Assets/Demo/Scenes/PrologueDarkFogReview.unity";
 public static void Build(){
  if(File.Exists(target)||AssetDatabase.IsValidFolder(folder)) throw new Exception("Target already exists");
  AssetDatabase.CreateFolder("Assets/Demo","DarkFogReview");
  AssetDatabase.CopyAsset("Assets/Demo/FogLightDemo/FogRenderer.asset",folder+"/Renderer.asset");
  AssetDatabase.CopyAsset("Assets/Demo/FogLightDemo/FogPipeline.asset",folder+"/Pipeline.asset");
  var renderer=AssetDatabase.LoadAssetAtPath<ScriptableRendererData>(folder+"/Renderer.asset");
  var rs=new SerializedObject(renderer); var map=rs.FindProperty("m_RendererFeatureMap"); map.arraySize=renderer.rendererFeatures.Count;
  for(int i=0;i<renderer.rendererFeatures.Count;i++){ string guid; long id; if(!AssetDatabase.TryGetGUIDAndLocalFileIdentifier(renderer.rendererFeatures[i],out guid,out id)) throw new Exception("Renderer feature missing"); map.GetArrayElementAtIndex(i).longValue=id; } rs.ApplyModifiedPropertiesWithoutUndo(); EditorUtility.SetDirty(renderer);
  var pipeline=AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>(folder+"/Pipeline.asset"); var ps=new SerializedObject(pipeline); ps.FindProperty("m_RendererDataList").GetArrayElementAtIndex(ps.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue=renderer; ps.ApplyModifiedPropertiesWithoutUndo(); EditorUtility.SetDirty(pipeline);
  var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueFogLightDemo.unity"); if(!EditorSceneManager.SaveScene(scene,target,true)) throw new Exception("Scene copy failed"); scene=EditorSceneManager.OpenScene(target);
  GameObject.Find("Fog Demo Pipeline").GetComponent<FogDemoPipeline>().pipeline=pipeline;
  var profile=ScriptableObject.CreateInstance<VolumeProfile>(); AssetDatabase.CreateAsset(profile,folder+"/Profile.asset"); var fog=profile.Add<VolumetricFogVolumeComponent>(true); AssetDatabase.AddObjectToAsset(fog,profile);
  fog.enabled.Override(true); fog.distance.Override(80); fog.baseHeight.Override(0); fog.maximumHeight.Override(22); fog.density.Override(.35f); fog.attenuationDistance.Override(30); fog.enableMainLightContribution.Override(true); fog.scattering.Override(.28f); fog.tint.Override(new Color(.33f,.36f,.37f)); fog.enableAdditionalLightsContribution.Override(true); fog.maxSteps.Override(64); fog.blurIterations.Override(2); EditorUtility.SetDirty(fog); EditorUtility.SetDirty(profile);
  GameObject.Find("Volumetric Fog Demo Volume").GetComponent<Volume>().sharedProfile=profile;
  var glow=GameObject.Find("MicroAVL warm light test"); if(glow) glow.SetActive(false);
  var cam=GameObject.Find("Demo camera").GetComponent<Camera>(); cam.GetUniversalAdditionalCameraData().renderPostProcessing=true;
  EditorSceneManager.MarkSceneDirty(scene); EditorSceneManager.SaveScene(scene); AssetDatabase.SaveAssets();
  var oldG=GraphicsSettings.defaultRenderPipeline; var oldQ=QualitySettings.renderPipeline; try { GraphicsSettings.defaultRenderPipeline=pipeline; QualitySettings.renderPipeline=pipeline;
   var pos=GameObject.Find("Player").transform.position; cam.transform.position=pos+new Vector3(0,10,-10); cam.transform.rotation=Quaternion.LookRotation(pos+Vector3.up*.9f-cam.transform.position); Directory.CreateDirectory("Art_Direction/DarkFogReview");
   fog.enabled.value=false; CreateForestFinalReview.Render(cam,"Art_Direction/DarkFogReview/fog_off.png",1600,900,1);
   fog.enabled.value=true; CreateForestFinalReview.Render(cam,"Art_Direction/DarkFogReview/fog_on.png",1600,900,1);
  } finally { fog.enabled.value=true; GraphicsSettings.defaultRenderPipeline=oldG; QualitySettings.renderPipeline=oldQ; }
  Debug.Log("DARK_FOG_REVIEW_SUCCESS components="+profile.components.Count);
 }
}
