using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using Object = UnityEngine.Object;

// Renders the built settlement from fixed viewpoints and records geometry checks.
// This is evidence from the real URP scene, not a script-success claim.
public static class AuditSettlementScene
{
    const string ScenePath = BuildSettlementScene.ScenePath;
    const string OutDir = "Evidence/settlement-20261029";
    static Camera cam;

    public static void Run()
    {
        Directory.CreateDirectory(OutDir);
        var scene = EditorSceneManager.OpenScene(ScenePath);
        var terrain = Object.FindObjectOfType<Terrain>();
        var sb = new StringBuilder();
        sb.AppendLine("check\tvalue");

        // ---- top down, scene lighting ----
        cam = NewCamera("Audit camera");
        cam.orthographic = true;
        cam.orthographicSize = 32f;
        cam.transform.position = new Vector3(0, 95f, 0);
        cam.transform.rotation = Quaternion.Euler(90, 0, 0);
        cam.farClipPlane = 200f;
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(.015f, .02f, .03f);
        bool fog = RenderSettings.fog;
        RenderSettings.fog = false; // top-down comparison must not be hidden by the fog wall
        Shot("01_topdown_scene_lighting.png", 1600, 854);
        RenderSettings.fog = fog;

        // ---- top down, neutral layout light ----
        var savedAmbient = RenderSettings.ambientMode;
        var savedSky = RenderSettings.ambientLight;
        var savedSkybox = RenderSettings.skybox;
        RenderSettings.fog = false;
        RenderSettings.skybox = null;
        RenderSettings.ambientMode = AmbientMode.Flat;
        RenderSettings.ambientLight = new Color(.55f, .57f, .6f);
        var sun = NewLight("Audit sun", new Color(1f, .97f, .92f), 1.35f, Quaternion.Euler(56, 38, 0));
        var fill = NewLight("Audit fill", new Color(.7f, .78f, .9f), .5f, Quaternion.Euler(48, -150, 0));
        Shot("02_topdown_layout.png", 1600, 854);

        // Angled overview and a village close-up, closer to how the reference image is framed.
        cam.orthographic = false;
        cam.fieldOfView = 32f;
        cam.transform.position = new Vector3(2f, 52f, -44f);
        cam.transform.LookAt(new Vector3(0f, 0f, -2f));
        Shot("02b_overview_angled.png", 1600, 900);

        cam.orthographic = true;
        cam.orthographicSize = 17f;
        cam.transform.position = new Vector3(-14f, 60f, -7.5f);
        cam.transform.rotation = Quaternion.Euler(90, 0, 0);
        Shot("02c_village_closeup.png", 1100, 640);
        cam.transform.position = new Vector3(48f, 60f, -8f);
        Shot("02d_forest_entrance_closeup.png", 1100, 640);
        cam.orthographic = true;
        cam.orthographicSize = 32f;
        cam.transform.position = new Vector3(0, 95f, 0);
        cam.transform.rotation = Quaternion.Euler(90, 0, 0);
        Object.DestroyImmediate(sun.gameObject);
        Object.DestroyImmediate(fill.gameObject);
        RenderSettings.fog = fog;
        RenderSettings.skybox = savedSkybox;
        RenderSettings.ambientMode = savedAmbient;
        RenderSettings.ambientLight = savedSky;

        // ---- eye level views ----
        cam.orthographic = false;
        cam.fieldOfView = 55f;
        cam.clearFlags = CameraClearFlags.Skybox;
        Vector3[] targets =
        {
            BuildSettlementScene.P(16f, 26.4f),   // village entrance
            BuildSettlementScene.P(40f, 24f),     // square approach
            BuildSettlementScene.P(50f, 30f),     // inn
            BuildSettlementScene.P(70f, 32f),     // witness lane
            BuildSettlementScene.P(100f, 28f),    // drag marks
            BuildSettlementScene.P(112f, 23.9f),  // forest entrance
        };
        string[] names = { "03_eye_entrance", "04_eye_square", "05_eye_inn", "06_eye_witness", "07_eye_dragmarks", "08_eye_forest_entrance" };
        for (int i = 0; i < targets.Length; i++)
        {
            Vector3 t = targets[i];
            t.y = terrain.SampleHeight(t) + 1.4f;
            cam.transform.position = t + new Vector3(0, 8.2f, -8.2f);
            cam.transform.LookAt(t + new Vector3(0, 1.0f, 2.4f));
            Shot(names[i] + ".png", 1280, 720);
        }

        // ---- per building elevation ----
        var buildings = GameObject.FindObjectsOfType<Transform>();
        foreach (var b in buildings)
        {
            if (!b.name.StartsWith("B0") && !b.name.StartsWith("B1")) continue;
            var door = b.Find("door");
            if (!door) continue;
            var rs = b.GetComponentsInChildren<Renderer>();
            if (rs.Length == 0) continue;
            Bounds bb = rs[0].bounds;
            foreach (var r in rs) bb.Encapsulate(r.bounds);
            float ground = terrain.SampleHeight(bb.center);
            Vector3 dir = door.forward;
            cam.transform.position = bb.center + dir * (Mathf.Max(bb.size.x, bb.size.z) * 1.5f + 4f) + Vector3.up * (bb.size.y * .45f);
            cam.transform.LookAt(bb.center);
            Shot("10_" + b.name.Split(' ')[0] + "_door.png", 800, 600);

            sb.AppendLine(b.name.Split(' ')[0] + "_upright\t" + (Mathf.Abs(b.eulerAngles.x) < .1f && Mathf.Abs(b.eulerAngles.z) < .1f));
            sb.AppendLine(b.name.Split(' ')[0] + "_ground_gap\t" + (bb.min.y - ground).ToString("F3"));
            sb.AppendLine(b.name.Split(' ')[0] + "_height\t" + bb.size.y.ToString("F2"));
            sb.AppendLine(b.name.Split(' ')[0] + "_door_world\t" + door.position.ToString("F1"));
        }

        // ---- route clearance / nav ----
        var player = GameObject.Find("Player");
        if (player)
        {
            var agent = player.GetComponent<UnityEngine.AI.NavMeshAgent>();
            sb.AppendLine("player_on_navmesh\t" + (agent && agent.isOnNavMesh));
            var path = new UnityEngine.AI.NavMeshPath();
            Vector3 start = player.transform.position;
            Vector3[] route =
            {
                BuildSettlementScene.P(46f, 24.6f), BuildSettlementScene.P(71f, 38.4f),
                BuildSettlementScene.P(92f, 30.6f), BuildSettlementScene.P(112f, 23.9f),
                BuildSettlementScene.P(117f, 17f)
            };
            string[] routeNames = { "square", "witness", "trail", "forest_entrance", "mentor" };
            for (int i = 0; i < route.Length; i++)
            {
                Vector3 target = route[i];
                bool sampled = UnityEngine.AI.NavMesh.SamplePosition(target, out var hit, 4f, UnityEngine.AI.NavMesh.AllAreas);
                bool complete = sampled && UnityEngine.AI.NavMesh.CalculatePath(start, hit.position, UnityEngine.AI.NavMesh.AllAreas, path)
                                && path.status == UnityEngine.AI.NavMeshPathStatus.PathComplete;
                float length = 0f;
                if (complete) for (int p = 1; p < path.corners.Length; p++) length += Vector3.Distance(path.corners[p - 1], path.corners[p]);
                sb.AppendLine("route_" + routeNames[i] + "\t" + (complete ? "complete " + length.ToString("F1") + "m" : "BLOCKED"));
            }
        }

        int trees = GameObject.FindObjectsOfType<Transform>().Length;
        sb.AppendLine("transforms\t" + trees);
        File.WriteAllText(OutDir + "/scene-audit.tsv", sb.ToString());
        Debug.Log("SETTLEMENT_AUDIT_DONE -> " + OutDir);
    }

    static Camera NewCamera(string name)
    {
        var go = new GameObject(name);
        var c = go.AddComponent<Camera>();
        c.nearClipPlane = .1f;
        c.farClipPlane = 200f;
        return c;
    }

    static Light NewLight(string name, Color color, float intensity, Quaternion rot)
    {
        var go = new GameObject(name);
        go.transform.rotation = rot;
        var l = go.AddComponent<Light>();
        l.type = LightType.Directional;
        l.color = color;
        l.intensity = intensity;
        return l;
    }

    static void Shot(string name, int w, int h)
    {
        var rt = new RenderTexture(w, h, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.sRGB);
        cam.targetTexture = rt;
        cam.Render();
        RenderTexture.active = rt;
        var tex = new Texture2D(w, h, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, w, h), 0, 0);
        tex.Apply();
        File.WriteAllBytes(OutDir + "/" + name, tex.EncodeToPNG());
        cam.targetTexture = null;
        RenderTexture.active = null;
        Object.DestroyImmediate(rt);
        Object.DestroyImmediate(tex);
    }
}
