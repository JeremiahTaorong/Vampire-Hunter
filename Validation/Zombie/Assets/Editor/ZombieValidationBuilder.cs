using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

public static class ZombieValidationBuilder
{
    public static void Build()
    {
        EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        foreach (string file in new[] {"Zombie_Shamble.anim", "Zombie_Bite.anim", "Zombie.controller", "ShirtlessZombie.prefab", "Target.mat", "Floor.mat", "ZombieFeasibility.unity"})
            AssetDatabase.DeleteAsset("Assets/Validation/" + file);
        GraphicsSettings.renderPipelineAsset = AssetDatabase.LoadAssetAtPath<RenderPipelineAsset>("Assets/Settings/URP-Balanced.asset");
        QualitySettings.renderPipeline = GraphicsSettings.renderPipelineAsset;
        string modelPath = File.ReadAllText("Evidence/model-path.txt").Trim();
        var importer = (ModelImporter)AssetImporter.GetAtPath(modelPath);
        importer.animationType = ModelImporterAnimationType.Human;
        importer.avatarSetup = ModelImporterAvatarSetup.CreateFromThisModel;
        importer.SaveAndReimport();
        var source = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/NewPunch/ShirtlessZombieFree/Prefabs/ShirtlessZombie_FREE_URP.prefab");
        var zombie = (GameObject)PrefabUtility.InstantiatePrefab(source);
        zombie.name = "Shirtless Zombie - independent test";
        var animator = zombie.GetComponent<Animator>();
        if (!animator || !animator.avatar || !animator.avatar.isValid || !animator.avatar.isHuman) throw new Exception("Model lacks a valid humanoid avatar");
        animator.applyRootMotion = false;
        animator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
        var mesh = zombie.GetComponentsInChildren<SkinnedMeshRenderer>();
        foreach (var r in mesh) r.updateWhenOffscreen = true;
        var walk = ZombieAnimationBake.Bake(animator, "Zombie_Shamble", false);
        var bite = ZombieAnimationBake.Bake(animator, "Zombie_Bite", true);
        // The source keeps its valid Humanoid avatar for future retargeting.
        // These authored clips contain this skeleton's transform curves.
        animator.avatar = null;
        var controller = AnimatorController.CreateAnimatorControllerAtPath("Assets/Validation/Zombie.controller");
        controller.AddParameter("Walking", AnimatorControllerParameterType.Bool);
        controller.AddParameter("Bite", AnimatorControllerParameterType.Trigger);
        var machine = controller.layers[0].stateMachine;
        var idle = machine.AddState("Idle"); idle.motion = walk; idle.speed = .18f;
        var shamble = machine.AddState("Shamble"); shamble.motion = walk;
        var attack = machine.AddState("Bite"); attack.motion = bite;
        machine.defaultState = idle;
        var go = idle.AddTransition(shamble); go.hasExitTime = false; go.duration = .12f; go.AddCondition(AnimatorConditionMode.If, 0, "Walking");
        var stop = shamble.AddTransition(idle); stop.hasExitTime = false; stop.duration = .12f; stop.AddCondition(AnimatorConditionMode.IfNot, 0, "Walking");
        var hit = machine.AddAnyStateTransition(attack); hit.hasExitTime = false; hit.duration = .1f; hit.canTransitionToSelf = false; hit.AddCondition(AnimatorConditionMode.If, 0, "Bite");
        var recover = attack.AddTransition(idle); recover.hasExitTime = true; recover.exitTime = 1; recover.duration = .1f;
        animator.runtimeAnimatorController = controller;
        zombie.transform.position = new Vector3(0, 0, -3);
        PrefabUtility.SaveAsPrefabAsset(zombie, "Assets/Validation/ShirtlessZombie.prefab");
        var target = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        target.name = "Damage target"; target.transform.position = new Vector3(0, 1, 0);
        target.transform.localScale = new Vector3(.55f, 1, .55f);
        target.GetComponent<Renderer>().sharedMaterial = Material("Target", new Color(.24f,.49f,.58f));
        var enemy = zombie.AddComponent<ZombieValidationEnemy>(); enemy.animator = animator; enemy.target = target.transform;
        var floor = GameObject.CreatePrimitive(PrimitiveType.Plane); floor.name = "Validation ground";
        floor.transform.localScale = Vector3.one * 1.5f; floor.GetComponent<Renderer>().sharedMaterial = Material("Floor", new Color(.15f,.17f,.19f));
        var camera = new GameObject("Camera").AddComponent<Camera>(); camera.tag = "MainCamera";
        camera.transform.position = new Vector3(4, 2.2f, -.5f); camera.transform.LookAt(new Vector3(0, 1, -1.1f));
        camera.fieldOfView = 36; camera.backgroundColor = new Color(.06f,.075f,.095f); camera.clearFlags = CameraClearFlags.SolidColor;
        var light = new GameObject("Key light").AddComponent<Light>(); light.type = LightType.Directional; light.intensity = 1.4f;
        light.transform.rotation = Quaternion.Euler(35, -35, 0);
        var fill = new GameObject("Fill light").AddComponent<Light>(); fill.type = LightType.Directional; fill.intensity = .7f; fill.color = new Color(.64f,.78f,1);
        fill.transform.rotation = Quaternion.Euler(30, 145, 0);
        RenderSettings.ambientMode = AmbientMode.Flat; RenderSettings.ambientLight = new Color(.35f,.35f,.35f);
        EditorSceneManager.SaveScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene(), "Assets/Validation/ZombieFeasibility.unity");
        AssetDatabase.SaveAssets();
        Debug.Log("ZOMBIE BUILD PASS: humanoid avatar, authored shamble and bite clips, controller, prefab, URP scene");
        EditorApplication.Exit(0);
    }
    static Material Material(string name, Color color)
    {
        var material = new Material(Shader.Find("Universal Render Pipeline/Lit")) {name = name, color = color};
        AssetDatabase.CreateAsset(material, "Assets/Validation/" + name + ".mat");
        return material;
    }
    public static void Import()
    {
        string package = File.ReadAllText("Evidence/package-path.txt");
        AssetDatabase.importPackageCompleted += name => EditorApplication.delayCall += Inspect;
        AssetDatabase.importPackageFailed += (name, message) => { Debug.LogError(message); EditorApplication.Exit(1); };
        AssetDatabase.ImportPackage(package, false);
    }
    public static void Inspect()
    {
        foreach (string path in AssetDatabase.GetAllAssetPaths().Where(p => p.StartsWith("Assets/") && (p.EndsWith(".fbx", StringComparison.OrdinalIgnoreCase) || p.EndsWith(".prefab") || p.EndsWith(".anim"))))
        {
            Debug.Log("ZOMBIE ASSET " + path);
            foreach (var clip in AssetDatabase.LoadAllAssetsAtPath(path).OfType<AnimationClip>()) Debug.Log("ZOMBIE CLIP " + clip.name + " length=" + clip.length);
            var model = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            if (!model) continue;
            foreach (var t in model.GetComponentsInChildren<Transform>(true)) Debug.Log("ZOMBIE BONE " + AnimationUtility.CalculateTransformPath(t, model.transform) + " rotation=" + t.localEulerAngles);
            foreach (var r in model.GetComponentsInChildren<SkinnedMeshRenderer>(true)) Debug.Log("ZOMBIE MESH " + r.name + " bounds=" + r.bounds + " materials=" + string.Join(",", r.sharedMaterials.Select(m => m ? m.name : "NULL")));
        }
        EditorApplication.Exit(0);
    }
}
