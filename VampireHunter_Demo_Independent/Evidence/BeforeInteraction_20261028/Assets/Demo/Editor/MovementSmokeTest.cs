using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class MovementSmokeTest
{
    static int stage;
    static double until;
    static Vector3 start;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");
        EditorApplication.playModeStateChanged += OnState;
        EditorApplication.isPlaying = true;
    }
    static void OnState(PlayModeStateChange state)
    {
        if (state == PlayModeStateChange.EnteredPlayMode) { until = EditorApplication.timeSinceStartup + 2; EditorApplication.update += Tick; }
    }
    static void Tick()
    {
        if (EditorApplication.timeSinceStartup < until) return;
        var p = GameObject.Find("Player");
        var agent = p ? p.GetComponent<NavMeshAgent>() : null;
        if (!p || !agent || !agent.isOnNavMesh) { Fail("player missing from baked navigation surface"); return; }
        if (stage == 0)
        {
            start = p.transform.position;
            if (!agent.SetDestination(new Vector3(-5, 0, -5))) { Fail("destination was rejected"); return; }
            stage = 1; until = EditorApplication.timeSinceStartup + 2; return;
        }
        if (stage == 1)
        {
            if (Vector3.Distance(start, p.transform.position) < .1f) { Fail("agent did not follow path"); return; }
            agent.ResetPath();
            start = p.transform.position;
            agent.Move(Vector3.right * .5f);
            if (Vector3.Distance(start, p.transform.position) < .1f || agent.hasPath) { Fail("manual movement or path cancellation failed"); return; }
            if (!GameObject.Find("Demo camera").GetComponent<DemoCamera>().target) { Fail("camera target missing"); return; }
            Debug.Log("MOVEMENT_SMOKE_PASS: navigation, path cancellation, manual agent movement, camera target");
            EditorApplication.Exit(0);
        }
    }
    static void Fail(string message) { Debug.LogError("MOVEMENT_SMOKE_FAIL: " + message); EditorApplication.Exit(1); }
}
