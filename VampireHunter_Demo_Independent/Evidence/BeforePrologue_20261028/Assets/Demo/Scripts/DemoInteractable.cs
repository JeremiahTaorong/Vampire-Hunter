using UnityEngine;

public class DemoInteractable : MonoBehaviour
{
    public float range = 2.5f;
    [TextArea] public string evidenceText = "Evidence: A hunter's emblem lies in the dust.";
    public string clueId = "emblem";
    public bool examined { get; private set; }
    public string Activate()
    {
        examined = true;
        var investigation = FindObjectOfType<DemoInvestigation>();
        if (investigation) investigation.Record(clueId);
        return evidenceText;
    }
}
