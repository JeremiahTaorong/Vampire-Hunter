using UnityEngine;
public class DemoCamera : MonoBehaviour
{
    public Transform target;
    public Vector3 offset = new Vector3(0, 10, -10);
    void LateUpdate()
    {
        if (!target) return;
        transform.position = target.position + offset;
        transform.LookAt(target.position);
    }
}
