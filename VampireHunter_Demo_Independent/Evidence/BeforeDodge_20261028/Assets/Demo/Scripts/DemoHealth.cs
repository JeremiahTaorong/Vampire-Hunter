using UnityEngine;
using UnityEngine.SceneManagement;

public class DemoHealth : MonoBehaviour
{
    public int maxHealth = 100;
    public int Health { get; private set; }
    public bool IsDead => Health <= 0;
    public bool Victory { get; private set; }
    float feedbackUntil;
    void Awake() { Health = maxHealth; }
    public void TakeDamage(int amount)
    {
        if (IsDead || Victory || amount <= 0) return;
        Health = Mathf.Max(0, Health - amount);
        feedbackUntil = Time.time + 1f;
    }
    public void ShowVictory() { if (!IsDead) Victory = true; }
    void Update()
    {
        if ((IsDead || Victory) && Input.GetKeyDown(KeyCode.R)) SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    void OnGUI()
    {
        GUI.Box(new Rect(12, 72, 200, 45), "HP " + Health + " / " + maxHealth + (Time.time < feedbackUntil ? "  HIT!" : ""));
        if (IsDead || Victory) GUI.Box(new Rect(240, 72, 250, 45), (IsDead ? "Defeated" : "Victory") + " — Press R to retry");
    }
}
