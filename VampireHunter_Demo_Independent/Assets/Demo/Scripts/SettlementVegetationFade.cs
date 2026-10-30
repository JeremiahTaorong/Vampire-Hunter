using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class SettlementVegetationFade : MonoBehaviour {
 public Transform target;
 public Transform[] plants;
 public float occludedVisibility=.18f, fadeSpeed=3f;
 class Part {public Renderer renderer;public Material[] opaque, transparent;}
 class Group {public Part[] parts;public float value=1;public bool blended;}
 readonly List<Group> groups=new List<Group>();
 readonly Dictionary<Material,Material> transparentCache=new Dictionary<Material,Material>();
 MaterialPropertyBlock block;
 void OnEnable(){Initialize();}
 public void Initialize(){Restore();ReleaseMaterials();groups.Clear();block=new MaterialPropertyBlock();if(plants==null)return;
  foreach(var t in plants)if(t){var rs=t.GetComponentsInChildren<Renderer>(true);var parts=new List<Part>();foreach(var r in rs){var original=r.sharedMaterials;var blended=new Material[original.Length];for(int i=0;i<original.Length;i++)blended[i]=Transparent(original[i]);parts.Add(new Part{renderer=r,opaque=original,transparent=blended});}groups.Add(new Group{parts=parts.ToArray()});}
 }
 Material Transparent(Material original){if(!original)return null;Material result;if(transparentCache.TryGetValue(original,out result))return result;
  result=new Material(original){name=original.name+" Smooth Occlusion",hideFlags=HideFlags.HideAndDontSave};
  result.SetFloat("_SettlementSrcBlend",(float)BlendMode.SrcAlpha);result.SetFloat("_SettlementDstBlend",(float)BlendMode.OneMinusSrcAlpha);result.SetFloat("_SettlementZWrite",0);result.renderQueue=(int)RenderQueue.Transparent;
  result.SetShaderPassEnabled("DepthOnly",false);result.SetShaderPassEnabled("DepthNormals",false);result.SetShaderPassEnabled("DepthNormalsOnly",false);result.SetShaderPassEnabled("ShadowCaster",false);
  transparentCache.Add(original,result);return result;
 }
 public void Step(float delta){
  if(block==null)Initialize();if(!target){Restore();return;}
  Vector3 end=target.position+Vector3.up*.9f,d=end-transform.position;float distance=d.magnitude;if(distance<.01f){Restore();return;}var ray=new Ray(transform.position,d/distance);
  foreach(var g in groups){bool first=true;Bounds bounds=default(Bounds);foreach(var part in g.parts){var r=part.renderer;if(!r)continue;if(first){bounds=r.bounds;first=false;}else bounds.Encapsulate(r.bounds);}if(first)continue;
   bounds.Expand(1.5f);float hit;bool occluded=bounds.Contains(transform.position)||(bounds.IntersectRay(ray,out hit)&&hit<distance);
   g.value=Mathf.MoveTowards(g.value,occluded?occludedVisibility:1,Mathf.Max(0,delta)*fadeSpeed);Apply(g);
  }
 }
 void Apply(Group g){bool blended=g.value<.99999f;foreach(var part in g.parts){var r=part.renderer;if(!r)continue;if(blended!=g.blended)r.sharedMaterials=blended?part.transparent:part.opaque;r.GetPropertyBlock(block);block.SetFloat("_Visibility",g.value);r.SetPropertyBlock(block);}g.blended=blended;}
 public void Restore(){if(block==null)return;foreach(var g in groups){g.value=1;Apply(g);}}
 public float MinimumVisibility {get {float v=1;foreach(var g in groups)v=Mathf.Min(v,g.value);return v;}}
 void LateUpdate(){Step(Time.deltaTime);}
 void OnDisable(){Restore();ReleaseMaterials();groups.Clear();block=null;}
 void ReleaseMaterials(){foreach(var m in transparentCache.Values)if(m){if(Application.isPlaying)Destroy(m);else DestroyImmediate(m);}transparentCache.Clear();}
}
