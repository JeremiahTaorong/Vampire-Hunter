using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Object=UnityEngine.Object;
[InitializeOnLoad]
public static class InspectionSetup
{
 const string E="Evidence/evidence-inspection-20261106/";
 const string Scene="Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity";
 static InspectionSetup(){EditorApplication.update+=Poll;}
 static void Poll()
 {
  if(EditorApplication.isCompiling||EditorApplication.isUpdating) return;
  string path=E+"command.txt"; if(!File.Exists(path))return;
  string cmd;
  try{cmd=File.ReadAllText(path).Trim();File.Move(path,E+"command-"+DateTime.UtcNow.Ticks+".txt");}catch(IOException){return;}
  try{
   if(cmd=="build") Build();
   else if(cmd=="test") {if(EditorSceneManager.GetActiveScene().isDirty)throw new Exception("Save first");Object.FindObjectOfType<DemoMovement>().gameObject.AddComponent<InspectionProbe>();EditorApplication.isPlaying=true;}
   else if(cmd=="finish") {if(EditorApplication.isPlaying)throw new Exception("Stop Play first");foreach(var p in Object.FindObjectsOfType<InspectionProbe>())Object.DestroyImmediate(p);EditorSceneManager.OpenScene(Scene);File.WriteAllText(E+"saved.txt","Saved scene reopened; probe absent; Unity "+Application.unityVersion);}
   else if(cmd=="approacharm") {
    if(!EditorApplication.isPlaying)throw new Exception("Play first");
    var clue=Object.FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId=="trail");
    var movement=Object.FindObjectOfType<DemoMovement>(); movement.TakeManualControl();
    if(UnityEngine.AI.NavMesh.SamplePosition(clue.transform.position+new Vector3(-3,0,-2),out var point,5,UnityEngine.AI.NavMesh.AllAreas))movement.GetComponent<UnityEngine.AI.NavMeshAgent>().Warp(point.position);
   }
   else if(cmd=="label") {
    if(EditorApplication.isPlaying)throw new Exception("Stop first");
    var clue=Object.FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId=="trail");
    foreach(var text in clue.GetComponent<TrailClueMarker>().badge.GetComponentsInChildren<TextMesh>())text.text="SEVERED ARM";
    var scene=clue.gameObject.scene;EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);
   }
   else if(cmd=="status") File.WriteAllText(E+"status.txt","playing="+EditorApplication.isPlaying+" open="+EvidenceInspection.IsOpen+" item="+(EvidenceInspection.Active?EvidenceInspection.Active.itemTitle:"none")+" scale="+Time.timeScale);
   else if(cmd=="showbadge"||cmd=="showarm") {
    if(!EditorApplication.isPlaying){EditorApplication.isPlaying=true;File.WriteAllText(E+"pending.txt",cmd);}
    else Object.FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId==(cmd=="showbadge"?"emblem":"trail")).Activate();
   }
   else if(cmd=="stop") {if(EvidenceInspection.Active)EvidenceInspection.Active.Close();EditorApplication.isPlaying=false;}
   else throw new Exception(cmd);
  }catch(Exception ex){File.WriteAllText(E+"error.txt",ex.ToString());Debug.LogException(ex);}
 }
 static void Build()
 {
  if(EditorApplication.isPlayingOrWillChangePlaymode||EditorSceneManager.GetActiveScene().isDirty)throw new Exception("Preserve scene first");
  var scene=EditorSceneManager.OpenScene(Scene);
  var clues=Object.FindObjectsOfType<DemoInteractable>();
  var trail=clues.Single(c=>c.clueId=="trail");
  var arm=trail.transform.Find("Blood evidence visuals").GetComponentsInChildren<Transform>().First(t=>t.name.StartsWith("Severed Arm"));
  Bounds bounds=arm.GetComponentInChildren<Renderer>().bounds;
  var children=trail.transform.Cast<Transform>().ToArray();
  foreach(var t in children)t.SetParent(null,true);
  trail.transform.position=bounds.center;
  foreach(var t in children)t.SetParent(trail.transform,true);
  var box=trail.GetComponent<BoxCollider>();box.center=Vector3.zero;box.size=bounds.size+new Vector3(.18f,.20f,.18f);box.isTrigger=true;
  var marker=trail.GetComponent<TrailClueMarker>();
  if(marker&&marker.badge)marker.badge.position=bounds.center+Vector3.up*.8f;
  foreach(string id in new[]{"trail","emblem"}) {
   var clue=clues.Single(c=>c.clueId==id);
   var inspection=clue.GetComponent<EvidenceInspection>();if(!inspection)inspection=clue.gameObject.AddComponent<EvidenceInspection>();
   inspection.displayModel=id=="trail"?arm:clue.transform.Find("Hunter cross badge");
   inspection.blurShader=Shader.Find("Hidden/Demo/EvidenceBlur");
   inspection.itemTitle=id=="trail"?"What the Blood Left Behind":"The Worn Hunter's Cross";
   inspection.story=id=="trail"?
    "A severed arm lies among the pooled blood. Beyond it, a long smear cuts across the earth and continues toward the pines. Someone was dragged away from this place.\n\nThe missing villagers did not simply abandon their homes. Whatever happened here left a trail into the forest. The arm offers no name, and no answer about who may still be alive. The hunter will need the survivor's account before following it.":
    "Beneath the dirt, the worn silver cross is familiar. It bears the mark the hunter remembers from a mentor's equipment - a sign once associated with protection, discipline, and restraint.\n\nElias Voss disappeared months ago while investigating the castle. Now that same mark lies at the edge of another disappearance. It is a link to the missing mentor, but no proof of what brought him here. The hunter pockets the memory and keeps searching for a living witness.";
   EditorUtility.SetDirty(inspection);
  }
  EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);AssetDatabase.SaveAssets();
  File.WriteAllText(E+"built.txt","Unity="+Application.unityVersion+"\nArm interaction center="+trail.transform.position+" collider="+box.size+" range="+trail.range+"\nTwo inspection components; English story drafts from Narrative III; blur shader="+Shader.Find("Hidden/Demo/EvidenceBlur"));
  EditorSceneManager.OpenScene(Scene);
 }
 [InitializeOnLoadMethod]static void Pending(){EditorApplication.playModeStateChanged+=state=>{if(state==PlayModeStateChange.EnteredPlayMode&&File.Exists(E+"pending.txt")){var cmd=File.ReadAllText(E+"pending.txt");File.Delete(E+"pending.txt");Object.FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId==(cmd=="showbadge"?"emblem":"trail")).Activate();}};}
}
