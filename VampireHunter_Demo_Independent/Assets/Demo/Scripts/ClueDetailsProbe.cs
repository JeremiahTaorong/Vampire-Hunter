using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.AI;

public class ClueDetailsProbe : MonoBehaviour
{
    IEnumerator Start()
    {
        const string output="Evidence/clue-details-20261106/";
        var log=new StringBuilder("mode=real Unity Play Mode; NavMeshAgent, ray selection and BeginInteraction; no simulated OS input\n");
        log.AppendLine("Unity="+Application.unityVersion+" platform="+Application.platform+" run_at_utc="+DateTime.UtcNow.ToString("O"));
        bool pass=true, errors=false;
        Application.LogCallback onLog=(message,trace,type)=>{if(type==LogType.Error||type==LogType.Exception||type==LogType.Assert){errors=true;log.AppendLine(type+": "+message+"\n"+trace);}};
        Application.logMessageReceived+=onLog;
        yield return new WaitForSeconds(1);
        var movement=GetComponent<DemoMovement>();var investigation=GetComponent<DemoInvestigation>();var agent=GetComponent<NavMeshAgent>();var cam=movement.viewCamera;var follow=cam.GetComponent<DemoCamera>();
        foreach(string id in new[]{"trail","emblem"})
        {
            var clue=FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId==id);
            Vector3 p=clue.transform.position;
            bool sampled=NavMesh.SamplePosition(p+new Vector3(-4,0,-2),out var start,6,NavMesh.AllAreas);
            bool warped=sampled&&agent.Warp(start.position);
            yield return new WaitForSeconds(.7f);
            Vector3 clickPoint=id=="trail"?p+Vector3.up*.65f:clue.transform.Find("Hunter cross badge").GetComponentInChildren<Renderer>().bounds.center;
            var ray=cam.ScreenPointToRay(cam.WorldToScreenPoint(clickPoint));
            bool hit=Physics.Raycast(ray,out var selected,100);
            bool selectable=hit&&selected.collider.GetComponent<DemoInteractable>()==clue;
            log.AppendLine(id+": sampled="+sampled+" warped="+warped+" selectable="+selectable+" hit="+(hit?selected.collider.name:"none"));
            movement.BeginInteraction(clue);float began=Time.time;
            while(!clue.examined&&Time.time-began<25)yield return null;
            bool recorded=id=="trail"?investigation.HasTrail:investigation.HasEvidence;
            log.AppendLine(id+": examined="+clue.examined+" recorded="+recorded+" path="+agent.pathStatus+" approachSeconds="+(Time.time-began).ToString("F2")+" distance="+Vector3.Distance(transform.position,p));
            pass&=sampled&&warped&&selectable&&clue.examined&&recorded;
            if(id=="trail")
            {
                var marker=clue.GetComponent<TrailClueMarker>();yield return null;
                bool hidden=marker&&!marker.badge.gameObject.activeSelf;
                int count=clue.transform.Find("Blood evidence visuals/Scattered blood pool cluster").GetComponentsInChildren<Renderer>().Length;
                log.AppendLine("clusterStains="+count+" markerHidden="+hidden);pass&=count==12&&hidden;
            }
            else
            {
                var badge=clue.transform.Find("Hunter cross badge");
                bool valid=badge&&badge.GetComponentsInChildren<Renderer>().All(r=>r.sharedMaterials.All(m=>m&&m.shader&&m.shader.isSupported));
                int triangles=badge.GetComponentsInChildren<MeshFilter>().Sum(f=>f.sharedMesh.triangles.Length/3);
                log.AppendLine("badgeMaterialsValid="+valid+" badgeTriangles="+triangles+" colliderRange="+clue.range);pass&=valid;
            }
            // Pose the player to the side for an unobstructed art review image.
            movement.TakeManualControl();
            if(NavMesh.SamplePosition(p+new Vector3(-1.9f,0,-1.6f),out var side,5,NavMesh.AllAreas))agent.Warp(side.position);
            yield return new WaitForSeconds(.4f);
            Capture(cam,output+id+"-gameplay.png");
            if(follow)follow.enabled=false;
            Vector3 focus=id=="trail"?p:clue.transform.Find("Hunter cross badge").position;
            cam.transform.position=focus+(id=="trail"?new Vector3(-2.8f,4.4f,-4.8f):new Vector3(-.65f,.9f,-1.1f));
            cam.transform.LookAt(focus);
            yield return new WaitForSeconds(.5f);
            Capture(cam,output+id+"-detail.png");
            if(follow)follow.enabled=true;
        }
        Application.logMessageReceived-=onLog;
        pass&=!errors;
        log.AppendLine("result="+(pass?"PASS":"FAIL")+" exit_code="+(pass?0:1));
        File.WriteAllText(output+"playmode.txt",log.ToString());
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying=false;
#endif
    }
    static void Capture(Camera camera,string path)
    {
        var old=camera.targetTexture;var active=RenderTexture.active;var rt=new RenderTexture(1600,900,24);camera.targetTexture=rt;camera.Render();RenderTexture.active=rt;
        var picture=new Texture2D(1600,900,TextureFormat.RGB24,false);picture.ReadPixels(new Rect(0,0,1600,900),0,0);picture.Apply();File.WriteAllBytes(path,picture.EncodeToPNG());
        camera.targetTexture=old;RenderTexture.active=active;Destroy(picture);rt.Release();Destroy(rt);
    }
}
