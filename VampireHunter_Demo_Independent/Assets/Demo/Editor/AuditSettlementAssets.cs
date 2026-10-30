using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

// Renders every candidate prefab in the URP project so placement decisions come from
// actual images instead of assumed pivots, facing or scale.
public static class AuditSettlementAssets
{
    const string OutDir = "Evidence/asset-audit-20261029";
    const string ReportPath = OutDir + "/asset-audit.tsv";

    static readonly string[] Paths =
    {
        "Assets/Forst/Conifers [BOTD]/Render Pipeline Support/URP/Prefabs/PF Conifer Tall BOTD URP.prefab",
        "Assets/Forst/Conifers [BOTD]/Render Pipeline Support/URP/Prefabs/PF Conifer Medium BOTD URP.prefab",
        "Assets/Forst/Conifers [BOTD]/Render Pipeline Support/URP/Prefabs/PF Conifer Small BOTD URP.prefab",
        "Assets/Forst/Conifers [BOTD]/Render Pipeline Support/URP/Prefabs/PF Conifer Bare BOTD URP.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Pine.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/JapaneseCedar.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/JapaneseCypress.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/SawtoothOak.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/PlaneTree.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/DawnRedwood.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Ginkgo_wood.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/JapaneseEurya.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/JapaneseLaurel.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Mugwort.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Rock_A.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Rock_B.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/Decayed_wood_A.prefab",
        "Assets/Polyeler/EssentialNaturePack/Prefabs/FallenLeaves.prefab",
        "Assets/Fantasy Forest Environment Free Sample/Meshes/Prefabs/tree_1.prefab",
        "Assets/Fantasy Forest Environment Free Sample/Meshes/Prefabs/grass01.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Trees/Evergreen_TallMed.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Trees/Evergreen_MedSmall.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Trees/Evergreen_Small.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Trees/Dead.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/Bushes/Bush_block.prefab",
        "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/GroundCover/GroundCover_Grass.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_bighouse_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_bighouse_02.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_small_house_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_small_house_tall_roof_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_small_house_straw_roof_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_blacksmith_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_storage_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_big_storage_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_barracks_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_barracks_single_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_tower_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_gate_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_crane_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_wall_panel_01.prefab",
        "Assets/Viking Village/Prefabs/Buildings/pf_build_wall_corner_01.prefab",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/House_1.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/House_2.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/House_3.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/House_4.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Inn.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Blacksmith.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Bell_Tower.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Mill.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Sawmill.fbx",
        "Assets/Demo/ThirdParty/VillageBuildings/FBX/Stable.fbx",
        "Assets/Viking Village/Prefabs/Props/pf_fence_01.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_barrel_01.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_buckets_01.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_plank_03.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_torch_fire_01.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_plankpath_01.prefab",
        "Assets/Viking Village/Prefabs/Props/pf_skull_stick_01.prefab"
    };

