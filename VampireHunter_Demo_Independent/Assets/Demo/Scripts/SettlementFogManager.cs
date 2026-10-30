using UnityEngine;
[ExecuteAlways]
public class SettlementFogManager : MonoBehaviour {
 public SettlementFogLight[] lights;
 public const int Capacity=64;
 readonly Vector4[] centers=new Vector4[Capacity], parameters=new Vector4[Capacity];
 bool warned;
 public void Upload(float delta) {
  if(lights==null) return;
  if(lights.Length>Capacity && !warned){Debug.LogError("Settlement fog exceeds 64 lights; registration must be reduced or capacity increased.");warned=true;}
  int count=0;
  foreach(var item in lights){if(!item)continue;item.Tick(delta);if(count>=Capacity)break;
   centers[count]=new Vector4(item.transform.position.x,item.transform.position.y,item.transform.position.z,item.innerRadius);
   parameters[count]=new Vector4(Mathf.Max(item.innerRadius+.01f,item.outerRadius),item.minimumDensity,item.strength,0);count++;
  }
  Shader.SetGlobalVectorArray("_SettlementFogCenters",centers);Shader.SetGlobalVectorArray("_SettlementFogParameters",parameters);Shader.SetGlobalInt("_SettlementFogCount",count);
 }
 void LateUpdate(){Upload(Time.deltaTime);}
 void OnDisable(){Shader.SetGlobalInt("_SettlementFogCount",0);}
}
