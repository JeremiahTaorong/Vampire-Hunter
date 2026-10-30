using UnityEngine;
using System.Reflection;
// Adapter for the unchanged standalone prototype. Movement remains authoritative.
[DefaultExecutionOrder(100)]
public class HunterGameplayAnimator:MonoBehaviour {
 public Animator animator; DemoMovement movement; DemoHealth health; Vector3 previous; int hp; float observedAttack; string state=""; float actionUntil;
 public string CurrentVisualState => state;
 static readonly FieldInfo AttackClock=typeof(DemoMovement).GetField("nextAttack",BindingFlags.Instance|BindingFlags.NonPublic);
 void Start(){movement=GetComponent<DemoMovement>();health=GetComponent<DemoHealth>();previous=transform.position;hp=health?health.Health:0;animator.applyRootMotion=false;}
 void LateUpdate(){if(!animator)return;float velocity=Vector3.Distance(transform.position,previous)/Mathf.Max(Time.deltaTime,.001f);previous=transform.position;
 string next=velocity>.15f?"Run":"Idle";
 if(health&&health.IsDead)next="Death";
 else if(movement&&movement.IsDodging)next="Dodge";
 else {float clock=movement&&AttackClock!=null?(float)AttackClock.GetValue(movement):0;if(clock>observedAttack){observedAttack=clock;actionUntil=Time.time+movement.attackInterval;state="";next="Attack";}else if(health&&health.Health<hp){actionUntil=Time.time+.35f;state="";next="Hit";}else if(Time.time<actionUntil)return;}
 if(health)hp=health.Health;SetState(next);
 }
 public bool SetState(string next){if(state==next)return true;int hash=Animator.StringToHash(next);if(!animator.HasState(0,hash))return false;if(next=="Attack"&&movement.Target){var d=movement.Target.transform.position-transform.position;d.y=0;if(d.sqrMagnitude>.001f)animator.transform.rotation=Quaternion.LookRotation(d);}else if(next=="Run"||next=="Idle"||next=="Dodge")animator.transform.localRotation=Quaternion.identity;animator.speed=next=="Dodge"?1.466667f/Mathf.Max(.1f,movement.dodgeDuration):next=="Attack"?1.533333f/Mathf.Max(.2f,movement.attackInterval):1;animator.CrossFadeInFixedTime(hash,next=="Dodge"?.02f:.08f);state=next;return true;}
}
