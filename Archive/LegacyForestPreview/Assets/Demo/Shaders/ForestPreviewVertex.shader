Shader "VampireDemo/ForestPreviewVertex" {
 Properties { _Tint("Tint", Color) = (0.28,0.34,0.32,1) _Cutoff("Cutoff",Range(0,1)) = 0.3 }
 SubShader { Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
 Pass { Tags { "LightMode"="UniversalForward" } Cull Off ZWrite On
 HLSLPROGRAM
 #pragma vertex vert
 #pragma fragment frag
 #pragma multi_compile_fog
 #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
 #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
 struct Attributes { float4 positionOS:POSITION; float3 normalOS:NORMAL; float4 color:COLOR; };
 struct Varyings { float4 positionCS:SV_POSITION; half3 color:COLOR; half alpha:TEXCOORD0; half fog:TEXCOORD1; half3 normalWS:TEXCOORD2; };
 CBUFFER_START(UnityPerMaterial) half4 _Tint; half _Cutoff; CBUFFER_END
 Varyings vert(Attributes i) { Varyings o; VertexPositionInputs p=GetVertexPositionInputs(i.positionOS.xyz); o.positionCS=p.positionCS; o.normalWS=TransformObjectToWorldNormal(i.normalOS); o.color=i.color.rgb*_Tint.rgb; o.alpha=i.color.a; o.fog=ComputeFogFactor(p.positionCS.z); return o; }
 half4 frag(Varyings i):SV_Target { clip(i.alpha-_Cutoff); Light l=GetMainLight(); half light=0.45h+0.55h*saturate(dot(normalize(i.normalWS),l.direction)); return half4(MixFog(i.color*light,i.fog),1); }
 ENDHLSL } } }
