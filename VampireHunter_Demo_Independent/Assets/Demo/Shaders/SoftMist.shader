// Soft, low-contrast mist layer for the near-black forest. The previous layered fog shader
// returned a flat alpha across the whole quad, which pastes a bright veil over the frame.
// Here the alpha is driven by camera distance and by a broad noise field, so the layer only
// ever appears as a soft gradient between tree layers and never right in front of the camera.
Shader "VampireDemo/SoftMist"
{
    Properties
    {
        _FogColor ("Mist Color", Color) = (0.055, 0.070, 0.090, 1)
        _Density ("Density", Range(0, 1)) = 0.35
        _NoiseScale ("Noise Scale", Float) = 0.05
        _DriftSpeed ("Drift Speed", Float) = 0.012
        _Offset ("Layer Offset", Float) = 0
        _NearFade ("Near Fade Distance", Float) = 5
        _FarFade ("Far Fade Distance", Float) = 26
        _Softness ("Softness", Range(0.05, 1)) = 0.65
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "Queue" = "Transparent" "RenderType" = "Transparent" }

        Pass
        {
            Name "Mist"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual
            Cull Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                half4 _FogColor;
                float _Density;
                float _NoiseScale;
                float _DriftSpeed;
                float _Offset;
                float _NearFade;
                float _FarFade;
                float _Softness;
            CBUFFER_END

            struct Attributes { float4 positionOS : POSITION; float2 uv : TEXCOORD0; };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float eyeDepth : TEXCOORD2;
            };

            float hash2(float2 p) { return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453); }

            float noise2(float2 p)
            {
                float2 i = floor(p), f = frac(p);
                f = f * f * (3.0 - 2.0 * f);
                return lerp(lerp(hash2(i), hash2(i + float2(1, 0)), f.x),
                            lerp(hash2(i + float2(0, 1)), hash2(i + 1.0), f.x), f.y);
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                VertexPositionInputs positions = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = positions.positionCS;
                output.positionWS = positions.positionWS;
                output.uv = input.uv;
                output.eyeDepth = -TransformWorldToView(positions.positionWS).z;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float2 p = input.positionWS.xz * _NoiseScale + float2(_Time.y * _DriftSpeed, _Offset);
                float warp = noise2(p * 0.6 + float2(4.2, _Offset)) * 1.7;
                float broad = noise2(p + warp) * 0.58
                            + noise2(p * 2.3 + float2(_Offset, 1.3)) * 0.28
                            + noise2(p * 4.7) * 0.14;

                // Softness widens the transition band so the mist has no audible edge.
                float density = smoothstep(0.5 - _Softness * 0.5, 0.5 + _Softness * 0.5, broad);

                // Never sit in front of the lens: fade in over the first few metres and ease the
                // far edge so the layer blends into the distance fog instead of ending on a line.
                float depthFade = smoothstep(_NearFade, _NearFade + 14.0, input.eyeDepth);
                float farFade = 1.0 - smoothstep(_FarFade, _FarFade + 30.0, input.eyeDepth);
                float edge =
                    smoothstep(0.0, 0.18, input.uv.x) * smoothstep(0.0, 0.18, 1.0 - input.uv.x) *
                    smoothstep(0.0, 0.18, input.uv.y) * smoothstep(0.0, 0.18, 1.0 - input.uv.y);

                half alpha = _FogColor.a * _Density * density * depthFade * farFade * edge;
                return half4(_FogColor.rgb, alpha);
            }
            ENDHLSL
        }
    }
    FallBack Off
}
