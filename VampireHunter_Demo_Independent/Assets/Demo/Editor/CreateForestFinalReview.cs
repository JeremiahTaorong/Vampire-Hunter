using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

// Builds a NEW review scene from the previous one. The source scene is never modified,
// so PrologueForestAtmosphereReview.unity stays available as the before/after reference.
public static class CreateForestFinalReview
{
    const string Base = "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/";
    const string Source = "Assets/Demo/Scenes/PrologueForestAtmosphereReview.unity";
    const string Target = "Assets/Demo/Scenes/PrologueForestFinalReview.unity";
    const string TreeMatPath = "Assets/Demo/Atmosphere/ForestFoliage.mat";
    const string GroundMatPath = "Assets/Demo/Atmosphere/ForestGroundCover.mat";
    const string OutDir = "Art_Direction/FinalReview";

    public static void Build()
    {
        if (File.Exists(Target)) throw new Exception("Refusing to overwrite existing scene: " + Target);
        Directory.CreateDirectory(OutDir);

        var scene = EditorSceneManager.OpenScene(Source);
        if (!EditorSceneManager.SaveScene(scene, Target, true)) throw new Exception("Scene copy failed");
        scene = EditorSceneManager.OpenScene(Target);

        if (!Shader.Find("VampireDemo/ForestFoliageURP"))
            throw new Exception("missing ForestFoliageURP shader");

        var treeMat = EnsureMaterial(TreeMatPath, treeOptions: true);
        var groundMat = EnsureMaterial(GroundMatPath, treeOptions: false);

        var root = GameObject.Find("Forest review - placed vegetation");
        if (!root) throw new Exception("vegetation root not found");

        var report = new List<string>();
        report.Add("swapped_materials=" + SwapMaterials(root, treeMat, groundMat));
        report.Add("added_props=" + Densify(root.transform, treeMat, groundMat));
        report.AddRange(Relight());
        report.AddRange(RetuneFog());

        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();

        foreach (var line in RenderPreviews()) report.Add(line);

        var path = Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-final-review-build.log");
        File.WriteAllLines(path, report);
        foreach (var line in report) Debug.Log("[ForestFinal] " + line);
        Debug.Log("[ForestFinal] wrote " + path);
    }

