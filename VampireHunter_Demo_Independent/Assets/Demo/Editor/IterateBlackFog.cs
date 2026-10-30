using System; using System.IO; using UnityEditor; using UnityEditor.SceneManagement; using UnityEngine; using UnityEngine.Rendering; using UnityEngine.Rendering.Universal;
public static class IterateBlackFog {
 public static void Build(){
 const string target="Assets/Demo/Scenes/PrologueBlackFogReview.unity", profilePath="Assets/Demo/DarkFogReview/BlackProfile.asset", output="Art_Direction/BlackFogReview";
 if(File.Exists(target)||File.Exists(profilePath)||Directory.Exists(output)) throw new Exception("Target exists");
 AssetDatabase.CopyAsset("Assets/Demo/DarkFogReview/Profile.asset",profilePath);
 var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueNeutralFogReview.unity"); if(!EditorSceneManager.SaveScene(scene,target,true)) throw new Exception("Scene copy failed"); scene=EditorSceneManager.OpenScene(target);
 var vol=GameObject.Find("Volumetric Fog Demo Volume").GetComponent<Volume>(); var profile=AssetDatabase.LoadAssetAtPath<VolumeProfile>(profilePath); vol.sharedProfile=profile; VolumetricFogVolumeComponent fog; if(!profile.TryGet(out fog))throw new Exception("Fog missing");
 fog.density.Override(.65f); fog.distance.Override(100); fog.baseHeight.Override(8); fog.maximumHeight.Override(35); fog.attenuationDistance.Override(14); fog.scattering.Override(.42f); fog.tint.Override(new Color(.16f,.16f,.16f)); fog.enableMainLightContribution.Override(true); fog.enableAdditionalLightsContribution.Override(false); fog.maxSteps.Override(96);
 foreach(var l in UnityEngine.Object.FindObjectsOfType<Light>()) if(l.type==LightType.Directional) l.color=Color.white;
 var cam=GameObject.Find("Demo camera").GetComponent<Camera>(); var p=GameObject.Find("Player").transform.position; var oldpos=cam.transform.position; var oldrot=cam.transform.rotation;
 EditorUtility.SetDirty(fog); EditorUtility.SetDirty(profile); EditorSceneManager.MarkSceneDirty(scene); EditorSceneManager.SaveScene(scene); AssetDatabase.SaveAssets();
 var oldG=GraphicsSettings.defaultRenderPipeline; var oldQ=QualitySettings.renderPipeline; var pipeline=GameObject.Find("Fog Demo Pipeline").GetComponent<FogDemoPipeline>().pipeline;
 try {GraphicsSettings.defaultRenderPipeline=pipeline; QualitySettings.renderPipeline=pipeline; Directory.CreateDirectory(output);
  cam.transform.position=p+new Vector3(0,10,-10); cam.transform.rotation=Quaternion.LookRotation(p+Vector3.up*.9f-cam.transform.position);
  fog.enabled.value=false; CreateForestFinalReview.Render(cam,output+"/rig_off.png",1600,900,1); fog.enabled.value=true; CreateForestFinalReview.Render(cam,output+"/rig_on.png",1600,900,1);
  cam.transform.position=p+new Vector3(-8,3,-5); cam.transform.rotation=Quaternion.LookRotation(new Vector3(38,2,1)-cam.transform.position); CreateForestFinalReview.Render(cam,output+"/low_on.png",1600,900,1);
 } finally {fog.enabled.value=true; cam.transform.position=oldpos; cam.transform.rotation=oldrot; GraphicsSettings.defaultRenderPipeline=oldG; QualitySettings.renderPipeline=oldQ;}
 Debug.Log("BLACK_FOG_COMPLETE");
 }
}
