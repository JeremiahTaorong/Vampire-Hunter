using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Unity.AI.Navigation;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using Object = UnityEngine.Object;

// Rebuilds the prologue settlement + forest as one authored scene.
// All positions are authored in reference-image coordinates (0..120 east, 0..64 north)
// and converted to world space, so the plan can be compared with the reference directly.
public static class BuildSettlementScene
{
    public const string ScenePath = "Assets/Demo/Scenes/PrologueSettlement.unity";
    const string EnvDir = "Assets/Demo/Environment";
    const string MatDir = EnvDir + "/Materials";
    const string TerrainAsset = EnvDir + "/SettlementTerrain.asset";
    const string NavAsset = EnvDir + "/SettlementNavMesh.asset";
    public const float MapW = 120f;
    public const float MapH = 64f;

    // ---------- reference -> world ----------
    public static Vector3 P(float rx, float rz, float y = 0f) => new Vector3(rx - MapW * .5f, y, rz - MapH * .5f);
    static Vector2 V(float rx, float rz) => new Vector2(rx, rz);

    static readonly Vector2 PlazaCenter = V(46f, 25.5f);
    static readonly Vector2 VillageEntrance = V(16f, 26.4f);
    static readonly Vector2 WitnessPoint = V(75.4f, 39.7f);
    static readonly Vector2 EvidencePoint = V(80.9f, 27.7f);
    static readonly Vector2 MissingScenePoint = V(92.2f, 31.4f);
    static readonly Vector2 DragPoint = V(103.1f, 25.6f);
    static readonly Vector2 ForestEntrance = V(112.1f, 23.9f);
    static readonly Vector2 MentorPoint = V(117f, 17f);
    static readonly Vector2[] CluePoints = { WitnessPoint, EvidencePoint, MissingScenePoint, DragPoint, MentorPoint };

    static readonly Vector2[] MainRoad =
    {
        V(4f, 27.2f), V(10f, 26.8f), V(16f, 26.4f), V(22f, 26.2f), V(28f, 25.8f),
        V(34f, 25.2f), V(40f, 24.6f), V(46f, 24.4f), V(52f, 24.8f), V(58f, 25.6f),
        V(64f, 26.4f), V(70f, 27.0f), V(76f, 27.4f), V(82f, 27.8f), V(88f, 29.4f),
        V(92f, 31.2f), V(96f, 30.4f), V(100f, 28.6f), V(104f, 26.8f), V(108f, 25.2f),
        V(112f, 23.9f), V(116f, 22.8f), V(119f, 22.2f)
    };
    static readonly Vector2[] NorthBranch =
    {
        V(31f, 26.0f), V(31.5f, 31f), V(31f, 36f), V(30f, 41f), V(30f, 45.5f), V(31f, 48.4f)
    };
    static readonly Vector2[] NorthBranchB9 =
    {
        V(44f, 25f), V(46f, 31f), V(48f, 37f), V(49f, 42f), V(50f, 45.6f)
    };
    static readonly Vector2[] SouthBranch =
    {
        V(44f, 23f), V(42f, 18f), V(41f, 14f), V(43f, 10.6f), V(47f, 9.2f), V(52f, 10.4f),
        V(57f, 12.4f), V(61f, 15.6f), V(63f, 20f), V(63.5f, 25f), V(63.5f, 29.4f)
    };
    static readonly Vector2[] WitnessSpur =
    {
        V(58f, 25.6f), V(62f, 28.6f), V(67f, 32.6f), V(72f, 36.2f), V(75f, 38.6f)
    };

    static readonly List<Vector2[]> Roads = new List<Vector2[]> { MainRoad, NorthBranch, NorthBranchB9, SouthBranch, WitnessSpur };

    // ---------- building data ----------
    class BuildingDef
    {
        public string id, label;
        public string[] parts;
        public Vector2 pos;      // reference coords
        public float width;      // world units across the widest side
        public float doorDir;    // world degrees, 0 = +Z, 90 = +X
        public bool doorOnMinusZ;
        public float heightLimit; // 0 = no limit
    }

    static readonly BuildingDef[] Buildings =
    {
        new BuildingDef { id = "B01", label = "House_4+House_1 (teal two storey)", parts = new[]{"Village/House_1"}, pos = V(26.6f, 13.5f), width = 7.4f, doorDir = 42f, doorOnMinusZ = false },
        new BuildingDef { id = "B02", label = "Inn (red roof, centre of village)", parts = new[]{"Village/Inn"}, pos = V(54.7f, 34.8f), width = 9.6f, doorDir = -128f, doorOnMinusZ = false },
        new BuildingDef { id = "B03", label = "House_3+House_1 (north of square)", parts = new[]{"Village/House_1"}, pos = V(35.5f, 37.7f), width = 5.2f, doorDir = 180f, doorOnMinusZ = false },
        new BuildingDef { id = "B04", label = "Sawmill (east range)", parts = new[]{"Village/Sawmill"}, pos = V(63.9f, 32.6f), width = 10.2f, doorDir = -90f, doorOnMinusZ = false },
        new BuildingDef { id = "B05", label = "Straw roof cabin (south-east)", parts = new[]{"Viking/pf_build_small_house_straw_roof_01"}, pos = V(63.9f, 12.3f), width = 9.0f, doorDir = -60f, doorOnMinusZ = true },
        new BuildingDef { id = "B06", label = "Log house (south)", parts = new[]{"Viking/pf_build_small_house_01"}, pos = V(52f, 10.1f), width = 8.6f, doorDir = 180f, doorOnMinusZ = true },
        new BuildingDef { id = "B07", label = "House_1 (small teal hut)", parts = new[]{"Village/House_1"}, pos = V(43f, 8.5f), width = 4.4f, doorDir = 0f, doorOnMinusZ = false },
        new BuildingDef { id = "B08", label = "Water mill (north-west)", parts = new[]{"Village/House_2"}, pos = V(22.3f, 51.5f), width = 6.2f, doorDir = 135f, doorOnMinusZ = false },
        new BuildingDef { id = "B09", label = "Stable / long house (north)", parts = new[]{"Village/Stable"}, pos = V(54.7f, 51.5f), width = 12.4f, doorDir = 180f, doorOnMinusZ = false },
        new BuildingDef { id = "B10", label = "Thrall cabin in the trees (north-east)", parts = new[]{"Viking/pf_build_small_house_straw_roof_01"}, pos = V(82f, 44.3f), width = 7.2f, doorDir = -128f, doorOnMinusZ = true },
        new BuildingDef { id = "B11", label = "Forest hut (south-east)", parts = new[]{"Viking/pf_build_small_house_straw_roof_01"}, pos = V(93.8f, 13.8f), width = 6.2f, doorDir = -90f, doorOnMinusZ = true }
    };

    static readonly List<Footprint> Footprints = new List<Footprint>();
    class Footprint { public Vector2 center; public Vector2 half; public float yaw; public float doorDir; }
    static readonly List<Vector3> PlacedPoints = new List<Vector3>();

    static Transform villageRoot, forestRoot, propRoot, clueRoot, lightRoot;
    static Terrain terrain;
    static TerrainData terrainData;

    // ---------- materials ----------
    static readonly Dictionary<string, Material> Mats = new Dictionary<string, Material>();