    [MenuItem("Vampire Demo/Audit Settlement Assets")]
    public static void Run()
    {
        Directory.CreateDirectory(OutDir);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        RenderSettings.fog = false;
        RenderSettings.ambientMode = AmbientMode.Flat;
        RenderSettings.ambientLight = new Color(.55f, .58f, .62f);
        var key = new GameObject("Key").AddComponent<Light>();
        key.type = LightType.Directional;
        key.intensity = 1.6f;
        key.color = new Color(1f, .96f, .9f);
        key.transform.rotation = Quaternion.Euler(45, 35, 0);
        var fill = new GameObject("Fill").AddComponent<Light>();
        fill.type = LightType.Directional;
        fill.intensity = .5f;
        fill.color = new Color(.6f, .7f, .9f);
        fill.transform.rotation = Quaternion.Euler(30, -150, 0);

        var cam = new GameObject("Audit Camera").AddComponent<Camera>();
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(.32f, .35f, .38f);
        cam.nearClipPlane = .05f;
        cam.farClipPlane = 4000f;
        cam.orthographic = true;

        var sb = new StringBuilder();
        sb.AppendLine("asset\tkind\tboundsX\tboundsY\tboundsZ\tminY\tshaderIssues\tmaterials\tmeshRenderers\tstatics\tnote");

        int index = 0;
        foreach (var path in Paths)
        {
            var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            var name = Path.GetFileNameWithoutExtension(path);
            if (!prefab)
            {
                sb.AppendLine(name + "\tMISSING\t\t\t\t\t\t\t\t\t" + path);
                continue;
            }
            var go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
            go.transform.position = Vector3.zero;
            go.transform.rotation = prefab.transform.rotation;
            var renderers = go.GetComponentsInChildren<Renderer>();
            var colliders = go.GetComponentsInChildren<Collider>();
            var shaders = new HashSet<string>();
            var bad = new List<string>();
            foreach (var r in renderers)
            {
                foreach (var m in r.sharedMaterials)
                {
                    if (!m) { bad.Add("null-material"); continue; }
                    shaders.Add(m.shader ? m.shader.name : "null-shader");
                    if (!m.shader) bad.Add("null-shader:" + m.name);
                    else if (m.shader.name == "Standard" || m.shader.name == "Legacy Shaders/Diffuse" ||
                             m.shader.name.Contains("InternalError") || m.shader.name.Contains("Hidden/Internal"))
                        bad.Add(m.shader.name + ":" + m.name);
                }
            }
            Bounds b = new Bounds(go.transform.position, Vector3.zero);
            if (renderers.Length > 0)
            {
                b = renderers[0].bounds;
                foreach (var r in renderers) b.Encapsulate(r.bounds);
            }
            bool isBuilding = path.Contains("Viking Village/Prefabs/Buildings") || path.Contains("VillageBuildings/FBX");
            string kind = isBuilding ? "building" : path.Contains("Props") ? "prop" : "nature";
            if (!isBuilding)
            {
                go.transform.rotation = Quaternion.identity;
                go.transform.position = -b.min;
                foreach (var r in renderers) { }
                b = new Bounds(Vector3.zero, Vector3.zero);
                if (renderers.Length > 0)
                {
                    b = renderers[0].bounds;
                    foreach (var r in renderers) b.Encapsulate(r.bounds);
                }
            }
            string note = "colliders=" + colliders.Length + " shaders=" + string.Join("|", shaders);
            sb.AppendLine(string.Join("\t", new[]
            {
                name, kind, b.size.x.ToString("F2"), b.size.y.ToString("F2"), b.size.z.ToString("F2"),
                b.min.y.ToString("F2"), bad.Count == 0 ? "ok" : string.Join(",", bad),
                renderers.Length.ToString(), colliders.Length.ToString(), "", note
            }));

            if (isBuilding)
            {
                // Four elevations; the door edge tells us which way the prefab faces.
                string[] labels = { "south_+Z", "east_+X", "north_-Z", "west_-X" };
                Vector3[] dirs = { Vector3.forward, Vector3.right, Vector3.back, Vector3.left };
                float s = Mathf.Max(b.size.x, b.size.z, b.size.y);
                for (int i = 0; i < 4; i++)
                {
                    cam.orthographicSize = s * .62f;
                    cam.transform.position = b.center + dirs[i] * (s * 2.2f) + Vector3.up * (b.size.y * .12f);
                    cam.transform.LookAt(b.center);
                    Shot(cam, string.Format("{0:D2}_{1}_{2}", index, Sanitize(name), labels[i]), 420, 360);
                }
            }
            else
            {
                float s = Mathf.Max(b.size.x, b.size.y, b.size.z);
                cam.orthographicSize = s * .62f;
                cam.transform.position = b.center + (new Vector3(1, .45f, 1).normalized * s * 2.2f);
                cam.transform.LookAt(b.center);
                Shot(cam, string.Format("{0:D2}_{1}", index, Sanitize(name)), 420, 420);
            }
            Object.DestroyImmediate(go);
            index++;
        }

        File.WriteAllText(ReportPath, sb.ToString());
        var layers = AssetDatabase.FindAssets("t:TerrainLayer");
        var lsb = new StringBuilder("terrain layers:\n");
        foreach (var g in layers)
        {
            var p = AssetDatabase.GUIDToAssetPath(g);
            var tl = AssetDatabase.LoadAssetAtPath<TerrainLayer>(p);
            lsb.AppendLine(p + "\tdiffuse=" + (tl && tl.diffuseTexture ? tl.diffuseTexture.name + " " + tl.diffuseTexture.width + "x" + tl.diffuseTexture.height : "none")
                + "\tnormal=" + (tl && tl.normalMapTexture ? tl.normalMapTexture.name : "none")
                + "\ttile=" + (tl ? tl.tileSize : Vector2.zero));
        }
        File.WriteAllText(OutDir + "/terrain-layers.txt", lsb.ToString());
        Debug.Log("ASSET_AUDIT_DONE " + index + " assets -> " + OutDir);
    }

    static string Sanitize(string s)
    {
        foreach (var c in Path.GetInvalidFileNameChars()) s = s.Replace(c, '_');
        return s.Replace(' ', '_');
    }

    static void Shot(Camera cam, string name, int w, int h)
    {
        var rt = new RenderTexture(w, h, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.sRGB);
        cam.targetTexture = rt;
        cam.Render();
        RenderTexture.active = rt;
        var tex = new Texture2D(w, h, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, w, h), 0, 0);
        tex.Apply();
        File.WriteAllBytes(OutDir + "/" + name + ".png", tex.EncodeToPNG());
        cam.targetTexture = null;
        RenderTexture.active = null;
        Object.DestroyImmediate(rt);
        Object.DestroyImmediate(tex);
    }
}
