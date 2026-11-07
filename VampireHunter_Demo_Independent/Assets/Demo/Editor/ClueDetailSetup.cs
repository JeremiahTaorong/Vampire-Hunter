using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Object = UnityEngine.Object;

[InitializeOnLoad]
public static class ClueDetailSetup
{
    public const string Evidence = "Evidence/clue-details-20261106/";
    const string Scene = "Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity";
    const string Folder = "Assets/Demo/Environment/HunterBadge/";
    static ClueDetailSetup() { EditorApplication.update += Poll; }
    static void Poll()
    {
        if (EditorApplication.isCompiling || EditorApplication.isUpdating || EditorApplication.isPlayingOrWillChangePlaymode) return;
        string path = Evidence + "command.txt";
        if (!File.Exists(path)) return;
        string command;
        try { command = File.ReadAllText(path).Trim(); File.Move(path, Evidence + "command-" + DateTime.UtcNow.Ticks + ".txt"); }
        catch (IOException) { return; } // Publisher may still be replacing its command file.
        try
        {
            if (command == "build") Build();
            else if (command == "test") Test();
            else if (command == "finish") Finish();
            else if (command == "ground") GroundAndSave();
            else throw new ArgumentException(command);
        }
        catch (Exception e) { File.WriteAllText(Evidence + "error.txt", e.ToString()); Debug.LogException(e); }
    }

    [MenuItem("Vampire Demo/Clue Details/Build Blood Cluster and Original Badge")]
    public static void Build()
    {
        if (EditorSceneManager.GetActiveScene().isDirty) throw new InvalidOperationException("Preserve unsaved scene changes before building.");
        var scene = EditorSceneManager.OpenScene(Scene);
        Directory.CreateDirectory(Evidence);
        Directory.CreateDirectory(Folder);
        AssetDatabase.Refresh();
        var clues = Object.FindObjectsOfType<DemoInteractable>();
        var trail = clues.Single(c => c.clueId == "trail");
        var terrain = Object.FindObjectOfType<Terrain>();
        var blood = trail.transform.Find("Blood evidence visuals");
        if (!blood) throw new InvalidOperationException("Existing blood scene is required.");
        if (blood.Find("Scattered blood pool cluster")) throw new InvalidOperationException("Cluster already exists; inspect before rebuilding.");
        var cluster = new GameObject("Scattered blood pool cluster").transform;
        cluster.SetParent(blood, false);
        var pool = AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/Environment/BloodClue/BloodPool0.mat");
        var splash = AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/Environment/BloodClue/BloodPool1.mat");
        if (!pool || !splash) throw new FileNotFoundException("Existing free blood materials missing.");
        // x/z offset, length, width, rotation in degrees. A dense irregular center
        // tapers to small separate stains rather than a uniformly repeated row.
        Vector4[] patches = {
            new Vector4(-.85f,-.65f,1.05f,.8f), new Vector4(.55f,-.65f,.95f,.85f),
            new Vector4(1.1f,.15f,.85f,.68f), new Vector4(-.7f,.7f,.8f,.65f),
            new Vector4(.2f,.8f,.75f,.65f), new Vector4(-1.45f,-.1f,.6f,.5f),
            new Vector4(1.45f,-.55f,.55f,.48f), new Vector4(-1.1f,-1.1f,.42f,.35f),
            new Vector4(.95f,1f,.45f,.36f), new Vector4(1.9f,.65f,.35f,.28f),
            new Vector4(-1.9f,-.75f,.32f,.27f), new Vector4(.05f,-1.3f,.3f,.25f)
        };
        float[] angles = { 18, 105, -25, 72, -60, 145, 25, -10, 85, -40, 60, 135 };
        Vector3 p = trail.transform.position;
        for (int i = 0; i < patches.Length; i++)
        {
            var patch = patches[i];
            Vector3 center = p + new Vector3(patch.x, 0, patch.y);
            Vector3 axis = Quaternion.Euler(0, angles[i], 0) * Vector3.right * patch.z * .5f;
            BloodClueSetup.Strip(cluster, terrain, center - axis, center + axis, patch.w,
                i % 4 == 3 ? splash : pool, "Cluster blood stain " + (i + 1).ToString("00"), i % 3);
        }

        var emblem = clues.Single(c => c.clueId == "emblem");
        if (emblem.transform.Find("Hunter cross badge")) throw new InvalidOperationException("Badge already exists.");
        Vector3 originalPosition = emblem.transform.position;
        var oldRenderer = emblem.GetComponent<Renderer>();
        if (oldRenderer) oldRenderer.enabled = false;
        foreach (var collider in emblem.GetComponents<Collider>()) collider.enabled = false;
        emblem.transform.rotation = Quaternion.identity;
        emblem.transform.localScale = Vector3.one;
        var badge = CreateBadge();
        badge.transform.SetParent(emblem.transform, false);
        badge.transform.localRotation = Quaternion.Euler(88, -14, -12);
        var box = emblem.gameObject.AddComponent<BoxCollider>();
        box.size = new Vector3(.82f, .7f, .92f);
        box.center = new Vector3(0, .04f, 0);
        box.isTrigger = true;
        GroundBadge(emblem, terrain);
        emblem.name = "Evidence - original silver hunter cross badge";
        emblem.evidenceText = "Evidence: a worn silver hunter's badge bears the mentor's cross.";
        var glint = emblem.GetComponentInChildren<Light>();
        if (glint) { glint.transform.localPosition = new Vector3(.1f, .65f, -.2f); glint.intensity = 1.2f; }
        PrefabUtility.SaveAsPrefabAsset(badge, Folder + "Hunter_Cross_Badge.prefab");
        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();
        File.WriteAllText(Evidence + "built.txt", "Unity=" + Application.unityVersion + "\nscene=" + Scene +
            "\nextraBloodStains=" + patches.Length + "\nbadge=original project geometry; no external model or fee" +
            "\nemblemPosition=" + originalPosition + " range=" + emblem.range + "\ntrailPosition=" + p + " range=" + trail.range);
        EditorSceneManager.OpenScene(Scene);
    }

