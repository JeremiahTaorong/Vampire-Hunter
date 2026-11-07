using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.AI;

// Added only by the explicit editor verification command; removed after testing.
public class BloodClueProbe : MonoBehaviour
{
    public bool requireArm = true;
    IEnumerator Start()
    {
        const string output = "Evidence/blood-clue-20261106/";
        var log = new StringBuilder();
        log.AppendLine("mode=real Unity Play Mode; real NavMeshAgent and BeginInteraction; no OS mouse/keyboard simulation");
        log.AppendLine("unity=" + Application.unityVersion + " platform=" + Application.platform);
        log.AppendLine("run_at_utc=" + DateTime.UtcNow.ToString("O") + " scene=" + gameObject.scene.path);
        log.AppendLine("scope=" + (requireArm ? "blood-and-arm integration" : "blood-only integration; arm deferred by user"));
        bool errors = false;
        Application.LogCallback callback = (condition, trace, type) =>
        {
            if (type == LogType.Error || type == LogType.Exception || type == LogType.Assert)
            { errors = true; log.AppendLine(type + ": " + condition + "\n" + trace); }
        };
        Application.logMessageReceived += callback;
        yield return new WaitForSeconds(1);
        var clue = FindObjectsOfType<DemoInteractable>().Single(c => c.clueId == "trail");
        var movement = GetComponent<DemoMovement>();
        var investigation = GetComponent<DemoInvestigation>();
        var agent = GetComponent<NavMeshAgent>();
        var cam = movement.viewCamera;
        Vector3 target = clue.transform.position;
        bool sample = NavMesh.SamplePosition(target + new Vector3(-5, 0, -2), out var start, 5, NavMesh.AllAreas);
        bool warp = sample && agent.Warp(start.position);
        log.AppendLine("startSample=" + sample + " warp=" + warp + " initialHasTrail=" + investigation.HasTrail);
        yield return new WaitForSeconds(1);
        var ray = cam.ScreenPointToRay(cam.WorldToScreenPoint(target + Vector3.up * .7f));
        bool hit = Physics.Raycast(ray, out var selected, 100);
        bool selectable = hit && selected.collider.GetComponent<DemoInteractable>() == clue;
        log.AppendLine("raycastSelectable=" + selectable + " hit=" + (hit ? selected.collider.name : "none"));
        var visuals = clue.transform.Find("Blood evidence visuals");
        var renderers = visuals.GetComponentsInChildren<Renderer>();
        bool materials = renderers.All(r => r.sharedMaterials.All(m => m && m.shader && m.shader.isSupported));
        log.AppendLine("visualRenderers=" + renderers.Length + " allShadersSupported=" + materials);
        bool armPresent = visuals.GetComponentsInChildren<Transform>().Any(t => t.name.StartsWith("Severed Arm"));
        log.AppendLine("armPresent=" + armPresent);
        movement.BeginInteraction(clue);
        float began = Time.time;
        while (!clue.examined && Time.time - began < 30) yield return null;
        var marker = clue.GetComponent<TrailClueMarker>();
        yield return null;
        bool badgeHidden = marker && !marker.badge.gameObject.activeSelf;
        log.AppendLine("examined=" + clue.examined + " HasTrail=" + investigation.HasTrail + " badgeHidden=" + badgeHidden);
        log.AppendLine("path=" + agent.pathStatus + " approachSeconds=" + (Time.time - began).ToString("F2") + " playerDistance=" + Vector3.Distance(transform.position, target));
        Capture(cam, output + "gameplay.png");
        var follow = cam.GetComponent<DemoCamera>();
        if (follow) follow.enabled = false;
        cam.transform.position = target + new Vector3(-2.5f, 3.7f, -4.6f);
        cam.transform.LookAt(target + new Vector3(.3f, .1f, 0));
        yield return new WaitForSeconds(.5f);
        Capture(cam, output + "detail.png");
        bool passed = sample && warp && selectable && materials && (!requireArm || armPresent) && clue.examined && investigation.HasTrail && badgeHidden && !errors;
        log.AppendLine("result=" + (passed ? "PASS" : "FAIL") + " exit_code=" + (passed ? 0 : 1));
        Application.logMessageReceived -= callback;
        File.WriteAllText(output + "playmode.txt", log.ToString());
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }
    static void Capture(Camera camera, string path)
    {
        var previous = camera.targetTexture;
        var active = RenderTexture.active;
        var rt = new RenderTexture(1600, 900, 24);
        camera.targetTexture = rt;
        camera.Render();
        RenderTexture.active = rt;
        var image = new Texture2D(1600, 900, TextureFormat.RGB24, false);
        image.ReadPixels(new Rect(0, 0, 1600, 900), 0, 0);
        image.Apply();
        File.WriteAllBytes(path, image.EncodeToPNG());
        camera.targetTexture = previous;
        RenderTexture.active = active;
        Destroy(image); rt.Release(); Destroy(rt);
    }
}
