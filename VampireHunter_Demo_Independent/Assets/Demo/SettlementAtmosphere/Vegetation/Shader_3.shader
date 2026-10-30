Shader "VampireDemo/SettlementFade/CTI/URP/CTI URP SG Bark"
{
Properties { [HideInInspector]_SettlementSrcBlend("Fade Source", Float)=1 [HideInInspector]_SettlementDstBlend("Fade Destination", Float)=0 [HideInInspector]_SettlementZWrite("Fade Depth", Float)=1 _Visibility("Visibility", Range(0,1)) = 1
_HueVariation("Color Variation", Color) = (0.9, 0.5, 0, 0.1019608)
[NoScaleOffset]_BaseMap("Albedo (RGB) Smoothness (A)", 2D) = "white" {}
_Smoothness("-    Smoothness", Range(0, 1)) = 1
[NoScaleOffset]_BumpOcclusionMap("Normal (AG) Occlusion (B)", 2D) = "linearGrey" {}
_BumpScale("-    Normal Scale", Range(0, 4)) = 1
_SpecColor("Specular", Color) = (0.2, 0.2, 0.2, 0)
_BaseWindMultipliers("Main (X) Branch (Y) Flutter (Z)", Vector) = (1, 1, 1, 0)
[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
[HideInInspector]_QueueControl("_QueueControl", Float) = -1
[HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
[HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
[HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
}
SubShader
{
Tags
{
"RenderPipeline"="UniversalPipeline"
"RenderType"="Opaque"
"UniversalMaterialType" = "Lit"
"Queue"="Geometry"
"DisableBatching"="LODFading"
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalLitSubTarget"
}
Pass
{
    Name "Universal Forward"
    Tags
    {
        "LightMode" = "UniversalForward"
    }

// Render State
Cull Back

Blend [_SettlementSrcBlend] [_SettlementDstBlend]
ZTest LEqual

ZWrite [_SettlementZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma multi_compile_fog
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _LIGHT_LAYERS
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _LIGHT_COOKIES
#pragma multi_compile _ _FORWARD_PLUS
#pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
#pragma multi_compile _ LOD_FADE_CROSSFADE
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD
#define _FOG_FRAGMENT 1
#define _SPECULAR_SETUP 1
#define USE_UNITY_CROSSFADE 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
 float2 CustomInterpolator;
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float2 CustomInterpolator;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV : INTERP0;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV : INTERP1;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP2;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord : INTERP3;
#endif
 float4 tangentWS : INTERP4;
 float4 texCoord0 : INTERP5;
 float4 fogFactorAndVertexLight : INTERP6;
 float4 packed_positionWS_CustomInterpolatorx : INTERP7;
 float4 packed_normalWS_CustomInterpolatory : INTERP8;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.packed_positionWS_CustomInterpolatorx.xyz = input.positionWS;
output.packed_positionWS_CustomInterpolatorx.w = input.CustomInterpolator.x;
output.packed_normalWS_CustomInterpolatory.xyz = input.normalWS;
output.packed_normalWS_CustomInterpolatory.w = input.CustomInterpolator.y;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.positionWS = input.packed_positionWS_CustomInterpolatorx.xyz;
output.CustomInterpolator.x = input.packed_positionWS_CustomInterpolatorx.w;
output.normalWS = input.packed_normalWS_CustomInterpolatory.xyz;
output.CustomInterpolator.y = input.packed_normalWS_CustomInterpolatory.w;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_Multiply_half_half(half A, half B, out half Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
half2 CustomInterpolator;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
output.CustomInterpolator = input.CustomInterpolator;
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
half3 BaseColor;
half3 NormalTS;
float3 Emission;
half3 Specular;
half Smoothness;
half Occlusion;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
half4 _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4 = _HueVariation;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float = IN.CustomInterpolator[0];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float = IN.CustomInterpolator[1];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_B_3_Float = 0;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_A_4_Float = 0;
half3 _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float, _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3);
UnityTexture2D _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpOcclusionMap);
half4 _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.tex, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.samplerstate, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_R_4_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.r;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_G_5_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.g;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_B_6_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.b;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_A_7_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.a;
half _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float = _BumpScale;
half3 _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
CTI_UnpackNormal_half(_SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4, _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float, _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3);
half4 _Property_99923200f8f049bfa77aa3f0a20327d1_Out_0_Vector4 = _SpecColor;
half _Property_23ed2775da13411d87351f12ece9be43_Out_0_Float = _Smoothness;
half _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float, _Property_23ed2775da13411d87351f12ece9be43_Out_0_Float, _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float);
half _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_B_6_Float, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float, _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float);
surface.BaseColor = _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
surface.NormalTS = _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
surface.Emission = float3(0, 0, 0);
surface.Specular = (_Property_99923200f8f049bfa77aa3f0a20327d1_Out_0_Vector4.xyz);
surface.Smoothness = _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float;
surface.Occlusion = _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        output.CustomInterpolator = input.CustomInterpolator;
    
    
    
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
        output.uv0 = input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_PBRForwardPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "GBuffer"
    Tags
    {
        "LightMode" = "UniversalGBuffer"
    }

// Render State
Cull Back
Blend One Zero
ZTest LEqual
ZWrite On

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma exclude_renderers gles gles3 glcore
#pragma multi_compile_instancing
#pragma multi_compile_fog
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile _ LOD_FADE_CROSSFADE
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER
#define _FOG_FRAGMENT 1
#define _SPECULAR_SETUP 1
#define USE_UNITY_CROSSFADE 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
 float2 CustomInterpolator;
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float2 CustomInterpolator;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV : INTERP0;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV : INTERP1;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP2;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord : INTERP3;
#endif
 float4 tangentWS : INTERP4;
 float4 texCoord0 : INTERP5;
 float4 fogFactorAndVertexLight : INTERP6;
 float4 packed_positionWS_CustomInterpolatorx : INTERP7;
 float4 packed_normalWS_CustomInterpolatory : INTERP8;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.packed_positionWS_CustomInterpolatorx.xyz = input.positionWS;
output.packed_positionWS_CustomInterpolatorx.w = input.CustomInterpolator.x;
output.packed_normalWS_CustomInterpolatory.xyz = input.normalWS;
output.packed_normalWS_CustomInterpolatory.w = input.CustomInterpolator.y;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.positionWS = input.packed_positionWS_CustomInterpolatorx.xyz;
output.CustomInterpolator.x = input.packed_positionWS_CustomInterpolatorx.w;
output.normalWS = input.packed_normalWS_CustomInterpolatory.xyz;
output.CustomInterpolator.y = input.packed_normalWS_CustomInterpolatory.w;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_Multiply_half_half(half A, half B, out half Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
half2 CustomInterpolator;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
output.CustomInterpolator = input.CustomInterpolator;
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
half3 BaseColor;
half3 NormalTS;
float3 Emission;
half3 Specular;
half Smoothness;
half Occlusion;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
half4 _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4 = _HueVariation;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float = IN.CustomInterpolator[0];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float = IN.CustomInterpolator[1];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_B_3_Float = 0;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_A_4_Float = 0;
half3 _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float, _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3);
UnityTexture2D _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpOcclusionMap);
half4 _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.tex, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.samplerstate, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_R_4_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.r;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_G_5_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.g;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_B_6_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.b;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_A_7_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.a;
half _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float = _BumpScale;
half3 _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
CTI_UnpackNormal_half(_SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4, _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float, _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3);
half4 _Property_99923200f8f049bfa77aa3f0a20327d1_Out_0_Vector4 = _SpecColor;
half _Property_23ed2775da13411d87351f12ece9be43_Out_0_Float = _Smoothness;
half _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float, _Property_23ed2775da13411d87351f12ece9be43_Out_0_Float, _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float);
half _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_B_6_Float, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float, _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float);
surface.BaseColor = _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
surface.NormalTS = _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
surface.Emission = float3(0, 0, 0);
surface.Specular = (_Property_99923200f8f049bfa77aa3f0a20327d1_Out_0_Vector4.xyz);
surface.Smoothness = _Multiply_3d35fd9ee2254f79a9e9dc22aafc0ab7_Out_2_Float;
surface.Occlusion = _Multiply_cd109833ed66493faf018e48f11a3d97_Out_2_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        output.CustomInterpolator = input.CustomInterpolator;
    
    
    
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
        output.uv0 = input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_PBRGBufferPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

// Render State
Cull Back
ZTest LEqual
ZWrite On
ColorMask 0

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
#pragma multi_compile _ LOD_FADE_CROSSFADE
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_NORMAL_WS
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER
#define USE_UNITY_CROSSFADE 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

// Render State
Cull Back
ZTest LEqual
ZWrite On
ColorMask R

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ LOD_FADE_CROSSFADE
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define USE_UNITY_CROSSFADE 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_DepthOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

// Render State
Cull Back
ZTest LEqual
ZWrite On

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ LOD_FADE_CROSSFADE
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALS
#define USE_UNITY_CROSSFADE 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 tangentWS : INTERP0;
 float4 texCoord0 : INTERP1;
 float3 normalWS : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
half3 NormalTS;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpOcclusionMap);
half4 _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.tex, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.samplerstate, _Property_48ff5f82473140b9a2a6fa934d3c3419_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_R_4_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.r;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_G_5_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.g;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_B_6_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.b;
half _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_A_7_Float = _SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4.a;
half _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float = _BumpScale;
half3 _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
CTI_UnpackNormal_half(_SampleTexture2D_4ce90e5ccc574e08b6f79f5e435ae7ce_RGBA_0_Vector4, _Property_b1d4ad15cf224e2cbe61b659c7b409bb_Out_0_Float, _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3);
surface.NormalTS = _CTIUnpackNormalCustomFunction_3dfc6612969d4cb58947a525bf2b86d0_oNormalTS_2_Vector3;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        
    
    
    
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
        output.uv0 = input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_DepthNormalsOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "Meta"
    Tags
    {
        "LightMode" = "Meta"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature _ EDITOR_VISUALIZATION
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define _FOG_FRAGMENT 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
 float2 CustomInterpolator;
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float2 CustomInterpolator;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 texCoord2 : INTERP2;
 float2 CustomInterpolator : INTERP3;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.CustomInterpolator.xy = input.CustomInterpolator;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.CustomInterpolator = input.CustomInterpolator.xy;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
half2 CustomInterpolator;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
output.CustomInterpolator = input.CustomInterpolator;
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
half3 BaseColor;
float3 Emission;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
half4 _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4 = _HueVariation;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float = IN.CustomInterpolator[0];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float = IN.CustomInterpolator[1];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_B_3_Float = 0;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_A_4_Float = 0;
half3 _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float, _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3);
surface.BaseColor = _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
surface.Emission = float3(0, 0, 0);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        output.CustomInterpolator = input.CustomInterpolator;
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
        output.uv0 = input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
// PassKeywords: <None>
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull Back

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
// PassKeywords: <None>
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "Universal 2D"
    Tags
    {
        "LightMode" = "Universal2D"
    }

// Render State
Cull Back
Blend One Zero
ZTest LEqual
ZWrite On

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
// PassKeywords: <None>
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_2D


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
 float2 CustomInterpolator;
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float2 CustomInterpolator;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 WorldSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
 float4 uv1;
 float4 uv2;
 float4 VertexColor;
 float3 TimeParameters;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float2 CustomInterpolator : INTERP1;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.CustomInterpolator.xy = input.CustomInterpolator;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.CustomInterpolator = input.CustomInterpolator.xy;
#if UNITY_ANY_INSTANCING_ENABLED
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpOcclusionMap_TexelSize;
float3 _BaseWindMultipliers;
half _BumpScale;
half4 _SpecColor;
half _Smoothness;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpOcclusionMap);
SAMPLER(sampler_BumpOcclusionMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
half2 CustomInterpolator;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _BaseWindMultipliers;
float4 _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4;
float3 _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3;
float2 _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGBA_4_Vector4, _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, _Combine_a1227c783b854c3495ba2fc6412ab419_RG_6_Vector2);
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.WorldSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), float(0), _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, 0, 0, float2 (0, 0), _Combine_a1227c783b854c3495ba2fc6412ab419_RGB_5_Vector3, 0, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2);
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvariation_8_Vector2;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
output.CustomInterpolator = input.CustomInterpolator;
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
half3 BaseColor;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
half4 _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4 = _HueVariation;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float = IN.CustomInterpolator[0];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_G_2_Float = IN.CustomInterpolator[1];
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_B_3_Float = 0;
half _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_A_4_Float = 0;
half3 _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_2a487807fd6d4ac5987c65d7c0496fa1_Out_0_Vector4, _Split_6e0ccfc8667043ba9c2afafc6bcf0aa0_R_1_Float, _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3);
surface.BaseColor = _CTIColorVariationCustomFunction_47a387b46d0e4defad7dc04684e5384a_oAlbedo_3_Vector3;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
    {
        VertexDescriptionInputs output;
        ZERO_INITIALIZE(VertexDescriptionInputs, output);
    
        output.ObjectSpaceNormal =                          input.normalOS;
        output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        output.ObjectSpacePosition =                        input.positionOS;
        output.uv1 =                                        input.uv1;
        output.uv2 =                                        input.uv2;
        output.VertexColor =                                input.color;
        output.TimeParameters =                             _TimeParameters.xyz;
    
        return output;
    }
    
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
    
    #ifdef HAVE_VFX_MODIFICATION
    #if VFX_USE_GRAPH_VALUES
        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
    #endif
        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
    
    #endif
    
        output.CustomInterpolator = input.CustomInterpolator;
    
    
    
    
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
        output.uv0 = input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    
            return output;
    }
    

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/Demo/SettlementAtmosphere/Vegetation/Packages_com.unity.render-pipelines.universal_Editor_ShaderGraph_Includes_PBR2DPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
}
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
FallBack "Hidden/Shader Graph/FallbackError"
}