    static void GroundAndSave()
    {
        if(EditorSceneManager.GetActiveScene().isDirty)throw new InvalidOperationException("Save scene first.");
        var emblem=Object.FindObjectsOfType<DemoInteractable>().Single(c=>c.clueId=="emblem");
        GroundBadge(emblem,Object.FindObjectOfType<Terrain>());
        EditorSceneManager.MarkSceneDirty(emblem.gameObject.scene);
        EditorSceneManager.SaveScene(emblem.gameObject.scene);
        AssetDatabase.SaveAssets();
        File.WriteAllText(Evidence+"grounded.txt","Badge visual scaled to 0.68 and grounded; original clue anchor/range preserved.");
    }
    static void GroundBadge(DemoInteractable emblem,Terrain terrain)
    {
        var badge=emblem.transform.Find("Hunter cross badge");
        badge.localScale=Vector3.one*.68f;
        badge.localRotation=Quaternion.Euler(88,-14,-12);
        var renderers=badge.GetComponentsInChildren<Renderer>();
        Bounds b=renderers[0].bounds;foreach(var r in renderers)b.Encapsulate(r.bounds);
        float ground=terrain.SampleHeight(b.center)+terrain.transform.position.y;
        foreach(float x in new[]{b.min.x,b.max.x})foreach(float z in new[]{b.min.z,b.max.z})
            ground=Mathf.Max(ground,terrain.SampleHeight(new Vector3(x,0,z))+terrain.transform.position.y);
        badge.position+=Vector3.up*(ground+.018f-b.min.y);
        b=renderers[0].bounds;foreach(var r in renderers)b.Encapsulate(r.bounds);
        var box=emblem.GetComponents<BoxCollider>().Single(c=>c.enabled);
        box.center=emblem.transform.InverseTransformPoint(b.center);
        box.size=b.size+new Vector3(.25f,.35f,.25f);
        PrefabUtility.SaveAsPrefabAsset(badge.gameObject,Folder+"Hunter_Cross_Badge.prefab");
    }

