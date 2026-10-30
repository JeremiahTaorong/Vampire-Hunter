using UnityEngine;
using System.Linq;
[DefaultExecutionOrder(200)]
public class HunterTorchPose : MonoBehaviour {
 public HunterGameplayAnimator bridge;
 public int layer=1;
 public float blendSeconds=.12f;
 Transform torch, grip; bool bound;
 public Transform Grip => grip;
 public float Weight => bridge && bridge.animator ? bridge.animator.GetLayerWeight(layer) : 0;
 void Start(){
  if(!bridge||!bridge.animator)return;
  foreach(var l in GetComponentsInChildren<Light>(true))if(l.name=="Carried lantern"){var r=l.GetComponent<Renderer>();if(r)r.enabled=false;}
  torch=bridge.animator.GetComponentsInChildren<Transform>(true).FirstOrDefault(t=>t.name=="Hunter Left Torch");
  if(torch)foreach(var ps in torch.GetComponentsInChildren<ParticleSystem>())if(ps.name=="fx_fire"){var main=ps.main;main.simulationSpace=ParticleSystemSimulationSpace.Local;}
  var hand=bridge.animator.GetBoneTransform(HumanBodyBones.LeftHand);
  grip=hand.Find("Left Palm Torch Grip");
  if(grip){torch.SetParent(grip,true);torch.localPosition=Vector3.zero;torch.localRotation=Quaternion.identity;bound=true;}
 }
 void LateUpdate(){
  if(!bridge||!bridge.animator)return;
  string s=bridge.CurrentVisualState;
  float target=(s=="Idle"||s=="Walk"||s=="Run"||s=="Attack")?1:0;
  bridge.animator.SetLayerWeight(layer,Mathf.MoveTowards(Weight,target,Time.deltaTime/Mathf.Max(.02f,blendSeconds)));
  // Calibrate once after Humanoid IK. Thereafter the hierarchy drives BOTH position and rotation.
  if(!bound&&torch&&Weight>.99f){var a=bridge.animator;var hand=a.GetBoneTransform(HumanBodyBones.LeftHand);var index=a.GetBoneTransform(HumanBodyBones.LeftIndexProximal);var little=a.GetBoneTransform(HumanBodyBones.LeftLittleProximal);grip=new GameObject("Left Palm Torch Grip").transform;grip.SetParent(hand,false);grip.position=Vector3.Lerp(hand.position,(index.position+little.position)*.5f,.68f);grip.rotation=a.transform.rotation;torch.SetParent(grip,true);torch.localPosition=Vector3.zero;torch.localRotation=Quaternion.identity;bound=true;}
 }
}
