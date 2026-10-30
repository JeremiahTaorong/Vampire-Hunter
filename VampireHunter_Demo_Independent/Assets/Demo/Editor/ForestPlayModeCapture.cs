using System.IO;
using UnityEditor;
using UnityEngine;

// Registers the review scene for Play Mode tests. Batch mode can hang when entering Play Mode
// through EditorApplication.EnterPlaymode, so the walk is driven by the Unity Test Framework
// instead, which needs the scene in the build settings.
public static class ForestPlayModeCapture
{
    const string Scene = "Assets/Demo/Scenes/PrologueForestFinalReview.unity";

    public static void Prepare()
    {
        var scenes = new System.Collections.Generic.List<EditorBuildSettingsScene>(EditorBuildSettings.scenes);
        if (!scenes.Exists(s => s.path == Scene))
            scenes.Add(new EditorBuildSettingsScene(Scene, true));
        EditorBuildSettings.scenes = scenes.ToArray();
        AssetDatabase.SaveAssets();
        File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-test-scene-registration.log"),
            "build_scene=" + Scene + "\ncount=" + EditorBuildSettings.scenes.Length + "\n");
        Debug.Log("[ForestTest] registered " + Scene);
    }
}
