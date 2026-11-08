using UnityEngine;

// Scene-owned binding: the shared prefab never serializes another chapter's camera.
[DefaultExecutionOrder(-100)]
[RequireComponent(typeof(DemoMovement))]
public sealed class SharedPlayerChapterBinding : MonoBehaviour
{
    public Camera chapterCamera;
    public DemoMovement Movement => GetComponent<DemoMovement>();
    void Awake() { Bind(chapterCamera ? chapterCamera : Camera.main); }
    public void Bind(Camera camera)
    {
        chapterCamera = camera;
        if (!camera)
        {
            Movement.enabled = false;
            Debug.LogError("Shared Player Motion: assign this chapter's camera or tag it MainCamera.", this);
            return;
        }
        Movement.viewCamera = camera;
        Movement.enabled = true;
        var follow = camera.GetComponent<DemoCamera>();
        if (follow) follow.target = transform;
    }
}
