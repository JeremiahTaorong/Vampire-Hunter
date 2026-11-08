using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class ZombiePlayVerification
{
    static double deadline;
    static int stage;
    static float began;
    static Vector3 start;
    static int healthBeforeMiss;
    static Quaternion startLeg;
    static Transform leg;
    static ZombieValidationEnemy enemy;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Validation/ZombieFeasibility.unity");
        EditorApplication.playModeStateChanged += state => {
            if (state != PlayModeStateChange.EnteredPlayMode) return;
            enemy = UnityEngine.Object.FindObjectOfType<ZombieValidationEnemy>();
            start = enemy.transform.position;
            leg = enemy.animator.GetComponentsInChildren<Transform>().First(t => t.name == "thigh_l");
            startLeg = leg.localRotation;
            deadline = EditorApplication.timeSinceStartup + 35;
            began = Time.time;
            EditorApplication.update += Tick;
        };
        EditorApplication.isPlaying = true;
    }
    static void Require(bool result, string message)
    {
        if (!result) throw new Exception(message);
        Debug.Log("ZOMBIE CHECK PASS: " + message);
    }
    static void Tick()
    {
        try
        {
            if (EditorApplication.timeSinceStartup > deadline) throw new Exception("Play test timed out at stage " + stage);
            if (!EditorApplication.isPlaying || !enemy) return;
            if (stage == 0 && Time.time - began > 1)
            {
                Require(Vector3.Distance(start, enemy.transform.position) > .4f, "enemy moves toward target");
                Require(Quaternion.Angle(startLeg, leg.localRotation) > 1, "shamble animates leg bones");
                Require(enemy.animator.GetCurrentAnimatorStateInfo(0).IsName("Shamble"), "Shamble state active");
                Capture("Shamble-play.png");
                stage = 1;
            }
            else if (stage == 1 && enemy.landedBites == 1)
            {
                Require(enemy.targetHealth == 85, "bite applies exactly 15 damage at contact");
                Require(enemy.animator.GetCurrentAnimatorStateInfo(0).IsName("Bite"), "Bite state active");
                Capture("Bite-play.png");
                stage = 2;
            }
            else if (stage == 2 && !enemy.IsBiting) stage = 3;
            else if (stage == 3 && enemy.IsBiting)
            {
                healthBeforeMiss = enemy.targetHealth;
                enemy.target.position += Vector3.forward * 5;
                stage = 4;
            }
            else if (stage == 4 && !enemy.IsBiting)
            {
                Require(enemy.targetHealth == healthBeforeMiss && enemy.landedBites == 1, "target leaving range avoids bite damage");
                File.WriteAllText("Evidence/play-result.txt", "PASS: URP play mode; shamble movement and animated leg; Bite state; one contact causes 15 damage; target leaving range avoids next bite. Flat ground harness only; Demo untouched.");
                Debug.Log("ZOMBIE PLAY VERIFICATION PASS");
                EditorApplication.Exit(0);
            }
        }
        catch (Exception ex) { Debug.LogError("ZOMBIE PLAY VERIFICATION FAIL: " + ex); EditorApplication.Exit(1); }
    }
    public static void Capture(string file)
    {
        var cam = Camera.main;
        var rt = new RenderTexture(1280, 900, 24);
        cam.targetTexture = rt;
        cam.Render();
        RenderTexture.active = rt;
        var texture = new Texture2D(1280, 900, TextureFormat.RGB24, false);
        texture.ReadPixels(new Rect(0, 0, 1280, 900), 0, 0);
        texture.Apply();
        File.WriteAllBytes("Evidence/" + file, texture.EncodeToPNG());
        cam.targetTexture = null;
        RenderTexture.active = null;
        UnityEngine.Object.DestroyImmediate(texture);
        UnityEngine.Object.DestroyImmediate(rt);
    }
}
