using UnityEngine;
using UnityEngine.AI;

public class DemoPrologueFlow : MonoBehaviour
{
    public GameObject enemy;
    public GameObject mentorClue;
    public Transform checkpoint;
    public bool CheckpointActive { get; private set; }
    Vector3 enemyStart;
    public enum Stage { Investigate, Hunt, MentorClue, Complete }
    public Stage Current { get; private set; } = Stage.Investigate;
    void Awake()
    {
        if (enemy) enemy.SetActive(false);
        if (mentorClue) mentorClue.SetActive(false);
    }
    public void BeginHunt()
    {
        if (Current != Stage.Investigate) return;
        Current = Stage.Hunt;
        if (enemy) { enemyStart = enemy.transform.position; enemy.SetActive(true); }
    }
    public void EnemyDefeated()
    {
        if (Current != Stage.Hunt) return;
        Current = Stage.MentorClue;
        if (mentorClue) mentorClue.SetActive(true);
    }
    public void DiscoverMentorClue()
    {
        if (Current != Stage.MentorClue) return;
        Current = Stage.Complete;
        GetComponent<DemoHealth>().CompletePrologue();
    }
    void Update()
    {
        if (Current == Stage.Hunt && checkpoint && !CheckpointActive &&
            Vector3.Distance(transform.position, checkpoint.position) <= 5f) CheckpointActive = true;
    }
    public bool RetryAtCheckpoint()
    {
        if (!CheckpointActive || Current != Stage.Hunt || !checkpoint || !enemy) return false;
        var agent = GetComponent<NavMeshAgent>();
        if (!agent || !agent.isOnNavMesh || !NavMesh.SamplePosition(checkpoint.position, out var point, 3f, NavMesh.AllAreas)) return false;
        GetComponent<DemoMovement>().ResetAfterFailure();
        if (!agent.Warp(point.position)) return false;
        enemy.SetActive(true);
        enemy.GetComponent<DemoEnemy>().ResetForRetry(enemyStart);
        GetComponent<DemoHealth>().RestoreForRetry();
        return true;
    }
    void OnGUI()
    {
        DemoUiStyle.Apply();
        string objective = Current == Stage.Investigate ? "Investigate the evidence and witness" :
            Current == Stage.Hunt ? "Defeat the forest enemy" :
            Current == Stage.MentorClue ? "Inspect the hunter's mark" : "Prologue prototype complete";
        GUI.Box(new Rect(540, 12, 300, 48), "Objective: " + objective);
        if (Current == Stage.Hunt)
            GUI.Box(new Rect(540, 65, 360, 75), "Left-click enemy to attack. WASD moves.\nSpace dodges. Approach the checkpoint.\n" + (CheckpointActive ? "Checkpoint active." : "Checkpoint: forest entrance."));
        if (Current == Stage.Complete)
            GUI.Box(new Rect(540, 65, 360, 75), "A familiar mark points to the castle.\nThe hunter continues the search.");
    }
}
