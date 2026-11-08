Shader "VampireDemo/ForestDetailReview" {
 Properties { _Tint("Tint",Color)=(0.55,0.61,0.58,1) _Visibility("Visibility",Range(0,1))=1 }
 SubShader { Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
 Pass { Tags { "LightMode"="UniversalForward" } Cull Off ZWrite On
 HLSLPROGRAM
 #pragma vertex vert
 #pragma fragment frag
 #pragma multi_compile_fog
 #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
 #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
 struct Attributes { float4 positionOS:POSITION; float3 normalOS:NORMAL; float4 color:COLOR; float2 uv:TEXCOORD0; };
 struct Varyings { float4 positionCS:SV_POSITION; half4 color:COLOR; float2 uv:TEXCOORD0; half fog:TEXCOORD1; half3 normalWS:TEXCOORD2; };
 CBUFFER_START(UnityPerMaterial) half4 _Tint; half _Visibility; CBUFFER_END
 Varyings vert(Attributes i) { Varyings o; VertexPositionInputs p=GetVertexPositionInputs(i.positionOS.xyz); o.positionCS=p.positionCS; o.normalWS=TransformObjectToWorldNormal(i.normalOS); o.color=i.color; o.uv=i.uv; o.fog=ComputeFogFactor(p.positionCS.z); return o; }
 float sourceNoise(float2 uv,float steps){float2 q=floor(uv*steps)/(steps-1); float2 s=q+0.2127+q.x*0.3713*q.y; float2 r=4.789*sin(489.123*s); return frac(r.x*r.y*(1+s.x));}
 half4 frag(Varyings i):SV_Target {float pixelNoise=frac(52.9829189*frac(dot(floor(i.positionCS.xy),float2(0.06711056,0.00583715)))); float alpha=lerp(i.color.a*(-18.2)*sourceNoise(i.uv,150)*0.5,2.1,i.color.a); clip(alpha+pixelNoise-1.0); clip(_Visibility-pixelNoise); Light l=GetMainLight(); half light=.45h+.55h*saturate(dot(normalize(i.normalWS),l.direction)); half3 color=(.57547+.4*sourceNoise(i.uv,600))*i.color.rgb*_Tint.rgb*light; return half4(MixFog(color,i.fog),1); }
 ENDHLSL } } }
