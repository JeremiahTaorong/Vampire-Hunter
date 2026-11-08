using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class ZombieAttackPreview
{
    static ZombieValidationEnemy previewEnemy;
    static int previewFrame;
    static bool poseReady;
    public static void Run()
    {
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        EditorSceneManager.OpenScene("Assets/Validation/ZombieFeasibility.unity");
        Measure();
        EditorApplication.playModeStateChanged += state => {
            if (state != PlayModeStateChange.EnteredPlayMode) return;
            previewEnemy = UnityEngine.Object.FindObjectOfType<ZombieValidationEnemy>();
            previewEnemy.enabled = false;
            previewEnemy.transform.position = new Vector3(0, 0, -.75f);
            previewEnemy.animator.speed = 0;
            Directory.CreateDirectory("Evidence/GrabFrames");
            EditorApplication.update += Tick;
        };
        EditorApplication.isPlaying = true;
    }
    static void Tick()
    {
        if (!previewEnemy) return;
        if (!poseReady)
        {
            previewEnemy.animator.Play("Bite", 0, previewFrame / 48f);
            previewEnemy.animator.Update(0);
            poseReady = true;
            return;
        }
        ZombiePlayVerification.Capture("GrabFrames/" + previewFrame.ToString("D3") + ".png");
        poseReady = false;
        if (++previewFrame > 48) { Debug.Log("ZOMBIE ANIMATED GRAB PREVIEW PASS"); EditorApplication.Exit(0); }
    }
    static void Measure()
    {
        var enemy = UnityEngine.Object.FindObjectOfType<ZombieValidationEnemy>();
        enemy.enabled = false;
        enemy.transform.position = new Vector3(0, 0, -.75f);
        enemy.animator.enabled = false;
        var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>("Assets/Validation/Zombie_Bite.anim");
        var bones = enemy.GetComponentsInChildren<Transform>();
        var chest = bones.First(t => t.name == "spine_03");
        var hand = bones.First(t => t.name == "hand_r");
        clip.SampleAnimation(enemy.gameObject, .30f);
        Quaternion windup = chest.rotation;
        Vector3 handStart = hand.position;
        clip.SampleAnimation(enemy.gameObject, .98f);
        float twist = Quaternion.Angle(windup, chest.rotation);
        float travel = Vector3.Distance(handStart, hand.position);
        if (twist < 85 || travel < .45f) throw new Exception("Attack amplitude too small: torso=" + twist + ", hand=" + travel);
        File.WriteAllText("Evidence/grab-amplitude.txt", "Measured on sampled skeleton: torso rotation between windup and follow-through=" + twist.ToString("F1") + " degrees; right-hand displacement=" + travel.ToString("F2") + " m.");
        var leftHand = bones.First(t => t.name == "hand_l");
        var renderer = enemy.GetComponentsInChildren<SkinnedMeshRenderer>().OrderByDescending(r => r.sharedMesh.vertexCount).First();
        var mesh = new Mesh();
        float minSide = float.PositiveInfinity;
        float maxPenetration = 0;
        int maxInsideVertices = 0;
        for (int frame = 0; frame <= 48; frame++)
        {
            clip.SampleAnimation(enemy.gameObject, frame / 30f);
            minSide = Mathf.Min(minSide, enemy.transform.InverseTransformPoint(hand.position).x, -enemy.transform.InverseTransformPoint(leftHand.position).x);
            renderer.BakeMesh(mesh);
            int inside = 0;
            foreach (Vector3 local in mesh.vertices)
            {
                Vector3 vertex = renderer.transform.TransformPoint(local);
                Vector3 axisPoint = new Vector3(enemy.target.position.x, Mathf.Clamp(vertex.y, .275f, 1.725f), enemy.target.position.z);
                float penetration = .275f - Vector3.Distance(vertex, axisPoint);
                maxPenetration = Mathf.Max(maxPenetration, penetration);
                if (penetration > .02f) inside++;
            }
            maxInsideVertices = Mathf.Max(maxInsideVertices, inside);
        }
        UnityEngine.Object.DestroyImmediate(mesh);
        File.WriteAllText("Evidence/grab-clearance.txt", "49 sampled poses: minimum wrist distance from own centre plane=" + minSide.ToString("F3") + " m; maximum body-mesh penetration into test capsule=" + maxPenetration.ToString("F3") + " m; maximum vertices inside capsule by more than 2 cm=" + maxInsideVertices + ".");
        Debug.Log("ZOMBIE CLEARANCE: wristSide=" + minSide + " penetration=" + maxPenetration + " vertices=" + maxInsideVertices);
        if (minSide < .16f || maxPenetration > .002f) throw new Exception("Grab clearance failed; see Evidence/grab-clearance.txt");
        enemy.animator.enabled = true;
        Debug.Log("ZOMBIE GRAB PREVIEW PASS: torso=" + twist + " handTravel=" + travel);
    }
}
