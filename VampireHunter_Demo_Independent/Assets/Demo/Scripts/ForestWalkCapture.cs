using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.AI;

// Drives the real player agent along the forest path during Play Mode and records what the
// game camera sees plus the per-frame occlusion fade values. This is scripted walking, not
// human keyboard input: it exercises the same NavMeshAgent, camera LateUpdate and
// ForestCameraFade.LateUpdate that a player would, but cannot judge feel or input latency.
public class ForestWalkCapture : MonoBehaviour
{
    public static ForestWalkCapture Instance;

    // Entering Play Mode reloads the scene from disk, so an object created by an editor script
    // beforehand is destroyed. The probe therefore creates itself after the scene loads, gated
    // by an EditorPrefs flag the editor sets right before entering Play Mode.
    public const string PrefsKey = "VampireHunter.ForestWalkCapture";

    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
    static void Bootstrap()
    {
#if UNITY_EDITOR
        if (!UnityEditor.EditorPrefs.GetBool(PrefsKey, false)) return;
        UnityEditor.EditorPrefs.SetBool(PrefsKey, false);
        var cam = Camera.main;
        var root = GameObject.Find("Forest review - placed vegetation");
        if (!cam || !root) return;
        var go = new GameObject("ForestWalkCapture");
        var capture = go.AddComponent<ForestWalkCapture>();
        capture.Configure(cam, root.transform, DefaultPath, "Art_Direction/PlayModeCapture");
#endif
    }

    // A short stretch through the verge is enough to show the fade under motion.
    public static readonly Vector3[] DefaultPath =
    {
        new Vector3(20f, 1f, 0f),
        new Vector3(22.5f, 1f, 3.2f),
        new Vector3(26f, 1f, -2.6f),
    };

    public Camera gameCamera;
    public Transform vegetationRoot;
    public Vector3[] waypoints;
    public float shotInterval = 5f;
    public string outDir;

    public bool Finished { get; private set; }
    public string Failure { get; private set; }

    readonly List<string> log = new List<string>();
    NavMeshAgent agent;
    ForestCameraFade fade;
    MaterialPropertyBlock block;
    float travelled;
    int shotIndex;
    int flickerEvents;
    float lastMin = 1f;
    int frames;
    float minSeen = 1f;
    int occludedFrames;

    public void Configure(Camera cam, Transform root, Vector3[] path, string dir)
    {
        gameCamera = cam;
        vegetationRoot = root;
        waypoints = path;
        outDir = dir;
    }

    void Awake() { Instance = this; }

    void Start() { StartCoroutine(Run()); }

    IEnumerator Run()
    {
        var dir = Path.IsPathRooted(outDir)
            ? outDir
            : Path.Combine(Directory.GetParent(Application.dataPath).FullName, outDir);
        Directory.CreateDirectory(dir);
        outDir = dir;
        block = new MaterialPropertyBlock();
        var player = GameObject.Find("Player");
        if (!player) { Fail("player not found"); yield break; }
        agent = player.GetComponent<NavMeshAgent>();
        fade = gameCamera.GetComponent<ForestCameraFade>();
        if (!agent) { Fail("NavMeshAgent missing"); yield break; }
        if (!fade) { Fail("ForestCameraFade missing on camera"); yield break; }

        log.Add("walk_start player=" + player.transform.position.ToString("F2") + " time=" + Time.time.ToString("F2"));
        log.Add("waypoints=" + string.Join(" ", System.Array.ConvertAll(waypoints, w => w.ToString("F1"))));
        log.Add("navmesh_on_agent=" + agent.isOnNavMesh);

        var rt = new RenderTexture(1600, 900, 24, RenderTextureFormat.ARGB32) { antiAliasing = 4 };
        rt.Create();
        gameCamera.targetTexture = rt;

        for (int i = 0; i < waypoints.Length; i++)
        {
            if (!agent.isOnNavMesh) { Fail("agent left navmesh at " + player.transform.position); break; }
            agent.SetDestination(waypoints[i]);
            float guard = 0f;
            while (true)
            {
                if (!agent.pathPending && agent.remainingDistance <= agent.stoppingDistance + 0.5f) break;
                guard += Time.deltaTime;
                if (guard > 25f) { log.Add("timeout reaching wp" + i); break; }
                yield return null;
            }
            log.Add("reached wp" + i + " pos=" + player.transform.position.ToString("F2")
                    + " hp=" + DescribeHealth(player));
            yield return StartCoroutine(Shoot(rt, "walk_" + shotIndex++ + "_wp" + i));
        }

        gameCamera.targetTexture = null;
        rt.Release();
        Object.Destroy(rt);

        log.Add("frames=" + frames);
        log.Add("occluded_frames=" + occludedFrames + " (" + (frames > 0 ? 100f * occludedFrames / frames : 0f).ToString("F1") + "%)");
        log.Add("min_visibility_seen=" + minSeen.ToString("F3"));
        log.Add("fade_threshold_crossings=" + flickerEvents);
        log.Add("finished=true");
        Finished = true;
    }

    string DescribeHealth(GameObject player)
    {
        var h = player.GetComponent<DemoHealth>();
        return h ? h.ToString() : "n/a";
    }

    IEnumerator Shoot(RenderTexture rt, string name)
    {
        yield return new WaitForEndOfFrame();
        RenderTexture.active = rt;
        var img = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, false);
        img.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        img.Apply();
        File.WriteAllBytes(Path.Combine(outDir, name + ".png"), img.EncodeToPNG());
        Destroy(img);
        RenderTexture.active = null;
        log.Add("shot=" + name + " t=" + Time.time.ToString("F2"));
    }

    void Fail(string reason)
    {
        Failure = reason;
        log.Add("FAILED: " + reason);
        Finished = true;
    }

    // Sampled every frame so the fade can be judged as a time series rather than a single
    // "did the property change" check.
    void LateUpdate()
    {
        if (!fade || !vegetationRoot || block == null) return;
        frames++;
        float frameMin = 1f;
        int occluded = 0;
        foreach (var r in vegetationRoot.GetComponentsInChildren<Renderer>())
        {
            if (!r || !r.enabled) continue;
            r.GetPropertyBlock(block);
            float v = block.GetFloat("_Visibility");
            if (v <= 0f) v = 1f; // renderers the fade has not touched keep the material default
            if (v < frameMin) frameMin = v;
            if (v < 0.9f) occluded++;
        }
        if (occluded > 0) occludedFrames++;
        if (frameMin < minSeen) minSeen = frameMin;
        if (Mathf.Abs(frameMin - lastMin) > 0.35f) flickerEvents++;
        lastMin = frameMin;
    }

    public string Dump()
    {
        var sb = new StringBuilder();
        foreach (var l in log) sb.AppendLine(l);
        if (!string.IsNullOrEmpty(Failure)) sb.AppendLine("failure=" + Failure);
        return sb.ToString();
    }
}
