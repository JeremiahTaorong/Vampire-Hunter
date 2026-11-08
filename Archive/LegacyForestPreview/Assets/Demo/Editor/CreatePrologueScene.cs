using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class CreatePrologueScene
{
    public static void Build()
    {
        var scene = EditorSceneManager.OpenScene("Assets/Demo/Scenes/MovementDemo.unity");
        EditorSceneManager.SaveScene(scene, "Assets/Demo/Scenes/ProloguePrototype.unity");
        var player = GameObject.Find("Player");
        var enemy = GameObject.Find("Training enemy");
        var clue = GameObject.CreatePrimitive(PrimitiveType.Cube);
        clue.name = "Mentor mark placeholder";
        clue.transform.position = new Vector3(5,.5f,6);
        var interaction = clue.AddComponent<DemoInteractable>();
        interaction.clueId = "mentor";
        interaction.evidenceText = "A familiar hunter's mark points toward the castle.";
        var flow = player.AddComponent<DemoPrologueFlow>();
        flow.enemy = enemy; flow.mentorClue = clue;
        EditorSceneManager.SaveScene(scene);
        EditorBuildSettings.scenes = new [] {
            new EditorBuildSettingsScene("Assets/Demo/Scenes/MovementDemo.unity", true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/ProloguePrototype.unity", true)
        };
        AssetDatabase.SaveAssets();
        Debug.Log("PROLOGUE_SCENE_CREATED");
    }
}
