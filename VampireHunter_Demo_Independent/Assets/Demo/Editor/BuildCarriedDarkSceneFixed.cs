using System; using System.IO; using UnityEditor; using UnityEditor.SceneManagement; using UnityEngine; using UnityEngine.Rendering; using UnityEngine.Rendering.Universal;
public static class BuildCarriedDarkSceneFixed {
 [MenuItem("Vampire Demo/Build Carried Dark Fog Fixed")]
 public static void Build(){
 const string folder="Assets/Demo/CarriedDarkReview", target="Assets/Demo/Scenes/PrologueCarriedDarkReview.unity";
 if(EditorApplication.isPlaying || EditorSceneManager.GetActiveScene().isDirty) throw new Exception("Stop play and save current scene first");
 if(File.Exists(target)||AssetDatabase.IsValidFolder(folder)) throw new Exception("Target exists");
 AssetDatabase.CreateFolder("Assets/Demo","CarriedDarkReview");
 AssetDatabase.CopyAsset("Assets/Demo/DarkFogReview/Renderer.asset",folder+"/Renderer.asset"); AssetDatabase.CopyAsset("Assets/Demo/FogLightRepair/Pipeline.asset",folder+"/Pipeline.asset"); AssetDatabase.CopyAsset("Assets/Demo/FogLightRepair/Profile.asset",folder+"/Profile.asset");
 var renderer=AssetDatabase.LoadAssetAtPath<ScriptableRendererData>(folder+"/Renderer.asset");
 renderer.rendererFeatures.RemoveAll(f=>f is VolumetricFogRendererFeature || f is CarriedDarkFogRendererFeature);
 var feature=ScriptableObject.CreateInstance<CarriedDarkFogRendererFeature>(); feature.name="Carried Fog"; AssetDatabase.AddObjectToAsset(feature,renderer); renderer.rendererFeatures.Add(feature); feature.Create();
 var rs=new SerializedObject(renderer); var map=rs.FindProperty("m_RendererFeatureMap"); map.arraySize=renderer.rendererFeatures.Count; for(int i=0;i<renderer.rendererFeatures.Count;i++){string guid;long id;if(!AssetDatabase.TryGetGUIDAndLocalFileIdentifier(renderer.rendererFeatures[i],out guid,out id)) throw new Exception("Missing feature");map.GetArrayElementAtIndex(i).longValue=id;}rs.ApplyModifiedPropertiesWithoutUndo();EditorUtility.SetDirty(renderer);
 var pipeline=AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>(folder+"/Pipeline.asset");var ps=new SerializedObject(pipeline);ps.FindProperty("m_RendererDataList").GetArrayElementAtIndex(ps.FindProperty("m_DefaultRendererIndex").intValue).objectReferenceValue=renderer;ps.FindProperty("m_MSAA").intValue=1;ps.ApplyModifiedPropertiesWithoutUndo();EditorUtility.SetDirty(pipeline);
 var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueFogLightRepair.unity");if(!EditorSceneManager.SaveScene(scene,target,true))throw new Exception("Cannot copy scene");scene=EditorSceneManager.OpenScene(target);
 GameObject.Find("Fog Demo Pipeline").GetComponent<FogDemoPipeline>().pipeline=pipeline;
 var profile=AssetDatabase.LoadAssetAtPath<VolumeProfile>(folder+"/Profile.asset");VolumetricFogVolumeComponent fog;if(!profile.TryGet(out fog))throw new Exception("Fog missing");fog.density.Override(.7f);fog.attenuationDistance.Override(12);fog.maximumHeight.Override(35);fog.enableMainLightContribution.Override(false);fog.enableAdditionalLightsContribution.Override(true);EditorUtility.SetDirty(fog);EditorUtility.SetDirty(profile);GameObject.Find("Volumetric Fog Demo Volume").GetComponent<Volume>().sharedProfile=profile;
 foreach(var l in UnityEngine.Object.FindObjectsOfType<Light>())l.enabled=false;
 var prev=GameObject.Find("MicroAVL warm light test");if(prev)prev.SetActive(false);
 var player=GameObject.Find("Player"); var anchor=new GameObject("Carried Warm Light");anchor.transform.SetParent(player.transform,false);anchor.transform.localPosition=new Vector3(.65f,.8f,0);var light=anchor.AddComponent<Light>();light.type=LightType.Point;light.color=new Color(1f,.63f,.3f);light.intensity=3.5f;light.range=9;light.shadows=LightShadows.None;var scatter=anchor.AddComponent<VolumetricAdditionalLight>();scatter.Scattering=.45f;anchor.AddComponent<CarriedFogClear>();
 var glow=GameObject.CreatePrimitive(PrimitiveType.Sphere);glow.name="Carried MicroAVL Glow";glow.transform.SetParent(anchor.transform,false);glow.transform.localScale=Vector3.one*1.5f;UnityEngine.Object.DestroyImmediate(glow.GetComponent<Collider>());glow.GetComponent<Renderer>().sharedMaterial=AssetDatabase.LoadAssetAtPath<Material>("Assets/AkiDevCat/MicroAVL/Examples/Materials/M_Light_Orange.mat");
 var cam=GameObject.Find("Demo camera").GetComponent<Camera>();cam.allowMSAA=false;cam.GetUniversalAdditionalCameraData().renderPostProcessing=true;
 EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);AssetDatabase.SaveAssets();Debug.Log("CARRIED_LIGHT_SCENE_READY");
 }
}
