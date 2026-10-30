using UnityEngine;
[DisallowMultipleComponent, RequireComponent(typeof(Light))]
public class SettlementFogLight : MonoBehaviour {
 public Light source;
 public float innerRadius, outerRadius, minimumDensity=.35f, referenceIntensity=1f;
 [System.NonSerialized] public float strength;
 public void Tick(float delta) {
  if(!source) source=GetComponent<Light>();
  float wanted=source && source.enabled && source.gameObject.activeInHierarchy ? Mathf.Clamp01(source.intensity/Mathf.Max(.001f,referenceIntensity)) : 0;
  strength=Application.isPlaying ? Mathf.MoveTowards(strength,wanted,delta*3f) : wanted;
 }
}
