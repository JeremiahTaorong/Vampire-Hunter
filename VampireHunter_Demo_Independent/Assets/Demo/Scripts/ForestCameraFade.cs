using System.Collections.Generic;
using UnityEngine;

public class ForestCameraFade : MonoBehaviour {
 public Transform target;
 public Transform vegetationRoot;
 [Range(0,1)] public float occludedVisibility=.18f;
 public float fadeSpeed=3f;
 readonly List<Renderer> renderers=new List<Renderer>();
 readonly Dictionary<Renderer,float> current=new Dictionary<Renderer,float>();
 MaterialPropertyBlock props;
 void Start(){props=new MaterialPropertyBlock(); if(vegetationRoot) foreach(var r in vegetationRoot.GetComponentsInChildren<Renderer>()) {renderers.Add(r); current[r]=1;}}
 void LateUpdate(){
  if(!target) return; Vector3 d=target.position-transform.position; float distance=d.magnitude; if(distance<.01f)return; var ray=new Ray(transform.position,d/distance);
  foreach(var r in renderers){ if(!r)continue; Bounds b=r.bounds; b.Expand(1.5f); float hit; bool occluded=b.Contains(transform.position)||(b.IntersectRay(ray,out hit)&&hit<distance); float v=Mathf.MoveTowards(current[r],occluded?occludedVisibility:1f,fadeSpeed*Time.deltaTime); current[r]=v; r.GetPropertyBlock(props); props.SetFloat("_Visibility",v); r.SetPropertyBlock(props); }
 }
}
