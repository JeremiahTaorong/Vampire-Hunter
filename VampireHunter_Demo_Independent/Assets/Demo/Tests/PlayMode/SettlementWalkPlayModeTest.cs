using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using UnityEngine.TestTools;

// Walks the whole prologue route in Play Mode with the real NavMeshAgent, real camera rig,
// real lighting and the real clue objects. Input is not simulated: this measures navigation,
// clearance, visibility and frame cost, not mouse/keyboard feel.
public class SettlementWalkPlayModeTest
{
    const string SceneName = "PrologueSettlement";
    const string OutDir = "Evidence/settlement-20261029";

    static readonly Vector2[] Route =
    {
        new Vector2(16f, 26.4f),   // village entrance / spawn
        new Vector2(45.5f, 24.8f), // square
        new Vector2(54.7f, 30.4f), // inn front
        new Vector2(75.4f, 35.6f), // witness lane
        new Vector2(92.2f, 31.0f), // missing scene
        new Vector2(103.1f, 25.6f),// drag marks
        new Vector2(112.1f, 23.9f),// forest entrance
        new Vector2(117.0f, 17.0f) // mentor mark
    };
    static readonly string[] RouteNames = { "spawn", "square", "inn", "witness", "missing", "dragmarks", "forest_entrance", "mentor" };

    static Vector3 Ref(float x, float z) => new Vector3(x - 60f, 0f, z - 32f);

