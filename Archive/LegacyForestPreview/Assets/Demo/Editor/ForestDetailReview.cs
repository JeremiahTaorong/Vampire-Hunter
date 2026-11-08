using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
public static class ForestDetailReview {
 public static void Build(){var dst="Assets/Demo/Scenes/PrologueForestDetailReview.unity"; if(File.Exists(dst))throw new Exception("scene exists"); var s=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueForestReviewV6.unity"); EditorSceneManager.SaveScene(s,dst,true); s=EditorSceneManager.OpenScene(dst); var shader=Shader.Find("VampireDemo/ForestDetailReview");if(!shader)throw new Exception("shader missing");var m=new Material(shader);AssetDatabase.CreateAsset(m,"Assets/Demo/Atmosphere/ForestDetailReview.mat");var root=GameObject.Find("Forest review - placed vegetation");foreach(var r in root.GetComponentsInChildren<Renderer>(true))r.sharedMaterials=Enumerable.Repeat(m,r.sharedMaterials.Length).ToArray();EditorSceneManager.SaveScene(s);AssetDatabase.SaveAssets();EditorApplication.Exit(0); }
}
