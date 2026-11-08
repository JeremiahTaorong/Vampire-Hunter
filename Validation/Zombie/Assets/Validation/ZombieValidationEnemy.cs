using UnityEngine;

// Flat-ground feasibility harness, deliberately independent of the game Demo.
public class ZombieValidationEnemy : MonoBehaviour
{
    public Animator animator;
    public Transform target;
    public float speed = .65f;
    public float biteRange = .75f;
    public int targetHealth = 100;
    public int landedBites;
    public bool IsBiting { get; private set; }
    float attackStarted;
    float nextAttack;
    bool contactChecked;

    void Update()
    {
        if (!target || !animator) return;
        var delta = target.position - transform.position;
        delta.y = 0;
        if (IsBiting)
        {
            float elapsed = Time.time - attackStarted;
            if (!contactChecked && elapsed >= .75f)
            {
                contactChecked = true;
                if (delta.magnitude <= biteRange + .1f)
                {
                    targetHealth = Mathf.Max(0, targetHealth - 15);
                    landedBites++;
                }
            }
            if (elapsed >= 1.6f) { IsBiting = false; nextAttack = Time.time + .6f; }
            return;
        }
        if (delta.sqrMagnitude > .01f)
            transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(delta), 120 * Time.deltaTime);
        bool walking = delta.magnitude > biteRange;
        animator.SetBool("Walking", walking);
        if (walking) transform.position += delta.normalized * Mathf.Min(speed * Time.deltaTime, delta.magnitude - biteRange);
        else if (Time.time >= nextAttack)
        {
            animator.SetBool("Walking", false);
            animator.SetTrigger("Bite");
            IsBiting = true;
            attackStarted = Time.time;
            contactChecked = false;
        }
    }

    void OnGUI()
    {
        GUI.Label(new Rect(20, 20, 600, 28), "Independent zombie feasibility test — target HP: " + targetHealth);
        GUI.Label(new Rect(20, 48, 600, 28), IsBiting ? "Grab attack: contact at 0.75s" : "Shambling toward target");
    }
}
