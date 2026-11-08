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
            var evidence = GameObject.Find("Evidence - hunter emblem");
            if (!evidence) { Fail("evidence missing"); return; }
            p.GetComponent<DemoMovement>().BeginInteraction(evidence.GetComponent<DemoInteractable>());
            stage = 2; until = EditorApplication.timeSinceStartup + 7; return;
        }
        if (stage == 2)
        {
            var evidence = GameObject.Find("Evidence - hunter emblem").GetComponent<DemoInteractable>();
            if (!evidence.examined) { Fail("evidence did not activate after approaching"); return; }
            var target = GameObject.Find("Training enemy").GetComponent<DemoEnemy>();
            p.GetComponent<DemoMovement>().SelectEnemy(target);
            stage = 3; until = EditorApplication.timeSinceStartup + 3; return;
        }
        if (stage == 3)
        {
            var target = GameObject.Find("Training enemy");
            if (!target) { Fail("target missing too early"); return; }
            var enemy = target.GetComponent<DemoEnemy>();
            var controller = p.GetComponent<DemoMovement>();
            controller.TakeManualControl();
            if (controller.Target != enemy || agent.hasPath) { Fail("manual takeover did not retain target and cancel path"); return; }
            stage = 4; until = EditorApplication.timeSinceStartup + 4; return;
        }
        if (stage == 4)
        {
            var controller = p.GetComponent<DemoMovement>();
            if (!controller.Target || controller.Target.Health >= controller.Target.maxHealth) { Fail("target was not attacked"); return; }
            Debug.Log("MOVEMENT_SMOKE_PASS: navigation, interaction, pursuit, automatic damage and manual target retention");
            EditorApplication.Exit(0);
        }
    }
    static void Fail(string message) { Debug.LogError("MOVEMENT_SMOKE_FAIL: " + message); EditorApplication.Exit(1); }
}
