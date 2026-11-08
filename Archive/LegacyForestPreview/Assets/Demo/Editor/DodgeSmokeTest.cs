using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class DodgeSmokeTest
{
    static int stage;
    static double until;
    static Vector3 start;
    static int initialHP;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");
        EditorApplication.playModeStateChanged += s => { if (s == PlayModeStateChange.EnteredPlayMode) { until = EditorApplication.timeSinceStartup + 2; EditorApplication.update += Tick; } };
        EditorApplication.isPlaying = true;
    }
    static void Tick()
    {
        if (EditorApplication.timeSinceStartup < until) return;
        var p = GameObject.Find("Player");
        if (!p) { Fail("player missing"); return; }
        var move = p.GetComponent<DemoMovement>(); var hp = p.GetComponent<DemoHealth>();
        if (stage == 0)
        {
            start = p.transform.position; initialHP = hp.Health;
            if (!move.TryDodge(Vector3.left) || !move.IsInvulnerable) { Fail("dodge did not start"); return; }
            hp.TakeDamage(10);
            if (hp.Health != initialHP || move.TryDodge(Vector3.left)) { Fail("invulnerability or cooldown failed"); return; }
            stage = 1; until = EditorApplication.timeSinceStartup + .6; return;
        }
        if (stage == 1)
        {
            if (Vector3.Distance(start,p.transform.position) < .1f || move.IsInvulnerable || move.IsDodging) { Fail("dodge movement or ending failed"); return; }
            hp.TakeDamage(10);
            if (hp.Health != initialHP-10) { Fail("damage remained blocked after invulnerability"); return; }
            stage = 2; until = EditorApplication.timeSinceStartup + .7; return;
        }
        if (!move.TryDodge(Vector3.right)) { Fail("cooldown did not expire"); return; }
        Debug.Log("DODGE_SMOKE_PASS: displacement, temporary invulnerability, damage after window, cooldown");
        EditorApplication.Exit(0);
    }
    static void Fail(string why) { Debug.LogError("DODGE_SMOKE_FAIL: " + why); EditorApplication.Exit(1); }
}
