// URP port of the Pine Forest- LowPoly "Mobile_Vtx_Cutout" algorithm.
// The original asset carries no textures: albedo comes from vertex colour RGB and the
// silhouette comes from vertex colour ALPHA modulated by a cell-quantised hash noise.
// Mesh alpha never reaches 1.0 (grass tops out at 0.8), so the noise is what produces
// the fine needle breakup. Reproducing that threshold is the whole point of this shader.
Shader "VampireDemo/ForestFoliageURP"
{
    Properties
    {
        [Header(Original asset parameters)]
        _ColorBase ("Color Base", Color) = (0.6470588, 0.6470588, 0.6470588, 1)
        _NoiseColor ("Noise Color", Color) = (0.9338235, 0.9338235, 0.9338235, 1)
        _BaseNoiseAmount ("Base Noise Amount", Float) = 0.4
        _ColorNoiseSteps ("Color Noise Steps", Float) = 600
        _OpacityNoiseSteps ("Opacity Noise Steps", Float) = 150
        _OpacityNoiseAmount ("Opacity Noise Amount", Float) = 0.5
        _VtxColorAmount ("Vertex Color Amount", Float) = 1
        _VtxOpacity ("Vertex Opacity", Float) = -18.2
        _AllOpacity ("All Opacity", Float) = 2.1
        _Cutoff ("Cutoff", Float) = 1.5
        _ObjectNoiseBlend ("Object Noise Blend", Range(0, 1)) = 1
        _ObjectNoiseScale ("Object Noise Scale", Float) = 120

        [Header(Atmosphere)]
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _AmbientBoost ("Ambient Boost", Float) = 1
        _ShadowWrap ("Shadow Wrap", Range(0, 1)) = 0.15
        _Visibility ("Visibility", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "TransparentCutout"
            "Queue" = "AlphaTest"
        }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        CBUFFER_START(UnityPerMaterial)
            half4 _ColorBase;
            half4 _NoiseColor;
            float _BaseNoiseAmount;
            float _ColorNoiseSteps;
            float _OpacityNoiseSteps;
            float _OpacityNoiseAmount;
            float _VtxColorAmount;
            float _VtxOpacity;
            float _AllOpacity;
            float _Cutoff;
            float _ObjectNoiseBlend;
            float _ObjectNoiseScale;
            half4 _Tint;
            float _AmbientBoost;
            float _ShadowWrap;
            float _Visibility;
        CBUFFER_END

        // Shader Forge "Noise" node: UV is quantised into _steps cells, then a single
        // hash value is taken per cell. This hard cell structure is the needle breakup.
        float FoliageNoise(float2 uv, float steps)
        {
            float2 cell = floor(uv * steps) / max(steps - 1.0, 1.0);
            float2 skew = cell + 0.2127 + cell.x * 0.3713 * cell.y;
            float2 rnd = 4.789 * sin(489.123 * skew);
            return frac(rnd.x * rnd.y * (1.0 + skew.x));
        }

        // The original resolved the silhouette edge with a 3x3 ordered dither. That reads as
        // a visible screen-door grid once the camera sits close to the foliage, so coverage
        // is derived analytically and resolved by MSAA alpha-to-coverage instead: same soft
        // gradient, no repeating pattern.
        float FoliageCoverage(float mask)
        {
            float width = max(fwidth(mask), 1e-4);
            return saturate(mask / width + 0.5);
        }

        // Several meshes in the pack pack every card onto almost the same UV point, so the UV
        // grid produces one giant cell on them no matter how high the step count goes. Object
        // space voxel noise is independent of the UV layout and keeps detail on those cards.
        float FoliageNoiseObject(float3 positionOS)
        {
            float3 cell = floor(positionOS * _ObjectNoiseScale);
            return frac(sin(dot(cell, float3(127.1, 311.7, 74.7))) * 43758.5453);
        }

        float FoliageMask(float4 vtxColor, float2 uv, float3 positionOS)
        {
            float uvNoise = FoliageNoise(uv, _OpacityNoiseSteps);
            float objectNoise = FoliageNoiseObject(positionOS);
            float noise = lerp(uvNoise, objectNoise, _ObjectNoiseBlend);
            float sparse = (vtxColor.a * _VtxOpacity) * noise * _OpacityNoiseAmount;
            return lerp(sparse, _AllOpacity, vtxColor.a) - _Cutoff;
        }

        ENDHLSL

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            Cull Back
            ZWrite On
            ZTest LEqual
            AlphaToMask On

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                half4 color : TEXCOORD2;
                float2 uv : TEXCOORD3;
                half fogFactor : TEXCOORD4;
                float3 positionOS : TEXCOORD5;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                VertexPositionInputs positions = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = positions.positionCS;
                output.positionWS = positions.positionWS;
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.color = input.color;
                output.uv = input.uv;
                output.fogFactor = ComputeFogFactor(positions.positionCS.z);
                output.positionOS = input.positionOS.xyz;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float coverage = FoliageCoverage(FoliageMask(input.color, input.uv, input.positionOS)) * _Visibility;
                clip(coverage - 0.001);

                float3 normalWS = normalize(input.normalWS);

                float colorNoise = FoliageNoise(input.uv, _ColorNoiseSteps);
                half3 albedo = ((colorNoise * _NoiseColor.rgb * _BaseNoiseAmount) + _ColorBase.rgb)
                             * input.color.rgb * _VtxColorAmount * _Tint.rgb;

                float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                Light mainLight = GetMainLight(shadowCoord);

                half wrap = saturate(dot(normalWS, mainLight.direction) * (1.0 - _ShadowWrap) + _ShadowWrap);
                half3 lighting = mainLight.color
                               * (mainLight.distanceAttenuation * mainLight.shadowAttenuation)
                               * wrap;

                #ifdef _ADDITIONAL_LIGHTS
                uint lightCount = GetAdditionalLightsCount();
                for (uint i = 0u; i < lightCount; ++i)
                {
                    Light light = GetAdditionalLight(i, input.positionWS);
                    half nDotL = saturate(dot(normalWS, light.direction));
                    lighting += light.color * (light.distanceAttenuation * light.shadowAttenuation) * nDotL;
                }
                #endif

                half3 ambient = SampleSH(normalWS) * _AmbientBoost;
                half3 color = albedo * (lighting + ambient);
                color = MixFog(color, input.fogFactor);
                return half4(color, coverage);
            }
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            Cull Back
            ZWrite On
            ZTest LEqual
            ColorMask 0

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

            float3 _LightDirection;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half4 color : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 positionOS : TEXCOORD2;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                VertexPositionInputs positions = GetVertexPositionInputs(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.positionCS = TransformWorldToHClip(
                    ApplyShadowBias(positions.positionWS, normalWS, _LightDirection));
                #if UNITY_REVERSED_Z
                output.positionCS.z = min(output.positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                output.positionCS.z = max(output.positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif
                output.color = input.color;
                output.uv = input.uv;
                output.positionOS = input.positionOS.xyz;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                clip(FoliageMask(input.color, input.uv, input.positionOS));
                return 0;
            }
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }

            Cull Back
            ZWrite On
            ColorMask 0

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half4 color : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 positionOS : TEXCOORD2;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.color = input.color;
                output.uv = input.uv;
                output.positionOS = input.positionOS.xyz;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                clip(FoliageMask(input.color, input.uv, input.positionOS));
                return 0;
            }
            ENDHLSL
        }

        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }

            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS : TEXCOORD0;
                half4 color : TEXCOORD1;
                float2 uv : TEXCOORD2;
                float3 positionOS : TEXCOORD3;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.color = input.color;
                output.uv = input.uv;
                output.positionOS = input.positionOS.xyz;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                clip(FoliageMask(input.color, input.uv, input.positionOS));
                return half4(normalize(input.normalWS), 0);
            }
            ENDHLSL
        }
    }
    FallBack "Universal Render Pipeline/Lit"
}
