Shader "VampireDemo/LayeredGroundFog"
{
    Properties
    {
        _FogColor ("Fog Color", Color) = (0.56, 0.60, 0.62, 0.22)
        _NoiseScale ("Noise Scale", Float) = 0.075
        _Offset ("Layer Offset", Float) = 0
        _DriftSpeed ("Drift Speed", Float) = 0.035
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" "Queue"="Transparent" "RenderType"="Transparent" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            CBUFFER_START(UnityPerMaterial)
                half4 _FogColor;
                float _NoiseScale;
                float _Offset;
                float _DriftSpeed;
            CBUFFER_END
            struct Attributes { float4 positionOS : POSITION; float2 uv : TEXCOORD0; };
            struct Varyings { float4 positionCS : SV_POSITION; float3 positionWS : TEXCOORD0; float2 uv : TEXCOORD1; };
            float hash2(float2 p) { return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453); }
            float noise2(float2 p)
            {
                float2 i=floor(p), f=frac(p); f=f*f*(3.0-2.0*f);
                return lerp(lerp(hash2(i),hash2(i+float2(1,0)),f.x),lerp(hash2(i+float2(0,1)),hash2(i+1.0),f.x),f.y);
            }
            Varyings vert(Attributes v)
            {
                Varyings o; o.positionWS=TransformObjectToWorld(v.positionOS.xyz);
                o.positionCS=TransformWorldToHClip(o.positionWS); o.uv=v.uv; return o;
            }
            half4 frag(Varyings i) : SV_Target
            {
                float2 p=i.positionWS.xz*_NoiseScale + float2(_Time.y*_DriftSpeed, _Offset);
                float warp=noise2(p*.7+float2(4.2,_Offset))*1.5;
                float broad=noise2(p+warp)*.62+noise2(p*2.1+float2(_Offset,1.3))*.26+noise2(p*4.1)*.12;
                float density=smoothstep(.26,.76,broad);
                float edge=smoothstep(0.0,.09,i.uv.x)*smoothstep(0.0,.09,1.0-i.uv.x)*smoothstep(0.0,.09,i.uv.y)*smoothstep(0.0,.09,1.0-i.uv.y);
                return half4(_FogColor.rgb, _FogColor.a * density * edge);
            }
            ENDHLSL
        }
    }
}
