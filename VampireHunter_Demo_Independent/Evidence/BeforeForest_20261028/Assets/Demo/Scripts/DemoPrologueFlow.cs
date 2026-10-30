using UnityEngine;

public class DemoPrologueFlow : MonoBehaviour
{
    public GameObject enemy;
    public GameObject mentorClue;
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
        if (enemy) enemy.SetActive(true);
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
    void OnGUI()
    {
        string objective = Current == Stage.Investigate ? "Investigate the evidence and witness" :
            Current == Stage.Hunt ? "Defeat the forest enemy" :
            Current == Stage.MentorClue ? "Inspect the hunter's mark" : "Prologue prototype complete";
        GUI.Box(new Rect(540, 12, 300, 48), "Objective: " + objective);
    }
}
