using System;
using UnityEngine;

// Independent Demo presentation. The source clue retains investigation ownership.
public class EvidenceInspection : MonoBehaviour
{
    public Transform displayModel;
    public string itemTitle;
    [TextArea(6, 12)] public string story;
    public Shader blurShader;
    public static EvidenceInspection Active { get; private set; }
    public static bool IsOpen => Active != null;
    public RenderTexture Backdrop => backdrop;
    public RenderTexture ModelPreview => preview;
    public bool PreviewReady => previewCamera && previewCamera.isActiveAndEnabled && previewModel;
    public static int BlockWorldInputThroughFrame { get; private set; }
    const int PreviewLayer = 30;
    float previousTimeScale;
    int oldCameraMask;
    Camera worldCamera, previewCamera;
    GameObject previewRoot;
    Transform previewModel;
    RenderTexture backdrop, preview;
    Material blur;
    DemoMovement player;
    GUIStyle titleStyle, storyStyle, smallStyle, buttonStyle;
    bool ownsPause;
    void Awake() { GetComponent<DemoInteractable>().Activated += Open; }
    void OnDestroy()
    {
        var clue = GetComponent<DemoInteractable>();
        if (clue) clue.Activated -= Open;
        Close();
    }
    void OnDisable() { Close(); }
    public void Open()
    {
        if (Active == this || !displayModel) return;
        if (Active) Active.Close();
        player = FindObjectOfType<DemoMovement>();
        worldCamera = player ? player.viewCamera : Camera.main;
        if (!worldCamera) return;
        try
        {
            oldCameraMask = worldCamera.cullingMask;
            CaptureBackground();
            worldCamera.cullingMask &= ~(1 << PreviewLayer);
            CreatePreview();
            previousTimeScale = Time.timeScale;
            ownsPause = true;
            if (player) player.TakeManualControl();
            Active = this;
            Time.timeScale = 0;
        }
        catch (Exception ex) { Close(); Debug.LogException(ex); }
    }
    void CaptureBackground()
    {
        int w = Mathf.Max(320, Screen.width / 4), h = Mathf.Max(180, Screen.height / 4);
        backdrop = new RenderTexture(w,h,0,RenderTextureFormat.ARGB32) { name = "Inspection blurred background" };
        var raw = RenderTexture.GetTemporary(w,h,24,RenderTextureFormat.ARGB32);
        var ping = RenderTexture.GetTemporary(w,h,0,RenderTextureFormat.ARGB32);
        var oldTarget = worldCamera.targetTexture;
        var oldActive = RenderTexture.active;
        try
        {
            worldCamera.targetTexture = raw;
            worldCamera.Render();
            if (blurShader && blurShader.isSupported)
            {
                blur = new Material(blurShader);
                Graphics.Blit(raw,backdrop,blur);
                for(int i=0;i<4;i++) { Graphics.Blit(backdrop,ping,blur); Graphics.Blit(ping,backdrop,blur); }
            }
            else Graphics.Blit(raw,backdrop);
        }
        finally
        {
            worldCamera.targetTexture = oldTarget;
            RenderTexture.active = oldActive;
            RenderTexture.ReleaseTemporary(raw); RenderTexture.ReleaseTemporary(ping);
        }
    }
    void CreatePreview()
    {
        previewRoot = new GameObject("Inspection preview (temporary)");
        previewRoot.transform.position = new Vector3(1000,1000,1000);
        var pivot = new GameObject("Rotation pivot").transform;
        pivot.SetParent(previewRoot.transform,false);
        previewModel = pivot;
        var clone = Instantiate(displayModel.gameObject,pivot);
        clone.name = "Inspection model";
        clone.transform.localPosition = Vector3.zero;
        clone.transform.rotation = GetComponent<DemoInteractable>().clueId == "emblem" ? Quaternion.identity : displayModel.rotation;
        clone.transform.localScale = displayModel.lossyScale;
        foreach(var component in clone.GetComponentsInChildren<MonoBehaviour>()) component.enabled = false;
        foreach(var collider in clone.GetComponentsInChildren<Collider>()) collider.enabled = false;
        foreach(var t in clone.GetComponentsInChildren<Transform>(true)) t.gameObject.layer = PreviewLayer;
        var b = ModelBounds(clone);
        if(b.size.y < b.size.x && b.size.y < b.size.z) clone.transform.Rotate(90,0,0,Space.World);
        b = ModelBounds(clone);
        clone.transform.position += pivot.position-b.center;
        b = ModelBounds(clone);
        var cameraObject = new GameObject("Inspection camera",typeof(Camera));
        cameraObject.transform.SetParent(previewRoot.transform,false);
        previewCamera = cameraObject.GetComponent<Camera>();
        previewCamera.orthographic = true;
        previewCamera.orthographicSize = Mathf.Max(b.size.y*.63f,b.size.x*.63f/(1440f/550f));
        previewCamera.nearClipPlane = .01f; previewCamera.farClipPlane = 20;
        previewCamera.transform.position = pivot.position + Vector3.back*4;
        previewCamera.transform.LookAt(pivot);
        previewCamera.clearFlags = CameraClearFlags.SolidColor;
        previewCamera.backgroundColor = Color.clear;
        previewCamera.cullingMask = 1 << PreviewLayer;
        previewCamera.allowHDR = false;
        preview = new RenderTexture(1440,550,24,RenderTextureFormat.ARGB32) { name="Inspection object preview" };
        previewCamera.targetTexture = preview;
        AddLight("Inspection key",new Vector3(28,-25,0),1.5f,new Color(1,.88f,.73f));
        AddLight("Inspection fill",new Vector3(-20,145,0),0.75f,new Color(.65f,.77f,1));
        previewCamera.Render();
    }
    void AddLight(string label, Vector3 rotation, float intensity, Color color)
    {
        var go = new GameObject(label,typeof(Light));
        go.transform.SetParent(previewRoot.transform,false);
        go.transform.rotation = Quaternion.Euler(rotation);
        var light = go.GetComponent<Light>();
        light.type = LightType.Directional; light.intensity=intensity; light.color=color;
        light.cullingMask = 1 << PreviewLayer; light.shadows=LightShadows.None;
    }
    static Bounds ModelBounds(GameObject model)
    {
        var renderers = model.GetComponentsInChildren<Renderer>();
        var b=renderers[0].bounds;
        foreach(var renderer in renderers) b.Encapsulate(renderer.bounds);
        return b;
    }
    void Update()
    {
        if(Active != this) return;
        if(Input.GetKeyDown(KeyCode.Escape)) { Close(); return; }
        if(Input.GetMouseButton(0) && Input.mousePosition.y > Screen.height*.36f)
        {
            previewModel.Rotate(Vector3.up,-Input.GetAxisRaw("Mouse X")*5,Space.World);
            previewModel.Rotate(Vector3.right,Input.GetAxisRaw("Mouse Y")*3,Space.World);
        }
    }
    public void Close()
    {
        if(Active != this && !previewRoot && !backdrop) return;
        if(Active == this) Active=null;
        BlockWorldInputThroughFrame=Time.frameCount+1;
        if(ownsPause) { Time.timeScale=previousTimeScale; ownsPause=false; }
        if(worldCamera) worldCamera.cullingMask=oldCameraMask;
        if(previewCamera) previewCamera.targetTexture=null;
        if(previewRoot) { previewRoot.SetActive(false); Destroy(previewRoot); }
        if(preview) { preview.Release(); Destroy(preview); }
        if(backdrop) { backdrop.Release(); Destroy(backdrop); }
        if(blur) Destroy(blur);
        previewRoot=null; previewModel=null; previewCamera=null; preview=null; backdrop=null;
    }
    void OnGUI()
    {
        if(Active != this) return;
        GUI.depth=-1000;
        var matrix=GUI.matrix;
        var color=GUI.color;
        GUI.matrix=Matrix4x4.TRS(Vector3.zero,Quaternion.identity,new Vector3(Screen.width/1920f,Screen.height/1080f,1));
        if(titleStyle==null)
        {
            titleStyle=new GUIStyle(GUI.skin.label){fontSize=48,fontStyle=FontStyle.Bold,normal={textColor=new Color(.92f,.87f,.76f)}};
            storyStyle=new GUIStyle(GUI.skin.label){fontSize=25,wordWrap=true,normal={textColor=new Color(.84f,.84f,.82f)}};
            smallStyle=new GUIStyle(GUI.skin.label){fontSize=19,normal={textColor=new Color(.66f,.64f,.59f)}};
            buttonStyle=new GUIStyle(GUI.skin.button){fontSize=23};
        }
        GUI.DrawTexture(new Rect(0,0,1920,1080),backdrop,ScaleMode.StretchToFill);
        GUI.color=new Color(.018f,.022f,.03f,.55f); GUI.DrawTexture(new Rect(0,0,1920,1080),Texture2D.whiteTexture);
        GUI.color=new Color(.6f,.43f,.27f,.8f); GUI.DrawTexture(new Rect(100,103,1720,1),Texture2D.whiteTexture);
        GUI.DrawTexture(new Rect(250,714,1420,1),Texture2D.whiteTexture);
        GUI.color=Color.white;
        GUI.Label(new Rect(100,55,900,35),"FIELD NOTES     /     THE VANISHING",smallStyle);
        GUI.Label(new Rect(1430,55,400,35),"DRAG TO ROTATE  /  ESC TO CLOSE",smallStyle);
        GUI.DrawTexture(new Rect(240,120,1440,550),preview,ScaleMode.ScaleToFit,true);
        GUI.Label(new Rect(250,645,1420,65),itemTitle,titleStyle);
        GUI.Label(new Rect(250,745,1420,240),story,storyStyle);
        GUI.Label(new Rect(100,1015,1050,35),"EVIDENCE RECORDED     /     VILLAGE OUTSKIRTS",smallStyle);
        if(GUI.Button(new Rect(1470,1000,350,55),"Return to investigation",buttonStyle)) Close();
        GUI.matrix=matrix; GUI.color=color;
    }
}
