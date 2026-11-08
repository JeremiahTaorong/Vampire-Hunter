using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public static class ZombieAnimationBake
{
    public static AnimationClip Bake(Animator animator, string name, bool bite)
    {
        var handler = new HumanPoseHandler(animator.avatar, animator.transform);
        var pose = new HumanPose();
        handler.GetHumanPose(ref pose);
        Vector3 body = pose.bodyPosition;
        Quaternion bodyRotation = pose.bodyRotation;
        var bones = animator.GetComponentsInChildren<Transform>();
        var feet = new[] { animator.GetBoneTransform(HumanBodyBones.LeftFoot), animator.GetBoneTransform(HumanBodyBones.RightFoot) };
        var footPositions = new[] { feet[0].position, feet[1].position };
        var footRotations = new[] { feet[0].rotation, feet[1].rotation };
        var hips = animator.GetBoneTransform(HumanBodyBones.Hips);
        var spine = animator.GetBoneTransform(HumanBodyBones.Spine);
        var chest = animator.GetBoneTransform(HumanBodyBones.Chest);
        var hipPositionCurves = new[] {new AnimationCurve(), new AnimationCurve(), new AnimationCurve()};
        var curves = new Dictionary<Transform, AnimationCurve[]>();
        foreach (var bone in bones)
        {
            if (bone == animator.transform) continue;
            curves[bone] = new[] {new AnimationCurve(), new AnimationCurve(), new AnimationCurve(), new AnimationCurve()};
        }
        var clip = new AnimationClip {name = name, frameRate = 30};
        const float duration = 1.6f;
        for (int frame = 0; frame <= 48; frame++)
        {
            float t = frame / 30f;
            float cycle = t / duration * Mathf.PI * 2;
            Array.Clear(pose.muscles, 0, pose.muscles.Length);
            float attack = bite ? Mathf.SmoothStep(0, 1, Mathf.Clamp01((t - .28f) / .42f)) * (1 - Mathf.SmoothStep(0, 1, Mathf.Clamp01((t - .95f) / .65f))) : 0;
            float walk = bite ? 0 : Mathf.Sin(cycle);
            void Muscle(string muscle, float value)
            {
                int index = Array.IndexOf(HumanTrait.MuscleName, muscle);
                if (index >= 0) pose.muscles[index] = value;
            }
            Muscle("Spine Front-Back", -.18f - attack * .32f);
            Muscle("Chest Front-Back", -.12f - attack * .25f);
            Muscle("Spine Left-Right", bite ? 0 : .07f * Mathf.Sin(cycle));
            Muscle("Chest Twist Left-Right", bite ? 0 : .08f * walk);
            Muscle("Head Nod Down-Up", -.1f - attack * .32f);
            Muscle("Head Turn Left-Right", bite ? .12f * attack : .07f * Mathf.Sin(cycle + .7f));
            foreach (string side in new[] {"Left", "Right"})
            {
                float phase = side == "Left" ? walk : -walk;
                Muscle(side + " Upper Leg Front-Back", -.08f + .23f * phase);
                Muscle(side + " Upper Leg In-Out", -.1f);
                Muscle(side + " Lower Leg Stretch", -.25f - .3f * Mathf.Max(0, -phase));
                Muscle(side + " Foot Up-Down", -.06f + .12f * phase);
                Muscle(side + " Arm Down-Up", -.35f + .15f * attack);
                Muscle(side + " Arm Front-Back", .45f + .35f * attack + .05f * phase);
                Muscle(side + " Forearm Stretch", -.35f - attack * .15f);
                Muscle(side + " Hand Down-Up", -.25f);
                foreach (string finger in new[] {"Index", "Middle", "Ring", "Little"})
                {
                    Muscle(side + " " + finger + " 1 Stretched", bite ? -.10f - .10f * attack : -.35f);
                    Muscle(side + " " + finger + " 2 Stretched", bite ? -.40f - .20f * attack : -.3f);
                    Muscle(side + " " + finger + " 3 Stretched", bite ? -.30f - .20f * attack : -.25f);
                }
            }
            pose.bodyPosition = body + new Vector3(bite ? Key(t, 0, .025f, -.015f, -.035f, -.015f, 0, 0) : 0,
                bite ? -.055f * attack : -.015f * (1 - Mathf.Cos(cycle * 2)), bite ? .13f * attack : 0);
            pose.bodyRotation = bodyRotation * Quaternion.Euler(bite ? 7 * attack : 2, 0, bite ? 0 : 2.5f * walk);
            handler.SetHumanPose(ref pose);
            if (bite)
            {
                // A planted lower body leads a much larger, delayed torso rotation.
                hips.rotation = Quaternion.AngleAxis(Key(t, 0, -15, -4, 6, 12, 5, 0), Vector3.up) * hips.rotation;
                spine.rotation = Quaternion.AngleAxis(Key(t, 0, -20, -5, 4, 14, 5, 0), Vector3.up) * spine.rotation;
                chest.rotation = Quaternion.AngleAxis(Key(t, 0, -28, -8, 6, 18, 7, 0), Vector3.up) * chest.rotation;
            }
            for (int side = 0; side < 2; side++)
            {
                var upperLeg = animator.GetBoneTransform(side == 0 ? HumanBodyBones.LeftUpperLeg : HumanBodyBones.RightUpperLeg);
                var lowerLeg = animator.GetBoneTransform(side == 0 ? HumanBodyBones.LeftLowerLeg : HumanBodyBones.RightLowerLeg);
                var foot = feet[side];
                float phase = cycle + side * Mathf.PI;
                var target = footPositions[side] + Vector3.forward * (bite ? 0 : .17f * Mathf.Cos(phase)) + Vector3.up * (bite ? 0 : .045f * Mathf.Max(0, Mathf.Sin(phase)));
                SolveLeg(upperLeg, lowerLeg, foot, target);
                foot.rotation = footRotations[side];
            }
            for (int side = 0; side < 2; side++)
            {
                bool left = side == 0;
                var upper = animator.GetBoneTransform(left ? HumanBodyBones.LeftUpperArm : HumanBodyBones.RightUpperArm);
                var lower = animator.GetBoneTransform(left ? HumanBodyBones.LeftLowerArm : HumanBodyBones.RightLowerArm);
                var hand = animator.GetBoneTransform(left ? HumanBodyBones.LeftHand : HumanBodyBones.RightHand);
                float sway = bite ? 0 : .06f * Mathf.Sin(cycle + side * Mathf.PI);
                var outward = (left ? Vector3.left : Vector3.right) * .18f;
                var upperDirection = Vector3.forward * (.55f + .4f * attack + sway) + Vector3.down * (.8f - .65f * attack) + outward;
                var lowerDirection = Vector3.forward * (.8f + .15f * attack) + Vector3.down * (.25f - .15f * attack) + outward * .2f;
                if (bite)
                {
                    float sign = left ? -1 : 1;
                    // Every wrist stays on its own side. Clasp the target's flanks,
                    // hold there, then release outwards instead of folding through the chest.
                    float x = left ? Key(t, .42f, .57f, .46f, .385f, .385f, .56f, .42f) : Key(t, .42f, .72f, .52f, .385f, .385f, .62f, .42f);
                    float y = left ? Key(t, 1.15f, 1.42f, 1.43f, 1.31f, 1.27f, 1.32f, 1.15f) : Key(t, 1.15f, 1.59f, 1.49f, 1.34f, 1.29f, 1.34f, 1.15f);
                    float z = left ? Key(t, .36f, .19f, .47f, .65f, .65f, .38f, .36f) : Key(t, .36f, -.10f, .37f, .65f, .65f, .24f, .36f);
                    Vector3 wristTarget = animator.transform.TransformPoint(new Vector3(sign * x, y, z));
                    Vector3 pole = upper.position + animator.transform.TransformDirection(new Vector3(sign * .65f, -.3f, .05f));
                    SolveArm(upper, lower, hand, wristTarget, pole);
                    var middle = animator.GetBoneTransform(left ? HumanBodyBones.LeftMiddleProximal : HumanBodyBones.RightMiddleProximal);
                    var index = animator.GetBoneTransform(left ? HumanBodyBones.LeftIndexProximal : HumanBodyBones.RightIndexProximal);
                    var little = animator.GetBoneTransform(left ? HumanBodyBones.LeftLittleProximal : HumanBodyBones.RightLittleProximal);
                    Vector3 fingers = middle.position - hand.position;
                    Vector3 palm = Vector3.Cross(fingers, index.position - little.position).normalized * (left ? -1 : 1);
                    Quaternion currentHandFrame = Quaternion.LookRotation(fingers, palm);
                    Vector3 fingerDirection = animator.transform.TransformDirection(new Vector3(0, Key(t, -.25f, .45f, .12f, -.35f, -.55f, .15f, -.25f), 1));
                    Vector3 palmDirection = animator.transform.TransformDirection(new Vector3(-sign, 0, .15f));
                    hand.rotation = Quaternion.LookRotation(fingerDirection, palmDirection) * Quaternion.Inverse(currentHandFrame) * hand.rotation;
                    continue;
                }
                if (upper && lower && hand)
                {
                    upper.rotation = Quaternion.FromToRotation(lower.position - upper.position, upperDirection) * upper.rotation;
                    lower.rotation = Quaternion.FromToRotation(hand.position - lower.position, lowerDirection) * lower.rotation;
                }
            }
            foreach (var pair in curves)
            {
                var q = pair.Key.localRotation;
                pair.Value[0].AddKey(t, q.x); pair.Value[1].AddKey(t, q.y);
                pair.Value[2].AddKey(t, q.z); pair.Value[3].AddKey(t, q.w);
            }
            for (int axis = 0; axis < 3; axis++) hipPositionCurves[axis].AddKey(t, hips.localPosition[axis]);
        }
        foreach (var pair in curves)
        {
            string path = AnimationUtility.CalculateTransformPath(pair.Key, animator.transform);
            string[] axes = {"x", "y", "z", "w"};
            for (int i = 0; i < 4; i++) clip.SetCurve(path, typeof(Transform), "m_LocalRotation." + axes[i], pair.Value[i]);
        }
        clip.EnsureQuaternionContinuity();
        if (bite)
        {
            string hipPath = AnimationUtility.CalculateTransformPath(hips, animator.transform);
            for (int axis = 0; axis < 3; axis++) clip.SetCurve(hipPath, typeof(Transform), "m_LocalPosition." + "xyz"[axis], hipPositionCurves[axis]);
        }
        var settings = AnimationUtility.GetAnimationClipSettings(clip);
        settings.loopTime = !bite;
        AnimationUtility.SetAnimationClipSettings(clip, settings);
        AssetDatabase.CreateAsset(clip, "Assets/Validation/" + name + ".anim");
        handler.Dispose();
        return clip;
    }
    static float Key(float time, params float[] values)
    {
        float[] times = {0, .30f, .58f, .75f, .98f, 1.22f, 1.6f};
        for (int i = 1; i < times.Length; i++)
            if (time <= times[i]) return Mathf.Lerp(values[i - 1], values[i], Mathf.SmoothStep(0, 1, Mathf.InverseLerp(times[i - 1], times[i], time)));
        return values[values.Length - 1];
    }
    static void SolveLeg(Transform hip, Transform knee, Transform ankle, Vector3 target)
    {
        float thigh = Vector3.Distance(hip.position, knee.position);
        float shin = Vector3.Distance(knee.position, ankle.position);
        Vector3 direction = target - hip.position;
        float distance = Mathf.Clamp(direction.magnitude, .01f, thigh + shin - .0005f);
        direction.Normalize();
        float along = (thigh * thigh - shin * shin + distance * distance) / (2 * distance);
        Vector3 bend = Vector3.ProjectOnPlane(Vector3.forward, direction).normalized;
        Vector3 kneeTarget = hip.position + direction * along + bend * Mathf.Sqrt(Mathf.Max(0, thigh * thigh - along * along));
        hip.rotation = Quaternion.FromToRotation(knee.position - hip.position, kneeTarget - hip.position) * hip.rotation;
        knee.rotation = Quaternion.FromToRotation(ankle.position - knee.position, target - knee.position) * knee.rotation;
    }
    static void SolveArm(Transform shoulder, Transform elbow, Transform wrist, Vector3 target, Vector3 pole)
    {
        float upper = Vector3.Distance(shoulder.position, elbow.position);
        float lower = Vector3.Distance(elbow.position, wrist.position);
        Vector3 delta = target - shoulder.position;
        float distance = Mathf.Clamp(delta.magnitude, Mathf.Abs(upper - lower) + .02f, (upper + lower) * .985f);
        Vector3 direction = delta.normalized;
        target = shoulder.position + direction * distance;
        float along = (upper * upper - lower * lower + distance * distance) / (2 * distance);
        Vector3 bend = Vector3.ProjectOnPlane(pole - shoulder.position, direction).normalized;
        Vector3 elbowTarget = shoulder.position + direction * along + bend * Mathf.Sqrt(Mathf.Max(0, upper * upper - along * along));
        shoulder.rotation = Quaternion.FromToRotation(elbow.position - shoulder.position, elbowTarget - shoulder.position) * shoulder.rotation;
        elbow.rotation = Quaternion.FromToRotation(wrist.position - elbow.position, target - elbow.position) * elbow.rotation;
    }
}
