using System; using System.IO; using UnityEditor; using UnityEditor.SceneManagement; using UnityEngine; using UnityEngine.Rendering; using UnityEngine.Rendering.Universal;
public static class BuildFogLightRepair {
 [MenuItem("Vampire Demo/Build Fog Light Repair")]
 public static void Build(){
  const string folder="Assets/Demo/FogLightRepair", target="Assets/Demo/Scenes/PrologueFogLightRepair.unity";
  if(EditorSceneManager.GetActiveScene().isDirty) throw new Exception("Current scene has unsaved changes; save them before running");
  if(File.Exists(target)||AssetDatabase.IsValidFolder(folder)) throw new Exception("Target already exists");
  AssetDatabase.CreateFolder("Assets/Demo","FogLightRepair");
  AssetDatabase.CopyAsset("Assets/Demo/DarkFogReview/BlackProfile.asset",folder+"/Profile.asset"); AssetDatabase.CopyAsset("Assets/Demo/DarkFogReview/Pipeline.asset",folder+"/Pipeline.asset");
  var pipeline=AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>(folder+"/Pipeline.asset"); var ser=new SerializedObject(pipeline); ser.FindProperty("m_MSAA").intValue=1; ser.ApplyModifiedPropertiesWithoutUndo(); EditorUtility.SetDirty(pipeline);
  var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueBlackFogReview.unity"); if(!EditorSceneManager.SaveScene(scene,target,true)) throw new Exception("Scene copy failed"); scene=EditorSceneManager.OpenScene(target);
  GameObject.Find("Fog Demo Pipeline").GetComponent<FogDemoPipeline>().pipeline=pipeline;
  var profile=AssetDatabase.LoadAssetAtPath<VolumeProfile>(folder+"/Profile.asset"); VolumetricFogVolumeComponent fog; if(!profile.TryGet(out fog)) throw new Exception("Fog missing");
  fog.enableAdditionalLightsContribution.Override(true); fog.density.Override(.45f); fog.attenuationDistance.Override(22f); fog.tint.Override(new Color(.16f,.16f,.16f)); EditorUtility.SetDirty(fog); EditorUtility.SetDirty(profile);
  GameObject.Find("Volumetric Fog Demo Volume").GetComponent<Volume>().sharedProfile=profile;
  foreach(var l in UnityEngine.Object.FindObjectsOfType<Light>()) if(l.type==LightType.Point) { l.intensity*=3f; var v=l.GetComponent<VolumetricAdditionalLight>(); if(!v) v=l.gameObject.AddComponent<VolumetricAdditionalLight>(); v.Scattering=0.5f; }
  var glow=GameObject.Find("MicroAVL warm light test"); if(!glow) { foreach(var t in Resources.FindObjectsOfTypeAll<Transform>()) if(t.gameObject.scene==scene && t.name=="MicroAVL warm light test") {glow=t.gameObject; break;} } if(glow) {glow.SetActive(true); glow.transform.localScale=Vector3.one*2f;}
  var cam=GameObject.Find("Demo camera").GetComponent<Camera>(); cam.allowMSAA=false; cam.GetUniversalAdditionalCameraData().renderPostProcessing=true;
  EditorSceneManager.MarkSceneDirty(scene); EditorSceneManager.SaveScene(scene); AssetDatabase.SaveAssets();
  Debug.Log("FOG_LIGHT_REPAIR_READY; point fog enabled, MSAA disabled, MicroAVL="+(glow!=null));
 }
}
