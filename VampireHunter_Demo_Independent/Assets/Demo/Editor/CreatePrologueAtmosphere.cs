using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

public static class CreatePrologueAtmosphere
{
    public static void Build()
    {
        var scene = EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueGreybox.unity");
        EditorSceneManager.SaveScene(scene, "Assets/Demo/Scenes/PrologueAtmosphere.unity");
        RenderSettings.skybox = null;
        RenderSettings.ambientMode = AmbientMode.Flat;
        RenderSettings.ambientLight = new Color(.11f, .115f, .12f);
        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.Linear;
        RenderSettings.fogColor = new Color(.055f, .06f, .065f);
        RenderSettings.fogStartDistance = 17f;
        RenderSettings.fogEndDistance = 85f;
        var camera = GameObject.Find("Demo camera").GetComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = RenderSettings.fogColor;
        var sun = GameObject.Find("Directional Light").GetComponent<Light>();
        sun.color = new Color(.58f,.65f,.72f); sun.intensity = .28f;
        var dark = MaterialAt("Assets/Demo/Atmosphere/DarkStone.mat",new Color(.12f,.13f,.14f));
        var ground = MaterialAt("Assets/Demo/Atmosphere/Ground.mat",new Color(.18f,.19f,.20f));
        var player = MaterialAt("Assets/Demo/Atmosphere/Player.mat",new Color(.25f,.28f,.31f));
        var landmark = MaterialAt("Assets/Demo/Atmosphere/Clue.mat",new Color(.55f,.51f,.43f));
        Assign("Walkable ground",ground);
        foreach (var name in new [] {"Village house A","Village house B","Village house C","Village square well marker","Forest entrance north","Forest entrance south","Forest tree marker A","Forest tree marker B","Forest tree marker C","Forest tree marker D","Forest tree marker E","Castle vista marker"}) Assign(name,dark);
        Assign("Player",player); Assign("Witness placeholder",player);
        foreach (var name in new [] {"Evidence - hunter emblem","Evidence - drag marks placeholder","Mentor mark placeholder","Forest checkpoint placeholder"}) Assign(name,landmark);
        Point("Village entrance lantern",new Vector3(-47,3,-7),new Color(1f,.58f,.25f),1.8f,13f);
        Point("Village square lantern",new Vector3(-34,3,6),new Color(1f,.58f,.25f),1.8f,16f);
        Point("Village exit lantern",new Vector3(-19,3,0),new Color(1f,.62f,.32f),1.5f,12f);
        Point("Forest entrance moonlight",new Vector3(4,5,0),new Color(.65f,.74f,.85f),1.7f,17f);
        Point("Forest clearing moonlight",new Vector3(28,7,0),new Color(.62f,.70f,.80f),2f,20f);
        Point("Mentor mark light",new Vector3(49,3,0),new Color(.75f,.79f,.84f),1.2f,12f);
        var fill = new GameObject("Hunter visibility fill");
        fill.transform.SetParent(GameObject.Find("Player").transform, false);
        fill.transform.localPosition = new Vector3(0,2,0);
        var fillLight=fill.AddComponent<Light>(); fillLight.type=LightType.Point; fillLight.color=new Color(.65f,.7f,.75f); fillLight.intensity=.38f; fillLight.range=6f; fillLight.shadows=LightShadows.None;
        EditorSceneManager.SaveScene(scene);
        EditorBuildSettings.scenes = new [] {
            new EditorBuildSettingsScene("Assets/Demo/Scenes/MovementDemo.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/ProloguePrototype.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueGreybox.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueAtmosphere.unity",true)
        };
        AssetDatabase.SaveAssets();
        Debug.Log("PROLOGUE_ATMOSPHERE_CREATED");
    }
    static Material MaterialAt(string path, Color color)
    {
        if (!AssetDatabase.IsValidFolder("Assets/Demo/Atmosphere")) AssetDatabase.CreateFolder("Assets/Demo","Atmosphere");
        var existing=AssetDatabase.LoadAssetAtPath<Material>(path);
        if (existing) return existing;
        var material = new Material(Shader.Find("Universal Render Pipeline/Lit")); material.color=color;
        AssetDatabase.CreateAsset(material,path); return material;
    }
    static void Assign(string name, Material material)
    {
        var go = GameObject.Find(name);
        if (go && go.GetComponent<Renderer>()) go.GetComponent<Renderer>().sharedMaterial=material;
    }
    static void Point(string name, Vector3 position, Color color, float intensity, float range)
    {
        var go=new GameObject(name); go.transform.position=position;
        var light=go.AddComponent<Light>(); light.type=LightType.Point; light.color=color; light.intensity=intensity; light.range=range; light.shadows=LightShadows.None;
    }
}
