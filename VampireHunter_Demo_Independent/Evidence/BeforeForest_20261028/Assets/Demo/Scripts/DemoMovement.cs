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
    DemoInteractable interaction;
    DemoEnemy enemy;
    bool chaseEnemy;
    float nextAttack;
    public float attackRange = 2f;
    public float attackInterval = .7f;
    public float dodgeDistance = 2.5f;
    public float dodgeDuration = .25f;
    public float dodgeInvulnerability = .15f;
    public float dodgeCooldown = 1f;
    float dodgeEnd;
    float invulnerableEnd;
    float dodgeReady;
    Vector3 dodgeDirection;
    public bool IsDodging => Time.time < dodgeEnd;
    public bool IsInvulnerable => Time.time < invulnerableEnd;
    public DemoEnemy Target => enemy;
    public string message = "Left click to move; WASD takes control.";

    void Awake() { agent = GetComponent<NavMeshAgent>(); agent.speed = speed; }
    void Update()
    {
        var health = GetComponent<DemoHealth>();
        if (health && health.IsDead) { if (agent.isOnNavMesh && agent.hasPath) agent.ResetPath(); return; }
        if (!agent.isOnNavMesh) { message = "Player is outside the walkable area."; return; }
        Vector3 input = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        Vector3 forward = Vector3.ProjectOnPlane(viewCamera.transform.forward, Vector3.up).normalized;
        Vector3 right = Vector3.ProjectOnPlane(viewCamera.transform.right, Vector3.up).normalized;
        if (!IsDodging && Input.GetKeyDown(KeyCode.Space))
        {
            Vector3 requested = (right * input.x + forward * input.z).normalized;
            TryDodge(requested.sqrMagnitude > .01f ? requested : transform.forward);
        }
        if (IsDodging)
        {
            Vector3 step = dodgeDirection * (dodgeDistance / Mathf.Max(.01f, dodgeDuration)) * Time.deltaTime;
            if (NavMesh.Raycast(transform.position, transform.position + step, out var edge, NavMesh.AllAreas))
                step = edge.position - transform.position;
            agent.Move(step);
            return;
        }
        if (input.sqrMagnitude > .01f)
        {
            if (!wasManual) TakeManualControl();
            wasManual = true;
            Vector3 move = (right * input.x + forward * input.z).normalized;
            agent.Move(move * speed * Time.deltaTime);
            if (move.sqrMagnitude > .001f) transform.rotation = Quaternion.LookRotation(move);
            return;
        }
        wasManual = false;
        if (enemy && enemy.IsAlive)
        {
            var delta = enemy.transform.position - transform.position;
            delta.y = 0;
            if (delta.magnitude <= attackRange)
            {
                if (agent.hasPath) agent.ResetPath();
                if (Time.time >= nextAttack && HasLineOfSight())
                {
                    enemy.TakeDamage(10);
                    nextAttack = Time.time + attackInterval;
                    message = enemy.IsAlive ? "Attacking target." : "Target defeated.";
                }
            }
            else if (chaseEnemy && !agent.pathPending && !agent.hasPath)
            {
                if (NavMesh.SamplePosition(enemy.transform.position, out var enemyPoint, 2f, NavMesh.AllAreas))
                {
                    var path = new NavMeshPath();
                    if (agent.CalculatePath(enemyPoint.position, path) && path.status == NavMeshPathStatus.PathComplete) agent.SetPath(path);
                    else { chaseEnemy = false; message = "Target unreachable."; }
                }
                else { chaseEnemy = false; message = "Target unreachable."; }
            }
        }
        if (interaction && !agent.pathPending && agent.remainingDistance <= agent.stoppingDistance + .2f)
        {
            if (Vector3.Distance(transform.position, interaction.transform.position) <= interaction.range)
                message = interaction.Activate();
            else message = "Object unreachable.";
            interaction = null;
            agent.ResetPath();
        }
        var investigation = GetComponent<DemoInvestigation>();
        if (Input.GetMouseButtonDown(0) && (EventSystem.current == null || !EventSystem.current.IsPointerOverGameObject())
            && (!investigation || !investigation.BlocksWorldClick(Input.mousePosition)))
        {
            interaction = null;
            if (Physics.Raycast(viewCamera.ScreenPointToRay(Input.mousePosition), out var objectHit, 200f))
            {
                var selectedEnemy = objectHit.collider.GetComponent<DemoEnemy>();
                if (selectedEnemy && selectedEnemy.IsAlive) { SelectEnemy(selectedEnemy); return; }
                var selected = objectHit.collider.GetComponent<DemoInteractable>();
                if (selected) { BeginInteraction(selected); return; }
            }
            enemy = null; chaseEnemy = false;
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
    public bool TryDodge(Vector3 direction)
    {
        var health = GetComponent<DemoHealth>();
        if (!agent || !agent.isOnNavMesh || (health && health.IsDead) || IsDodging || Time.time < dodgeReady) return false;
        direction.y = 0;
        if (direction.sqrMagnitude < .01f) return false;
        TakeManualControl();
        dodgeDirection = direction.normalized;
        transform.rotation = Quaternion.LookRotation(dodgeDirection);
        dodgeEnd = Time.time + dodgeDuration;
        invulnerableEnd = Time.time + Mathf.Min(dodgeInvulnerability, dodgeDuration);
        dodgeReady = Time.time + dodgeCooldown;
        message = "Dodge!";
        return true;
    }
    bool HasLineOfSight()
    {
        Vector3 direction = enemy.transform.position - transform.position;
        return !Physics.Linecast(transform.position + Vector3.up * .4f, enemy.transform.position + Vector3.up * .4f, out var hit)
            || hit.collider.GetComponent<DemoEnemy>() == enemy;
    }
    public void TakeManualControl()
    {
        if (agent && agent.isOnNavMesh) agent.ResetPath();
        interaction = null;
        chaseEnemy = false;
    }
    public void SelectEnemy(DemoEnemy selected)
    {
        interaction = null;
        enemy = selected;
        chaseEnemy = selected && selected.IsAlive;
        if (agent.isOnNavMesh) agent.ResetPath();
        message = "Target selected.";
    }
    public void BeginInteraction(DemoInteractable selected)
    {
        if (!selected || !agent.isOnNavMesh) return;
        enemy = null; chaseEnemy = false;
        var path = new NavMeshPath();
        if (NavMesh.SamplePosition(selected.transform.position, out var target, selected.range, NavMesh.AllAreas) &&
            agent.CalculatePath(target.position, path) && path.status == NavMeshPathStatus.PathComplete)
        {
            interaction = selected;
            agent.SetPath(path);
            message = "Approaching evidence...";
        }
        else { interaction = null; agent.ResetPath(); message = "Object unreachable."; }
    }
    void OnGUI()
    {
        GUI.Box(new Rect(12, 12, 430, 55), "Independent demo: movement test\n" + message);
    }
}