    // ======================================================================
    [MenuItem("Vampire Demo/Build Prologue Settlement Scene")]
    public static void Run()
    {
        Debug.Log("SETTLEMENT_BUILD_START");
        Footprints.Clear(); PlacedPoints.Clear(); Mats.Clear();
        Directory.CreateDirectory(EnvDir); Directory.CreateDirectory(MatDir);

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        PrepareMaterials();

        villageRoot = new GameObject("Village").transform;
        propRoot = new GameObject("Village props and fences").transform;
        forestRoot = new GameObject("Forest").transform;
        clueRoot = new GameObject("Investigation").transform;
        lightRoot = new GameObject("Lighting").transform;

        BuildTerrain();
        BuildRoads();
        BuildBuildings();
        BuildProps();
        BuildVegetation();
        BuildInvestigation();
        BuildLighting();
        BuildPlayerAndCamera();
        BuildPostProcessing();
        BakeNavigation();
        ConfigureScene();
        InstallSettlementAtmosphere.Install();

        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene, ScenePath);
        AddSceneToBuildSettings();
        AssetDatabase.SaveAssets();
        Debug.Log("SETTLEMENT_BUILD_DONE buildings=" + Buildings.Length + " footprints=" + Footprints.Count);
    }

    // ======================================================================
    // Terrain
    // ======================================================================
    static void BuildTerrain()
    {
        foreach (var path in new[] { TerrainAsset, NavAsset })
            if (AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(path)) AssetDatabase.DeleteAsset(path);

        terrainData = new TerrainData
        {
            heightmapResolution = 513,
            alphamapResolution = 1024,
            baseMapResolution = 1024,
            size = new Vector3(MapW, 6f, MapH)
        };
        terrainData.terrainLayers = new[]
        {
            LoadTerrainLayer("Forest_Ground"), LoadTerrainLayer("Forest_GreenGround"),
            LoadTerrainLayer("Forest_Road"), LoadTerrainLayer("Forest_Leaves")
        };
        terrainData.terrainLayers[2].tileSize = new Vector2(5f, 5f);

        int res = terrainData.heightmapResolution;
        var heights = new float[res, res];
        for (int i = 0; i < res; i++)
            for (int j = 0; j < res; j++)
            {
                float rx = i / (float)(res - 1) * MapW;
                float rz = j / (float)(res - 1) * MapH;
                heights[j, i] = HeightAt(rx, rz) / terrainData.size.y;
            }
        terrainData.SetHeights(0, 0, heights);

        AssetDatabase.CreateAsset(terrainData, TerrainAsset);
        var go = Terrain.CreateTerrainGameObject(terrainData);
        go.name = "Settlement terrain";
        go.transform.position = new Vector3(-MapW * .5f, 0f, -MapH * .5f);
        terrain = go.GetComponent<Terrain>();
        terrain.heightmapPixelError = 4;
        terrain.drawInstanced = true;
        terrain.shadowCastingMode = ShadowCastingMode.On;
        go.transform.SetParent(villageRoot);

        PaintGround();
        AssetDatabase.SaveAssets();
    }

    static TerrainLayer LoadTerrainLayer(string name)
    {
        var source = AssetDatabase.LoadAssetAtPath<TerrainLayer>("Assets/Polyeler/EssentialNaturePack/Terrain/" + name + ".terrainlayer");
        if (!source) throw new Exception("Missing terrain layer " + name);
        // Duplicate so tile scales do not modify the vendor asset.
        string path = EnvDir + "/Ground_" + name + ".terrainlayer";
        var existing = AssetDatabase.LoadAssetAtPath<TerrainLayer>(path);
        if (existing) AssetDatabase.DeleteAsset(path);
        var copy = Object.Instantiate(source);
        copy.tileSize = new Vector2(7f, 7f);
        AssetDatabase.CreateAsset(copy, path);
        return copy;
    }

    // Layered ground: green pasture around the village, forest floor under canopy,
    // leaf litter at the tree line, dirt on the roads and the square.
    static void PaintGround()
    {
        int w = terrainData.alphamapWidth, h = terrainData.alphamapHeight;
        var map = new float[h, w, 4];
        for (int y = 0; y < h; y++)
        {
            float rz = y / (float)(h - 1) * MapH;
            for (int x = 0; x < w; x++)
            {
                float rx = x / (float)(w - 1) * MapW;
                float road = RoadDistance(rx, rz);
                float plaza = PlazaMask(rx, rz);
                float wild = Wildness(rx, rz);
                float n1 = Mathf.PerlinNoise(rx * .33f + 5f, rz * .33f + 9f);
                float n2 = Mathf.PerlinNoise(rx * .09f + 31f, rz * .09f + 17f);

                float roadEdge = Mathf.Lerp(2.5f, 1.65f, Smooth(62f, 96f, rx));
                float dirt = Mathf.Clamp01((1f - Smooth(roadEdge + n1 * .35f, roadEdge + 1.15f + n1 * .55f, road)));
                dirt = Mathf.Max(dirt, plaza);

                float leaves = Mathf.Clamp01(wild * 1.15f * (.45f + .55f * n2) - dirt * 1.2f);
                leaves = Mathf.Max(leaves, Mathf.Clamp01((1f - Smooth(2.2f, 6.5f, road)) * wild * .6f));
                float green = Mathf.Clamp01((1f - wild) * 1.25f * (.55f + .45f * n1) - dirt);
                float forest = Mathf.Clamp01(1f - green - leaves - dirt);

                float sum = forest + green + dirt + leaves + .0001f;
                map[y, x, 0] = forest / sum;
                map[y, x, 1] = green / sum;
                map[y, x, 2] = dirt / sum;
                map[y, x, 3] = leaves / sum;
            }
        }
        foreach (var probe in new[] { new Vector2(46f, 24f), new Vector2(30f, 30f), new Vector2(100f, 30f) })
        {
            int px = Mathf.RoundToInt(probe.x / MapW * (w - 1)), py = Mathf.RoundToInt(probe.y / MapH * (h - 1));
            Debug.Log(string.Format("SETTLEMENT_SPLAT {0} wild={1:F2} road={2:F2} plaza={3:F2} w=({4:F2},{5:F2},{6:F2},{7:F2})",
                probe, Wildness(probe.x, probe.y), RoadDistance(probe.x, probe.y), PlazaMask(probe.x, probe.y),
                map[py, px, 0], map[py, px, 1], map[py, px, 2], map[py, px, 3]));
        }
        terrainData.SetAlphamaps(0, 0, map);
    }

    // Height in metres for a reference-space point. Village and roads stay nearly flat.
    static float HeightAt(float rx, float rz)
    {
        float n = Mathf.PerlinNoise(rx * .045f + 3.1f, rz * .045f + 8.7f) - .5f;
        float n2 = Mathf.PerlinNoise(rx * .13f + 21f, rz * .13f + 4f) - .5f;
        float n3 = Mathf.PerlinNoise(rx * .021f + 44f, rz * .021f + 12f) - .5f;
        float wild = Wildness(rx, rz);
        float road = Mathf.Clamp01((RoadDistance(rx, rz) - 2.4f) / 5f);
        float plaza = 1f - PlazaMask(rx, rz);
        float influence = Mathf.Clamp01(wild * road * plaza);
        return 0.02f + (n * 2.3f + n2 * .5f + n3 * 2.6f) * influence;
    }

    static float WorldHeight(float wx, float wz) => HeightAt(wx + MapW * .5f, wz + MapH * .5f);

    // ======================================================================
    // Spatial helpers (reference space for authoring, world space for placement)
    // ======================================================================
    static float RoadDistance(float rx, float rz)
    {
        float best = float.MaxValue;
        foreach (var road in Roads)
            for (int i = 0; i < road.Length - 1; i++)
                best = Mathf.Min(best, SegDist(new Vector2(rx, rz), road[i], road[i + 1]));
        return best;
    }

    static float SegDist(Vector2 p, Vector2 a, Vector2 b)
    {
        Vector2 ab = b - a;
        float t = Mathf.Clamp01(Vector2.Dot(p - a, ab) / Mathf.Max(.0001f, ab.sqrMagnitude));
        return Vector2.Distance(p, a + ab * t);
    }

    // Smoothstep with edges in world units (Mathf.SmoothStep takes a 0..1 blend factor instead).
    static float Smooth(float edge0, float edge1, float x)
    {
        float t = Mathf.Clamp01((x - edge0) / (edge1 - edge0));
        return t * t * (3f - 2f * t);
    }

    static float PlazaMask(float rx, float rz)
    {
        float dx = (rx - PlazaCenter.x) / 10.2f, dz = (rz - PlazaCenter.y) / 7.4f;
        float d = Mathf.Sqrt(dx * dx + dz * dz);
        return 1f - Smooth(.72f, 1.05f, d);
    }

    // 0 = village clearing, 1 = deep woodland. Drives ground paint, height and planting.
    static float Wildness(float rx, float rz)
    {
        float dx = (rx - 46f) / 32f, dz = (rz - 24f) / 21f;
        float d = Mathf.Sqrt(dx * dx + dz * dz);
        float village = 1f - Smooth(.70f, 1.02f, d);
        float east = Smooth(64f, 88f, rx);
        float north = Smooth(46f, 58f, rz);
        float south = Smooth(2f, -10f, rz);
        float west = Smooth(12f, 1f, rx);
        float wild = Mathf.Max(Mathf.Max(east, north), Mathf.Max(south, west));
        wild = Mathf.Max(wild, (1f - village) * .85f);
        wild *= Mathf.Lerp(1f, .06f, village);
        return Mathf.Clamp01(wild);
    }

    static float OrientedBoxDistance(Vector2 p, Footprint f)
    {
        Vector2 d = p - f.center;
        float c = Mathf.Cos(-f.yaw * Mathf.Deg2Rad), s = Mathf.Sin(-f.yaw * Mathf.Deg2Rad);
        Vector2 local = new Vector2(d.x * c - d.y * s, d.x * s + d.y * c);
        Vector2 q = new Vector2(Mathf.Abs(local.x) - f.half.x, Mathf.Abs(local.y) - f.half.y);
        return new Vector2(Mathf.Max(q.x, 0f), Mathf.Max(q.y, 0f)).magnitude + Mathf.Min(Mathf.Max(q.x, q.y), 0f);
    }

    static bool ClearOfBuildings(Vector2 p, float margin)
    {
        foreach (var f in Footprints)
            if (OrientedBoxDistance(p, f) < margin) return false;
        return true;
    }

    static bool ClearOfClues(Vector2 p, float radius)
    {
        foreach (var c in CluePoints) if (Vector2.Distance(p, c) < radius) return false;
        return true;
    }

    static bool ClearOfPlaza(Vector2 p, float margin) => PlazaMask(p.x, p.y) < .05f && Vector2.Distance(p, PlazaCenter) > 10.5f + margin;

    // ======================================================================
    // Roads: terrain paint plus plank / stone detail
    // ======================================================================
    static void BuildRoads()
    {
        var root = new GameObject("Road and ground detail").transform;
        root.SetParent(propRoot);

        // Plank crossings and stepping stones keep the route legible where it leaves the village.
        var rng = new System.Random(7);
        Vector2[] plankSpots = { V(30f, 25.6f), V(64.5f, 26.8f), V(84f, 29.0f), V(96.5f, 30.6f), V(50.5f, 10.8f) };
        foreach (var spot in plankSpots)
        {
            var go = PlaceProp("Viking/pf_plankpath_01", spot, rng.Next(0, 360));
            if (go) go.transform.localScale = Vector3.one * .42f;
        }
        // Loose stones along road edges
        for (int i = 0; i < 90; i++)
        {
            var road = Roads[rng.Next(0, 3)];
            int seg = rng.Next(0, road.Length - 1);
            float t = (float)rng.NextDouble();
            Vector2 p = Vector2.Lerp(road[seg], road[seg + 1], t);
            Vector2 perp = Vector2.Perpendicular((road[seg + 1] - road[seg]).normalized);
            p += perp * (float)(rng.NextDouble() * 1.6 + 1.5) * (rng.Next(2) == 0 ? 1 : -1);
            if (PlazaMask(p.x, p.y) > .08f) continue;
            var go = PlaceProp("Polyeler/Rock_B", p, rng.Next(0, 360));
            if (go) go.transform.localScale *= .8f + (float)rng.NextDouble() * .8f;
        }
    }

    // ======================================================================
    // Buildings
    // ======================================================================
    static void BuildBuildings()
    {
        foreach (var def in Buildings) PlaceBuilding(def);
        Debug.Log("SETTLEMENT_BUILDINGS " + Buildings.Length);
    }

    static void PlaceBuilding(BuildingDef def)
    {
        var group = new GameObject(def.id + " " + def.label);
        group.transform.SetParent(villageRoot);
        Vector2 refPos = def.pos;
        Vector3 ground = P(refPos.x, refPos.y);
        float yaw = def.doorDir - (def.doorOnMinusZ ? 180f : 0f);
        float y = WorldHeight(ground.x, ground.z);
        group.transform.SetPositionAndRotation(new Vector3(ground.x, y, ground.z), Quaternion.Euler(0, yaw, 0));

        float top = 0f;
        float widest = 0f, deepest = 0f;
        foreach (var partPath in def.parts)
        {
            var prefab = LoadPrefab(partPath);
            var go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
            go.name = Path.GetFileNameWithoutExtension(partPath);
            go.transform.SetParent(group.transform, false);
            // Keep the FBX axis correction; only the group yaw decides facing.

            var rs = go.GetComponentsInChildren<Renderer>();
            if (rs.Length == 0) throw new Exception("No renderers in " + partPath);
            Bounds b = rs[0].bounds;
            foreach (var r in rs) b.Encapsulate(r.bounds);
            float scale = def.width / Mathf.Max(b.size.x, b.size.z);
            if (partPath.StartsWith("Village/") && b.size.y * scale > 10f) scale = 10f / b.size.y;
            go.transform.localScale = go.transform.localScale * scale;

            rs = go.GetComponentsInChildren<Renderer>();
            b = rs[0].bounds;
            foreach (var r in rs) b.Encapsulate(r.bounds);
            float worldMin = b.min.y - group.transform.position.y;
            go.transform.localPosition += new Vector3(0, top - worldMin + .02f, 0);

            rs = go.GetComponentsInChildren<Renderer>();
            b = rs[0].bounds;
            foreach (var r in rs) b.Encapsulate(r.bounds);
            top += b.size.y - .04f;
            widest = Mathf.Max(widest, b.size.x);
            deepest = Mathf.Max(deepest, b.size.z);

            AddBlockingCollider(go);
            foreach (var r in rs) r.shadowCastingMode = ShadowCastingMode.On;
        }

        // Door marker: the audit and play test check it faces the road and is reachable.
        Bounds total = new Bounds(group.transform.position, Vector3.zero);
        foreach (var r in group.GetComponentsInChildren<Renderer>()) total.Encapsulate(r.bounds);
        float depth = total.size.z;
        Vector3 doorWorld = total.center + Quaternion.Euler(0, def.doorDir, 0) * Vector3.forward * (depth * .5f + .5f);
        doorWorld.y = group.transform.position.y + .1f;
        var door = new GameObject("door");
        door.transform.SetParent(group.transform, true);
        door.transform.position = doorWorld;
        door.transform.rotation = Quaternion.Euler(0, def.doorDir, 0);

        Footprints.Add(new Footprint
        {
            center = new Vector2(total.center.x + MapW * .5f, total.center.z + MapH * .5f),
            half = new Vector2(total.size.x * .5f, total.size.z * .5f),
            yaw = 0f, // conservative world-aligned box
            doorDir = def.doorDir
        });
        Debug.Log(string.Format("SETTLEMENT_BUILDING {0} {1} pos={2:F1},{3:F1} size={4:F1}x{5:F1} top={6:F1} yaw={7:F0}",
            def.id, def.label, def.pos.x, def.pos.y, widest, deepest, top, yaw));
    }

    static void AddBlockingCollider(GameObject go)
    {
        if (go.GetComponentInChildren<Collider>()) return;
        var rs = go.GetComponentsInChildren<Renderer>();
        Bounds b = rs[0].bounds;
        foreach (var r in rs) b.Encapsulate(r.bounds);
        var box = go.AddComponent<BoxCollider>();
        box.center = go.transform.InverseTransformPoint(b.center);
        Vector3 s = go.transform.InverseTransformVector(b.size);
        box.size = new Vector3(Mathf.Abs(s.x), Mathf.Abs(s.y), Mathf.Abs(s.z));
    }

    // ======================================================================
    // Props: fences, well, torches, barrels, signpost
    // ======================================================================
    static void BuildProps()
    {
        // Fence lines (reference-space start/end). Skip segments that would cross a door approach.
        FenceLine(V(12f, 32.5f), V(26f, 33.5f));
        FenceLine(V(20f, 18.6f), V(30f, 17.6f));
        FenceLine(V(33f, 44f), V(27f, 44.6f));
        FenceLine(V(58f, 40f), V(66f, 40.5f));
        FenceLine(V(68f, 33.6f), V(76f, 33.2f));
        FenceLine(V(48f, 5.2f), V(56f, 4.8f));
        FenceLine(V(66f, 16.4f), V(72f, 15.8f));

        BuildWell(V(45.5f, 27.6f));
        BuildWaterWheel(V(18.9f, 51.2f), 2.05f);
        BuildVillageGate(V(13.5f, 26.5f));
        BuildForestSign(V(108.5f, 24.2f));

        // Village dressing: work areas, storage and market clutter ring the square.
        var rng = new System.Random(11);
        Vector2[] clusters =
        {
            V(52.6f, 36.2f), V(56.9f, 33.4f), V(31.6f, 12.8f), V(27.8f, 15.6f),
            V(49.4f, 12.6f), V(54.6f, 12.9f), V(61.2f, 14.4f), V(66.2f, 31.2f),
            V(24.4f, 50.2f), V(25.6f, 48.8f), V(53.2f, 49.6f), V(57.8f, 49.4f),
            V(81.2f, 42.4f), V(92.6f, 15.4f), V(36.2f, 39.6f), V(42.4f, 10.2f),
            V(50.4f, 21.6f), V(55.2f, 22.6f), V(33.4f, 30.4f), V(59.6f, 24.4f)
        };
        string[] props = { "Viking/pf_barrel_01", "Viking/pf_barrel_01", "Viking/pf_buckets_01", "Viking/pf_plank_03", "Viking/pf_plank_03" };
        foreach (var c in clusters)
        {
            int n = 2 + rng.Next(0, 3);
            for (int i = 0; i < n; i++)
            {
                Vector2 p = c + new Vector2((float)rng.NextDouble() * 1.6f - .8f, (float)rng.NextDouble() * 1.6f - .8f);
                var go = PlaceProp(props[rng.Next(0, props.Length)], p, rng.Next(0, 360));
                if (go) go.transform.localScale *= .9f + (float)rng.NextDouble() * .25f;
            }
        }

        // Bigger work props that give the square its silhouette.
        PlaceProp("Viking/pf_plankpile_01", V(51.6f, 21.2f), 18f);
        PlaceProp("Viking/pf_plankpile_02", V(54.4f, 20.2f), 190f);
        PlaceProp("Viking/pf_logpile_01", V(34.6f, 30.6f), 95f);
        PlaceProp("Viking/pf_logpile_01", V(58.4f, 14.8f), 12f);
        PlaceProp("Viking/pf_logpile_01", V(20.4f, 48.6f), 76f);
        PlaceProp("Viking/pf_shed_01", V(57.4f, 18.0f), -70f);
        PlaceProp("Viking/pf_shed_02", V(58.6f, 53.2f), 160f);
        PlaceProp("Viking/pf_fish_stick_01", V(49.0f, 20.2f), 40f);
        PlaceProp("Viking/pf_fish_stick_01", V(50.2f, 18.9f), 130f);
        PlaceProp("Viking/pf_barrels_01", V(56.2f, 32.2f), 24f);
        PlaceProp("Viking/pf_barrels_02", V(30.4f, 15.2f), 66f);
        PlaceProp("Viking/pf_plankpath_01", V(46.6f, 22.8f), 6f);
        PlaceProp("Viking/pf_pillar_05", V(41.6f, 21.4f), 0f);
        PlaceProp("Viking/pf_pillar_06", V(52.2f, 26.4f), 0f);
        PlaceProp("Viking/pf_menhir_01", V(37.6f, 44.6f), 30f);
        PlaceProp("Viking/pf_wall_logs_04", V(47.6f, 44.2f), 8f);

        BuildFirePit(V(49.4f, 22.4f));
        PlaceProp("Viking/pf_shed_01", V(51.8f, 19.4f), 42f);
        PlaceProp("Viking/pf_shed_01", V(38.2f, 21.4f), -118f);
        PlaceProp("Viking/pf_barrels_02", V(39.4f, 19.6f), 12f);

        // Torches by the square, inn and gate.
        Torch(V(41.6f, 29.4f)); Torch(V(49.8f, 22.2f)); Torch(V(58.6f, 32.6f));
        Torch(V(18.2f, 24.2f)); Torch(V(34.4f, 20.6f)); Torch(V(61.4f, 22.6f));

        // Firewood and deadfall in the village edges
        var rng2 = new System.Random(23);
        Vector2[] logs = { V(28.4f, 17.4f), V(58.4f, 36.8f), V(30.6f, 46.6f), V(67.4f, 17.2f), V(20.4f, 33.2f) };
        foreach (var l in logs)
        {
            var go = PlaceProp("Polyeler/Decayed_wood_A", l, rng2.Next(0, 360));
            if (go) go.transform.localScale *= 1.0f + (float)rng2.NextDouble() * .5f;
        }
    }

    static void FenceLine(Vector2 a, Vector2 b)
    {
        float dist = Vector2.Distance(a, b);
        int count = Mathf.Max(1, Mathf.RoundToInt(dist / 3.25f));
        Vector2 dir = (b - a).normalized;
        var yaw = Mathf.Atan2(dir.x, dir.y) * Mathf.Rad2Deg;
        for (int i = 0; i < count; i++)
        {
            Vector2 p = Vector2.Lerp(a, b, i / (float)count) + dir * 1.62f;
            var go = PlaceProp("Viking/pf_fence_01", p, yaw, 1.6f);
            if (go) go.transform.localScale = new Vector3(1f, 1f, dist / count / 3.31f);
        }
    }

    static void BuildWell(Vector2 at)
    {
        var root = new GameObject("Village well");
        root.transform.SetParent(propRoot);
        Vector3 g = P(at.x, at.y, WorldHeight(at.x - 60f, at.y - 32f));
        root.transform.position = g;

        var rim = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        rim.name = "stone rim"; rim.transform.SetParent(root.transform, false);
        rim.transform.localPosition = new Vector3(0, .45f, 0);
        rim.transform.localScale = new Vector3(2.1f, .45f, 2.1f);
        rim.GetComponent<Renderer>().sharedMaterial = Mats["stone"];
        Object.DestroyImmediate(rim.GetComponent<Collider>());

        var hole = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        hole.name = "water"; hole.transform.SetParent(root.transform, false);
        hole.transform.localPosition = new Vector3(0, .62f, 0);
        hole.transform.localScale = new Vector3(1.7f, .02f, 1.7f);
        hole.GetComponent<Renderer>().sharedMaterial = Mats["water"];
        Object.DestroyImmediate(hole.GetComponent<Collider>());

        for (int i = 0; i < 2; i++)
        {
            var post = GameObject.CreatePrimitive(PrimitiveType.Cube);
            post.name = "roof post"; post.transform.SetParent(root.transform, false);
            post.transform.localPosition = new Vector3(i == 0 ? -1.3f : 1.3f, 1.6f, 0);
            post.transform.localScale = new Vector3(.18f, 3.2f, .18f);
            post.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
        }
        var roof = GameObject.CreatePrimitive(PrimitiveType.Cube);
        roof.name = "well roof"; roof.transform.SetParent(root.transform, false);
        roof.transform.localPosition = new Vector3(0, 3.05f, 0);
        roof.transform.localScale = new Vector3(2.7f, .14f, 2.0f);
        roof.GetComponent<Renderer>().sharedMaterial = Mats["wood"];

        var bucket = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        bucket.name = "bucket"; bucket.transform.SetParent(root.transform, false);
        bucket.transform.localPosition = new Vector3(0, 1.48f, 0);
        bucket.transform.localScale = new Vector3(.28f, .3f, .28f);
        bucket.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
        Object.DestroyImmediate(bucket.GetComponent<Collider>());

        var col = root.AddComponent<CapsuleCollider>();
        col.radius = 1.05f; col.height = 1.2f; col.center = new Vector3(0, .6f, 0);
        var light = new GameObject("well lantern").AddComponent<Light>();
        light.transform.SetParent(root.transform, false);
        light.transform.localPosition = new Vector3(0, 2.55f, 0);
        light.type = LightType.Point; light.range = 11f; light.intensity = 4f;
        light.color = new Color(1f, .6f, .28f); light.shadows = LightShadows.Soft;
    }

    // The reference mill has a water wheel on its west face; the FBX set has no wheel, so it is built here.
    static void BuildWaterWheel(Vector2 at, float radius)
    {
        var root = new GameObject("Mill water wheel");
        root.transform.SetParent(propRoot);
        Vector3 w = P(at.x, at.y);
        root.transform.position = new Vector3(w.x, WorldHeight(w.x, w.z) + radius * .72f, w.z);
        root.transform.rotation = Quaternion.Euler(0, 8f, 0);

        var axle = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        axle.name = "axle"; axle.transform.SetParent(root.transform, false);
        axle.transform.localRotation = Quaternion.Euler(0, 0, 90);
        axle.transform.localScale = new Vector3(.16f, .85f, .16f);
        axle.GetComponent<Renderer>().sharedMaterial = Mats["darkwood"];
        Object.DestroyImmediate(axle.GetComponent<Collider>());

        int spokes = 16;
        for (int i = 0; i < spokes; i++)
        {
            float a = i * 360f / spokes;
            var spoke = GameObject.CreatePrimitive(PrimitiveType.Cube);
            spoke.name = "spoke"; spoke.transform.SetParent(root.transform, false);
            spoke.transform.localRotation = Quaternion.Euler(a, 0, 0);
            spoke.transform.localPosition = Quaternion.Euler(a, 0, 0) * new Vector3(0, radius * .5f, 0);
            spoke.transform.localScale = new Vector3(.1f, radius, .1f);
            spoke.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
            Object.DestroyImmediate(spoke.GetComponent<Collider>());

            var rim = GameObject.CreatePrimitive(PrimitiveType.Cube);
            rim.name = "rim"; rim.transform.SetParent(root.transform, false);
            rim.transform.localRotation = Quaternion.Euler(a, 0, 0);
            rim.transform.localPosition = Quaternion.Euler(a, 0, 0) * new Vector3(0, radius, 0);
            rim.transform.localScale = new Vector3(.16f, .1f, radius * 2f * Mathf.PI / spokes * 1.05f);
            rim.GetComponent<Renderer>().sharedMaterial = Mats["darkwood"];
            Object.DestroyImmediate(rim.GetComponent<Collider>());

            if (i % 2 == 0)
            {
                var paddle = GameObject.CreatePrimitive(PrimitiveType.Cube);
                paddle.name = "paddle"; paddle.transform.SetParent(root.transform, false);
                paddle.transform.localRotation = Quaternion.Euler(a, 0, 0);
                paddle.transform.localPosition = Quaternion.Euler(a, 0, 0) * new Vector3(0, radius * .93f, 0);
                paddle.transform.localScale = new Vector3(.62f, .5f, .12f);
                paddle.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
                Object.DestroyImmediate(paddle.GetComponent<Collider>());
            }
        }

        var water = GameObject.CreatePrimitive(PrimitiveType.Cube);
        water.name = "mill race"; water.transform.SetParent(propRoot, false);
        water.transform.position = new Vector3(w.x, WorldHeight(w.x, w.z) + .03f, w.z);
        water.transform.localScale = new Vector3(3.4f, .04f, 3.2f);
        water.GetComponent<Renderer>().sharedMaterial = Mats["water"];
        Object.DestroyImmediate(water.GetComponent<Collider>());
    }

    static void BuildFirePit(Vector2 at)
    {
        var root = new GameObject("Village fire pit");
        root.transform.SetParent(propRoot);
        Vector3 g = P(at.x, at.y);
        root.transform.position = new Vector3(g.x, WorldHeight(g.x, g.z) + .02f, g.z);
        for (int i = 0; i < 10; i++)
        {
            float a = i * 36f;
            var stone = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            stone.name = "pit stone";
            stone.transform.SetParent(root.transform, false);
            stone.transform.localPosition = Quaternion.Euler(0, a, 0) * new Vector3(0, .1f, 1.15f);
            stone.transform.localScale = new Vector3(.5f, .32f, .42f);
            stone.GetComponent<Renderer>().sharedMaterial = Mats["stone"];
            Object.DestroyImmediate(stone.GetComponent<Collider>());
        }
        for (int i = 0; i < 4; i++)
        {
            var log = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            log.name = "fire log";
            log.transform.SetParent(root.transform, false);
            log.transform.localPosition = new Vector3(0, .22f, 0);
            log.transform.localRotation = Quaternion.Euler(0, i * 45f, 82f);
            log.transform.localScale = new Vector3(.16f, .9f, .16f);
            log.GetComponent<Renderer>().sharedMaterial = Mats["darkwood"];
            Object.DestroyImmediate(log.GetComponent<Collider>());
        }
        var embers = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        embers.name = "embers";
        embers.transform.SetParent(root.transform, false);
        embers.transform.localPosition = new Vector3(0, .12f, 0);
        embers.transform.localScale = new Vector3(1.1f, .05f, 1.1f);
        embers.GetComponent<Renderer>().sharedMaterial = Mats["ember"];
        Object.DestroyImmediate(embers.GetComponent<Collider>());

        var light = new GameObject("fire light").AddComponent<Light>();
        light.transform.SetParent(root.transform, false);
        light.transform.localPosition = new Vector3(0, .8f, 0);
        light.type = LightType.Point; light.range = 12f; light.intensity = 4.2f;
        light.color = new Color(1f, .52f, .18f); light.shadows = LightShadows.Soft;
        light.shadowStrength = .6f;
        root.AddComponent<LanternFlicker>().source = light;
    }

    static void BuildVillageGate(Vector2 at)
    {
        var root = new GameObject("Village entrance gate");
        root.transform.SetParent(propRoot);
        Vector3 g = P(at.x, at.y);
        root.transform.position = new Vector3(g.x, WorldHeight(g.x, g.z), g.z);
        for (int i = 0; i < 2; i++)
        {
            var post = GameObject.CreatePrimitive(PrimitiveType.Cube);
            post.transform.SetParent(root.transform, false);
            post.transform.localPosition = new Vector3(0, 1.9f, i == 0 ? -2.9f : 2.9f);
            post.transform.localScale = new Vector3(.36f, 3.8f, .36f);
            post.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
        }
        var beam = GameObject.CreatePrimitive(PrimitiveType.Cube);
        beam.transform.SetParent(root.transform, false);
        beam.transform.localPosition = new Vector3(0, 3.75f, 0);
        beam.transform.localScale = new Vector3(.3f, .3f, 6.2f);
        beam.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
        var sign = GameObject.CreatePrimitive(PrimitiveType.Cube);
        sign.name = "gate board"; sign.transform.SetParent(root.transform, false);
        sign.transform.localPosition = new Vector3(-.28f, 3.1f, 0);
        sign.transform.localScale = new Vector3(.1f, .62f, 2.4f);
        sign.GetComponent<Renderer>().sharedMaterial = Mats["darkwood"];

        var lamp = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        lamp.name = "gate lamp"; lamp.transform.SetParent(root.transform, false);
        lamp.transform.localPosition = new Vector3(0, 3.42f, 1.4f);
        lamp.transform.localScale = Vector3.one * .3f;
        lamp.GetComponent<Renderer>().sharedMaterial = Mats["lantern"];
        Object.DestroyImmediate(lamp.GetComponent<Collider>());
        var l = lamp.AddComponent<Light>();
        l.type = LightType.Point; l.range = 12f; l.intensity = 4.5f; l.color = new Color(1f, .62f, .3f);
        l.shadows = LightShadows.Soft;
        lamp.AddComponent<LanternFlicker>().source = l;
    }

    static void BuildForestSign(Vector2 at)
    {
        var root = new GameObject("Forest path sign");
        root.transform.SetParent(propRoot);
        Vector3 g = P(at.x, at.y);
        root.transform.position = new Vector3(g.x, WorldHeight(g.x, g.z), g.z);
        var post = GameObject.CreatePrimitive(PrimitiveType.Cube);
        post.transform.SetParent(root.transform, false);
        post.transform.localPosition = new Vector3(0, 1.2f, 0);
        post.transform.localScale = new Vector3(.16f, 2.4f, .16f);
        post.GetComponent<Renderer>().sharedMaterial = Mats["wood"];
        var board = GameObject.CreatePrimitive(PrimitiveType.Cube);
        board.name = "sign board"; board.transform.SetParent(root.transform, false);
        board.transform.localPosition = new Vector3(0, 2.15f, .06f);
        board.transform.localScale = new Vector3(1.05f, .42f, .08f);
        board.GetComponent<Renderer>().sharedMaterial = Mats["darkwood"];
        board.transform.localRotation = Quaternion.Euler(0, 34f, 0);
    }

    static void Torch(Vector2 at)
    {
        var go = PlaceProp("Viking/pf_torch_fire_01", at, 0f);
        if (!go) return;
        var l = new GameObject("torch light").AddComponent<Light>();
        l.transform.SetParent(go.transform, false);
        l.transform.localPosition = new Vector3(0, 1.1f, 0);
        l.type = LightType.Point; l.range = 9f; l.intensity = 3.6f;
        l.color = new Color(1f, .58f, .25f); l.shadows = LightShadows.Soft;
        go.AddComponent<LanternFlicker>().source = l;
    }

    static GameObject PlaceProp(string path, Vector2 refPos, float yaw, float extraSink = 0f)
    {
        var prefab = LoadPrefab(path);
        if (!prefab) return null;
        var go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
        go.name = Path.GetFileNameWithoutExtension(path);
        go.transform.SetParent(propRoot, false);
        Vector3 w = P(refPos.x, refPos.y);
        float y = WorldHeight(w.x, w.z) - extraSink;
        go.transform.SetPositionAndRotation(new Vector3(w.x, y, w.z), Quaternion.Euler(0, yaw, 0));

        var rs = go.GetComponentsInChildren<Renderer>();
        if (rs.Length > 0)
        {
            Bounds b = rs[0].bounds;
            foreach (var r in rs) b.Encapsulate(r.bounds);
            go.transform.position += new Vector3(0, y - b.min.y, 0);
        }
        PlacedPoints.Add(go.transform.position);
        return go;
    }

    // ======================================================================
    // Vegetation
    // ======================================================================
    class PlantDef
    {
        public string path;
        public float minScale, maxScale;
        public float radius;      // footprint radius used for spacing/clearance
        public float roadClear;   // minimum distance from road centre line
    }

    static readonly PlantDef[] Canopy =
    {
        new PlantDef { path = "Forst/PF Conifer Tall BOTD URP", minScale = .72f, maxScale = 1.05f, radius = 3.1f, roadClear = 3.7f },
        new PlantDef { path = "Polyeler/Pine", minScale = .85f, maxScale = 1.15f, radius = 2.8f, roadClear = 3.7f },
        new PlantDef { path = "Polyeler/JapaneseCedar", minScale = .8f, maxScale = 1.0f, radius = 2.5f, roadClear = 3.3f },
        new PlantDef { path = "Polyeler/JapaneseCypress", minScale = .8f, maxScale = 1.05f, radius = 2.4f, roadClear = 3.3f },
        new PlantDef { path = "Polyeler/PlaneTree", minScale = .9f, maxScale = 1.2f, radius = 3.4f, roadClear = 3.9f }
    };
    static readonly PlantDef[] MidTrees =
    {
        new PlantDef { path = "Forst/PF Conifer Medium BOTD URP", minScale = .85f, maxScale = 1.1f, radius = 2.4f, roadClear = 3.5f },
        new PlantDef { path = "Polyeler/SawtoothOak", minScale = .9f, maxScale = 1.35f, radius = 2.8f, roadClear = 3.7f },
        new PlantDef { path = "Polyeler/DawnRedwood", minScale = .8f, maxScale = 1.1f, radius = 2.6f, roadClear = 3.3f },
        new PlantDef { path = "Polyeler/Ginkgo_wood", minScale = .85f, maxScale = 1.2f, radius = 2.4f, roadClear = 3.5f }
    };
    static readonly PlantDef[] SmallTrees =
    {
        new PlantDef { path = "Forst/PF Conifer Small BOTD URP", minScale = .9f, maxScale = 1.25f, radius = 1.5f, roadClear = 3.3f },
        new PlantDef { path = "Fantasy/tree_1", minScale = .55f, maxScale = .8f, radius = 3.0f, roadClear = 3.7f }
    };
    static readonly PlantDef[] Ferns =
    {
        new PlantDef { path = "BotD/Fern_var01_Prefab", minScale = 1.0f, maxScale = 2.2f, radius = .9f, roadClear = 2.6f },
        new PlantDef { path = "BotD/Fern_var02_Prefab", minScale = 1.0f, maxScale = 2.2f, radius = .9f, roadClear = 2.6f },
        new PlantDef { path = "BotD/Fern_var03_Prefab", minScale = 1.0f, maxScale = 2.2f, radius = .9f, roadClear = 2.6f }
    };

    static readonly PlantDef[] Bushes =
    {
        new PlantDef { path = "Polyeler/JapaneseEurya", minScale = .8f, maxScale = 1.5f, radius = 1.15f, roadClear = 2.4f },
        new PlantDef { path = "Polyeler/JapaneseLaurel", minScale = .8f, maxScale = 1.5f, radius = 1.15f, roadClear = 2.4f },
        new PlantDef { path = "Polyeler/JapaneseEurya", minScale = .45f, maxScale = .8f, radius = .7f, roadClear = 2.4f }
    };
    static readonly PlantDef[] Grass =
    {
        new PlantDef { path = "Polyeler/Mugwort", minScale = .9f, maxScale = 1.7f, radius = .55f, roadClear = 1.9f },
        new PlantDef { path = "Fantasy/grass01", minScale = 1.3f, maxScale = 2.2f, radius = .5f, roadClear = 1.8f },
        new PlantDef { path = "Polyeler/JapaneseEurya", minScale = .35f, maxScale = .6f, radius = .45f, roadClear = 1.9f }
    };

    static readonly List<Placed> Occupied = new List<Placed>();
    class Placed { public Vector3 p; public float r; public int kind; }
    static readonly Dictionary<long, List<Placed>> Grid = new Dictionary<long, List<Placed>>();

    static long Cell(float x, float z) => ((long)Mathf.Floor((x + 200f) / 8f) << 32) | (uint)Mathf.Floor((z + 200f) / 8f);

    static float MinGap(int a, int b, float ra, float rb)
    {
        if (a == 2 && b == 2) return Mathf.Max(ra, rb) * 1.05f;     // trees keep crown separation
        if (a == 2 && b == 1) return rb * .45f;                     // bushes may grow under trees
        if (a == 1 && b == 2) return ra * .45f;
        if (a == 2) return ra * .5f;                                // grass and stones may sit under trees
        if (b == 2) return rb * .5f;
        if (a == 1 && b == 1) return Mathf.Max(ra, rb) * .9f;
        if (a == 0 && b == 0) return Mathf.Max(ra, rb) * .55f;
        if (a == 0 || b == 0) return 0f;
        return Mathf.Max(ra, rb);
    }

    static bool FreeSpot(Vector3 p, float r, int kind)
    {
        long cx = (long)Mathf.Floor((p.x + 200f) / 8f), cz = (long)Mathf.Floor((p.z + 200f) / 8f);
        for (long dx = -1; dx <= 1; dx++)
            for (long dz = -1; dz <= 1; dz++)
            {
                long key = (cx + dx) << 32 | (uint)(cz + dz);
                if (!Grid.TryGetValue(key, out var list)) continue;
                foreach (var o in list)
                {
                    float min = MinGap(kind, o.kind, r, o.r);
                    if (min <= 0f) continue;
                    if ((o.p.x - p.x) * (o.p.x - p.x) + (o.p.z - p.z) * (o.p.z - p.z) < min * min) return false;
                }
            }
        return true;
    }

    static void Occupy(Vector3 p, float r, int kind)
    {
        var pl = new Placed { p = p, r = r, kind = kind };
        Occupied.Add(pl);
        long key = ((long)Mathf.Floor((p.x + 200f) / 8f) << 32) | (uint)Mathf.Floor((p.z + 200f) / 8f);
        if (!Grid.TryGetValue(key, out var list)) Grid[key] = list = new List<Placed>();
        list.Add(pl);
    }

    static void BuildVegetation()
    {
        // Village trees are authored, not scattered, so the square stays open.
        Vector2[] villageTrees =
        {
            V(31.8f, 20.2f), V(36.6f, 21.0f), V(24.0f, 22.6f), V(60.8f, 20.0f),
            V(59.4f, 36.6f), V(44.6f, 42.6f), V(69.4f, 35.0f)
        };
        foreach (var t in villageTrees) Plant(Canopy[1], t, 0.95f);

        int[] canopyCounts = { 42, 40, 38, 36, 30 };
        for (int i = 0; i < Canopy.Length; i++)
            Scatter(Canopy[i], canopyCounts[i], p => Wildness(p.x, p.y) > .42f);
        int[] midCounts = { 40, 40, 35, 35 };
        for (int i = 0; i < MidTrees.Length; i++)
            Scatter(MidTrees[i], midCounts[i], p => Wildness(p.x, p.y) > .30f);
        int[] smallCounts = { 60, 45 };
        for (int i = 0; i < SmallTrees.Length; i++)
            Scatter(SmallTrees[i], smallCounts[i], p => Wildness(p.x, p.y) > .20f);
        int[] fernCounts = { 90, 80, 80 };
        for (int i = 0; i < Ferns.Length; i++)
            Scatter(Ferns[i], fernCounts[i], p => Wildness(p.x, p.y) > .3f);
        int[] bushCounts = { 190, 170, 210 };
        for (int i = 0; i < Bushes.Length; i++)
            Scatter(Bushes[i], bushCounts[i], p => Wildness(p.x, p.y) > .06f);
        int[] grassCounts = { 380, 420, 420 };
        for (int i = 0; i < Grass.Length; i++)
            Scatter(Grass[i], grassCounts[i], p => true);
        Scatter(new PlantDef { path = "Polyeler/Rock_A", minScale = .7f, maxScale = 1.7f, radius = 1.0f, roadClear = 2.8f },
            70, p => Wildness(p.x, p.y) > .25f);
        Scatter(new PlantDef { path = "Polyeler/Rock_C", minScale = .7f, maxScale = 1.5f, radius = .9f, roadClear = 2.6f },
            55, p => Wildness(p.x, p.y) > .25f);
        Scatter(new PlantDef { path = "Polyeler/FallenLeaves", minScale = 1.4f, maxScale = 3.2f, radius = .8f, roadClear = 2.0f },
            130, p => Wildness(p.x, p.y) > .20f);

        PlantVillageShrubs();
        Scatter(new PlantDef { path = "Polyeler/Mugwort", minScale = .8f, maxScale = 1.4f, radius = .5f, roadClear = 2.0f },
            320, p => Wildness(p.x, p.y) < .3f);
        Scatter(new PlantDef { path = "BotD/Fern_var02_Prefab", minScale = .8f, maxScale = 1.5f, radius = .7f, roadClear = 2.3f },
            90, p => Wildness(p.x, p.y) < .45f);
        // The east half must stay a dense wood with only the trail cut through it.
        Scatter(Canopy[0], 45, p => p.x > 84f && p.y < 30f);
        Scatter(Canopy[3], 35, p => p.x > 84f && p.y < 30f);
        Scatter(MidTrees[1], 30, p => p.x > 84f && p.y < 30f);
        Scatter(Bushes[1], 120, p => p.x > 82f && p.y < 32f);
        Scatter(Grass[0], 160, p => p.x > 82f);
        Debug.Log("SETTLEMENT_VEGETATION occupied=" + Occupied.Count);
    }

    // Shrubs hug the building walls but never the door approach, which is how the reference
    // village reads: dense green edges with clear thresholds and lanes.
    static void PlantVillageShrubs()
    {
        var rng = new System.Random(97);
        foreach (var f in Footprints)
        {
            float baseR = Mathf.Max(f.half.x, f.half.y) + 1.35f;
            for (int i = 0; i < 12; i++)
            {
                float a = i * 30f + (float)rng.NextDouble() * 12f;
                if (Mathf.Abs(Mathf.DeltaAngle(a, f.doorDir)) < 55f) continue;
                if (rng.NextDouble() < .35) continue;
                Vector2 p = f.center + new Vector2(Mathf.Sin(a * Mathf.Deg2Rad), Mathf.Cos(a * Mathf.Deg2Rad)) * baseR;
                if (p.x < 3f || p.x > 117f || p.y < 3f || p.y > 61f) continue;
                if (RoadDistance(p.x, p.y) < 2.4f) continue;
                if (!ClearOfBuildings(p, .6f)) continue;
                if (!ClearOfClues(p, 2.4f)) continue;
                var def = Bushes[rng.Next(0, Bushes.Length)];
                float scale = Mathf.Lerp(def.minScale, def.maxScale, (float)rng.NextDouble()) * .85f;
                Vector3 w = P(p.x, p.y);
                w.y = WorldHeight(w.x, w.z);
                if (!FreeSpot(w, def.radius * scale, 1)) continue;
                InstantiatePlant(def.path, w, rng.Next(0, 360), scale);
                Occupy(w, def.radius * scale, 1);
            }
        }
    }

    // Rejection sampling across the map; the region filter decides where the plant belongs.
    static void Scatter(PlantDef def, int count, Func<Vector2, bool> region)
    {
        var rng = new System.Random(def.path.GetHashCode() ^ count);
        int placed = 0, attempts = 0, maxAttempts = count * 90;
        while (placed < count && attempts++ < maxAttempts)
        {
            Vector2 p = new Vector2((float)rng.NextDouble() * MapW, (float)rng.NextDouble() * MapH);
            if (!region(p)) continue;
            if (!ClearOfClues(p, 3.6f)) continue;
            if (!ClearOfBuildings(p, 1.5f)) continue;
            if (!ClearOfPlaza(p, .5f)) continue;
            if (RoadDistance(p.x, p.y) < def.roadClear) continue;
            float scale = Mathf.Lerp(def.minScale, def.maxScale, (float)rng.NextDouble());
            float r = def.radius * scale;
            Vector3 w = P(p.x, p.y);
            w.y = WorldHeight(w.x, w.z);
            int kind = def.radius >= 1.6f ? 2 : def.radius >= .7f ? 1 : 0;
            if (!FreeSpot(w, r, kind)) continue;
            var go = InstantiatePlant(def.path, w, rng.Next(0, 360), scale);
            if (!go) continue;
            Occupy(w, r, kind);
            placed++;
        }
        Debug.Log("SETTLEMENT_SCATTER " + def.path + " placed=" + placed + "/" + count + " attempts=" + attempts);
    }

        static void Plant(PlantDef def, Vector2 refPos, float scale)
    {
        Vector3 w = P(refPos.x, refPos.y);
        w.y = WorldHeight(w.x, w.z);
        InstantiatePlant(def.path, w, 0f, scale);
        Occupy(w, def.radius * scale, 2);
    }

    static GameObject InstantiatePlant(string path, Vector3 world, float yaw, float scale)
    {
        var prefab = LoadPrefab(path);
        if (!prefab) return null;
        var go = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
        go.name = Path.GetFileNameWithoutExtension(path);
        go.transform.SetParent(forestRoot, true);
        go.transform.SetPositionAndRotation(world, Quaternion.Euler(0, yaw, 0));
        go.transform.localScale = go.transform.localScale * scale;

        var rs = go.GetComponentsInChildren<Renderer>();
        if (rs.Length == 0) { Object.DestroyImmediate(go); return null; }
        Bounds b = rs[0].bounds;
        foreach (var r in rs) b.Encapsulate(r.bounds);
        go.transform.position += new Vector3(0, world.y - b.min.y, 0);

        if (path.StartsWith("Fantasy"))
        {
            bool grass = path.Contains("grass01");
            foreach (var r in rs)
            {
                var mats = r.sharedMaterials;
                for (int i = 0; i < mats.Length; i++)
                {
                    string original = mats[i] ? mats[i].name.ToLower() : "";
                    mats[i] = grass ? Mats["fantasyGrass"]
                        : original.Contains("bark") ? Mats["fantasyBark"]
                        : Mats["fantasyFoliage"];
                }
                r.sharedMaterials = mats;
            }
        }

        foreach (var r in rs)
        {
            r.shadowCastingMode = b.size.y > 3f ? ShadowCastingMode.On : ShadowCastingMode.Off;
            r.receiveShadows = true;
        }
        return go;
    }

    // ======================================================================
    // Investigation objects
    // ======================================================================
    static void BuildInvestigation()
    {
        // Hunter emblem on a crate by the inn door.
        var emblem = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        emblem.name = "Evidence - hunter emblem";
        emblem.transform.SetParent(clueRoot);
        Vector2 ep = V(57.8f, 31.2f);
        Vector3 ew = P(ep.x, ep.y);
        emblem.transform.position = new Vector3(ew.x, WorldHeight(ew.x, ew.z) + .55f, ew.z);
        emblem.transform.localScale = new Vector3(.5f, .06f, .5f);
        emblem.transform.rotation = Quaternion.Euler(0, 20, 90);
        emblem.GetComponent<Renderer>().sharedMaterial = Mats["metal"];
        var ei = emblem.AddComponent<DemoInteractable>();
        ei.clueId = "emblem"; ei.range = 2.6f;
        ei.evidenceText = "Evidence: a hunter's emblem pressed into the mud by the inn door.";
        var el = new GameObject("Emblem glint").AddComponent<Light>();
        el.transform.SetParent(emblem.transform, false);
        el.type = LightType.Point; el.range = 3.2f; el.intensity = 1.2f; el.color = new Color(1f, .85f, .6f);

        // Witness by the north-east cabin.
        var witness = new GameObject("Witness");
        witness.transform.SetParent(clueRoot);
        Vector3 ww = P(WitnessPoint.x, WitnessPoint.y);
        witness.transform.position = new Vector3(ww.x, WorldHeight(ww.x, ww.z), ww.z);
        witness.transform.rotation = Quaternion.Euler(0, -125f, 0);
        BuildFigure(witness.transform, Mats["cloth"]);
        var wi = witness.AddComponent<DemoInteractable>();
        wi.clueId = "witness"; wi.range = 3.2f;
        wi.evidenceText = "Witness: \"Something dragged a body east, past the old storehouse, into the pines.\"";

        // Drag marks from the east range of houses to the forest.
        var marks = new GameObject("Evidence - drag marks");
        marks.transform.SetParent(clueRoot);
        Vector2[] trail = { V(85.5f, 28.4f), V(91f, 30.6f), V(96.5f, 30.4f), V(101f, 27.4f), V(105.5f, 25.4f) };
        for (int i = 0; i < trail.Length - 1; i++)
            DragSegment(marks.transform, trail[i], trail[i + 1]);
        Vector3 trailAnchor = P(92f, 30.6f);
        var trailProp = GameObject.CreatePrimitive(PrimitiveType.Cube);
        trailProp.name = "Trail clue anchor";
        trailProp.transform.SetParent(marks.transform, false);
        trailProp.transform.position = new Vector3(trailAnchor.x, WorldHeight(trailAnchor.x, trailAnchor.z) + .08f, trailAnchor.z);
        trailProp.transform.localScale = new Vector3(1.1f, .12f, 2.2f);
        trailProp.GetComponent<Renderer>().sharedMaterial = Mats["trail"];
        var ti = trailProp.AddComponent<DemoInteractable>();
        ti.clueId = "trail"; ti.range = 2.8f;
        ti.evidenceText = "Evidence: deep drag marks and a broken strap lead east into the pines.";

        // Missing scene: disturbed ground and a dropped crate where the trail starts.
        var scene = new GameObject("Missing scene");
        scene.transform.SetParent(clueRoot);
        Vector3 ms = P(MissingScenePoint.x, MissingScenePoint.y);
        scene.transform.position = new Vector3(ms.x, WorldHeight(ms.x, ms.z), ms.z);
        var crate = GameObject.CreatePrimitive(PrimitiveType.Cube);
        crate.name = "broken crate"; crate.transform.SetParent(scene.transform, false);
        crate.transform.localPosition = new Vector3(0, .28f, 0);
        crate.transform.localScale = new Vector3(.9f, .55f, .7f);
        crate.transform.rotation = Quaternion.Euler(0, 24, 12);
        crate.GetComponent<Renderer>().sharedMaterial = Mats["wood"];

        // Mentor mark deep in the forest, behind the enemy.
        var mentor = GameObject.CreatePrimitive(PrimitiveType.Cube);
        mentor.name = "Mentor mark placeholder";
        mentor.transform.SetParent(clueRoot);
        Vector3 mp = P(MentorPoint.x, MentorPoint.y);
        mentor.transform.position = new Vector3(mp.x, WorldHeight(mp.x, mp.z) + .6f, mp.z);
        mentor.transform.localScale = new Vector3(.7f, 1.2f, .22f);
        mentor.transform.rotation = Quaternion.Euler(0, 20f, 0);
        mentor.GetComponent<Renderer>().sharedMaterial = Mats["marker"];
        var mfl = new GameObject("Mentor mark light").AddComponent<Light>();
        mfl.transform.SetParent(mentor.transform, false);
        mfl.transform.localPosition = new Vector3(0, .6f, -.4f);
        mfl.type = LightType.Point; mfl.range = 5f; mfl.intensity = 1.6f; mfl.color = new Color(.8f, .9f, 1f);
        var mm = mentor.AddComponent<DemoInteractable>();
        mm.clueId = "mentor"; mm.range = 3f;
        mm.evidenceText = "A familiar hunter's mark points toward the castle.";

        // Forest checkpoint at the entrance.
        var checkpoint = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        checkpoint.name = "Forest checkpoint placeholder";
        checkpoint.transform.SetParent(clueRoot);
        Vector3 cp = P(ForestEntrance.x - 3.5f, ForestEntrance.y + 1.6f);
        checkpoint.transform.position = new Vector3(cp.x, WorldHeight(cp.x, cp.z) + .5f, cp.z);
        checkpoint.transform.localScale = new Vector3(.8f, .5f, .8f);
        checkpoint.GetComponent<Renderer>().sharedMaterial = Mats["stone"];
        Object.DestroyImmediate(checkpoint.GetComponent<Collider>());
        CheckPoint = checkpoint.transform;

        // Enemy waiting deeper on the path.
        var enemy = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        enemy.name = "Training enemy";
        enemy.transform.SetParent(clueRoot);
        Vector3 en = P(99.5f, 27.2f);
        enemy.transform.position = new Vector3(en.x, WorldHeight(en.x, en.z) + .95f, en.z);
        enemy.transform.localScale = new Vector3(.8f, .95f, .8f);
        enemy.GetComponent<Renderer>().sharedMaterial = Mats["enemy"];
        Object.DestroyImmediate(enemy.GetComponent<CapsuleCollider>());
        var ec = enemy.AddComponent<CapsuleCollider>();
        ec.radius = .45f; ec.height = 1.9f; ec.center = new Vector3(0, 0, 0);
        var agent = enemy.AddComponent<NavMeshAgent>();
        agent.radius = .45f; agent.height = 1.8f; agent.speed = 2.6f; agent.stoppingDistance = 1.2f;
        enemy.AddComponent<DemoEnemy>();

        EnemyObject = enemy;
        MentorObject = mentor;
        CheckPoint = checkpoint.transform;
        MentorPointWorld = mentor.transform.position;
    }

    static GameObject EnemyObject, MentorObject;
    static Transform CheckPoint;
    static Vector3 MentorPointWorld;

    static void DragSegment(Transform parent, Vector2 a, Vector2 b)
    {
        Vector2[] samples = new Vector2[3];
        for (int i = 0; i < 3; i++)
        {
            Vector2 p = Vector2.Lerp(a, b, i / 2f);
            var q = GameObject.CreatePrimitive(PrimitiveType.Cube);
            q.name = "drag mark";
            q.transform.SetParent(parent, false);
            Vector3 w = P(p.x, p.y);
            q.transform.position = new Vector3(w.x, WorldHeight(w.x, w.z) + .03f, w.z);
            q.transform.localScale = new Vector3(.55f, .05f, 1.5f);
            q.transform.rotation = Quaternion.Euler(0, Mathf.Atan2(b.x - a.x, b.y - a.y) * Mathf.Rad2Deg, 0);
            q.GetComponent<Renderer>().sharedMaterial = Mats["trail"];
            Object.DestroyImmediate(q.GetComponent<Collider>());
        }
    }

    static void BuildFigure(Transform root, Material cloth)
    {
        var body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        body.name = "body"; body.transform.SetParent(root, false);
        body.transform.localPosition = new Vector3(0, .95f, 0);
        body.transform.localScale = new Vector3(.62f, .95f, .62f);
        body.GetComponent<Renderer>().sharedMaterial = cloth;
        Object.DestroyImmediate(body.GetComponent<Collider>());

        var head = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        head.name = "hood"; head.transform.SetParent(root, false);
        head.transform.localPosition = new Vector3(0, 1.92f, 0);
        head.transform.localScale = new Vector3(.36f, .4f, .38f);
        head.GetComponent<Renderer>().sharedMaterial = cloth;
        Object.DestroyImmediate(head.GetComponent<Collider>());

        var col = root.gameObject.AddComponent<CapsuleCollider>();
        col.radius = .4f; col.height = 2f; col.center = new Vector3(0, 1f, 0);
    }

    // ======================================================================
    // Lighting
    // ======================================================================
    static void BuildLighting()
    {
        var moonGo = new GameObject("Moonlight");
        moonGo.transform.SetParent(lightRoot);
        var moon = moonGo.AddComponent<Light>();
        moon.type = LightType.Directional;
        moon.color = new Color(.58f, .68f, 1f);
        moon.intensity = .85f;
        moon.shadows = LightShadows.Soft;
        moon.shadowStrength = .82f;
        moonGo.transform.rotation = Quaternion.Euler(42f, -34f, 0);

        var rimGo = new GameObject("Moon rim fill");
        rimGo.transform.SetParent(lightRoot);
        var rim = rimGo.AddComponent<Light>();
        rim.type = LightType.Directional;
        rim.color = new Color(.35f, .5f, .85f);
        rim.intensity = .22f;
        rim.shadows = LightShadows.None;
        rimGo.transform.rotation = Quaternion.Euler(28f, 150f, 0);

        // Door lamps are derived from each building's own door marker so the light always
        // falls on the threshold the player actually walks up to.
        foreach (var id in new[] { "B01", "B02", "B03", "B05", "B06", "B07", "B09", "B10", "B11" })
        {
            var def = Buildings.First(b => b.id == id);
            var building = GameObject.Find(def.id + " " + def.label);
            if (!building) continue;
            var door = building.transform.Find("door");
            if (!door) continue;
            Vector3 p = door.position + door.forward * .25f + Vector3.up * 2.35f;
            bool small = id == "B10" || id == "B11";
            var lamp = MakeLantern(p, small ? 7f : 8.5f, small ? 2.4f : 3.4f);
            lamp.name = id + " door lantern";
        }

        WarmLamp("Square lantern", V(45.5f, 26.2f), 3.0f, 13f, 5.4f, new Color(1f, .62f, .28f));
        WarmLamp("Square lantern south", V(48.5f, 20.5f), 2.6f, 10f, 3.2f, new Color(1f, .6f, .27f));
        WarmLamp("East range lantern", V(62.6f, 26.0f), 2.4f, 10f, 3.4f, new Color(1f, .6f, .27f));
        WarmLamp("North range lantern", V(53.2f, 47.4f), 2.0f, 8f, 2.4f, new Color(1f, .6f, .27f));
        WarmLamp("Forest edge lantern", V(107.4f, 26.2f), 2.2f, 9f, 2.8f, new Color(1f, .58f, .25f));

        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.ExponentialSquared;
        RenderSettings.fogColor = new Color(.035f, .05f, .075f);
        RenderSettings.fogDensity = .016f;
        RenderSettings.ambientMode = AmbientMode.Trilight;
        RenderSettings.ambientSkyColor = new Color(.10f, .13f, .19f);
        RenderSettings.ambientEquatorColor = new Color(.055f, .065f, .085f);
        RenderSettings.ambientGroundColor = new Color(.02f, .022f, .026f);
        RenderSettings.ambientIntensity = 1f;
        RenderSettings.skybox = Mats["sky"];
        RenderSettings.reflectionIntensity = .45f;
        RenderSettings.defaultReflectionMode = DefaultReflectionMode.Skybox;
    }

    static Light MakeLantern(Vector3 position, float range, float intensity)
    {
        var root = new GameObject("lantern");
        root.transform.SetParent(lightRoot);
        root.transform.position = position;
        var glass = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        glass.name = "glass";
        glass.transform.SetParent(root.transform, false);
        glass.transform.localScale = Vector3.one * .26f;
        glass.GetComponent<Renderer>().sharedMaterial = Mats["lantern"];
        Object.DestroyImmediate(glass.GetComponent<Collider>());
        var l = root.AddComponent<Light>();
        l.type = LightType.Point;
        l.range = range;
        l.intensity = intensity;
        l.color = new Color(1f, .64f, .3f);
        l.shadows = LightShadows.Soft;
        l.shadowStrength = .65f;
        root.AddComponent<LanternFlicker>().source = l;
        return l;
    }

    static void WarmLamp(string name, Vector2 at, float height, float range, float intensity, Color color)
    {
        Vector3 w = P(at.x, at.y);
        var go = new GameObject(name);
        go.transform.SetParent(lightRoot);
        go.transform.position = new Vector3(w.x, WorldHeight(w.x, w.z) + height, w.z);
        var l = go.AddComponent<Light>();
        l.type = LightType.Point;
        l.range = range;
        l.intensity = intensity;
        l.color = color;
        l.shadows = LightShadows.Soft;
        l.shadowStrength = .7f;
        go.AddComponent<LanternFlicker>().source = l;
    }

    // ======================================================================
    // Player, camera, post processing
    // ======================================================================
    static void BuildPlayerAndCamera()
    {
        var player = new GameObject("Player");
        Vector3 spawn = P(VillageEntrance.x + 1.5f, VillageEntrance.y);
        player.transform.position = new Vector3(spawn.x, WorldHeight(spawn.x, spawn.z) + .1f, spawn.z);
        player.transform.rotation = Quaternion.Euler(0, 90, 0);

        var body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        body.name = "Hunter body";
        body.transform.SetParent(player.transform, false);
        body.transform.localPosition = new Vector3(0, .9f, 0);
        body.transform.localScale = new Vector3(.68f, .9f, .68f);
        body.GetComponent<Renderer>().sharedMaterial = Mats["player"];
        Object.DestroyImmediate(body.GetComponent<Collider>());

        var head = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        head.name = "Hunter head";
        head.transform.SetParent(player.transform, false);
        head.transform.localPosition = new Vector3(0, 1.72f, 0);
        head.transform.localScale = Vector3.one * .34f;
        head.GetComponent<Renderer>().sharedMaterial = Mats["cloth"];
        Object.DestroyImmediate(head.GetComponent<Collider>());

        // Carried lantern in the left hand.
        var lamp = GameObject.CreatePrimitive(PrimitiveType.Cube);
        lamp.name = "Carried lantern";
        lamp.transform.SetParent(player.transform, false);
        lamp.transform.localPosition = new Vector3(.42f, 1.05f, .18f);
        lamp.transform.localScale = new Vector3(.22f, .3f, .22f);
        lamp.GetComponent<Renderer>().sharedMaterial = Mats["lantern"];
        Object.DestroyImmediate(lamp.GetComponent<Collider>());
        var carried = lamp.AddComponent<Light>();
        carried.type = LightType.Point;
        carried.range = 13f;
        carried.intensity = 4.6f;
        carried.color = new Color(1f, .74f, .45f);
        carried.shadows = LightShadows.Soft;
        carried.shadowStrength = .55f;

        var fill = new GameObject("Lantern near fill").AddComponent<Light>();
        fill.transform.SetParent(player.transform, false);
        fill.transform.localPosition = new Vector3(0, 2.2f, 0);
        fill.type = LightType.Point;
        fill.range = 5f;
        fill.intensity = .9f;
        fill.color = new Color(.85f, .9f, 1f);
        fill.shadows = LightShadows.None;

        var agent = player.AddComponent<NavMeshAgent>();
        agent.radius = .42f; agent.height = 1.8f; agent.baseOffset = 0f;
        agent.speed = 3.6f; agent.acceleration = 22f; agent.angularSpeed = 720f;
        agent.stoppingDistance = .15f;

        var movement = player.AddComponent<DemoMovement>();
        player.AddComponent<DemoHealth>();
        var flow = player.AddComponent<DemoPrologueFlow>();
        flow.enemy = EnemyObject;
        flow.mentorClue = MentorObject;
        flow.checkpoint = CheckPoint;
        var investigation = player.AddComponent<DemoInvestigation>();
        investigation.requireTrail = true;

        var camGo = new GameObject("Demo camera");
        camGo.transform.SetParent(player.transform, false);
        camGo.tag = "MainCamera";
        var cam = camGo.AddComponent<Camera>();
        cam.fieldOfView = 55f;
        cam.nearClipPlane = .15f;
        cam.farClipPlane = 140f;
        cam.clearFlags = CameraClearFlags.Skybox;
        cam.allowHDR = true;
        var cameraData = camGo.AddComponent<UniversalAdditionalCameraData>();
        cameraData.renderPostProcessing = true;
        cameraData.antialiasing = AntialiasingMode.SubpixelMorphologicalAntiAliasing;
        camGo.AddComponent<AudioListener>();
        var demoCam = camGo.AddComponent<DemoCamera>();
        demoCam.target = player.transform;
        demoCam.offset = new Vector3(0f, 8.2f, -8.2f);
        movement.viewCamera = cam;
        movement.groundMask = ~0;
    }

    static void BuildPostProcessing()
    {
        string profilePath = EnvDir + "/SettlementPostProfile.asset";
        if (AssetDatabase.LoadAssetAtPath<VolumeProfile>(profilePath)) AssetDatabase.DeleteAsset(profilePath);
        var profile = ScriptableObject.CreateInstance<VolumeProfile>();
        AssetDatabase.CreateAsset(profile, profilePath);

        var bloom = profile.Add<Bloom>(true);
        bloom.threshold.Override(.82f);
        bloom.intensity.Override(1.15f);
        bloom.scatter.Override(.72f);
        bloom.tint.Override(new Color(1f, .9f, .8f));

        var color = profile.Add<ColorAdjustments>(true);
        color.postExposure.Override(.55f);
        color.contrast.Override(9f);
        color.saturation.Override(-4f);
        color.colorFilter.Override(new Color(1f, .97f, .92f));

        var vignette = profile.Add<Vignette>(true);
        vignette.intensity.Override(.32f);
        vignette.smoothness.Override(.55f);

        var tone = profile.Add<Tonemapping>(true);
        tone.mode.Override(TonemappingMode.ACES);

        var volumeGo = new GameObject("Post processing");
        var volume = volumeGo.AddComponent<Volume>();
        volume.isGlobal = true;
        volume.sharedProfile = profile;
        volume.priority = 1f;
    }

    // ======================================================================
    // Navigation
    // ======================================================================
    static void BakeNavigation()
    {
        var go = new GameObject("Navigation");
        go.transform.SetParent(villageRoot);
        var surface = go.AddComponent<NavMeshSurface>();
        surface.collectObjects = CollectObjects.All;
        surface.useGeometry = NavMeshCollectGeometry.PhysicsColliders;
        surface.layerMask = ~0;
        surface.agentTypeID = 0;
        surface.BuildNavMesh();
        if (surface.navMeshData)
        {
            AssetDatabase.CreateAsset(surface.navMeshData, NavAsset);
        }
        Debug.Log("SETTLEMENT_NAV baked=" + (surface.navMeshData != null));
    }

    static void ConfigureScene()
    {
        var settings = AssetDatabase.LoadAssetAtPath<UniversalRenderPipelineAsset>("Assets/Viking Village/Rendering/VikingVillageUniversal.asset");
        if (settings) GraphicsSettings.defaultRenderPipeline = settings;
    }

    static void AddSceneToBuildSettings()
    {
        var list = EditorBuildSettings.scenes.ToList();
        if (!list.Any(s => s.path == ScenePath))
        {
            list.Insert(0, new EditorBuildSettingsScene(ScenePath, true));
            EditorBuildSettings.scenes = list.ToArray();
        }
    }

    // ======================================================================
    // Materials and prefab loading
    // ======================================================================
    static void PrepareMaterials()
    {
        Mats["stone"] = MakeLit("VillageStone", new Color(.42f, .41f, .39f), .1f);
        Mats["wood"] = MakeLit("VillageWood", new Color(.30f, .22f, .15f), .12f);
        Mats["darkwood"] = MakeLit("VillageDarkWood", new Color(.17f, .12f, .085f), .1f);
        Mats["cloth"] = MakeLit("VillageCloth", new Color(.22f, .18f, .16f), .05f);
        Mats["player"] = MakeLit("HunterCoat", new Color(.16f, .17f, .2f), .12f);
        Mats["metal"] = MakeLit("HunterEmblem", new Color(.55f, .55f, .58f), .55f);
        Mats["marker"] = MakeLit("MentorMark", new Color(.55f, .58f, .6f), .25f);
        Mats["enemy"] = MakeLit("TrainingEnemy", new Color(.32f, .06f, .06f), .18f);
        Mats["trail"] = MakeLit("DragMark", new Color(.13f, .045f, .035f), .02f);
        Mats["water"] = MakeLit("WellWater", new Color(.015f, .022f, .026f), .18f);
        Mats["lantern"] = MakeEmissive("LanternGlass", new Color(1f, .72f, .38f), 5f);
        Mats["ember"] = MakeEmissive("FireEmbers", new Color(1f, .42f, .12f), 2.4f);
        Mats["sky"] = MakeSky();
        Mats["fantasyBark"] = MakeTextured("FantasyBark", "Assets/Fantasy Forest Environment Free Sample/Textures/tree_branches.png", false);
        Mats["fantasyFoliage"] = MakeTextured("FantasyFoliage", "Assets/Fantasy Forest Environment Free Sample/Textures/tree_branches.png", true);
        Mats["fantasyGrass"] = MakeTextured("FantasyGrass", "Assets/Fantasy Forest Environment Free Sample/Textures/grassmesh.png", true);
        AssetDatabase.SaveAssets();
    }

    static Material MakeLit(string name, Color color, float smoothness)
    {
        var mat = new Material(Shader.Find("Universal Render Pipeline/Lit"));
        mat.name = name;
        mat.SetColor("_BaseColor", color);
        mat.SetFloat("_Smoothness", smoothness);
        mat.SetFloat("_Metallic", name == "HunterEmblem" ? .7f : 0f);
        mat.enableInstancing = true;
        SaveMaterial(mat);
        return mat;
    }

    static Material MakeEmissive(string name, Color color, float intensity)
    {
        var mat = new Material(Shader.Find("Universal Render Pipeline/Lit"));
        mat.name = name;
        mat.SetColor("_BaseColor", color);
        mat.SetColor("_EmissionColor", color * intensity);
        mat.EnableKeyword("_EMISSION");
        mat.SetFloat("_Smoothness", .4f);
        SaveMaterial(mat);
        return mat;
    }

    // The Fantasy Forest demo ships with a built-in-RP shader; rebuild its materials on URP Lit
    // so the tree and grass render instead of magenta / invisible.
    static Material MakeTextured(string name, string texturePath, bool foliage)
    {
        var tex = AssetDatabase.LoadAssetAtPath<Texture2D>(texturePath);
        var mat = new Material(Shader.Find("Universal Render Pipeline/Lit"));
        mat.name = name;
        if (tex) mat.SetTexture("_BaseMap", tex);
        mat.SetColor("_BaseColor", Color.white);
        mat.SetFloat("_Smoothness", .05f);
        mat.SetFloat("_Metallic", 0f);
        if (foliage)
        {
            mat.SetFloat("_AlphaClip", 1f);
            mat.SetFloat("_Cutoff", .35f);
            mat.SetFloat("_Cull", 0f);
            mat.EnableKeyword("_ALPHATEST_ON");
            mat.renderQueue = (int)RenderQueue.AlphaTest;
        }
        mat.enableInstancing = true;
        SaveMaterial(mat);
        return mat;
    }

    static Material MakeSky()
    {
        var shader = Shader.Find("Skybox/Procedural");
        Material mat;
        if (shader)
        {
            mat = new Material(shader);
            mat.name = "NightSky";
            mat.SetColor("_SkyTint", new Color(.09f, .12f, .2f));
            mat.SetColor("_GroundColor", new Color(.015f, .018f, .025f));
            mat.SetFloat("_AtmosphereThickness", 1.3f);
            mat.SetFloat("_Exposure", .55f);
            mat.SetFloat("_SunSize", .04f);
            mat.SetFloat("_SunSizeConvergence", 3f);
        }
        else
        {
            mat = MakeLit("NightSky", new Color(.03f, .04f, .06f), 0f);
        }
        SaveMaterial(mat);
        return mat;
    }

    static void SaveMaterial(Material mat)
    {
        string path = MatDir + "/" + mat.name + ".mat";
        if (AssetDatabase.LoadAssetAtPath<Material>(path)) AssetDatabase.DeleteAsset(path);
        AssetDatabase.CreateAsset(mat, path);
    }

    static GameObject LoadPrefab(string key)
    {
        string path;
        switch (key.Split('/')[0])
        {
            case "Village": path = "Assets/Demo/ThirdParty/VillageBuildings/FBX/" + key.Substring(8) + ".fbx"; break;
            case "Viking":
                var vikingName = key.Substring(7);
                path = "Assets/Viking Village/Prefabs/Buildings/" + vikingName + ".prefab";
                if (!AssetDatabase.LoadAssetAtPath<GameObject>(path))
                    path = "Assets/Viking Village/Prefabs/Props/" + vikingName + ".prefab";
                break;
            case "Polyeler": path = "Assets/Polyeler/EssentialNaturePack/Prefabs/" + key.Substring(9) + ".prefab"; break;
            case "Forst": path = "Assets/Forst/Conifers [BOTD]/Render Pipeline Support/URP/Prefabs/" + key.Substring(6) + ".prefab"; break;
            case "Pine": path = "Assets/AssetPacks/Pine Forest_LowPoly/Prefabs/" +
                    (key.StartsWith("Pine/Bush") ? "Bushes/" : key.StartsWith("Pine/Ground") ? "GroundCover/" : "") + key.Substring(5) + ".prefab"; break;
            case "Fantasy": path = "Assets/Fantasy Forest Environment Free Sample/Meshes/Prefabs/" + key.Substring(8) + ".prefab"; break;
            case "BotD": path = "Assets/Viking Village/Book of the Dead/Vegetation/Ferns/" + key.Substring(5) + ".prefab"; break;
            default: throw new Exception("Unknown asset key " + key);
        }
        var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(path);
        if (!prefab) Debug.LogError("SETTLEMENT_MISSING_ASSET " + path);
        return prefab;
    }
}