    [UnityTest]
    public IEnumerator WalksPrologueRoute()
    {
        yield return SceneManager.LoadSceneAsync(SceneName, LoadSceneMode.Single);
        yield return null;
        yield return null;

        var dir = Path.Combine(Directory.GetParent(Application.dataPath).FullName, OutDir);
        Directory.CreateDirectory(dir);
        var log = new StringBuilder();
        log.AppendLine("scene=" + SceneName);
        log.AppendLine("unity=" + Application.unityVersion);
        log.AppendLine("time=" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
        log.AppendLine("mode=PlayMode, real NavMeshAgent.SetDestination; no simulated input");

        var player = GameObject.Find("Player");
        Assert.IsNotNull(player, "Player missing");
        var agent = player.GetComponent<NavMeshAgent>();
        Assert.IsNotNull(agent, "NavMeshAgent missing");
        Assert.IsTrue(agent.isOnNavMesh, "Player is not on the NavMesh at spawn");

        var cam = Camera.main;
        Assert.IsNotNull(cam, "Main camera missing");
        var rt = new RenderTexture(1280, 720, 24, RenderTextureFormat.ARGB32) { antiAliasing = 2 };
        rt.Create();
        cam.targetTexture = rt;

        int arrived = 0;
        for (int i = 1; i < Route.Length; i++)
        {
            Vector3 target = Ref(Route[i].x, Route[i].y);
            bool sampled = NavMesh.SamplePosition(target, out var hit, 6f, NavMesh.AllAreas);
            Assert.IsTrue(sampled, "No navmesh near " + RouteNames[i]);
            var path = new NavMeshPath();
            bool complete = NavMesh.CalculatePath(player.transform.position, hit.position, NavMesh.AllAreas, path)
                            && path.status == NavMeshPathStatus.PathComplete;
            Assert.IsTrue(complete, "No complete path to " + RouteNames[i]);

            float startTime = Time.time;
            agent.SetDestination(hit.position);
            float timeout = 70f;
            while (Time.time - startTime < timeout)
            {
                if (!agent.pathPending && agent.remainingDistance <= 1.6f) break;
                yield return null;
            }
            float elapsed = Time.time - startTime;
            float moved = Vector3.Distance(player.transform.position, hit.position);
            bool reached = moved <= 2.2f;
            log.AppendLine(string.Format("leg {0}: {1} in {2:F1}s, remaining={3:F2}m, reached={4}",
                RouteNames[i], moved > 0 ? "moved" : "stuck", elapsed, moved, reached));
            Assert.IsTrue(reached, "Did not reach " + RouteNames[i] + " (remaining " + moved.ToString("F2") + " m)");

            if (i == 1 || i == 3 || i == 6 || i == 7)
                yield return Capture(rt, dir + "/play_" + i + "_" + RouteNames[i] + ".png", log, RouteNames[i]);
            if (i == 1 || i == 6) yield return MeasureFps(log, RouteNames[i]);
            arrived++;
        }
        Assert.AreEqual(Route.Length - 1, arrived);

        // Clues must be where the walk expects them and wired to the investigation.
        var emblem = GameObject.Find("Evidence - hunter emblem");
        var witness = GameObject.Find("Witness");
        var trail = GameObject.Find("Trail clue anchor");
        var mentor = GameObject.Find("Mentor mark placeholder");
        Assert.IsNotNull(emblem, "emblem missing");
        Assert.IsNotNull(witness, "witness missing");
        Assert.IsNotNull(trail, "trail missing");
        Assert.IsNotNull(mentor, "mentor missing");
        log.AppendLine("clue_emblem=" + emblem.transform.position.ToString("F1"));
        log.AppendLine("clue_witness=" + witness.transform.position.ToString("F1"));
        log.AppendLine("clue_trail=" + trail.transform.position.ToString("F1"));
        log.AppendLine("clue_mentor=" + mentor.transform.position.ToString("F1"));

        Activate(emblem);
        Activate(witness);
        Activate(trail);
        var investigation = player.GetComponent("DemoInvestigation");
        Assert.IsNotNull(investigation, "DemoInvestigation missing on player");
        bool resolved = (bool)investigation.GetType().GetMethod("Resolve").Invoke(investigation, new object[] { true });
        Assert.IsTrue(resolved, "Investigation did not resolve after three clues");
        log.AppendLine("investigation_resolved=true");

        var enemy = GameObject.Find("Training enemy");
        Assert.IsNotNull(enemy, "enemy missing");
        Assert.IsTrue(enemy.activeSelf, "enemy did not activate after the forest conclusion");
        log.AppendLine("enemy_active=true");

        // The mentor mark belongs to the hunt stage; the walk already proved it is reachable.
        var light = GameObject.Find("Carried lantern");
        Assert.IsNotNull(light, "carried lantern missing");
        log.AppendLine("carried_light=" + (light.GetComponent<Light>() ? light.GetComponent<Light>().intensity.ToString("F1") : "none"));

        cam.targetTexture = null;
        rt.Release();
        UnityEngine.Object.Destroy(rt);
        File.WriteAllText(dir + "/play-walk.log", log.ToString());
        Debug.Log("SETTLEMENT_WALK_PASS\n" + log);
    }

    static void Activate(GameObject go)
    {
        var interactable = go.GetComponent("DemoInteractable");
        Assert.IsNotNull(interactable, "DemoInteractable missing on " + go.name);
        interactable.GetType().GetMethod("Activate").Invoke(interactable, null);
    }

    static IEnumerator MeasureFps(StringBuilder log, string label)
    {
        float start = Time.time;
        int frames = 0;
        while (Time.time - start < 2f) { frames++; yield return null; }
        log.AppendLine("fps_" + label + "=" + (frames / (Time.time - start)).ToString("F1"));
    }

    static IEnumerator Capture(RenderTexture rt, string path, StringBuilder log, string label)
    {
        yield return new WaitForEndOfFrame();
        RenderTexture.active = rt;
        var tex = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        tex.Apply();
        File.WriteAllBytes(path, tex.EncodeToPNG());

        var pixels = tex.GetPixels();
        float sum = 0f; int dark = 0; int samples = 0;
        for (int i = 0; i < pixels.Length; i += 7)
        {
            float l = .2126f * pixels[i].r + .7152f * pixels[i].g + .0722f * pixels[i].b;
            sum += l;
            if (l < .02f) dark++;
            samples++;
        }
        log.AppendLine("brightness_" + label + "=" + (sum / Mathf.Max(1, samples)).ToString("F3")
            + " dark_fraction=" + (dark / (float)Mathf.Max(1, samples)).ToString("F2"));
        RenderTexture.active = null;
        UnityEngine.Object.Destroy(tex);
    }
}
