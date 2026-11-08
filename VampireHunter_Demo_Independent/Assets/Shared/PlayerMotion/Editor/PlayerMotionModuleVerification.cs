using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public static class PlayerMotionModuleVerification
{
    static DemoMovement movement;
    static DemoHealth health;
    static HunterGameplayAnimator animation;
    static HunterTorchPose torch;
    static NavMeshAgent agent;
    static DemoEnemy target;
    static Vector3 start, dodgeStart;
    static float began;
    static double deadline;
    static int stage, chapter;
    static string checks = "";
    static AsyncOperation loading;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene(PlayerMotionModuleTools.ChapterA);
        EditorApplication.playModeStateChanged += state => {
            if (state != PlayModeStateChange.EnteredPlayMode) return;
            deadline = EditorApplication.timeSinceStartup + 80;
            Cache();
            EditorApplication.update += Tick;
        };
        EditorApplication.isPlaying = true;
    }
    static void Cache()
    {
        movement = UnityEngine.Object.FindObjectOfType<DemoMovement>();
        health = movement.GetComponent<DemoHealth>();
        animation = movement.GetComponent<HunterGameplayAnimator>();
        torch = movement.GetComponent<HunterTorchPose>();
        agent = movement.GetComponent<NavMeshAgent>();
        target = UnityEngine.Object.FindObjectsOfType<DemoEnemy>(true).Single();
        start = movement.transform.position;
        began = Time.time;
    }
    static void Check(bool passed, string message)
    {
        if (!passed) throw new Exception("Chapter " + (chapter + 1) + ": " + message);
        string line = "PASS Chapter " + (chapter + 1) + ": " + message;
        checks += line + "\n";
        Debug.Log("SHARED PLAYER " + line);
    }
    static void Tick()
    {
        try
        {
            if (EditorApplication.timeSinceStartup > deadline) throw new Exception("Shared player test timed out: " + chapter + "/" + stage);
            if (stage == 5)
            {
                if (loading == null || !loading.isDone || SceneManager.GetActiveScene().path != PlayerMotionModuleTools.ChapterB) return;
                Cache(); stage = 0; return;
            }
            if (!movement || Time.time - began < .25f) return;
            if (stage == 0)
            {
                var binding = movement.GetComponent<SharedPlayerChapterBinding>();
                Check(binding && binding.chapterCamera == Camera.main && movement.viewCamera == Camera.main && Camera.main.GetComponent<DemoCamera>().target == movement.transform, "chapter camera auto-binding");
                Check(!movement.GetComponent<DemoPrologueFlow>() && !movement.GetComponent<DemoInvestigation>(), "no prologue quest or evidence state on player");
                Check(agent.isOnNavMesh, "shared player registered on this chapter NavMesh");
                Check(Mathf.Abs(movement.dodgeDuration - .8f) < .001f, "existing 0.8 second roll configuration retained");
                Check(agent.SetDestination(start + Vector3.forward * 2.5f), "click-navigation motor accepts chapter path");
                stage = 1;
            }
            else if (stage == 1 && Vector3.Distance(start, movement.transform.position) > .7f)
            {
                Check(animation.CurrentVisualState == "Run", "actual navigation movement drives Run animation");
                movement.TakeManualControl();
                dodgeStart = movement.transform.position;
                Check(movement.TryDodge(Vector3.right), "existing dodge API starts roll");
                began = Time.time; stage = 2;
            }
            else if (stage == 2 && Time.time - began > .2f)
            {
                Check(movement.IsDodging && animation.CurrentVisualState == "Dodge", "slow roll animation active during dodge");
                stage = 3;
            }
            else if (stage == 3 && !movement.IsDodging)
            {
                Check(Vector3.Distance(dodgeStart, movement.transform.position) > 1.8f, "roll moves player without root motion");
                movement.SelectEnemy(target);
                stage = 4;
            }
            else if (stage == 4 && target.Health < target.maxHealth)
            {
                if (animation.CurrentVisualState != "Attack") return;
                Check(target.Health <= target.maxHealth - 10, "same automatic melee attack and damage path");
                Check(torch && torch.Grip && torch.Weight > .9f, "left-hand torch remains active during attack");
                Check(!animation.animator.applyRootMotion, "navigation remains movement authority");
                Capture("chapter-" + (chapter + 1) + ".png");
                movement.TakeManualControl(); movement.enabled = false;
                health.TakeDamage(5); began = Time.time; stage = 6;
            }
            else if (stage == 6 && Time.time - began > .12f)
            {
                Check(animation.CurrentVisualState == "Hit", "existing damage feedback drives Hit animation");
                health.TakeDamage(1000); stage = 7;
            }
            else if (stage == 7 && health.IsDead && animation.CurrentVisualState == "Death")
            {
                Check(animation.CurrentVisualState == "Death", "existing defeat drives Death animation");
                Capture("chapter-" + (chapter + 1) + "-death.png");
                if (chapter == 0)
                {
                    chapter = 1; stage = 5;
                    loading = EditorSceneManager.LoadSceneAsyncInPlayMode(PlayerMotionModuleTools.ChapterB, new LoadSceneParameters(LoadSceneMode.Single));
                }
                else
                {
                    File.WriteAllText(PlayerMotionModuleTools.Evidence + "playmode.txt", "Unity " + Application.unityVersion + " / " + Application.platform + "\nAPI-driven real Play Mode; same prefab instantiated independently in two chapter scenes, no synthetic WASD/mouse input.\n" + checks);
                    Debug.Log("SHARED PLAYER TWO CHAPTER VERIFICATION PASS");
                    EditorApplication.Exit(0);
                }
            }
        }
        catch (Exception ex)
        {
            File.WriteAllText(PlayerMotionModuleTools.Evidence + "failure.txt", checks + "\n" + ex);
            Debug.LogException(ex); EditorApplication.Exit(1);
        }
    }
    static void Capture(string file)
    {
        var camera = Camera.main;
        var old = camera.targetTexture;
        var active = RenderTexture.active;
        var target = new RenderTexture(1280, 900, 24);
        var png = new Texture2D(1280, 900, TextureFormat.RGB24, false);
        camera.targetTexture = target; camera.Render(); RenderTexture.active = target;
        png.ReadPixels(new Rect(0, 0, 1280, 900), 0, 0); png.Apply();
        File.WriteAllBytes(PlayerMotionModuleTools.Evidence + file, png.EncodeToPNG());
        camera.targetTexture = old; RenderTexture.active = active;
        UnityEngine.Object.DestroyImmediate(png); UnityEngine.Object.DestroyImmediate(target);
    }
}
