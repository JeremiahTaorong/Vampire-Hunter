using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

// Menu: Vampire Demo / Apply Forest Objective Lights
//
// Two jobs, in the order the user asked for them:
//   1. Strengthen the existing yellow lanterns in the scene.
//   2. Put a warm light on every objective the player has to reach inside the forest.
//
// The tool is idempotent: objective lights it creates are named and reused, so running it
// twice does not stack duplicate lights. Every change is registered with Undo.
public static class ForestObjectiveLights
{
    const string Scene = "Assets/Demo/Scenes/PrologueForestFinalReview.unity";
    const string LightName = "Objective warm light";
    const string OutDir = "Art_Direction/FinalReview";

    // The forest runs from the tree line at x≈2 to the mentor mark at x=50.
    const float ForestStartX = 1.5f;
    static readonly Color WarmColor = new Color(1f, 0.66f, 0.30f, 1f);
    const float ObjectiveIntensity = 2.6f;
    const float ObjectiveRange = 8f;
    const float ObjectiveHeight = 2.1f;
    const float ExistingWarmRadius = 3.5f;
    const float MaxLanternIntensity = 2.8f;

    [MenuItem("Vampire Demo/Apply Forest Objective Lights")]
    public static void Apply()
    {
        var active = EditorSceneManager.GetActiveScene();
        if (active.path != Scene)
        {
            // A modal save prompt would hang a batch run.
            if (!Application.isBatchMode && !EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo()) return;
            active = EditorSceneManager.OpenScene(Scene);
        }

        var report = new StringBuilder();
        report.AppendLine("scene=" + active.path);

        report.AppendLine("--- strengthened existing warm lights ---");
        foreach (var light in Object.FindObjectsOfType<Light>())
        {
            if (!IsWarm(light)) continue;
            if (light.gameObject.name == LightName) continue;
            Undo.RecordObject(light, "Strengthen warm light");
            // Saturate rather than keep multiplying, so re-running the menu item is safe.
            if (light.intensity < MaxLanternIntensity)
                light.intensity = Mathf.Min(light.intensity * 1.8f, MaxLanternIntensity);
            light.range = Mathf.Min(light.range * 1.2f, 26f);
            report.AppendLine(light.gameObject.name + " -> intensity=" + light.intensity.ToString("F2")
                              + " range=" + light.range.ToString("F2"));
        }

        report.AppendLine("--- objective lights in the forest ---");
        foreach (var target in FindForestObjectives())
        {
            var existing = target.transform.Find(LightName);
            Light light;
            if (existing)
            {
                light = existing.GetComponent<Light>();
                report.AppendLine("kept " + target.name + " at " + target.transform.position.ToString("F1"));
            }
            else if (HasWarmLightNear(target.transform.position))
            {
                // The mentor mark already owns a designed lantern; adding a second light on top
                // would double the exposure there.
                report.AppendLine("skipped " + target.name + " (existing warm light within " + ExistingWarmRadius + "m)");
                continue;
            }
            else
            {
                var go = new GameObject(LightName);
                Undo.RegisterCreatedObjectUndo(go, "Add objective light");
                go.transform.SetParent(target.transform, false);
                go.transform.position = target.transform.position + Vector3.up * ObjectiveHeight;
                light = Undo.AddComponent<Light>(go);
                report.AppendLine("added " + target.name + " at " + target.transform.position.ToString("F1"));
            }
            light.type = LightType.Point;
            light.color = WarmColor;
            light.intensity = ObjectiveIntensity;
            light.range = ObjectiveRange;
            light.shadows = LightShadows.None;
            light.renderMode = LightRenderMode.Auto;
        }

        EditorSceneManager.MarkSceneDirty(active);
        EditorSceneManager.SaveScene(active);
        AssetDatabase.SaveAssets();

        if (!Application.isPlaying) RenderPreviews(report);

        File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-objective-lights.log"), report.ToString());
        Debug.Log("[ObjectiveLights]\n" + report);
    }

