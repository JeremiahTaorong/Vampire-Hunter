using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;

public static class CreatePrologueGreybox
{
    public static void Build()
    {
        var scene=EditorSceneManager.OpenScene("Assets/Demo/Scenes/ProloguePrototype.unity");
        EditorSceneManager.SaveScene(scene,"Assets/Demo/Scenes/PrologueGreybox.unity");
        var ground=GameObject.Find("Walkable ground");
        ground.transform.position=new Vector3(0,-.5f,0); ground.transform.localScale=new Vector3(120,1,64);
        var wall=GameObject.Find("Obstacle"); wall.name="Forest entrance north"; wall.transform.position=new Vector3(2,2,11); wall.transform.localScale=new Vector3(4,4,14);
        var player=GameObject.Find("Player"); player.transform.position=new Vector3(-50,1,0);
        player.GetComponent<DemoInvestigation>().requireTrail=true;
        var emblem=GameObject.Find("Evidence - hunter emblem"); emblem.transform.position=new Vector3(-43,.5f,-9);
        emblem.GetComponent<DemoInteractable>().evidenceText="Evidence: a familiar hunter's emblem lies near a disturbed house.";
        var witness=GameObject.Find("Witness placeholder"); witness.transform.position=new Vector3(-34,1,10);
        witness.GetComponent<DemoInteractable>().evidenceText="Witness: a cloaked figure passed the edge of the village at night.";
        var trail=GameObject.CreatePrimitive(PrimitiveType.Cube); trail.name="Evidence - drag marks placeholder";
        trail.transform.position=new Vector3(-19,.3f,1); trail.transform.localScale=new Vector3(1,.6f,1);
        var clue=trail.AddComponent<DemoInteractable>(); clue.clueId="trail"; clue.evidenceText="Evidence: drag marks lead away from the village toward the trees.";
        GameObject.Find("Training enemy").transform.position=new Vector3(28,1,0);
        GameObject.Find("Mentor mark placeholder").transform.position=new Vector3(50,.5f,0);
        Block("Village house A",new Vector3(-43,2,-16),new Vector3(8,4,6));
        Block("Village house B",new Vector3(-34,2,17),new Vector3(8,4,6));
        Block("Village house C",new Vector3(-25,2,-13),new Vector3(7,4,5));
        Block("Village square well marker",new Vector3(-36,1,0),new Vector3(3,2,3));
        Block("Forest entrance south",new Vector3(2,2,-11),new Vector3(4,4,14));
        Block("Forest tree marker A",new Vector3(13,2,7),new Vector3(3,4,3));
        Block("Forest tree marker B",new Vector3(18,2,-7),new Vector3(3,4,3));
        Block("Forest tree marker C",new Vector3(24,2,12),new Vector3(3,4,3));
        Block("Forest tree marker D",new Vector3(34,2,-10),new Vector3(3,4,3));
        Block("Forest tree marker E",new Vector3(38,2,10),new Vector3(3,4,3));
        Block("Castle vista marker",new Vector3(57,4,0),new Vector3(4,8,14));
        EditorSceneManager.SaveScene(scene);
        UnityEditor.AI.NavMeshBuilder.BuildNavMesh();
        EditorSceneManager.SaveScene(scene);
        EditorBuildSettings.scenes = new [] {
            new EditorBuildSettingsScene("Assets/Demo/Scenes/MovementDemo.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/ProloguePrototype.unity",true),
            new EditorBuildSettingsScene("Assets/Demo/Scenes/PrologueGreybox.unity",true)
        };
        AssetDatabase.SaveAssets();
        Debug.Log("PROLOGUE_GREYBOX_CREATED");
    }
    static void Block(string name,Vector3 position,Vector3 scale)
    {
        var obj=GameObject.CreatePrimitive(PrimitiveType.Cube); obj.name=name; obj.transform.position=position; obj.transform.localScale=scale;
        GameObjectUtility.SetStaticEditorFlags(obj,StaticEditorFlags.NavigationStatic);
    }
}
