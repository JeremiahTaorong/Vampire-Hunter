using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;

// Standalone prototype: click navigation and WASD share one movement agent.
[RequireComponent(typeof(NavMeshAgent))]
public class DemoMovement : MonoBehaviour
{
    public Camera viewCamera;
    public LayerMask groundMask;
    public float speed = 4f;
    NavMeshAgent agent;
    bool wasManual;
    public string message = "Left click to move; WASD takes control.";

    void Awake() { agent = GetComponent<NavMeshAgent>(); agent.speed = speed; }
    void Update()
    {
        if (!agent.isOnNavMesh) { message = "Player is outside the walkable area."; return; }
        Vector3 input = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        if (input.sqrMagnitude > .01f)
        {
            if (!wasManual) agent.ResetPath();
            wasManual = true;
            Vector3 forward = Vector3.ProjectOnPlane(viewCamera.transform.forward, Vector3.up).normalized;
            Vector3 right = Vector3.ProjectOnPlane(viewCamera.transform.right, Vector3.up).normalized;
            Vector3 move = (right * input.x + forward * input.z).normalized;
            agent.Move(move * speed * Time.deltaTime);
            if (move.sqrMagnitude > .001f) transform.rotation = Quaternion.LookRotation(move);
            return;
        }
        wasManual = false;
        if (Input.GetMouseButtonDown(0) && (EventSystem.current == null || !EventSystem.current.IsPointerOverGameObject()))
        {
            if (Physics.Raycast(viewCamera.ScreenPointToRay(Input.mousePosition), out var hit, 200f, groundMask))
            {
                var path = new NavMeshPath();
                if (NavMesh.SamplePosition(hit.point, out var target, .5f, NavMesh.AllAreas) &&
                    agent.CalculatePath(target.position, path) && path.status == NavMeshPathStatus.PathComplete)
                { agent.SetPath(path); message = "Moving to destination."; }
                else { agent.ResetPath(); message = "Destination unreachable."; }
            }
        }
    }
    void OnGUI()
    {
        GUI.Box(new Rect(12, 12, 430, 55), "Independent demo: movement test\n" + message);
    }
}
