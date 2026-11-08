using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public static class PrologueGreyboxSmokeTest
{
    static int stage; static double until;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled=true; EditorSettings.enterPlayModeOptions=EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueGreybox.unity");
        EditorApplication.playModeStateChanged += s => { if (s==PlayModeStateChange.EnteredPlayMode) { until=EditorApplication.timeSinceStartup+1; EditorApplication.update+=Tick; } };
        EditorApplication.isPlaying=true;
    }
    static void Tick()
    {
        if (EditorApplication.timeSinceStartup < until) return;
        var p=GameObject.Find("Player"); if (!p) { Fail("missing player"); return; }
        var a=p.GetComponent<DemoInvestigation>(); var flow=p.GetComponent<DemoPrologueFlow>();
        if (stage==0)
        {
            var nav=p.GetComponent<NavMeshAgent>();
            if (!nav.isOnNavMesh) { Fail("player outside navmesh"); return; }
            foreach (string objName in new [] { "Evidence - hunter emblem", "Witness placeholder", "Evidence - drag marks placeholder" })
            {
                var obj=GameObject.Find(objName); var path=new NavMeshPath();
                if (!obj || !NavMesh.SamplePosition(obj.transform.position,out var hit,2.5f,NavMesh.AllAreas) || !nav.CalculatePath(hit.position,path) || path.status!=NavMeshPathStatus.PathComplete) { Fail("unreachable "+objName); return; }
            }
            if (!NavMesh.SamplePosition(flow.enemy.transform.position,out var forest,2.5f,NavMesh.AllAreas)) { Fail("forest missing navmesh"); return; }
            var forestPath=new NavMeshPath();
            if (!nav.CalculatePath(forest.position,forestPath) || forestPath.status!=NavMeshPathStatus.PathComplete || Vector3.Distance(p.transform.position,forest.position)<70) { Fail("forest route"); return; }
            if (!NavMesh.SamplePosition(flow.mentorClue.transform.position,out var mark,2.5f,NavMesh.AllAreas)) { Fail("mentor mark missing navmesh"); return; }
            var lastPath=new NavMeshPath();
            if (!NavMesh.CalculatePath(forest.position,mark.position,NavMesh.AllAreas,lastPath) || lastPath.status!=NavMeshPathStatus.PathComplete) { Fail("mentor mark unreachable"); return; }
            GameObject.Find("Evidence - hunter emblem").GetComponent<DemoInteractable>().Activate();
            GameObject.Find("Witness placeholder").GetComponent<DemoInteractable>().Activate();
            if (a.Resolve(true)) { Fail("missing trail allowed conclusion"); return; }
            GameObject.Find("Evidence - drag marks placeholder").GetComponent<DemoInteractable>().Activate();
            if (!a.HasTrail || a.Resolve(false) || !a.WrongAttempt || !a.Resolve(true) || !flow.enemy.activeSelf) { Fail("clues or deduction"); return; }
            stage=1; until=EditorApplication.timeSinceStartup+1; return;
        }
        if (stage==1)
        {
            flow.enemy.GetComponent<DemoEnemy>().TakeDamage(1000);
            if (flow.Current!=DemoPrologueFlow.Stage.MentorClue || !flow.mentorClue.activeSelf) { Fail("mentor clue gating"); return; }
            flow.mentorClue.GetComponent<DemoInteractable>().Activate();
            if (!p.GetComponent<DemoHealth>().Victory) { Fail("completion"); return; }
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex); stage=2; until=EditorApplication.timeSinceStartup+1; return;
        }
        if (flow.Current!=DemoPrologueFlow.Stage.Investigate || a.HasEvidence || a.HasTrail || a.HasWitness) { Fail("retry reset"); return; }
        Debug.Log("GREYBOX_SMOKE_PASS: accessible village clues, long forest route, three-clue gating, retry and completion");
        EditorApplication.Exit(0);
    }
    static void Fail(string why) { Debug.LogError("GREYBOX_SMOKE_FAIL: "+why); EditorApplication.Exit(1); }
}
