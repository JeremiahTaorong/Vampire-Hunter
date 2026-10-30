using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class PrologueSmokeTest
{
    static int stage; static double until;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/ProloguePrototype.unity");
        EditorApplication.playModeStateChanged += state => { if (state == PlayModeStateChange.EnteredPlayMode) { until=EditorApplication.timeSinceStartup+1; EditorApplication.update += Tick; } };
        EditorApplication.isPlaying=true;
    }
    static void Tick()
    {
        if (EditorApplication.timeSinceStartup < until) return;
        var p=GameObject.Find("Player");
        if (!p) { Fail("player missing"); return; }
        var flow=p.GetComponent<DemoPrologueFlow>(); var investigation=p.GetComponent<DemoInvestigation>(); var health=p.GetComponent<DemoHealth>();
        if (stage == 0)
        {
            if (flow.enemy.activeSelf || flow.mentorClue.activeSelf || flow.Current != DemoPrologueFlow.Stage.Investigate) { Fail("initial gating"); return; }
            flow.DiscoverMentorClue();
            if (flow.Current != DemoPrologueFlow.Stage.Investigate || investigation.Resolve(true)) { Fail("early progression"); return; }
            GameObject.Find("Evidence - hunter emblem").GetComponent<DemoInteractable>().Activate();
            GameObject.Find("Witness placeholder").GetComponent<DemoInteractable>().Activate();
            if (!investigation.Resolve(true) || !flow.enemy.activeSelf || flow.mentorClue.activeSelf) { Fail("hunt did not start"); return; }
            stage=1; until=EditorApplication.timeSinceStartup+1; return;
        }
        if (stage == 1)
        {
            flow.enemy.GetComponent<DemoEnemy>().TakeDamage(1000);
            if (flow.Current != DemoPrologueFlow.Stage.MentorClue || !flow.mentorClue.activeSelf || health.Victory) { Fail("mentor clue gating"); return; }
            flow.mentorClue.GetComponent<DemoInteractable>().Activate();
            if (flow.Current != DemoPrologueFlow.Stage.Complete || !health.Victory) { Fail("completion"); return; }
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
            stage=2; until=EditorApplication.timeSinceStartup+1; return;
        }
        if (flow.Current != DemoPrologueFlow.Stage.Investigate || health.Victory || flow.enemy.activeSelf) { Fail("retry did not reset"); return; }
        Debug.Log("PROLOGUE_SMOKE_PASS: investigation gating, hunt, mentor clue, completion and retry");
        EditorApplication.Exit(0);
    }
    static void Fail(string message) { Debug.LogError("PROLOGUE_SMOKE_FAIL: "+message); EditorApplication.Exit(1); }
}