    static bool HasWarmLightNear(Vector3 position)
    {
        foreach (var l in Object.FindObjectsOfType<Light>())
        {
            if (l.gameObject.name == LightName) continue;
            if (!IsWarm(l)) continue;
            if (Vector3.Distance(l.transform.position, position) <= ExistingWarmRadius) return true;
        }
        return false;
    }

    static bool IsWarm(Light l)
    {
        var c = l.color;
        return l.type != LightType.Directional && c.r > 0.9f && c.g < 0.8f && c.b < 0.55f && c.r > c.g && c.g > c.b;
    }

    // Everything the player must physically reach once inside the forest: interactables, the
    // enemy, and the named markers used by the prologue flow.
    static List<GameObject> FindForestObjectives()
    {
        var result = new List<GameObject>();
        var seen = new HashSet<int>();
        void Consider(GameObject go)
        {
            if (!go || go.transform.position.x < ForestStartX) return;
            if (!seen.Add(go.GetInstanceID())) return;
            result.Add(go);
        }

        foreach (var mb in Object.FindObjectsOfType<MonoBehaviour>())
        {
            var n = mb.GetType().Name;
            if (n == "DemoInteractable" || n == "DemoEnemy") Consider(mb.gameObject);
        }
        foreach (var name in new[]
                 {
                     "Forest checkpoint placeholder", "Mentor mark placeholder",
                     "Forest entrance north", "Forest entrance south",
                     "Castle vista marker",
                 })
        {
            var go = GameObject.Find(name);
            if (go) Consider(go);
        }
        return result;
    }

    static void RenderPreviews(StringBuilder report)
    {
        Directory.CreateDirectory(OutDir);
        var cam = GameObject.Find("Demo camera") != null ? GameObject.Find("Demo camera").GetComponent<Camera>() : null;
        if (!cam) { report.AppendLine("preview skipped: no Demo camera"); return; }

        var player = GameObject.Find("Player");
        var oldPlayer = player ? player.transform.position : Vector3.zero;
        var oldCam = cam.transform.position;
        var oldRot = cam.transform.rotation;
        cam.allowMSAA = true;

        var shots = new (string name, Vector3 player, Vector3 offset)[]
        {
            ("lights_01_spawn", new Vector3(20, 1, 0), new Vector3(0, 10, -10)),
            ("lights_02_path", new Vector3(30, 1, 0), new Vector3(0, 10, -10)),
            ("lights_03_walklevel", new Vector3(26, 1, 0), new Vector3(0, 6.2f, -8.6f)),
            ("lights_04_checkpoint", new Vector3(8, 1, 0), new Vector3(0, 7f, -9f)),
            ("lights_05_mentor", new Vector3(50, 1, 0), new Vector3(0, 7f, -9f)),
            ("lights_06_entrance", new Vector3(3, 1, 0), new Vector3(0, 7f, -9f)),
        };
        foreach (var s in shots)
        {
            if (player) player.transform.position = s.player;
            cam.transform.position = s.player + s.offset;
            cam.transform.rotation = Quaternion.LookRotation(s.player + Vector3.up * 0.9f - cam.transform.position);
            var file = Path.Combine(OutDir, s.name + ".png");
            Render(cam, file, 1600, 900, 4);
            report.AppendLine("render " + file);
        }

        if (player) player.transform.position = oldPlayer;
        cam.transform.position = oldCam;
        cam.transform.rotation = oldRot;
        EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
    }

    static void Render(Camera cam, string path, int w, int h, int msaa)
    {
        var rt = new RenderTexture(w, h, 24, RenderTextureFormat.ARGB32) { antiAliasing = msaa };
        rt.Create();
        cam.targetTexture = rt;
        cam.Render();
        RenderTexture.active = rt;
        var img = new Texture2D(w, h, TextureFormat.RGB24, false);
        img.ReadPixels(new Rect(0, 0, w, h), 0, 0);
        img.Apply();
        File.WriteAllBytes(path, img.EncodeToPNG());
        cam.targetTexture = null;
        RenderTexture.active = null;
        Object.DestroyImmediate(rt);
        Object.DestroyImmediate(img);
    }
}
