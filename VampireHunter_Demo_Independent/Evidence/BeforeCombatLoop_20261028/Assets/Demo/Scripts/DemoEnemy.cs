using UnityEngine;

public class DemoEnemy : MonoBehaviour
{
    public int maxHealth = 30;
    public int Health { get; private set; }
    public bool IsAlive => Health > 0;
    void Awake() { Health = maxHealth; }
    public void TakeDamage(int amount)
    {
        if (!IsAlive || amount <= 0) return;
        Health = Mathf.Max(0, Health - amount);
        if (!IsAlive) gameObject.SetActive(false);
    }
}
