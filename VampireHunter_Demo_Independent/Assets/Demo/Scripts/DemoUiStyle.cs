using UnityEngine;

// Shared, deliberately modest prototype font size; layout and accessibility remain reviewable.
public static class DemoUiStyle
{
    public static void Apply()
    {
        GUI.skin.label.fontSize = 16;
        GUI.skin.button.fontSize = 16;
        GUI.skin.box.fontSize = 16;
        GUI.skin.box.wordWrap = true;
    }
}
