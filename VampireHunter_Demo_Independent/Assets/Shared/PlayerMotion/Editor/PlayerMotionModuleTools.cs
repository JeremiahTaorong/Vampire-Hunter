using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using Unity.AI.Navigation;

public static class PlayerMotionModuleTools
{
    public const string Root = "Assets/Shared/PlayerMotion/";
    public const string PrefabPath = Root + "Prefabs/Hunter_SharedPlayer.prefab";
    public const string ChapterA = Root + "Examples/PlayerMotion_ChapterA.unity";
    public const string ChapterB = Root + "Examples/PlayerMotion_ChapterB.unity";
    public const string Evidence = "Evidence/player-motion-module-20261108/";
    const string SourceScene = "Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity";
    static string Hash(string path)
    {
        using (var sha = SHA256.Create()) return BitConverter.ToString(sha.ComputeHash(File.ReadAllBytes(path))).Replace("-", "").ToLowerInvariant();
    }
    [MenuItem("Vampire Demo/Shared Player Motion/Rebuild Shared Prefab and Examples")]
    public static void Build()
    {
        try
        {
            string before = Hash(SourceScene);
            var sourceScene = EditorSceneManager.OpenScene(SourceScene);
            var source = sourceScene.GetRootGameObjects().SelectMany(r => r.GetComponentsInChildren<DemoMovement>(true)).Single();
            var clone = UnityEngine.Object.Instantiate(source.gameObject);
            clone.name = "Hunter Shared Player";
            clone.transform.SetParent(null);
            clone.transform.position = Vector3.zero;
            clone.transform.rotation = Quaternion.identity;
            foreach (var flow in clone.GetComponents<DemoPrologueFlow>()) UnityEngine.Object.DestroyImmediate(flow);
            foreach (var investigation in clone.GetComponents<DemoInvestigation>()) UnityEngine.Object.DestroyImmediate(investigation);
            foreach (var component in clone.GetComponentsInChildren<MonoBehaviour>(true).Where(c => c && (c.GetType().Name.EndsWith("Probe") || c.GetType().Name == "HunterReview")).ToArray())
                UnityEngine.Object.DestroyImmediate(component);
            foreach (var transform in clone.GetComponentsInChildren<Transform>(true)) GameObjectUtility.RemoveMonoBehavioursWithMissingScript(transform.gameObject);
            clone.GetComponent<DemoMovement>().viewCamera = null;
            var binding = clone.GetComponent<SharedPlayerChapterBinding>();
            if (!binding) binding = clone.AddComponent<SharedPlayerChapterBinding>();
            binding.chapterCamera = null;
            var prefab = PrefabUtility.SaveAsPrefabAsset(clone, PrefabPath);
            UnityEngine.Object.DestroyImmediate(clone);
            if (!prefab || prefab.GetComponent<DemoPrologueFlow>() || prefab.GetComponent<DemoInvestigation>()) throw new Exception("Shared prefab contains chapter quest logic");
            BuildChapter(ChapterA, "Chapter A", new Color(.24f,.29f,.33f));
            BuildChapter(ChapterB, "Chapter B", new Color(.32f,.27f,.22f));
            AssetDatabase.SaveAssets();
            var dependencies = AssetDatabase.GetDependencies(PrefabPath, true).Where(p => p.StartsWith("Assets/")).OrderBy(p => p).ToArray();
            File.WriteAllText(Root + "dependencies.txt", string.Join("\n", dependencies) + "\n");
            if (Hash(SourceScene) != before) throw new Exception("Source chapter scene changed during extraction");
            File.WriteAllText(Evidence + "setup.txt", "Unity " + Application.unityVersion + "\nSource scene unchanged SHA256=" + before + "\nShared prefab=" + PrefabPath + "\nBoth examples reference this prefab. Source scripts and motion parameters retained; chapter quest components and scene camera references removed.\nDependencies=" + dependencies.Length);
            Debug.Log("SHARED PLAYER MODULE SETUP PASS");
            EditorApplication.Exit(0);
        }
        catch (Exception ex) { Debug.LogException(ex); EditorApplication.Exit(1); }
    }
    static void BuildChapter(string scenePath, string title, Color color)
    {
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var navigation = new GameObject("Chapter navigation").AddComponent<NavMeshSurface>();
        navigation.collectObjects = CollectObjects.Children;
        var floor = GameObject.CreatePrimitive(PrimitiveType.Cube);
        floor.name = title + " ground";
        floor.transform.SetParent(navigation.transform);
        floor.transform.position = new Vector3(0, -.1f, 0);
        floor.transform.localScale = new Vector3(24, .2f, 24);
        var material = new Material(Shader.Find("Universal Render Pipeline/Lit")) {color = color};
        string materialPath = scenePath.Replace(".unity", ".mat");
        AssetDatabase.DeleteAsset(materialPath);
        AssetDatabase.CreateAsset(material, materialPath);
        floor.GetComponent<Renderer>().sharedMaterial = material;
        navigation.BuildNavMesh();
        string dataPath = scenePath.Replace(".unity", "_NavMesh.asset");
        AssetDatabase.DeleteAsset(dataPath);
        AssetDatabase.CreateAsset(navigation.navMeshData, dataPath);
        var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(PrefabPath);
        var player = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
        player.transform.position = new Vector3(-3, 0, 0);
        var movement = player.GetComponent<DemoMovement>();
        int mask = movement.groundMask.value;
        floor.layer = Enumerable.Range(0, 32).First(i => (mask & (1 << i)) != 0);
        var camera = new GameObject("Chapter camera").AddComponent<Camera>();
        camera.tag = "MainCamera";
        camera.fieldOfView = 45;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(.07f,.09f,.12f);
        camera.gameObject.AddComponent<DemoCamera>().offset = new Vector3(0, 5, -6);
        var sun = new GameObject("Chapter light").AddComponent<Light>();
        sun.type = LightType.Directional; sun.intensity = 1.1f; sun.transform.rotation = Quaternion.Euler(40,-35,0);
        RenderSettings.ambientLight = new Color(.4f,.4f,.4f);
        RenderSettings.fog = false;
        var target = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        target.name = "Animation test target"; target.transform.position = new Vector3(3, 1, 0);
        var enemy = target.AddComponent<DemoEnemy>(); enemy.maxHealth = 1000; enemy.enabled = false;
        EditorSceneManager.SaveScene(scene, scenePath);
    }
    [MenuItem("Vampire Demo/Shared Player Motion/Export Unity Package With Dependencies")]
    public static void Export()
    {
        Directory.CreateDirectory("Builds/PlayerMotion");
        AssetDatabase.ExportPackage(new[] {Root.TrimEnd('/'), "Assets/Demo/Scripts"}, "Builds/PlayerMotion/HunterPlayerMotion.unitypackage", ExportPackageOptions.IncludeDependencies | ExportPackageOptions.Recurse);
        Debug.Log("Shared player package exported to Builds/PlayerMotion/HunterPlayerMotion.unitypackage");
    }
}
