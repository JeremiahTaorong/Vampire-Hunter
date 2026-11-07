using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Object = UnityEngine.Object;

[InitializeOnLoad]
public static class SeveredArmSetup
{
    const string Evidence = "Evidence/severed-arm-20261106/";
    const string Scene = "Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity";
    const string Source = "Assets/Demo/ThirdParty/BloodClues/SeveredArm/";
    const string Generated = "Assets/Demo/Environment/SeveredArm/";
    static SeveredArmSetup() { EditorApplication.update += Poll; }
    static void Poll()
    {
        if (EditorApplication.isCompiling || EditorApplication.isUpdating || EditorApplication.isPlayingOrWillChangePlaymode) return;
        string command = Evidence + "command.txt";
        if (!File.Exists(command)) return;
        string action;
        try { action = File.ReadAllText(command).Trim(); File.Move(command, Evidence + "command-" + DateTime.UtcNow.Ticks + ".txt"); }
        catch (IOException) { return; }
        try
        {
            if (action == "build") Build();
            else if (action == "test")
            {
                if (EditorSceneManager.GetActiveScene().isDirty) throw new InvalidOperationException("Save scene before test.");
                Object.FindObjectOfType<DemoMovement>().gameObject.AddComponent<SeveredArmProbe>();
                EditorApplication.isPlaying = true;
            }
            else if (action == "finish")
            {
                foreach (var probe in Object.FindObjectsOfType<SeveredArmProbe>()) Object.DestroyImmediate(probe);
                EditorSceneManager.OpenScene(Scene);
                File.WriteAllText(Evidence + "saved.txt", "Saved scene reopened; temporary probe removed; " + Application.unityVersion);
            }
            else throw new ArgumentException(action);
        }
        catch (Exception ex) { File.WriteAllText(Evidence + "error.txt", ex.ToString()); Debug.LogException(ex); }
    }
    static Bounds BoundsOf(GameObject go)
    {
        var rs = go.GetComponentsInChildren<Renderer>();
        var bounds = rs[0].bounds;
        foreach (var r in rs) bounds.Encapsulate(r.bounds);
        return bounds;
    }
    static void Build()
    {
        if (EditorSceneManager.GetActiveScene().isDirty) throw new InvalidOperationException("Unsaved scene changes.");
        var scene = EditorSceneManager.OpenScene(Scene);
        var clue = Object.FindObjectsOfType<DemoInteractable>().Single(c => c.clueId == "trail");
        var root = clue.transform.Find("Blood evidence visuals");
        if (root.GetComponentsInChildren<Transform>().Any(t => t.name.StartsWith("Severed Arm"))) throw new InvalidOperationException("Arm already installed.");
        Directory.CreateDirectory(Generated);
        AssetDatabase.Refresh();
        string normalPath = Source + "textures/Dead_armLP_Choppedarm_Normal.png";
        var normalImporter = (TextureImporter)AssetImporter.GetAtPath(normalPath);
        normalImporter.textureType = TextureImporterType.NormalMap;
        normalImporter.SaveAndReimport();
        var material = new Material(Shader.Find("Universal Render Pipeline/Lit")) { name = "SeveredArm_Skin_URP" };
        material.SetTexture("_BaseMap", AssetDatabase.LoadAssetAtPath<Texture2D>(Source + "textures/Dead_armLP_Choppedarm_BaseColor.png"));
        material.SetTexture("_BumpMap", AssetDatabase.LoadAssetAtPath<Texture2D>(normalPath));
        material.EnableKeyword("_NORMALMAP");
        material.SetFloat("_BumpScale", .8f);
        material.SetFloat("_Metallic", 0);
        material.SetFloat("_Smoothness", .23f);
        AssetDatabase.CreateAsset(material, Generated + "SeveredArm_Skin_URP.mat");
        var arm = (GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>(Source + "source/Dead armLP.fbx"));
        arm.name = "Severed Arm - joshuagoldenburgh CC BY 4.0";
        arm.transform.SetParent(root, false);
        foreach (var animator in arm.GetComponentsInChildren<Animator>()) animator.enabled = false;
        foreach (var collider in arm.GetComponentsInChildren<Collider>()) Object.DestroyImmediate(collider);
        foreach (var renderer in arm.GetComponentsInChildren<Renderer>()) renderer.sharedMaterials = renderer.sharedMaterials.Select(m => material).ToArray();
        var b = BoundsOf(arm);
        if (b.size.y > b.size.x && b.size.y > b.size.z) arm.transform.Rotate(0, 0, 90, Space.World);
        b = BoundsOf(arm);
        if (b.size.y > b.size.z) arm.transform.Rotate(90, 0, 0, Space.World);
        arm.transform.Rotate(0, -22, 0, Space.World);
        b = BoundsOf(arm);
        arm.transform.localScale *= .92f / Mathf.Max(b.size.x, b.size.y, b.size.z);
        b = BoundsOf(arm);
        var terrain = Object.FindObjectOfType<Terrain>();
        var p = root.position + new Vector3(.15f, 0, -.12f);
        p.y = terrain.SampleHeight(p) + terrain.transform.position.y + .04f;
        arm.transform.position += p - new Vector3(b.center.x, b.min.y, b.center.z);
        clue.name = "Trail clue - blood drag and severed arm";
        clue.evidenceText = "Evidence: a severed arm lies in a pool of blood. A long blood smear leads east into the pines.";
        PrefabUtility.SaveAsPrefabAsset(arm, Generated + "SeveredArm_Ground.prefab");
        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();
        File.WriteAllText(Evidence + "built.txt", "Unity=" + Application.unityVersion + "\nArm=" + BoundsOf(arm) + "\nBaseColor+Normal; metallic=0 smoothness=.23; source roughness and metallic maps retained, not assigned.\nExtra pools=" + root.Find("Scattered blood pool cluster").GetComponentsInChildren<Renderer>().Length + "\nclueId=" + clue.clueId + " range=" + clue.range);
        EditorSceneManager.OpenScene(Scene);
    }
}
