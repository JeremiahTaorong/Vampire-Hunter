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
        var movement = GetComponent<DemoMovement>();
        if (IsDead || Victory || amount <= 0 || (movement && movement.IsInvulnerable)) return;
        Health = Mathf.Max(0, Health - amount);
        feedbackUntil = Time.time + 1f;
    }
    public void ShowVictory()
    {
        if (IsDead) return;
        var flow = GetComponent<DemoPrologueFlow>();
        if (flow) flow.EnemyDefeated(); else Victory = true;
    }
    public void CompletePrologue() { if (!IsDead) Victory = true; }
    public void RestoreForRetry() { Health = maxHealth; Victory = false; feedbackUntil = 0; }
    void Update()
    {
        if (EvidenceInspection.IsOpen || Time.frameCount <= EvidenceInspection.BlockWorldInputThroughFrame) return;
        if ((IsDead || Victory) && Input.GetKeyDown(KeyCode.R))
        {
            var flow = GetComponent<DemoPrologueFlow>();
            if (IsDead && flow && flow.RetryAtCheckpoint()) return;
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }
    void OnGUI()
    {
        if (EvidenceInspection.IsOpen) return;
        DemoUiStyle.Apply();
        GUI.Box(new Rect(12, 72, 200, 45), "HP " + Health + " / " + maxHealth + (Time.time < feedbackUntil ? "  HIT!" : ""));
        if (IsDead || Victory) GUI.Box(new Rect(240, 72, 270, 45), (IsDead ? "Defeated" : "Complete") + " — R to restart");
    }
}
