using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class InvestigationSmokeTest
{
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");
        EditorApplication.playModeStateChanged += state => {
            if (state != PlayModeStateChange.EnteredPlayMode) return;
            EditorApplication.delayCall += Check;
        };
        EditorApplication.isPlaying = true;
    }
    static void Check()
    {
        var p = GameObject.Find("Player");
        var a = p.GetComponent<DemoInvestigation>();
        var evidence = GameObject.Find("Evidence - hunter emblem").GetComponent<DemoInteractable>();
        var witness = GameObject.Find("Witness placeholder").GetComponent<DemoInteractable>();
        if (a.Resolve(true)) { Fail("conclusion allowed without clues"); return; }
        evidence.Activate(); evidence.Activate();
        if (!a.HasEvidence || a.HasWitness || a.Resolve(true)) { Fail("clue gating failed"); return; }
        witness.Activate();
        if (!a.HasWitness || a.Resolve(false) || a.Concluded || !a.WrongAttempt) { Fail("incorrect conclusion did not allow retry"); return; }
        if (!a.Resolve(true) || !a.Concluded) { Fail("correct conclusion failed"); return; }
        Debug.Log("INVESTIGATION_SMOKE_PASS: both clues, duplicate evidence, gated conclusion, wrong retry and forest conclusion");
        EditorApplication.Exit(0);
    }
    static void Fail(string message) { Debug.LogError("INVESTIGATION_SMOKE_FAIL: " + message); EditorApplication.Exit(1); }
}
