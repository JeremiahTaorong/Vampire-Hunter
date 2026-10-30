using UnityEngine;
[ExecuteAlways]
public class CarriedFogClear : MonoBehaviour {
 public float clearRadius=2.5f, fadeRadius=6f;
 void LateUpdate(){Shader.SetGlobalVector("_CarriedFogCenter",transform.position); Shader.SetGlobalFloat("_CarriedFogInner",clearRadius); Shader.SetGlobalFloat("_CarriedFogOuter",Mathf.Max(clearRadius+.01f,fadeRadius));}
 void OnDisable(){Shader.SetGlobalFloat("_CarriedFogInner",0);Shader.SetGlobalFloat("_CarriedFogOuter",0);}
}
