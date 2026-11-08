using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class ZombieIntegrationVerification
{
    static DemoEnemy enemy;
    static DemoZombieVisual visual;
    static DemoPrologueFlow flow;
    static DemoMovement movement;
    static DemoHealth health;
    static NavMeshAgent enemyAgent, playerAgent;
    static EvidenceInspection inspection;
    static Vector3 start, retreat;
    static float pauseTime, pauseAnimation, missedAt;
    static double deadline, pausedAt;
    static int stage, healthBeforeMiss;
    static string checks = "";
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        var scene = EditorSceneManager.OpenScene(ZombieSceneIntegration.ScenePath);
        EditorApplication.playModeStateChanged += state => {
            if (state != PlayModeStateChange.EnteredPlayMode) return;
            flow = UnityEngine.Object.FindObjectOfType<DemoPrologueFlow>();
            movement = flow.GetComponent<DemoMovement>();
            health = flow.GetComponent<DemoHealth>();
            enemy = flow.enemy.GetComponent<DemoEnemy>();
            visual = enemy.GetComponent<DemoZombieVisual>();
            enemyAgent = enemy.GetComponent<NavMeshAgent>();
            playerAgent = movement.GetComponent<NavMeshAgent>();
            inspection = UnityEngine.Object.FindObjectsOfType<EvidenceInspection>().First(i => i.GetComponent<DemoInteractable>().clueId == "emblem");
            deadline = EditorApplication.timeSinceStartup + 100;
            pausedAt = EditorApplication.timeSinceStartup;
            EditorApplication.update += Tick;
        };
        EditorApplication.isPlaying = true;
    }
    static void Check(bool passed, string message)
    {
        if (!passed) throw new Exception(message);
        checks += "PASS " + message + "\n";
        Debug.Log("ZOMBIE INTEGRATION CHECK PASS: " + message);
    }
    static Vector3 ReachableRetreat()
    {
        Vector3 origin = enemy.transform.position - Vector3.up * enemyAgent.baseOffset;
        for (int i = 0; i < 16; i++)
        {
            var direction = Quaternion.Euler(0, i * 22.5f, 0) * Vector3.forward;
            if (!NavMesh.SamplePosition(origin + direction * 4.2f, out var point, 1.5f, NavMesh.AllAreas)) continue;
            var path = new NavMeshPath();
            if (!enemyAgent.CalculatePath(point.position, path) || path.status != NavMeshPathStatus.PathComplete) continue;
            if (Vector3.Distance(origin, point.position) > 3.3f && Vector3.Distance(origin, point.position) < 5.6f) return point.position;
        }
        throw new Exception("Cannot find reachable forest combat test point");
    }
    static void Tick()
    {
        try
        {
            if (EditorApplication.timeSinceStartup > deadline) throw new Exception("Timeout at integration stage " + stage);
            if (!EditorApplication.isPlaying || !flow) return;
            if (stage == 0)
            {
                if (EditorApplication.timeSinceStartup - pausedAt < 1) return;
                Check(flow.Current == DemoPrologueFlow.Stage.Investigate && !enemy.gameObject.activeSelf, "investigation still gates enemy activation");
                Check(visual && visual.animator && !enemy.GetComponent<MeshRenderer>().enabled && enemy.GetComponent<CapsuleCollider>().enabled, "zombie visual replaces capsule; original target collider retained");
                Check(UnityEngine.Object.FindObjectsOfType<EvidenceInspection>().Count(i => i.displayModel && !string.IsNullOrEmpty(i.story)) == 2, "Windows badge and severed-arm inspection models and stories retained");
                flow.BeginHunt();
                movement.TakeManualControl();
                movement.enabled = false;
                Check(enemyAgent.isOnNavMesh, "original forest NavMesh agent activates");
                retreat = ReachableRetreat();
                Check(playerAgent.Warp(retreat), "player placed at reachable forest approach");
                start = enemy.transform.position;
                stage = 1;
            }
            else if (stage == 1 && Vector3.Distance(start, enemy.transform.position) > .45f)
            {
                Check(visual.animator.GetCurrentAnimatorStateInfo(0).IsName("Shamble"), "actual NavMesh pursuit drives shamble animation");
                Vector3 feet = visual.animator.transform.position;
                Check(NavMesh.SamplePosition(feet, out var point, .5f, NavMesh.AllAreas) && Mathf.Abs(feet.y - point.position.y) < .25f, "zombie visual feet aligned to forest navigation surface");
                Capture("pursuit-gameplay.png", movement.viewCamera);
                stage = 2;
            }
            else if (stage == 2 && enemy.PreparingAttack)
            {
                inspection.Open();
                pauseTime = Time.time;
                pauseAnimation = visual.animator.GetCurrentAnimatorStateInfo(0).normalizedTime;
                pausedAt = EditorApplication.timeSinceStartup;
                Check(EvidenceInspection.IsOpen && Time.timeScale == 0, "existing item inspection pauses combat");
                stage = 3;
            }
            else if (stage == 3 && EditorApplication.timeSinceStartup - pausedAt > .3)
            {
                Check(Mathf.Abs(Time.time - pauseTime) < .001f && health.Health == health.maxHealth, "grab damage does not advance while inspection is open");
                Check(Mathf.Abs(visual.animator.GetCurrentAnimatorStateInfo(0).normalizedTime - pauseAnimation) < .01f, "zombie animation pauses with inspection");
                inspection.Close();
                stage = 4;
            }
            else if (stage == 4 && health.Health < health.maxHealth)
            {
                Check(health.Health == health.maxHealth - 15, "grab contact applies existing 15 damage once");
                Check(visual.animator.GetCurrentAnimatorStateInfo(0).IsName("Bite"), "damage occurs during grab animation");
                Check(enemyAgent.isStopped, "enemy navigation stays planted during grab");
                Capture("grab-gameplay.png", movement.viewCamera);
                CaptureCloseup();
                stage = 5;
            }
            else if (stage == 5 && !enemy.PreparingAttack) stage = 6;
            else if (stage == 6 && enemy.PreparingAttack)
            {
                healthBeforeMiss = health.Health;
                retreat = ReachableRetreat();
                Check(playerAgent.Warp(retreat), "target retreats during next grab windup");
                Check(Vector3.Distance(playerAgent.transform.position, enemy.transform.position) > 3f, "retreat moves clear of current enemy position");
                missedAt = Time.time + enemy.windup + .15f;
                stage = 7;
            }
            else if (stage == 7 && Time.time > missedAt)
            {
                Check(health.Health == healthBeforeMiss, "leaving grab range avoids damage");
                Check(NavMesh.SamplePosition(flow.checkpoint.position, out var point, 3, NavMesh.AllAreas) && playerAgent.Warp(point.position), "existing checkpoint remains reachable");
                stage = 8;
            }
            else if (stage == 8 && flow.CheckpointActive)
            {
                enemy.TakeDamage(10);
                health.TakeDamage(1000);
                Check(health.IsDead, "existing player defeat still triggers");
                Check(flow.RetryAtCheckpoint(), "existing checkpoint retry succeeds");
                Check(health.Health == health.maxHealth && enemy.Health == enemy.maxHealth && enemy.gameObject.activeSelf, "retry restores hunter and zombie health");
                Check(!enemy.PreparingAttack && !enemyAgent.isStopped && visual.animator.GetCurrentAnimatorStateInfo(0).IsName("Idle"), "retry clears grab and restores animation/navigation");
                movement.SelectEnemy(enemy);
                Check(movement.Target == enemy, "existing player targeting still selects the same enemy component");
                enemy.TakeDamage(1000);
                Check(!enemy.gameObject.activeSelf && flow.Current == DemoPrologueFlow.Stage.MentorClue && flow.mentorClue.activeSelf, "zombie death advances existing mentor clue flow");
                flow.DiscoverMentorClue();
                Check(flow.Current == DemoPrologueFlow.Stage.Complete && health.Victory, "existing prologue completion still succeeds");
                File.WriteAllText(ZombieSceneIntegration.EvidencePath + "playmode.txt", "Unity " + Application.unityVersion + " / " + Application.platform + "\nAPI-driven Play Mode on current settlement scene; no synthetic keyboard/mouse input.\n" + checks);
                Debug.Log("ZOMBIE INTEGRATION PLAYMODE PASS");
                EditorApplication.Exit(0);
            }
        }
        catch (Exception ex)
        {
            if (EvidenceInspection.Active) EvidenceInspection.Active.Close();
            File.WriteAllText(ZombieSceneIntegration.EvidencePath + "playmode-failure.txt", checks + "\n" + ex);
            Debug.LogException(ex);
            EditorApplication.Exit(1);
        }
    }
    static void CaptureCloseup()
    {
        var go = new GameObject("Temporary zombie review camera");
        var camera = go.AddComponent<Camera>();
        camera.CopyFrom(movement.viewCamera);
        camera.transform.position = enemy.transform.position + enemy.transform.right * 3.2f + enemy.transform.forward * 2.5f + Vector3.up * .8f;
        camera.transform.LookAt(enemy.transform.position + Vector3.up * .05f);
        camera.fieldOfView = 40;
        Capture("grab-closeup.png", camera);
        UnityEngine.Object.DestroyImmediate(go);
    }
    static void Capture(string file, Camera camera)
    {
        var oldTarget = camera.targetTexture;
        var oldActive = RenderTexture.active;
        var texture = new RenderTexture(1280, 900, 24);
        var png = new Texture2D(1280, 900, TextureFormat.RGB24, false);
        camera.targetTexture = texture;
        camera.Render();
        RenderTexture.active = texture;
        png.ReadPixels(new Rect(0, 0, 1280, 900), 0, 0);
        png.Apply();
        File.WriteAllBytes(ZombieSceneIntegration.EvidencePath + file, png.EncodeToPNG());
        camera.targetTexture = oldTarget;
        RenderTexture.active = oldActive;
        UnityEngine.Object.DestroyImmediate(png);
        UnityEngine.Object.DestroyImmediate(texture);
    }
}
