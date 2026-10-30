using UnityEngine;
using UnityEngine.AI;

public class DemoEnemy : MonoBehaviour
{
    public int maxHealth = 30;
    public int Health { get; private set; }
    public bool IsAlive => Health > 0;
    public float detectionRange = 6f;
    public float attackRange = 1.6f;
    public float windup = .7f;
    public float cooldown = 1.5f;
    public bool PreparingAttack { get; private set; }
    NavMeshAgent agent;
    DemoHealth player;
    float attackAt;
    float nextAttack;
    void Awake() { Health = maxHealth; }
    void Start() { agent = GetComponent<NavMeshAgent>(); player = FindObjectOfType<DemoHealth>(); }
    void Update()
    {
        if (!IsAlive || !player || player.IsDead || !agent || !agent.isOnNavMesh) return;
        Vector3 difference = player.transform.position - transform.position;
        difference.y = 0;
        float distance = difference.magnitude;
        if (PreparingAttack)
        {
            if (Time.time >= attackAt)
            {
                PreparingAttack = false;
                if (distance <= attackRange && ClearPathToPlayer()) player.TakeDamage(15);
                nextAttack = Time.time + cooldown;
            }
            return;
        }
        if (distance <= attackRange)
        {
            agent.ResetPath();
            if (Time.time >= nextAttack) { PreparingAttack = true; attackAt = Time.time + windup; }
        }
        else if (distance <= detectionRange) agent.SetDestination(player.transform.position);
        else if (agent.hasPath) agent.ResetPath();
    }
    bool ClearPathToPlayer()
    {
        return !Physics.Linecast(transform.position + Vector3.up * .4f, player.transform.position + Vector3.up * .4f, out var hit)
            || hit.collider.GetComponent<DemoHealth>() == player;
    }
    void OnGUI()
    {
        DemoUiStyle.Apply();
        if (PreparingAttack) GUI.Label(new Rect(12, 125, 320, 25), "Enemy preparing attack!");
    }
    public void TakeDamage(int amount)
    {
        if (!IsAlive || amount <= 0) return;
        Health = Mathf.Max(0, Health - amount);
        if (!IsAlive) { if (player) player.ShowVictory(); gameObject.SetActive(false); }
    }
    public void ResetForRetry(Vector3 position)
    {
        Health = maxHealth;
        PreparingAttack = false;
        attackAt = 0; nextAttack = 0;
        if (!agent) agent = GetComponent<NavMeshAgent>();
        if (agent && agent.isOnNavMesh) { agent.ResetPath(); agent.Warp(position); }
    }
}
