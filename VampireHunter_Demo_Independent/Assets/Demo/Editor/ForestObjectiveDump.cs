using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class ForestObjectiveDump
{
    const string Scene = "Assets/Demo/Scenes/PrologueForestFinalReview.unity";

    public static void Run()
    {
        EditorSceneManager.OpenScene(Scene);
        var sb = new StringBuilder();
        sb.AppendLine("=== all root objects ===");
        foreach (var go in EditorSceneManager.GetActiveScene().GetRootGameObjects())
            sb.AppendLine(go.name + " active=" + go.activeSelf + " pos=" + go.transform.position.ToString("F2"));

        sb.AppendLine("=== lights ===");
        foreach (var l in Object.FindObjectsOfType<Light>())
        {
            sb.AppendLine(l.gameObject.name + " type=" + l.type + " color=" + l.color
                          + " intensity=" + l.intensity + " range=" + l.range
                          + " pos=" + l.transform.position.ToString("F2") + " shadows=" + l.shadows);
        }

        sb.AppendLine("=== interactables / markers ===");
        foreach (var mb in Object.FindObjectsOfType<MonoBehaviour>())
        {
            var n = mb.GetType().Name;
            if (!n.Contains("Interact") && !n.Contains("Investigation") && !n.Contains("Enemy")
                && !n.Contains("Prologue") && !n.Contains("Health")) continue;
            sb.AppendLine(mb.gameObject.name + " [" + n + "] pos=" + mb.transform.position.ToString("F2"));
        }

        File.WriteAllText(Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-objective-dump.log"), sb.ToString());
        Debug.Log(sb.ToString());
    }
}
