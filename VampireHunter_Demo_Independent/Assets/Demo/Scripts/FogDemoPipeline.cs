using UnityEngine;
using UnityEngine.Rendering;
public class FogDemoPipeline : MonoBehaviour {
 public RenderPipelineAsset pipeline;
 RenderPipelineAsset oldGraphics, oldQuality;
 void OnEnable() { oldGraphics=GraphicsSettings.defaultRenderPipeline; oldQuality=QualitySettings.renderPipeline; if(pipeline){ GraphicsSettings.defaultRenderPipeline=pipeline; QualitySettings.renderPipeline=pipeline; } }
 void OnDisable() { if(pipeline && GraphicsSettings.defaultRenderPipeline==pipeline) GraphicsSettings.defaultRenderPipeline=oldGraphics; if(pipeline && QualitySettings.renderPipeline==pipeline) QualitySettings.renderPipeline=oldQuality; }
}
