Shader "VampireDemo/ForestAtmosphereReview" {
 Properties { _Tint("Tint",Color)=(0.48,0.55,0.54,1) _Visibility("Visibility",Range(0,1))=1 }
 SubShader { Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
 Pass { Tags { "LightMode"="UniversalForward" } Cull Off ZWrite On AlphaToMask On
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
 float hash2(float2 p){return frac(sin(dot(p,float2(127.1,311.7)))*43758.5453);}
 float smoothNoise(float2 p){float2 c=floor(p),f=frac(p);f=f*f*(3-2*f);return lerp(lerp(hash2(c),hash2(c+float2(1,0)),f.x),lerp(hash2(c+float2(0,1)),hash2(c+1),f.x),f.y);}
 half4 frag(Varyings i):SV_Target {float n=smoothNoise(i.uv*70)*.72+smoothNoise(i.uv*145)*.28;float alpha=lerp(i.color.a*(-18.2)*n*.5,2.1,i.color.a);float edge=alpha-.66;float width=max(fwidth(edge),.015);clip(edge+width*.5);float coverage=saturate(edge/width+.5);if(_Visibility<.999){float d=frac(52.9829189*frac(dot(floor(i.positionCS.xy),float2(.06711056,.00583715))));clip(_Visibility-d);}Light l=GetMainLight();half light=.5h+.5h*saturate(dot(normalize(i.normalWS),l.direction));half variation=.82h+.18h*smoothNoise(i.uv*80);half3 color=variation*i.color.rgb*_Tint.rgb*light;return half4(MixFog(color,i.fog),coverage); }
 ENDHLSL } } }
