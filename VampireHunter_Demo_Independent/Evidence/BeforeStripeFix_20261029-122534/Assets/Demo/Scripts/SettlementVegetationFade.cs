using System.Collections.Generic;
using UnityEngine;
public class SettlementVegetationFade : MonoBehaviour {
 public Transform target;
 public Transform[] plants;
 public float occludedVisibility=.18f, fadeSpeed=3f;
 class Group {public Renderer[] renderers;public float value=1;}
 readonly List<Group> groups=new List<Group>();
 MaterialPropertyBlock block;
 void OnEnable(){Initialize();}
 public void Initialize(){Restore();groups.Clear();block=new MaterialPropertyBlock();if(plants==null)return;foreach(var t in plants)if(t)groups.Add(new Group{renderers=t.GetComponentsInChildren<Renderer>(true)});}
 public void Step(float delta){
  if(block==null)Initialize();if(!target){Restore();return;}
  Vector3 end=target.position+Vector3.up*.9f,d=end-transform.position;float distance=d.magnitude;if(distance<.01f){Restore();return;}var ray=new Ray(transform.position,d/distance);
  foreach(var g in groups){bool first=true;Bounds bounds=default(Bounds);foreach(var r in g.renderers)if(r){if(first){bounds=r.bounds;first=false;}else bounds.Encapsulate(r.bounds);}if(first)continue;
   bounds.Expand(1.5f);float hit;bool occluded=bounds.Contains(transform.position)||(bounds.IntersectRay(ray,out hit)&&hit<distance);
   g.value=Mathf.MoveTowards(g.value,occluded?occludedVisibility:1,delta*fadeSpeed);Apply(g);
  }
 }
 void Apply(Group g){foreach(var r in g.renderers)if(r){r.GetPropertyBlock(block);block.SetFloat("_Visibility",g.value);r.SetPropertyBlock(block);}}
 public void Restore(){if(block==null)return;foreach(var g in groups){g.value=1;Apply(g);}}
 public float MinimumVisibility {get {float v=1;foreach(var g in groups)v=Mathf.Min(v,g.value);return v;}}
 void LateUpdate(){Step(Time.deltaTime);}
 void OnDisable(){Restore();}
}
