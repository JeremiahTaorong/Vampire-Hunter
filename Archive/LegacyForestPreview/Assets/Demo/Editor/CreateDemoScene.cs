using UnityEditor;
using UnityEditor.AI;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class CreateDemoScene
{
    public static void Build()
    {
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var ground = GameObject.CreatePrimitive(PrimitiveType.Cube);
        ground.name = "Walkable ground"; ground.transform.position = new Vector3(0,-.5f,0); ground.transform.localScale = new Vector3(20,1,20);
        GameObjectUtility.SetStaticEditorFlags(ground, StaticEditorFlags.NavigationStatic);
        var wall = GameObject.CreatePrimitive(PrimitiveType.Cube);
        wall.name = "Obstacle"; wall.transform.position = new Vector3(1,1,2); wall.transform.localScale = new Vector3(5,2,1);
        GameObjectUtility.SetStaticEditorFlags(wall, StaticEditorFlags.NavigationStatic);
        EditorSceneManager.SaveScene(scene, "Assets/Demo/Scenes/MovementDemo.unity");
        UnityEditor.AI.NavMeshBuilder.BuildNavMesh();
        var player = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        player.name = "Player"; player.transform.position = new Vector3(0,1,-5);
        var agent = player.AddComponent<NavMeshAgent>(); agent.baseOffset = 1f; agent.speed = 4f; agent.angularSpeed = 720;
        var cameraObject = new GameObject("Demo camera");
        var cam = cameraObject.AddComponent<Camera>(); cameraObject.tag = "MainCamera"; cameraObject.AddComponent<AudioListener>();
        var follow = cameraObject.AddComponent<DemoCamera>(); follow.target = player.transform;
        cameraObject.transform.position = player.transform.position + follow.offset; cameraObject.transform.LookAt(player.transform.position);
        var movement = player.AddComponent<DemoMovement>(); movement.viewCamera = cam; movement.groundMask = 1;
        player.AddComponent<DemoHealth>();
        player.AddComponent<DemoInvestigation>();
        var evidence = GameObject.CreatePrimitive(PrimitiveType.Cube);
        evidence.name = "Evidence - hunter emblem";
        evidence.transform.position = new Vector3(-4, .5f, 3);
        evidence.transform.localScale = Vector3.one;
        evidence.AddComponent<DemoInteractable>();
        var witness = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        witness.name = "Witness placeholder";
        witness.transform.position = new Vector3(-5, 1, -1);
        var witnessInteraction = witness.AddComponent<DemoInteractable>();
        witnessInteraction.clueId = "witness";
        witnessInteraction.evidenceText = "Witness: the missing villagers were dragged toward the forest.";
        var enemy = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        enemy.name = "Training enemy";
        enemy.transform.position = new Vector3(4, 1, 4);
        var enemyAgent = enemy.AddComponent<NavMeshAgent>(); enemyAgent.baseOffset = 1f; enemyAgent.speed = 2.2f; enemyAgent.stoppingDistance = 1.2f;
        enemy.AddComponent<DemoEnemy>();
        if (!AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/TrainingEnemy.mat"))
        {
            var enemyMaterial = new Material(Shader.Find("Universal Render Pipeline/Lit"));
            enemyMaterial.color = new Color(.7f, .08f, .1f);
            AssetDatabase.CreateAsset(enemyMaterial, "Assets/Demo/TrainingEnemy.mat");
        }
        enemy.GetComponent<Renderer>().sharedMaterial = AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/TrainingEnemy.mat");
        var light = new GameObject("Directional Light"); light.AddComponent<Light>().type = LightType.Directional; light.transform.rotation = Quaternion.Euler(50,-30,0);
        EditorSceneManager.SaveScene(scene, "Assets/Demo/Scenes/MovementDemo.unity");
        EditorBuildSettings.scenes = new [] { new EditorBuildSettingsScene("Assets/Demo/Scenes/MovementDemo.unity", true) };
        AssetDatabase.SaveAssets();
        Debug.Log("DEMO_SCENE_CREATED");
    }
}
