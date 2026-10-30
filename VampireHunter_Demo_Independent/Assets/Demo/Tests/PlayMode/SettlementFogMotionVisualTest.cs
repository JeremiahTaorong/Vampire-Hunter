using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using UnityEngine.TestTools;
public class SettlementFogMotionVisualTest {
 [UnityTest] public IEnumerator ShortGameCameraMotion(){
  yield return SceneManager.LoadSceneAsync("PrologueSettlement",LoadSceneMode.Single);yield return null;yield return null;
  var player=GameObject.Find("Player");var camera=Camera.main;Assert.IsNotNull(camera);
  var movement=player.GetComponent("DemoMovement") as Behaviour;if(movement)movement.enabled=false;
  var agent=player.GetComponent<NavMeshAgent>();agent.enabled=false;
  var fade=camera.GetComponent("SettlementVegetationFade") as MonoBehaviour;Assert.IsNotNull(fade);var type=fade.GetType();
  bool baseline=File.ReadAllText("Assets/Demo/SettlementAtmosphere/Vegetation/Fade.hlsl").Contains("clip(_Visibility");
  string folder="Evidence/settlement-stripes-20261029/"+(baseline?"before":"after");Directory.CreateDirectory(folder);
  var log=new StringBuilder("PlayMode; scripted short displacement; game camera follows player; no keyboard/nav/gameplay test\n");
  var spots=new[]{new Vector3(-5.3f,0,-1.6f),new Vector3(47.4f,0,-5.8f)};string[] names={"inn","forest"};
  for(int spot=0;spot<spots.Length;spot++){
   var origin=spots[spot];origin.y=Terrain.activeTerrain.SampleHeight(origin)+.95f;player.transform.position=origin;
   for(int frame=0;frame<18;frame++)yield return null;
   for(int frame=0;frame<20;frame++){
    var pos=origin+Vector3.right*(frame*.08f);pos.y=Terrain.activeTerrain.SampleHeight(pos)+.95f;player.transform.position=pos;
    yield return null;
    float visibility=(float)type.GetProperty("MinimumVisibility").GetValue(fade);log.AppendLine(names[spot]+"\t"+frame+"\t"+visibility+"\t"+camera.transform.position);
    Assert.GreaterOrEqual(visibility,.179f);Assert.LessOrEqual(visibility,1);
    if(frame==0||frame==9||frame==19)Capture(camera,folder+"/"+names[spot]+"-"+frame.ToString("D2")+".png");
   }
   // Same actual game camera, all vegetation restored: isolates fade artifact from fog.
   fade.enabled=false;yield return null;Capture(camera,folder+"/"+names[spot]+"-fade-disabled.png");fade.enabled=true;
  }
  fade.enabled=false;yield return null;
  var plants=(Transform[])type.GetField("plants").GetValue(fade);var block=new MaterialPropertyBlock();
  foreach(var plant in plants)foreach(var r in plant.GetComponentsInChildren<Renderer>(true)){r.GetPropertyBlock(block);Assert.AreEqual(1,block.GetFloat("_Visibility"),.001f,"Disable failed to restore");if(!baseline)foreach(var mat in r.sharedMaterials)if(mat)Assert.Less(mat.renderQueue,3000,"Disable left transparent materials");}
  File.WriteAllText(folder+"/motion.tsv",log.ToString());
 }
 static void Capture(Camera camera,string path){var rt=new RenderTexture(1280,720,24,RenderTextureFormat.ARGB32);rt.antiAliasing=1;rt.Create();var old=camera.targetTexture;var active=RenderTexture.active;camera.targetTexture=rt;camera.Render();RenderTexture.active=rt;var tex=new Texture2D(1280,720,TextureFormat.RGB24,false);tex.ReadPixels(new Rect(0,0,1280,720),0,0);tex.Apply();File.WriteAllBytes(path,tex.EncodeToPNG());camera.targetTexture=old;RenderTexture.active=active;UnityEngine.Object.Destroy(tex);rt.Release();UnityEngine.Object.Destroy(rt);}
}
