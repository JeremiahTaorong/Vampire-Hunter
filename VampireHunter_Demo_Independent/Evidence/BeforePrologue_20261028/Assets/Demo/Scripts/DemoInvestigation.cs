using UnityEngine;

public class DemoInvestigation : MonoBehaviour
{
    public bool HasEvidence { get; private set; }
    public bool HasWitness { get; private set; }
    public bool Concluded { get; private set; }
    public bool WrongAttempt { get; private set; }
    public void Record(string id)
    {
        if (id == "emblem") HasEvidence = true;
        if (id == "witness") HasWitness = true;
    }
    public bool Resolve(bool forest)
    {
        if (!HasEvidence || !HasWitness || Concluded) return false;
        if (!forest) { WrongAttempt = true; return false; }
        Concluded = true;
        return true;
    }
    public bool BlocksWorldClick(Vector2 screenPosition)
    {
        Vector2 gui = new Vector2(screenPosition.x, Screen.height - screenPosition.y);
        return new Rect(12, 160, 510, 180).Contains(gui);
    }
    void OnGUI()
    {
        GUI.Box(new Rect(12, 160, 510, 180), "Investigation: find evidence and speak to the witness");
        GUI.Label(new Rect(24, 190, 470, 24), "Hunter emblem: " + (HasEvidence ? "Found" : "Not found"));
        GUI.Label(new Rect(24, 215, 470, 24), "Witness testimony: " + (HasWitness ? "Heard" : "Not heard"));
        if (Concluded) GUI.Label(new Rect(24, 245, 470, 50), "Conclusion: search the forest for the missing villagers.");
        else if (HasEvidence && HasWitness)
        {
            GUI.Label(new Rect(24, 245, 470, 24), "Where should the hunter search?");
            if (GUI.Button(new Rect(24, 275, 160, 30), "Forest")) Resolve(true);
            if (GUI.Button(new Rect(195, 275, 160, 30), "Stay in village")) Resolve(false);
            if (WrongAttempt) GUI.Label(new Rect(24, 310, 470, 24), "Review the clues and try again.");
        }
    }
}
