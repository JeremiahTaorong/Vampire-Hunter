using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class CreateSoftFogSample
{
    public static void Build()
    {
        var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueFogSample.unity");
        EditorSceneManager.SaveScene(scene,"Assets/Demo/Scenes/PrologueSoftFog.unity");
        foreach (var name in new [] {"Village ground mist","Village exit mist","Forest entrance mist","Forest clearing mist","Distant castle mist"})
        {
            var old=GameObject.Find(name); if (old) Object.DestroyImmediate(old);
        }
        var shader=Shader.Find("VampireDemo/LayeredGroundFog");
        if (!shader) throw new System.Exception("ground fog shader not found");
        var fill=GameObject.Find("Hunter visibility fill");
        if (fill && fill.GetComponent<Light>()) { fill.GetComponent<Light>().intensity=1.2f; fill.GetComponent<Light>().range=8f; }
        Layer("Near ground fog",new Vector3(0,.12f,0),new Vector2(116,60),shader,.18f,.07f,0,.025f);
        Layer("Mid-height drifting fog",new Vector3(0,.55f,0),new Vector2(112,56),shader,.12f,.10f,6.5f,.04f);
        Layer("Upper sparse fog",new Vector3(8,1.1f,0),new Vector2(98,52),shader,.065f,.055f,14f,-.018f);
        EditorSceneManager.SaveScene(scene);
        var existing=new System.Collections.Generic.List<EditorBuildSettingsScene>(EditorBuildSettings.scenes);
        if (!existing.Exists(x=>x.path=="Assets/Demo/Scenes/PrologueSoftFog.unity")) existing.Add(new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueSoftFog.unity",true));
        EditorBuildSettings.scenes=existing.ToArray();
        AssetDatabase.SaveAssets();
        Debug.Log("SOFT_FOG_SCENE_CREATED");
    }
    static void Layer(string name,Vector3 pos,Vector2 size,Shader shader,float alpha,float scale,float offset,float speed)
    {
        var mat=new Material(shader); mat.SetColor("_FogColor",new Color(.58f,.62f,.64f,alpha));
        mat.SetFloat("_NoiseScale",scale); mat.SetFloat("_Offset",offset); mat.SetFloat("_DriftSpeed",speed);
        string path="Assets/Demo/Atmosphere/"+name.Replace(" ","")+".mat";
        var existing=AssetDatabase.LoadAssetAtPath<Material>(path);
        if (!existing) AssetDatabase.CreateAsset(mat,path); else { EditorUtility.CopySerialized(mat,existing); Object.DestroyImmediate(mat); }
        var layer=GameObject.CreatePrimitive(PrimitiveType.Quad); layer.name=name; layer.transform.position=pos;
        layer.transform.rotation=Quaternion.Euler(90,0,0); layer.transform.localScale=new Vector3(size.x,size.y,1);
        Object.DestroyImmediate(layer.GetComponent<Collider>());
        layer.GetComponent<Renderer>().sharedMaterial=AssetDatabase.LoadAssetAtPath<Material>(path);
    }
}
