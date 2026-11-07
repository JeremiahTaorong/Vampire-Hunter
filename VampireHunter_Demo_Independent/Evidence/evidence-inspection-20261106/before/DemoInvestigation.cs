using UnityEngine;

public class DemoInvestigation : MonoBehaviour
{
    public bool HasEvidence { get; private set; }
    public bool HasWitness { get; private set; }
    public bool HasTrail { get; private set; }
    public bool requireTrail;
    public bool Concluded { get; private set; }
    public bool WrongAttempt { get; private set; }
    public void Record(string id)
    {
        if (id == "emblem") HasEvidence = true;
        if (id == "witness") HasWitness = true;
        if (id == "trail") HasTrail = true;
    }
    public bool Resolve(bool forest)
    {
        if (!HasEvidence || !HasWitness || (requireTrail && !HasTrail) || Concluded) return false;
        if (!forest) { WrongAttempt = true; return false; }
        Concluded = true;
        var flow = GetComponent<DemoPrologueFlow>();
        if (flow) flow.BeginHunt();
        return true;
    }
    public bool BlocksWorldClick(Vector2 screenPosition)
    {
        Vector2 gui = new Vector2(screenPosition.x, Screen.height - screenPosition.y);
        return new Rect(12, 160, 510, requireTrail ? 235 : 180).Contains(gui);
    }
    void OnGUI()
    {
        DemoUiStyle.Apply();
        GUI.Box(new Rect(12, 160, 510, requireTrail ? 235 : 180), "Investigation: find evidence and speak to the witness");
        if (requireTrail) GUI.Label(new Rect(24, 370, 475, 22), "Village clues are spread out. Forest path is to the right.");
        GUI.Label(new Rect(24, 190, 470, 24), "Hunter emblem: " + (HasEvidence ? "Found" : "Not found"));
        GUI.Label(new Rect(24, 215, 470, 24), "Witness testimony: " + (HasWitness ? "Heard" : "Not heard"));
        if (requireTrail) GUI.Label(new Rect(24, 240, 470, 24), "Drag marks: " + (HasTrail ? "Found" : "Not found"));
        int shift = requireTrail ? 25 : 0;
        if (Concluded) GUI.Label(new Rect(24, 245 + shift, 470, 50), "Conclusion: search the forest for the missing villagers.");
        else if (HasEvidence && HasWitness && (!requireTrail || HasTrail))
        {
            GUI.Label(new Rect(24, 245 + shift, 470, 24), "Where should the hunter search?");
            if (GUI.Button(new Rect(24, 275 + shift, 160, 30), "Forest")) Resolve(true);
            if (GUI.Button(new Rect(195, 275 + shift, 160, 30), "Stay in village")) Resolve(false);
            if (WrongAttempt) GUI.Label(new Rect(24, 310 + shift, 470, 24), "Review the clues and try again.");
        }
    }
}
