using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.AI;
public class InspectionProbe:MonoBehaviour
{
 IEnumerator Start()
 {
  const string E="Evidence/evidence-inspection-20261106/";
  var log=new StringBuilder("Real Unity Play Mode; runtime ray selection + NavMesh approach + UI lifecycle; screenshots include OnGUI.\n");
  log.AppendLine("Unity="+Application.unityVersion+" platform="+Application.platform+" utc="+DateTime.UtcNow.ToString("O"));
  bool pass=true,errors=false;
  Application.LogCallback cb=(m,s,t)=>{if(t==LogType.Exception||t==LogType.Error||t==LogType.Assert){errors=true;log.AppendLine(t+":"+m+"\n"+s);}};
  Application.logMessageReceived+=cb;
  yield return new WaitForSeconds(1);
  var movement=GetComponent<DemoMovement>();var agent=GetComponent<NavMeshAgent>();var health=GetComponent<DemoHealth>();var investigation=GetComponent<DemoInvestigation>();
  foreach(string id in new[]{"emblem","trail"})
  {
   var clue=FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId==id);var ui=clue.GetComponent<EvidenceInspection>();
   bool sample=NavMesh.SamplePosition(clue.transform.position+new Vector3(-4,0,-2),out var start,6,NavMesh.AllAreas);
   bool warp=sample&&agent.Warp(start.position);
   yield return new WaitForSeconds(.7f);
   var r=ui.displayModel.GetComponentInChildren<Renderer>();
   var ray=movement.viewCamera.ScreenPointToRay(movement.viewCamera.WorldToScreenPoint(r.bounds.center));
   bool hit=Physics.Raycast(ray,out var selected,100)&&selected.collider.GetComponent<DemoInteractable>()==clue;
   bool centered=id!="trail"||Vector3.Distance(clue.transform.position,r.bounds.center)<.01f;
   movement.BeginInteraction(clue);float startTime=Time.realtimeSinceStartup;
   while(!EvidenceInspection.IsOpen&&Time.realtimeSinceStartup-startTime<25)yield return null;
   bool opened=EvidenceInspection.Active==ui;
   bool recorded=clue.examined&&(id=="trail"?investigation.HasTrail:investigation.HasEvidence);
   var position=transform.position;int hp=health.Health;float clock=Time.time;
   bool dodgeBlocked=!movement.TryDodge(Vector3.right);
   yield return new WaitForSecondsRealtime(1.5f);
   bool frozen=Time.timeScale==0&&Mathf.Abs(Time.time-clock)<.001f&&Vector3.Distance(position,transform.position)<.01f&&hp==health.Health;
   bool preview=ui.PreviewReady&&ui.ModelPreview&&ui.ModelPreview.IsCreated()&&ui.Backdrop&&ui.Backdrop.IsCreated()&&ui.blurShader&&ui.blurShader.isSupported;
   yield return new WaitForEndOfFrame();ScreenCapture.CaptureScreenshot(E+id+"-inspection.png");
   yield return new WaitForSecondsRealtime(.25f);
   ui.Open();bool repeatStable=EvidenceInspection.Active==ui;
   ui.Close();yield return null;yield return null;
   bool restored=!EvidenceInspection.IsOpen&&Mathf.Abs(Time.timeScale-1)<.001f&&!ui.ModelPreview&&!ui.Backdrop;
   clue.Activate();yield return null;bool reopen=EvidenceInspection.Active==ui;ui.Close();yield return null;yield return null;
   log.AppendLine("storyLength="+ui.story.Length+" title="+ui.itemTitle);
   log.AppendLine(id+": sample="+sample+" warp="+warp+" rayHit="+hit+" centered="+centered+" opened="+opened+" recorded="+recorded+" frozen="+frozen+" dodgeBlocked="+dodgeBlocked+" preview="+preview+" repeatStable="+repeatStable+" restored="+restored+" reopen="+reopen);
   pass&=sample&&warp&&hit&&centered&&opened&&recorded&&frozen&&dodgeBlocked&&preview&&repeatStable&&restored&&reopen;
  }
  var armUi=FindObjectsOfType<EvidenceInspection>().Single(i=>i.GetComponent<DemoInteractable>().clueId=="trail");
  Time.timeScale=.5f;armUi.Open();yield return null;armUi.Close();bool customScale=Time.timeScale==.5f;Time.timeScale=1;
  log.AppendLine("restorePriorHalfSpeed="+customScale);pass&=customScale;
  var trail=armUi.GetComponent<DemoInteractable>();
  int stains=trail.transform.Find("Blood evidence visuals/Scattered blood pool cluster").GetComponentsInChildren<Renderer>().Length;
  var marker=trail.GetComponent<TrailClueMarker>();bool hidden=marker&&!marker.badge.gameObject.activeSelf;
  log.AppendLine("stains="+stains+" markerHidden="+hidden);pass&=stains==12&&hidden;
  Application.logMessageReceived-=cb;pass&=!errors;
  log.AppendLine("result="+(pass?"PASS":"FAIL")+" exit_code="+(pass?0:1));File.WriteAllText(E+"playmode.txt",log.ToString());
#if UNITY_EDITOR
  UnityEditor.EditorApplication.isPlaying=false;
#endif
 }
}