    // Re-applies material and lighting to an already built review scene without rebuilding.
    public static void Tune()
    {
        var scene = EditorSceneManager.OpenScene(Target);
        var treeMat = EnsureMaterial(TreeMatPath, treeOptions: true);
        var groundMat = EnsureMaterial(GroundMatPath, treeOptions: false);
        var root = GameObject.Find("Forest review - placed vegetation");
        SwapMaterials(root, treeMat, groundMat);

        var report = new List<string>();
        report.Add("hidden_block_bushes=" + HideBlockBushes(root));
        report.AddRange(Relight());
        report.AddRange(RetuneFog());
        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();
        foreach (var line in RenderPreviews()) report.Add(line);
        File.WriteAllLines(Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-final-review-tune.log"), report);
        foreach (var line in report) Debug.Log("[ForestFinal] " + line);
    }

    // Original asset values are kept for the noise/structure terms. Base and noise colours
    // are pulled dark because the prologue target is a near-black scene: with the original
    // 0.647 grey base the canopy renders pale grey and reads as snow against the fog.
    static Material EnsureMaterial(string path, bool treeOptions)
    {
        var shader = Shader.Find("VampireDemo/ForestFoliageURP");
        var mat = AssetDatabase.LoadAssetAtPath<Material>(path);
        if (mat == null)
        {
            mat = new Material(shader) { name = Path.GetFileNameWithoutExtension(path) };
            AssetDatabase.CreateAsset(mat, path);
        }
        else mat.shader = shader;

        mat.SetColor("_NoiseColor", new Color(0.72f, 0.78f, 0.70f, 1));
        mat.SetFloat("_BaseNoiseAmount", 0.55f);
        mat.SetFloat("_ColorNoiseSteps", 900f);
        mat.SetFloat("_OpacityNoiseAmount", 0.5f);
        mat.SetFloat("_VtxColorAmount", 1f);
        mat.SetFloat("_VtxOpacity", -18.2f);
        mat.SetFloat("_AllOpacity", 2.1f);
        mat.SetColor("_Tint", new Color(1f, 1f, 1f, 1));
        mat.SetFloat("_AmbientBoost", 1f);
        mat.SetFloat("_ShadowWrap", 0.10f);
        mat.SetFloat("_ObjectNoiseBlend", 1f);
        mat.SetFloat("_ObjectNoiseScale", 700f);

        if (treeOptions)
        {
            mat.SetColor("_ColorBase", new Color(0.145f, 0.175f, 0.145f, 1));
            // The pack's 150 cells were tuned for viewing whole trees from a distance; close to
            // the trunk each cell covers many pixels and reads as a rectangular tile.
            mat.SetFloat("_OpacityNoiseSteps", 700f);
            mat.SetFloat("_Cutoff", 1.5f);
        }
        else
        {
            // Ground cover is near-flat geometry with only two alpha levels (0.675 rim, 1.0
            // interior), so it needs a tighter cell grid and a slightly higher cut to break
            // the rim into tufts instead of leaving a solid disc.
            mat.SetColor("_ColorBase", new Color(0.105f, 0.120f, 0.088f, 1));
            mat.SetFloat("_OpacityNoiseSteps", 900f);
            mat.SetFloat("_Cutoff", 1.56f);
        }
        EditorUtility.SetDirty(mat);
        return mat;
    }

    // Bush_block / Bush_block_solid are 26-vertex boxes used as distant filler. Seen from the
    // path they read as hard cubes, so the ones bordering the corridor are switched off. They
    // are deactivated, not deleted, so the scene can be compared against the original.
    static int HideBlockBushes(GameObject root)
    {
        int n = 0;
        foreach (var t in root.GetComponentsInChildren<Transform>(true))
        {
            if (!t.name.StartsWith("Bush_block", StringComparison.OrdinalIgnoreCase)) continue;
            if (Mathf.Abs(t.position.z) > 9f) continue;
            if (!t.gameObject.activeSelf) continue;
            t.gameObject.SetActive(false);
            n++;
        }
        return n;
    }

    static bool IsGroundCover(string name) =>
        name.StartsWith("GroundCover", StringComparison.OrdinalIgnoreCase);

    static int SwapMaterials(GameObject root, Material treeMat, Material groundMat)
    {
        int n = 0;
        foreach (var r in root.GetComponentsInChildren<Renderer>(true))
        {
            var mat = IsGroundCover(r.gameObject.name) ? groundMat : treeMat;
            r.sharedMaterials = Enumerable.Repeat(mat, Mathf.Max(1, r.sharedMaterials.Length)).ToArray();
            n++;
        }
        return n;
    }

    // The previous pass spread ~90 trees over a 43 x 40 area, which reads as scattered rather
    // than enclosing. This adds a dense outer band plus taller trunks close to the corridor,
    // keeping a path roughly 6 units wide so the route and the player stay legible.
    static int Densify(Transform root, Material treeMat, Material groundMat)
    {
        var rng = new System.Random(1187);
        var trees = Load("Trees");
        var bushes = Load("Bushes");
        var grass = Load("GroundCover");
        int count = 0;

        for (int i = 0; i < 70; i++)
        {
            float x = -4f + (float)rng.NextDouble() * 56f;
            float z = (rng.Next(2) == 0 ? -1f : 1f) * (12f + (float)rng.NextDouble() * 14f);
            Place(trees[rng.Next(trees.Length)], root, x, z, 1.15f + (float)rng.NextDouble() * 0.9f, treeMat, rng);
            count++;
        }
        for (int i = 0; i < 44; i++)
        {
            float x = 2f + (float)rng.NextDouble() * 42f;
            float z = (rng.Next(2) == 0 ? -1f : 1f) * (7.5f + (float)rng.NextDouble() * 4f);
            Place(trees[rng.Next(trees.Length)], root, x, z, 0.95f + (float)rng.NextDouble() * 0.55f, treeMat, rng);
            count++;
        }
        for (int i = 0; i < 120; i++)
        {
            float x = -2f + (float)rng.NextDouble() * 50f;
            float z = (rng.Next(2) == 0 ? -1f : 1f) * (5.5f + (float)rng.NextDouble() * 16f);
            Place(bushes[rng.Next(bushes.Length)], root, x, z, 0.8f + (float)rng.NextDouble() * 0.7f, treeMat, rng);
            count++;
        }
        for (int i = 0; i < 150; i++)
        {
            float x = -2f + (float)rng.NextDouble() * 50f;
            float z = (rng.Next(2) == 0 ? -1f : 1f) * (4.6f + (float)rng.NextDouble() * 17f);
            Place(grass[rng.Next(grass.Length)], root, x, z, 0.75f + (float)rng.NextDouble() * 0.7f, groundMat, rng);
            count++;
        }
        // Verge: small tufts brushing the edge of the path rather than a lawn over it.
        for (int i = 0; i < 130; i++)
        {
            float x = -2f + (float)rng.NextDouble() * 50f;
            float z = (rng.Next(2) == 0 ? -1f : 1f) * (3.1f + (float)rng.NextDouble() * 1.8f);
            Place(grass[rng.Next(grass.Length)], root, x, z, 0.42f + (float)rng.NextDouble() * 0.3f, groundMat, rng);
            count++;
        }
        return count;
    }

    static string[] Load(string sub)
    {
        var paths = AssetDatabase.FindAssets("t:Prefab", new[] { Base + sub })
            .Select(AssetDatabase.GUIDToAssetPath).OrderBy(x => x).ToArray();
        if (paths.Length == 0) throw new Exception("prefabs missing: " + sub);
        return paths;
    }

    static void Place(string path, Transform root, float x, float z, float scale, Material mat, System.Random rng)
    {
        var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(path);
        var go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
        go.transform.SetParent(root);
        go.transform.position = new Vector3(x, 0, z);
        go.transform.rotation = Quaternion.Euler(0, (float)rng.NextDouble() * 360, 0);
        go.transform.localScale *= scale;
        foreach (var r in go.GetComponentsInChildren<Renderer>())
            r.sharedMaterials = Enumerable.Repeat(mat, r.sharedMaterials.Length).ToArray();
        foreach (var c in go.GetComponentsInChildren<Collider>())
            UnityEngine.Object.DestroyImmediate(c);
    }

    static string[] Relight()
    {
        var log = new List<string>();

        // Flat ambient at 0.11 lifted every surface to the same grey-blue and flattened the
        // image. Near-black cool ambient leaves the key light and lanterns to describe depth.
        RenderSettings.ambientMode = AmbientMode.Trilight;
        RenderSettings.ambientSkyColor = new Color(0.042f, 0.055f, 0.072f);
        RenderSettings.ambientEquatorColor = new Color(0.026f, 0.033f, 0.042f);
        RenderSettings.ambientGroundColor = new Color(0.011f, 0.011f, 0.010f);
        RenderSettings.ambientIntensity = 1f;
        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.ExponentialSquared;
        RenderSettings.fogColor = new Color(0.030f, 0.040f, 0.055f);
        RenderSettings.fogDensity = 0.028f;
        log.Add("ambient=trilight sky(0.042,0.055,0.072)");
        log.Add("fog=expsq density=0.028 color(0.030,0.040,0.055)");

        SetLight("Directional Light", new Color(0.68f, 0.78f, 0.94f), 0.80f, shadows: true);
        SetLight("Forest moon rim review", new Color(0.55f, 0.70f, 0.95f), 0.45f, shadows: false);
        SetLight("Forest entrance moonlight", new Color(0.70f, 0.80f, 0.92f), 0.45f, shadows: false);
        SetLight("Forest clearing moonlight", new Color(0.70f, 0.80f, 0.92f), 0.55f, shadows: false);
        SetLight("Hunter visibility fill", new Color(0.60f, 0.70f, 0.82f), 0.25f, shadows: false);
        SetLight("Village square lantern", new Color(1f, 0.55f, 0.22f), 1.5f, shadows: false);
        SetLight("Village entrance lantern", new Color(1f, 0.52f, 0.20f), 1.4f, shadows: false);
        SetLight("Village exit lantern", new Color(1f, 0.58f, 0.25f), 1.4f, shadows: false);
        SetLight("Mentor mark light", new Color(1f, 0.60f, 0.28f), 1.2f, shadows: false);
        log.Add("lights retuned: cool key 0.80 with shadows, cool fills 0.25-0.55, warm lanterns 1.2-1.5");
        return log.ToArray();
    }

    static void SetLight(string name, Color color, float intensity, bool shadows)
    {
        var go = GameObject.Find(name);
        if (!go) return;
        var light = go.GetComponent<Light>();
        if (!light) return;
        light.color = color;
        light.intensity = intensity;
        light.shadows = shadows ? LightShadows.Soft : LightShadows.None;
        if (shadows)
        {
            light.shadowStrength = 0.92f;
            light.shadowBias = 0.05f;
            light.shadowNormalBias = 0.35f;
        }
    }

    // The stacked fog planes used a bright grey-blue (0.42,0.50,0.52) at up to 0.13 alpha,
    // which veiled the whole frame evenly. Darker, thinner and tinted toward the ambient keeps
    // them as a depth cue between tree layers instead of a screen-wide wash.
    static string[] RetuneFog()
    {
        var log = new List<string>();
        var shader = Shader.Find("VampireDemo/SoftMist");
        if (!shader) throw new Exception("missing SoftMist shader");

        var settings = new (string name, Color color, float density, float scale, float speed, float nearFade, float farFade, float softness)[]
        {
            ("Near ground fog",        new Color(0.105f, 0.130f, 0.165f), 0.95f, 0.048f, 0.010f, 5f,  34f, 0.85f),
            ("Mid-height drifting fog",new Color(0.125f, 0.155f, 0.195f), 0.80f, 0.036f, 0.007f, 7f,  46f, 0.90f),
            ("Upper sparse fog",       new Color(0.150f, 0.185f, 0.230f), 0.55f, 0.026f, 0.005f, 9f,  62f, 0.92f),
        };
        foreach (var s in settings)
        {
            var go = GameObject.Find(s.name);
            if (!go) { log.Add("fog missing: " + s.name); continue; }
            var renderers = go.GetComponentsInChildren<Renderer>();
            for (int i = 0; i < renderers.Length; i++)
            {
                var r = renderers[i];
                var m = new Material(shader);
                m.SetColor("_FogColor", new Color(s.color.r, s.color.g, s.color.b, 1f));
                m.SetFloat("_Density", s.density);
                m.SetFloat("_NoiseScale", s.scale);
                m.SetFloat("_DriftSpeed", s.speed);
                m.SetFloat("_Offset", i * 13.7f);
                m.SetFloat("_NearFade", s.nearFade);
                m.SetFloat("_FarFade", s.farFade);
                m.SetFloat("_Softness", s.softness);
                var path = "Assets/Demo/Atmosphere/Mist_" + s.name.Replace(" ", "") + "_" + i + ".mat";
                AssetDatabase.DeleteAsset(path);
                AssetDatabase.CreateAsset(m, path);
                r.sharedMaterial = m;
            }
            log.Add("mist retuned: " + s.name + " density=" + s.density + " nearFade=" + s.nearFade);
        }
        return log.ToArray();
    }

    // Each leaf card in the pack maps to a narrow UV island, so the quantised cell grid that
    // looks like needles on a whole tree collapses into a few big squares when the camera is
    // close. This sweeps the cell count and renders the same close-up for each value.
    public static void CompareNoiseSteps()
    {
        EditorSceneManager.OpenScene(Target);
        var treeMat = AssetDatabase.LoadAssetAtPath<Material>(TreeMatPath);
        var groundMat = AssetDatabase.LoadAssetAtPath<Material>(GroundMatPath);
        var cam = GameObject.Find("Demo camera").GetComponent<Camera>();
        var player = GameObject.Find("Player");
        var oldPlayerPos = player.transform.position;
        var oldCamPos = cam.transform.position;
        var oldCamRot = cam.transform.rotation;

        var standing = new Vector3(32, 1, 0);
        player.transform.position = standing;
        cam.transform.position = standing + new Vector3(0, 6.2f, -8.6f);
        cam.transform.rotation = Quaternion.LookRotation(standing + Vector3.up * 0.9f - cam.transform.position);

        var log = new List<string>();
        foreach (float scale in new[] { 130f, 300f, 700f, 1500f })
        {
            treeMat.SetFloat("_ObjectNoiseScale", scale);
            var file = Path.Combine(OutDir, "objscale_" + (int)scale + ".png");
            Render(cam, file, 1600, 900, 4);
            log.Add(file);
        }
        treeMat.SetFloat("_ObjectNoiseScale", 700f);
        foreach (var l in log) Debug.Log("[Compare] " + l);
        File.WriteAllLines(Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-noise-steps-compare.log"), log);
        player.transform.position = oldPlayerPos;
        cam.transform.position = oldCamPos;
        cam.transform.rotation = oldCamRot;
    }

    static string[] RenderPreviews()
    {
        var log = new List<string>();
        var cam = GameObject.Find("Demo camera").GetComponent<Camera>();
        var player = GameObject.Find("Player");
        var oldPlayerPos = player.transform.position;
        var oldCamPos = cam.transform.position;
        var oldCamRot = cam.transform.rotation;
        var oldFov = cam.fieldOfView;
        cam.allowMSAA = true;

        // The rig uses a (0,10,-10) offset. At that height the camera looks down on the tree
        // tops, which is why the canopy reads flat; the lower shots show the same spot from a
        // rig the design has not committed to yet, for comparison only.
        var shots = new (string name, Vector3 player, Vector3 offset)[]
        {
            ("01_spawn_rig_0_10_-10", new Vector3(20, 1, 0), new Vector3(0, 10, -10)),
            ("02_spawn_rig_0_6.5_-9", new Vector3(20, 1, 0), new Vector3(0, 6.5f, -9f)),
            ("03_deep_rig_0_6.2_-8.6", new Vector3(32, 1, 0), new Vector3(0, 6.2f, -8.6f)),
            ("04_treeline_rig_0_6.2_-8.6", new Vector3(12, 1, 0), new Vector3(0, 6.2f, -8.6f)),
        };

        foreach (var shot in shots)
        {
            player.transform.position = shot.player;
            cam.transform.position = shot.player + shot.offset;
            cam.transform.rotation = Quaternion.LookRotation(shot.player + Vector3.up * 0.9f - cam.transform.position);
            cam.fieldOfView = 60f;
            var file = Path.Combine(OutDir, shot.name + ".png");
            Render(cam, file, 1600, 900, 4);
            log.Add("render " + file + " player=" + shot.player + " cam=" + cam.transform.position);
        }

        player.transform.position = oldPlayerPos;
        cam.transform.position = oldCamPos;
        cam.transform.rotation = oldCamRot;
        cam.fieldOfView = oldFov;
        return log.ToArray();
    }

    internal static void Render(Camera cam, string path, int w, int h, int msaa)
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
        UnityEngine.Object.DestroyImmediate(rt);
        UnityEngine.Object.DestroyImmediate(img);
    }
}
