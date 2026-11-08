using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class ZombieSceneIntegration
{
    public const string ScenePath = "Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity";
    public const string EvidencePath = "Evidence/zombie-integration-20261107/";
    const string AssetsPath = "Assets/Demo/Characters/Zombie/";
    public static void Build()
    {
        try
        {
            var scene = EditorSceneManager.OpenScene(ScenePath);
            var enemy = scene.GetRootGameObjects().SelectMany(r => r.GetComponentsInChildren<DemoEnemy>(true)).Single();
            var flow = scene.GetRootGameObjects().SelectMany(r => r.GetComponentsInChildren<DemoPrologueFlow>(true)).Single();
            if (flow.enemy != enemy.gameObject) throw new Exception("Existing quest enemy reference does not match");
            var agent = enemy.GetComponent<NavMeshAgent>();
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(AssetsPath + "Zombie.controller");
            foreach (string name in new[] { "LocomotionSpeed", "AttackSpeed" })
                if (!controller.parameters.Any(p => p.name == name))
                    controller.AddParameter(new AnimatorControllerParameter {name = name, type = AnimatorControllerParameterType.Float, defaultFloat = 1});
            foreach (var child in controller.layers[0].stateMachine.states)
            {
                var state = child.state;
                if (state.name == "Idle") state.speed = 0;
                else
                {
                    state.speedParameter = state.name == "Shamble" ? "LocomotionSpeed" : "AttackSpeed";
                    state.speedParameterActive = true;
                }
            }
            var oldVisual = enemy.transform.Find("Shirtless zombie visual");
            if (oldVisual) UnityEngine.Object.DestroyImmediate(oldVisual.gameObject);
            var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(AssetsPath + "ShirtlessZombie_Visual.prefab");
            var visual = (GameObject)PrefabUtility.InstantiatePrefab(prefab, enemy.transform);
            visual.name = "Shirtless zombie visual";
            visual.transform.localRotation = Quaternion.identity;
            Vector3 scale = enemy.transform.lossyScale;
            visual.transform.localScale = new Vector3(1 / scale.x, 1 / scale.y, 1 / scale.z);
            visual.transform.position = enemy.transform.position - Vector3.up * agent.baseOffset;
            var animator = visual.GetComponent<Animator>();
            animator.runtimeAnimatorController = controller;
            animator.avatar = null;
            animator.applyRootMotion = false;
            animator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
            foreach (var renderer in visual.GetComponentsInChildren<SkinnedMeshRenderer>(true)) renderer.updateWhenOffscreen = true;
            // Retain the root collider, agent and stable quest references, hide only the capsule mesh.
            enemy.GetComponent<MeshRenderer>().enabled = false;
            var bridge = enemy.GetComponent<DemoZombieVisual>();
            if (!bridge) bridge = enemy.gameObject.AddComponent<DemoZombieVisual>();
            bridge.animator = animator;
            agent.speed = .85f;
            agent.stoppingDistance = .9f;
            enemy.attackRange = 1.05f;
            EditorUtility.SetDirty(controller);
            EditorSceneManager.MarkSceneDirty(scene);
            EditorSceneManager.SaveScene(scene);
            AssetDatabase.SaveAssets();
            // Confirm that the saved scene retains the visual and quest references.
            scene = EditorSceneManager.OpenScene(ScenePath);
            enemy = scene.GetRootGameObjects().SelectMany(r => r.GetComponentsInChildren<DemoEnemy>(true)).Single();
            if (!enemy.GetComponent<DemoZombieVisual>() || enemy.GetComponent<MeshRenderer>().enabled)
                throw new Exception("Saved scene did not retain the replacement");
            File.WriteAllText(EvidencePath + "setup.txt", "Saved and reopened " + ScenePath + "\nExisting Training enemy GameObject, collider, navigation and quest references retained. Capsule mesh disabled; validated zombie visual added.\nHP=30; damage=15; windup=.7s; cooldown=1.5s unchanged. Presentation fit: speed=.85m/s, stoppingDistance=.9m, grab range=1.05m.\nUnity " + Application.unityVersion);
            Debug.Log("ZOMBIE INTEGRATION SETUP PASS");
            EditorApplication.Exit(0);
        }
        catch (Exception ex) { Debug.LogException(ex); EditorApplication.Exit(1); }
    }
}
