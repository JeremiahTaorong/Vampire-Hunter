using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public static class CombatLoopSmokeTest
{
    static int stage;
    static double until;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");
        EditorApplication.playModeStateChanged += state => {
            if (state == PlayModeStateChange.EnteredPlayMode) { until = EditorApplication.timeSinceStartup + 2; EditorApplication.update += Tick; }
        };
        EditorApplication.isPlaying = true;
    }
    static void Tick()
    {
        if (EditorApplication.timeSinceStartup < until) return;
        var player = GameObject.Find("Player");
        var enemy = GameObject.Find("Training enemy");
        if (!player || !enemy) { Fail("missing test objects"); return; }
        var hp = player.GetComponent<DemoHealth>();
        if (stage == 0)
        {
            var nav = enemy.GetComponent<NavMeshAgent>();
            if (!nav.isOnNavMesh || !nav.Warp(new Vector3(0,0,-3.8f))) { Fail("cannot place enemy"); return; }
            stage = 1; until = EditorApplication.timeSinceStartup + 3; return;
        }
        if (stage == 1)
        {
            if (hp.Health >= hp.maxHealth || hp.IsDead) { Fail("enemy did not damage player"); return; }
            hp.TakeDamage(1000);
            if (!hp.IsDead) { Fail("defeat did not trigger"); return; }
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
            stage = 2; until = EditorApplication.timeSinceStartup + 2; return;
        }
        if (hp.IsDead || hp.Health != hp.maxHealth) { Fail("retry did not restore player"); return; }
        enemy.GetComponent<DemoEnemy>().TakeDamage(1000);
        if (!hp.Victory || enemy.activeSelf) { Fail("victory did not trigger"); return; }
        Debug.Log("COMBAT_LOOP_PASS: enemy attack, player damage, defeat, scene reload and victory");
        EditorApplication.Exit(0);
    }
    static void Fail(string why) { Debug.LogError("COMBAT_LOOP_FAIL: " + why); EditorApplication.Exit(1); }
}
