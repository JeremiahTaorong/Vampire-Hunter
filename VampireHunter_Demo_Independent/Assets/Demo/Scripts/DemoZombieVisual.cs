using UnityEngine;
using UnityEngine.AI;

// Presentation for the existing DemoEnemy; health, hit validation and quest flow stay there.
[RequireComponent(typeof(DemoEnemy), typeof(NavMeshAgent))]
public sealed class DemoZombieVisual : MonoBehaviour
{
    public Animator animator;
    public float authoredWalkSpeed = .65f;
    public float authoredGrabContact = .75f;
    public float authoredGrabDuration = 1.6f;
    DemoEnemy enemy;
    NavMeshAgent agent;
    Transform target;
    float grabStarted, releaseAt;
    bool ownsStop, previousStop;
    static readonly int Walking = Animator.StringToHash("Walking");
    static readonly int Bite = Animator.StringToHash("Bite");
    static readonly int LocomotionSpeed = Animator.StringToHash("LocomotionSpeed");
    static readonly int AttackSpeed = Animator.StringToHash("AttackSpeed");

    void Awake() { Cache(); }
    void Cache()
    {
        if (!enemy) enemy = GetComponent<DemoEnemy>();
        if (!agent) agent = GetComponent<NavMeshAgent>();
        if (!animator) animator = GetComponentInChildren<Animator>(true);
    }
    void OnEnable()
    {
        Cache();
        enemy.AttackStarted += BeginGrab;
        enemy.Retried += ResetVisual;
        ResetVisual();
    }
    void OnDisable()
    {
        if (enemy) { enemy.AttackStarted -= BeginGrab; enemy.Retried -= ResetVisual; }
        ReleaseNavigation();
    }
    void BeginGrab()
    {
        if (!animator) return;
        float playback = authoredGrabContact / Mathf.Max(.05f, enemy.windup);
        grabStarted = Time.time;
        releaseAt = Time.time + authoredGrabDuration / playback + .1f;
        if (agent && agent.enabled && agent.isOnNavMesh)
        {
            if (!ownsStop) previousStop = agent.isStopped;
            agent.isStopped = true;
            ownsStop = true;
        }
        animator.SetBool(Walking, false);
        animator.SetFloat(AttackSpeed, playback);
        animator.SetTrigger(Bite);
        if (!target)
        {
            var health = FindObjectOfType<DemoHealth>();
            if (health) target = health.transform;
        }
    }
    void LateUpdate()
    {
        if (!animator || !enemy.IsAlive || EvidenceInspection.IsOpen ||
            Time.frameCount <= EvidenceInspection.BlockWorldInputThroughFrame) return;
        bool grabbing = Time.time < releaseAt;
        if (!grabbing) ReleaseNavigation();
        if (grabbing && target && Time.time - grabStarted < enemy.windup * .4f)
        {
            var direction = target.position - transform.position;
            direction.y = 0;
            if (direction.sqrMagnitude > .001f)
                transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(direction), 360 * Time.deltaTime);
        }
        float velocity = agent && agent.enabled && agent.isOnNavMesh ? agent.velocity.magnitude : 0;
        animator.SetBool(Walking, !grabbing && velocity > .05f);
        animator.SetFloat(LocomotionSpeed, Mathf.Clamp(velocity / Mathf.Max(.1f, authoredWalkSpeed), .5f, 2));
    }
    void ReleaseNavigation()
    {
        if (!ownsStop) return;
        if (agent && agent.enabled && agent.isOnNavMesh) agent.isStopped = previousStop;
        ownsStop = false;
    }
    public void ResetVisual()
    {
        ReleaseNavigation();
        grabStarted = releaseAt = 0;
        if (!animator || !animator.isActiveAndEnabled) return;
        animator.Rebind();
        animator.SetBool(Walking, false);
        animator.SetFloat(LocomotionSpeed, 1);
        animator.SetFloat(AttackSpeed, 1);
        animator.ResetTrigger(Bite);
        animator.Play("Idle", 0, 0);
        animator.Update(0);
    }
}
