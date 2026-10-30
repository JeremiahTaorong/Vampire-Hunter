using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

public static class CreateFogArtSample
{
    public static void Build()
    {
        var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/PrologueAtmosphere.unity");
        EditorSceneManager.SaveScene(scene,"Assets/Demo/Scenes/PrologueFogSample.unity");
        var texture=AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Demo/ThirdParty/Kenney_Particles/smoke_03.png");
        if (!texture) throw new System.Exception("Kenney smoke texture not imported");
        var shader=Shader.Find("Universal Render Pipeline/Particles/Unlit");
        if (!shader) throw new System.Exception("URP particle shader missing");
        var path="Assets/Demo/Atmosphere/LayeredMist.mat";
        var mat=AssetDatabase.LoadAssetAtPath<Material>(path);
        if (!mat)
        {
            mat=new Material(shader); mat.SetTexture("_BaseMap",texture);
            mat.SetColor("_BaseColor",Color.white);
            mat.SetFloat("_Surface",1); mat.SetFloat("_Blend",0);
            mat.SetFloat("_SrcBlend",(float)BlendMode.SrcAlpha);
            mat.SetFloat("_DstBlend",(float)BlendMode.OneMinusSrcAlpha);
            mat.SetFloat("_ZWrite",0);
            mat.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
            mat.renderQueue=(int)RenderQueue.Transparent;
            AssetDatabase.CreateAsset(mat,path);
        }
        Mist("Village ground mist",new Vector3(-37,.6f,0),new Vector3(18,1,20),mat,1.2f,6f);
        Mist("Village exit mist",new Vector3(-17,.6f,0),new Vector3(12,1,13),mat,.8f,6f);
        Mist("Forest entrance mist",new Vector3(5,.6f,0),new Vector3(15,1,20),mat,1.4f,8f);
        Mist("Forest clearing mist",new Vector3(30,.6f,0),new Vector3(18,1,22),mat,1.1f,8f);
        Mist("Distant castle mist",new Vector3(49,1,0),new Vector3(12,1,24),mat,.8f,8f);
        EditorSceneManager.SaveScene(scene);
        EditorBuildSettings.scenes = new [] {
            new EditorBuildSettingsScene("Assets/Demo/Scenes/MovementDemo.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/ProloguePrototype.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueGreybox.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueAtmosphere.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueFogSample.unity",true)
        };
        AssetDatabase.SaveAssets();
        Debug.Log("FOG_ART_SAMPLE_CREATED");
    }
    static void Mist(string name,Vector3 position,Vector3 box,Material mat,float rate,float size)
    {
        var go=new GameObject(name); go.transform.position=position;
        var ps=go.AddComponent<ParticleSystem>();
        var main=ps.main; main.loop=true; main.playOnAwake=true; main.startLifetime=24f; main.startSpeed=.06f;
        main.startSize=new ParticleSystem.MinMaxCurve(size*.6f,size);
        main.startColor=new Color(.70f,.74f,.78f,.12f); main.maxParticles=90;
        main.simulationSpace=ParticleSystemSimulationSpace.World;
        var shape=ps.shape; shape.shapeType=ParticleSystemShapeType.Box; shape.scale=box;
        var emission=ps.emission; emission.rateOverTime=rate;
        var velocity=ps.velocityOverLifetime; velocity.enabled=true; velocity.x=new ParticleSystem.MinMaxCurve(.08f,.18f);
        var renderer=go.GetComponent<ParticleSystemRenderer>(); renderer.renderMode=ParticleSystemRenderMode.Billboard; renderer.sharedMaterial=mat;
    }
}
