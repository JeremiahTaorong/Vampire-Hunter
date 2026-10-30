using System.Collections;
using System.IO;
using System.Text;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using UnityEngine.TestTools;

// Real Play Mode walk along a short stretch of the forest path. The camera rig, the camera's
// LateUpdate and ForestCameraFade's own LateUpdate all run unmodified; only the player's motion
// is scripted by moving its transform.
//
// The NavMeshAgent is disabled for this test: under the test runner it accepted a complete path
// but never advanced (pathPending stayed true for 25 s at speed 4), so driving it would have
// measured nothing. This test therefore does NOT validate navigation or pathing.
public class ForestWalkPlayModeTest
{
    const string SceneName = "PrologueForestFinalReview";
    const string OutDir = "Art_Direction/PlayModeCapture";
    const float WalkSpeed = 3.5f;

    static readonly Vector3[] WalkPath =
    {
        new Vector3(20f, 1f, 0f),
        new Vector3(22f, 1f, 2.6f),
        new Vector3(24.5f, 1f, 3.4f),
        new Vector3(27f, 1f, 1.2f),
    };

    [UnityTest]
    public IEnumerator WalksForestPathAndRecordsOcclusionFade()
    {
        yield return SceneManager.LoadSceneAsync(SceneName, LoadSceneMode.Single);

        var cam = Camera.main;
        Assert.IsNotNull(cam, "Main camera missing");
        var demoCamera = cam.GetComponent("DemoCamera");
        Assert.IsNotNull(demoCamera, "DemoCamera missing on the game camera");
        var targetField = demoCamera.GetType().GetField("target");
        var offsetField = demoCamera.GetType().GetField("offset");
        var rigTarget = targetField != null ? targetField.GetValue(demoCamera) as Transform : null;
        Assert.IsNotNull(rigTarget, "DemoCamera.target is not wired");

        var player = rigTarget.gameObject;
        var root = GameObject.Find("Forest review - placed vegetation");
        Assert.IsNotNull(root, "Vegetation root missing");
        Assert.IsNotNull(cam.GetComponent("ForestCameraFade"), "ForestCameraFade missing on the game camera");

        var agent = player.GetComponent<NavMeshAgent>();
        if (agent) agent.enabled = false;

        var dir = Path.Combine(Directory.GetParent(Application.dataPath).FullName, OutDir);
        Directory.CreateDirectory(dir);
        var log = new StringBuilder();
        log.AppendLine("scene=" + SceneName);
        log.AppendLine("unity=" + Application.unityVersion);
        log.AppendLine("movement=scripted transform, NavMeshAgent disabled (see class comment)");
        log.AppendLine("path=" + string.Join(" ", System.Array.ConvertAll(WalkPath, p => p.ToString("F1"))));

        var defaultOffset = offsetField != null ? (Vector3)offsetField.GetValue(demoCamera) : new Vector3(0, 10, -10);
        log.AppendLine("rig_offset=" + defaultOffset.ToString("F1"));

        yield return Walk(player, cam, root, dir, log, "rig", true, defaultOffset);

        // The shipped rig sits 10 m up, above the canopy, so it looks over the vegetation and the
        // fade has little to do. The second pass lowers the same rig to eye level so the effect
        // is actually exercised; the offset is restored afterwards and never saved to the scene.
        var lowOffset = new Vector3(0f, 5.2f, -8.2f);
        if (offsetField != null) offsetField.SetValue(demoCamera, lowOffset);
        log.AppendLine("--- second pass with lowered rig " + lowOffset.ToString("F1") + " ---");
        yield return Walk(player, cam, root, dir, log, "lowrig", true, lowOffset);
        if (offsetField != null) offsetField.SetValue(demoCamera, defaultOffset);

        File.WriteAllText(Path.Combine(Directory.GetParent(Application.dataPath).FullName,
            "Evidence", "forest-walk-playmode.log"), log.ToString());
    }

    IEnumerator Walk(GameObject player, Camera cam, GameObject root, string dir, StringBuilder log,
                    string tag, bool captureShots, Vector3 rigOffset)
    {
        player.transform.position = WalkPath[0];
        yield return null;

        var renderers = root.GetComponentsInChildren<Renderer>();
        var block = new MaterialPropertyBlock();
        var rt = new RenderTexture(1600, 900, 24, RenderTextureFormat.ARGB32) { antiAliasing = 4 };
        rt.Create();
        cam.targetTexture = rt;

        int frames = 0, occludedFrames = 0, crossings = 0, shot = 0;
        float minSeen = 1f, lastMin = 1f;
        float camLagMax = 0f;

        for (int wp = 1; wp < WalkPath.Length; wp++)
        {
            var target = WalkPath[wp];
            float guard = 0f;
            while (Vector3.Distance(player.transform.position, target) > 0.25f)
            {
                guard += Time.deltaTime;
                if (guard > 20f) { log.AppendLine(tag + " timeout_wp" + wp); break; }

                var flat = target - player.transform.position;
                flat.y = 0f;
                player.transform.position += flat.normalized * WalkSpeed * Time.deltaTime;

                float frameMin = 1f;
                int occluded = 0;
                foreach (var r in renderers)
                {
                    if (!r || !r.enabled) continue;
                    r.GetPropertyBlock(block);
                    float v = block.GetFloat("_Visibility");
                    if (v <= 0f) v = 1f;
                    if (v < frameMin) frameMin = v;
                    if (v < 0.9f) occluded++;
                }
                frames++;
                if (occluded > 0) occludedFrames++;
                if (frameMin < minSeen) minSeen = frameMin;
                if (Mathf.Abs(frameMin - lastMin) > 0.35f) crossings++;
                lastMin = frameMin;

                // WaitForEndOfFrame never fires in batch mode, so the render texture is read
                // one frame late instead; with a persistent target texture it always holds the
                // most recent rendered frame.
                yield return null;
                float lag = Vector3.Distance(cam.transform.position, player.transform.position + rigOffset);
                if (lag > camLagMax) camLagMax = lag;

                if (captureShots && frames % 45 == 0)
                {
                    RenderTexture.active = rt;
                    var img = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, false);
                    img.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
                    img.Apply();
                    File.WriteAllBytes(Path.Combine(dir, tag + "_" + (shot++).ToString("00") + ".png"), img.EncodeToPNG());
                    Object.Destroy(img);
                    RenderTexture.active = null;
                }
            }
            log.AppendLine(tag + " wp" + wp + " player=" + player.transform.position.ToString("F2"));
        }

        cam.targetTexture = null;
        rt.Release();
        Object.Destroy(rt);

        log.AppendLine(tag + " frames=" + frames + " occluded_frames=" + occludedFrames
                       + " (" + (frames > 0 ? (100f * occludedFrames / frames).ToString("F1") : "0") + "%)"
                       + " min_visibility=" + minSeen.ToString("F3")
                       + " step_crossings=" + crossings
                       + " max_horizontal_cam_lag=" + camLagMax.ToString("F2"));

        Assert.Greater(frames, 60, tag + ": walk too short to judge camera behaviour");
        Assert.Less(camLagMax, 0.35f, tag + ": camera did not follow the player");
    }
}