    static GameObject CreateBadge()
    {
        var root = new GameObject("Hunter cross badge");
        var silver = Material("Aged silver", new Color(.62f,.66f,.7f), .55f, .48f);
        var dark = Material("Dark engraved steel", new Color(.035f,.045f,.055f), .4f, .24f);
        var rivet = Material("Rivet bronze", new Color(.38f,.25f,.11f), .6f, .38f);
        Vector2[] shield = { new Vector2(-.22f,.29f), new Vector2(.22f,.29f), new Vector2(.27f,.18f),
            new Vector2(.22f,-.13f), new Vector2(0,-.34f), new Vector2(-.22f,-.13f), new Vector2(-.27f,.18f) };
        Shape(root.transform, "Silver bevel rim", shield, .0f, .047f, silver);
        Shape(root.transform, "Inset dark face", shield.Select(v=>v*.84f).ToArray(), -.022f, .018f, dark);
        Vector2[] cross = { new Vector2(-.037f,.205f), new Vector2(.037f,.205f), new Vector2(.037f,.095f),
            new Vector2(.142f,.095f), new Vector2(.142f,.025f), new Vector2(.037f,.025f),
            new Vector2(.037f,-.205f), new Vector2(0,-.25f), new Vector2(-.037f,-.205f),
            new Vector2(-.037f,.025f), new Vector2(-.142f,.025f), new Vector2(-.142f,.095f), new Vector2(-.037f,.095f) };
        Shape(root.transform, "Raised hunter cross", cross, -.046f, .028f, silver);
        for (int i=0;i<4;i++)
        {
            Vector2 center = i<2 ? new Vector2(i==0?-.175f:.175f,.19f) : new Vector2(i==2?-.13f:.13f,-.09f);
            var polygon = Enumerable.Range(0,8).Select(n=>center+new Vector2(Mathf.Cos(n*Mathf.PI/4),Mathf.Sin(n*Mathf.PI/4))*.016f).ToArray();
            Shape(root.transform,"Rivet "+i,polygon,-.037f,.013f,rivet);
        }
        // Small suspension eye makes the object read as a personal badge, not a shield.
        var ring = new GameObject("Suspension eye",typeof(MeshFilter),typeof(MeshRenderer));
        ring.transform.SetParent(root.transform,false);
        var vertices = new List<Vector3>(); var triangles = new List<int>();
        for(int i=0;i<24;i++) for(int j=0;j<8;j++)
        {
            float a=i*Mathf.PI/12, b=j*Mathf.PI/4;
            float r=.039f+.009f*Mathf.Cos(b);
            vertices.Add(new Vector3(Mathf.Cos(a)*r,.32f+Mathf.Sin(a)*r,-.01f+.009f*Mathf.Sin(b)));
            int k=i*8+j, next=((i+1)%24)*8+j, jn=i*8+(j+1)%8, nn=((i+1)%24)*8+(j+1)%8;
            triangles.AddRange(new[]{k,jn,next,jn,nn,next});
        }
        var mesh = new Mesh{name="Badge suspension eye",vertices=vertices.ToArray(),triangles=triangles.ToArray()};
        mesh.RecalculateNormals(); mesh.RecalculateBounds();
        AssetDatabase.CreateAsset(mesh,Folder+"SuspensionEye.asset");
        ring.GetComponent<MeshFilter>().sharedMesh=mesh; ring.GetComponent<MeshRenderer>().sharedMaterial=silver;
        return root;
    }
    static Material Material(string name, Color color, float metal, float smooth)
    {
        var mat=new Material(Shader.Find("Universal Render Pipeline/Lit")){name=name};
        mat.SetColor("_BaseColor",color); mat.SetFloat("_Metallic",metal); mat.SetFloat("_Smoothness",smooth); mat.SetFloat("_Cull",0);
        AssetDatabase.CreateAsset(mat,Folder+name.Replace(" ","_")+".mat"); return mat;
    }
    static void Shape(Transform parent,string name,Vector2[] outline,float z,float thickness,Material material)
    {
        int n=outline.Length;
        Vector2 center=outline.Aggregate(Vector2.zero,(sum,p)=>sum+p)/n;
        var v=new List<Vector3>{new Vector3(center.x,center.y,z-thickness*.5f),new Vector3(center.x,center.y,z+thickness*.5f)};
        foreach(var p in outline){v.Add(new Vector3(p.x,p.y,z-thickness*.5f));v.Add(new Vector3(p.x,p.y,z+thickness*.5f));}
        var indices=new List<int>();
        for(int i=0;i<n;i++)
        {
            int a=2+i*2,b=2+((i+1)%n)*2;
            indices.AddRange(new[]{0,b,a,1,a+1,b+1,a,b,a+1,a+1,b,b+1});
        }
        var mesh=new Mesh{name=name,vertices=v.ToArray(),triangles=indices.ToArray()};mesh.RecalculateNormals();mesh.RecalculateBounds();
        AssetDatabase.CreateAsset(mesh,Folder+name.Replace(" ","_")+".asset");
        var obj=new GameObject(name,typeof(MeshFilter),typeof(MeshRenderer));obj.transform.SetParent(parent,false);
        obj.GetComponent<MeshFilter>().sharedMesh=mesh;obj.GetComponent<MeshRenderer>().sharedMaterial=material;
    }
    static void Test()
    {
        if(EditorSceneManager.GetActiveScene().isDirty)throw new InvalidOperationException("Save scene first.");
        Object.FindObjectOfType<DemoMovement>().gameObject.AddComponent<ClueDetailsProbe>();
        EditorApplication.isPlaying=true;
    }
    static void Finish()
    {
        foreach(var probe in Object.FindObjectsOfType<ClueDetailsProbe>())Object.DestroyImmediate(probe);
        EditorSceneManager.OpenScene(Scene);
        File.WriteAllText(Evidence+"saved.txt","Saved and reopened scene; temporary probe removed.");
    }
}
