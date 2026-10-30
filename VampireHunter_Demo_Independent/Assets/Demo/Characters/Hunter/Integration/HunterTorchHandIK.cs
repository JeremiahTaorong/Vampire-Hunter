using UnityEngine;
[DefaultExecutionOrder(150)]
public class HunterTorchHandIK : MonoBehaviour {
 public HunterTorchPose pose;
 public Vector3 handTarget=new Vector3(-.40f,1.55f,.46f);
 Vector3 previousPosition; float stride, moving;
 void OnAnimatorIK(int layerIndex){
  if(!pose||layerIndex!=pose.layer)return;
  var a=pose.bridge.animator;var root=pose.transform;float weight=pose.Weight;
  float distance=Vector3.Distance(root.position,previousPosition);previousPosition=root.position;
  if(distance<.5f)stride+=distance*(Mathf.PI*2f/1.65f);
  bool locomotion=pose.bridge.CurrentVisualState=="Run"||pose.bridge.CurrentVisualState=="Walk";
  moving=Mathf.MoveTowards(moving,locomotion?1:0,Time.deltaTime*6);
  // The hand and elbow share the same modest gait motion; the arm stays bent.
  Vector3 bob=new Vector3(Mathf.Sin(stride)*.012f*moving,Mathf.Cos(stride*2)*.022f*moving+Mathf.Sin(Time.time*1.5f)*.005f,Mathf.Sin(stride*2)*.009f*moving);
  Vector3 target=handTarget+bob;
  a.SetIKPositionWeight(AvatarIKGoal.LeftHand,weight);a.SetIKRotationWeight(AvatarIKGoal.LeftHand,weight);
  a.SetIKHintPositionWeight(AvatarIKHint.LeftElbow,weight);
  a.SetIKPosition(AvatarIKGoal.LeftHand,root.position+a.transform.rotation*target);
  a.SetIKRotation(AvatarIKGoal.LeftHand,a.transform.rotation);
  a.SetIKHintPosition(AvatarIKHint.LeftElbow,root.position+a.transform.rotation*(target+new Vector3(-.10f,-.29f,-.13f)));
 }
 void LateUpdate(){
  if(!pose||!pose.Grip||pose.Weight<.001f)return;
  // Rotate the wrist, never the prop: the serialized palm attachment remains rigid.
  // Humanoid IK goal axes differ from this asset's actual hand-bone axes.
  var a=pose.bridge.animator;var hand=a.GetBoneTransform(HumanBodyBones.LeftHand);
  Quaternion desiredHand=a.transform.rotation*Quaternion.Inverse(pose.Grip.localRotation);
  hand.rotation=Quaternion.Slerp(hand.rotation,desiredHand,pose.Weight);
 }
}
