Shader "VampireDemo/SettlementFade/CTI/URP/CTI URP SG Leaves"
{
Properties { [HideInInspector]_SettlementSrcBlend("Fade Source", Float)=1 [HideInInspector]_SettlementDstBlend("Fade Destination", Float)=0 [HideInInspector]_SettlementZWrite("Fade Depth", Float)=1 _Visibility("Visibility", Range(0,1)) = 1
_HueVariation("Color Variation (RGB) Strength (A)", Color) = (0.9, 0.5, 0, 0.1019608)
[NoScaleOffset]_BaseMap("Albedo (RGB) Alpha (A)", 2D) = "white" {}
_Cutoff("-    Alpha Cutoff", Range(0, 1)) = 0.5
[NoScaleOffset]_BumpSpecMap("Normal (AG) Smoothness (B) Tranmission (R)", 2D) = "linearGrey" {}
_BumpScale("-    Normal Scale", Range(0, 4)) = 1
_Smoothness("-    Smoothness", Range(0, 1)) = 1
_BackFaceSmoothness("-    Back Face Smoothness", Range(0, 1)) = 1
_SpecColor("Specular", Color) = (0.2, 0.2, 0.2, 0)
_WindMultipliers("Wind: Main (X) Branch (Y) Flutter (Z)", Vector) = (1, 1, 1, 0)
[Toggle(_LEAFTUMBLING)]_LEAFTUMBLING("Enable Leaf Tumbling", Float) = 0
_TumbleStrength("-   Tumble Strength", Range(-1, 1)) = 0.01
_TumbleFrequency("-   Tumble Frequency", Range(0, 4)) = 1
[Toggle(_LEAFTURBULENCE)]_LEAFTURBULENCE("Enable Leaf Turbulence", Float) = 0
[Toggle(_BAKEDBRANCHAXIS)]_BAKEDBRANCHAXIS("-    Baked Branch Axis", Float) = 0
_LeafTurbulence("-    Leaf Turbulence", Range(0, 4)) = 0.2
_EdgeFlutterInfluence("-    Edge Flutter Influence", Range(0, 1)) = 0.25
[ToggleUI]_EnableNormalRotation("Enable Normal Rotation", Float) = 0
_LeafNoise("Leaf Noise", Float) = 0.1
[ToggleUI]_EnableAdvancedEdgeBending("Enable Advanced Edge Bending", Float) = 1
_AdvancedEdgeBending("-    Strenght (X) Frequency (Y)", Vector) = (0.1, 5, 0, 0)
_Translucency("Strength (X) Power (Y) Distortion (Z)", Vector) = (1, 8, 0.1, 0)
_AmbientTranslucency("Ambient Scattering", Range(0, 8)) = 1
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
"Queue"="AlphaTest"
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
Cull Off

Blend [_SettlementSrcBlend] [_SettlementDstBlend]
ZTest LEqual

ZWrite [_SettlementZWrite]

AlphaToMask Off

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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_POSITION_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TANGENT_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_SHADOW_COORD
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_CULLFACE
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 staticLightmapUV;
#endif
#endif
#if defined(DYNAMICLIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 dynamicLightmapUV;
#endif
#endif
#if !defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 sh;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 fogFactorAndVertexLight;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 shadowCoord;
#endif
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceBiTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 AbsoluteWorldSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float FaceSign;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 staticLightmapUV : INTERP0;
#endif
#endif
#if defined(DYNAMICLIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 dynamicLightmapUV : INTERP1;
#endif
#endif
#if !defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 sh : INTERP2;
#endif
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 shadowCoord : INTERP3;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS : INTERP4;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP5;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 fogFactorAndVertexLight : INTERP6;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_positionWS_CustomInterpolatorx : INTERP7;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_normalWS_CustomInterpolatory : INTERP8;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Lighting.hlsl"

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

void Unity_Branch_half(half Predicate, half True, half False, out half Out)
{
    Out = Predicate ? True : False;
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
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
half3 NormalWS;
half3 Emission;
half3 Specular;
half Smoothness;
half Occlusion;
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4 = _HueVariation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float = IN.CustomInterpolator[0];
half _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float = IN.CustomInterpolator[1];
half _Split_23b32f3fae454a089979ed1811e308a6_B_3_Float = 0;
half _Split_23b32f3fae454a089979ed1811e308a6_A_4_Float = 0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4, _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpSpecMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.tex, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.samplerstate, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.r;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_G_5_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.g;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.b;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_A_7_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float = _BumpScale;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean = max(0, IN.FaceSign.x);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3;
CTI_UnpackFixNormal_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4, _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float, ((half) _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean), _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3 = _Translucency;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
CTI_SimpleTranslucentLighting_half(IN.AbsoluteWorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3, _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3, _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3, _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float, _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_e0f7be9ef0b64d22a4c6507a6ccfa155_Out_0_Vector4 = _SpecColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_03697bc0c7e34dfeb2a6d57e4854770e_Out_0_Float = _BackFaceSmoothness;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float;
Unity_Branch_half(_IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean, half(1), _Property_03697bc0c7e34dfeb2a6d57e4854770e_Out_0_Float, _Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_bd3cabb84df14b349c71b071d9683691_Out_0_Float = _Smoothness;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float, _Property_bd3cabb84df14b349c71b071d9683691_Out_0_Float, _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float;
Unity_Multiply_half_half(_Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float, _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float, _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.BaseColor = _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
surface.NormalWS = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
surface.Emission = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
surface.Specular = (_Property_e0f7be9ef0b64d22a4c6507a6ccfa155_Out_0_Vector4.xyz);
surface.Smoothness = _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float;
surface.Occlusion = _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float;
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 unnormalizedNormalWS = input.normalWS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // use bitangent on the fly like in hdrp
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceBiTangent = renormFactor * bitang;
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
    #endif
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
    #endif
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
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
Cull Off
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_POSITION_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TANGENT_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_SHADOW_COORD
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_CULLFACE
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 staticLightmapUV;
#endif
#endif
#if defined(DYNAMICLIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 dynamicLightmapUV;
#endif
#endif
#if !defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 sh;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 fogFactorAndVertexLight;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 shadowCoord;
#endif
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceBiTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 AbsoluteWorldSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float FaceSign;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 staticLightmapUV : INTERP0;
#endif
#endif
#if defined(DYNAMICLIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 dynamicLightmapUV : INTERP1;
#endif
#endif
#if !defined(LIGHTMAP_ON)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 sh : INTERP2;
#endif
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 shadowCoord : INTERP3;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS : INTERP4;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP5;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 fogFactorAndVertexLight : INTERP6;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_positionWS_CustomInterpolatorx : INTERP7;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_normalWS_CustomInterpolatory : INTERP8;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Lighting.hlsl"

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

void Unity_Branch_half(half Predicate, half True, half False, out half Out)
{
    Out = Predicate ? True : False;
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
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
half3 NormalWS;
half3 Emission;
half3 Specular;
half Smoothness;
half Occlusion;
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4 = _HueVariation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float = IN.CustomInterpolator[0];
half _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float = IN.CustomInterpolator[1];
half _Split_23b32f3fae454a089979ed1811e308a6_B_3_Float = 0;
half _Split_23b32f3fae454a089979ed1811e308a6_A_4_Float = 0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4, _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpSpecMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.tex, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.samplerstate, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.r;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_G_5_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.g;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.b;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_A_7_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float = _BumpScale;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean = max(0, IN.FaceSign.x);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3;
CTI_UnpackFixNormal_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4, _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float, ((half) _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean), _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3 = _Translucency;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
CTI_SimpleTranslucentLighting_half(IN.AbsoluteWorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3, _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3, _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3, _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float, _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_e0f7be9ef0b64d22a4c6507a6ccfa155_Out_0_Vector4 = _SpecColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_03697bc0c7e34dfeb2a6d57e4854770e_Out_0_Float = _BackFaceSmoothness;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float;
Unity_Branch_half(_IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean, half(1), _Property_03697bc0c7e34dfeb2a6d57e4854770e_Out_0_Float, _Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_bd3cabb84df14b349c71b071d9683691_Out_0_Float = _Smoothness;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float;
Unity_Multiply_half_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float, _Property_bd3cabb84df14b349c71b071d9683691_Out_0_Float, _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float;
Unity_Multiply_half_half(_Branch_71ec1311fd394461b9cb0386916602b5_Out_3_Float, _Multiply_eb5c2a7027874fe5af3a70001e97f166_Out_2_Float, _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.BaseColor = _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
surface.NormalWS = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
surface.Emission = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
surface.Specular = (_Property_e0f7be9ef0b64d22a4c6507a6ccfa155_Out_0_Vector4.xyz);
surface.Smoothness = _Multiply_6a83f3e6073d4860b0bc7bdb90bba8cf_Out_2_Float;
surface.Occlusion = _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float;
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 unnormalizedNormalWS = input.normalWS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // use bitangent on the fly like in hdrp
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceBiTangent = renormFactor * bitang;
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
    #endif
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
    #endif
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
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
Cull Off
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER
#define _ALPHATEST_ON 1
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS : INTERP1;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
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
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
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
Cull Off
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define _ALPHATEST_ON 1
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
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
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
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
Cull Off
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_POSITION_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TANGENT_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_CULLFACE
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALS
#define _ALPHATEST_ON 1
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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceBiTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 AbsoluteWorldSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float FaceSign;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS : INTERP0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_positionWS_CustomInterpolatorx : INTERP2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_normalWS_CustomInterpolatory : INTERP3;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
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
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Lighting.hlsl"

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
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
half3 NormalWS;
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4 = _HueVariation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float = IN.CustomInterpolator[0];
half _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float = IN.CustomInterpolator[1];
half _Split_23b32f3fae454a089979ed1811e308a6_B_3_Float = 0;
half _Split_23b32f3fae454a089979ed1811e308a6_A_4_Float = 0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4, _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpSpecMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.tex, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.samplerstate, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.r;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_G_5_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.g;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.b;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_A_7_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float = _BumpScale;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean = max(0, IN.FaceSign.x);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3;
CTI_UnpackFixNormal_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4, _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float, ((half) _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean), _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3 = _Translucency;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
CTI_SimpleTranslucentLighting_half(IN.AbsoluteWorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3, _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3, _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3, _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float, _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.NormalWS = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 unnormalizedNormalWS = input.normalWS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // use bitangent on the fly like in hdrp
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceBiTangent = renormFactor * bitang;
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
    #endif
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
    #endif
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_POSITION_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_NORMAL_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TANGENT_WS
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_CULLFACE
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1


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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord2;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 WorldSpaceBiTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 AbsoluteWorldSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float FaceSign;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentWS : INTERP0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord1 : INTERP2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord2 : INTERP3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_positionWS_CustomInterpolatorx : INTERP4;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 packed_normalWS_CustomInterpolatory : INTERP5;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
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
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

// Graph Includes
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Wind.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Utils.hlsl"
#include "Assets/Forst/CTI Runtime Components/CTI Runtime Components URP 14plus/Shaders/Includes/CTI URP SG Lighting.hlsl"

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
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
half3 Emission;
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4 = _HueVariation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float = IN.CustomInterpolator[0];
half _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float = IN.CustomInterpolator[1];
half _Split_23b32f3fae454a089979ed1811e308a6_B_3_Float = 0;
half _Split_23b32f3fae454a089979ed1811e308a6_A_4_Float = 0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4, _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BumpSpecMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.tex, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.samplerstate, _Property_4242367ce3db4a06a763eab15a0822ab_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.r;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_G_5_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.g;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_B_6_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.b;
half _SampleTexture2D_feb02b8834bd49e685eca75adb577133_A_7_Float = _SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float = _BumpScale;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean = max(0, IN.FaceSign.x);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3;
CTI_UnpackFixNormal_half(_SampleTexture2D_feb02b8834bd49e685eca75adb577133_RGBA_0_Vector4, _Property_cb1937d1605c4dd582b575c5c7c8529f_Out_0_Float, ((half) _IsFrontFace_244a9cd9cada45c6becb56f3a391041e_Out_0_Boolean), _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3 = _Translucency;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3;
half3 _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
CTI_SimpleTranslucentLighting_half(IN.AbsoluteWorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3, _CTIUnpackFixNormalCustomFunction_d9bf2c4c02b348f690808dec2abcf85e_oNormalTS_2_Vector3, _Property_0773204e62b344168998cb8f3266e6a5_Out_0_Vector3, _SampleTexture2D_feb02b8834bd49e685eca75adb577133_R_4_Float, _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oNormalWS_6_Vector3, _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.BaseColor = _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
surface.Emission = _CTISimpleTranslucentLightingCustomFunction_7ef90e979a0b453aa7916ab5c9f09d1e_oTransmission_7_Vector3;
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 unnormalizedNormalWS = input.normalWS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // use bitangent on the fly like in hdrp
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.WorldSpaceBiTangent = renormFactor * bitang;
    #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
    #endif
    
    
        #if UNITY_UV_STARTS_AT_TOP
        #else
        #endif
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
    #endif
    
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1


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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
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
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1


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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
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
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
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
Cull Off
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
#pragma shader_feature_local_vertex _ _LEAFTUMBLING
#pragma shader_feature_local_vertex _ _LEAFTURBULENCE
#pragma shader_feature_local_vertex _ _BAKEDBRANCHAXIS

#if defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_0
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_1
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_2
#elif defined(_LEAFTUMBLING) && defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_3
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_4
#elif defined(_LEAFTUMBLING) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_5
#elif defined(_LEAFTUMBLING) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_6
#elif defined(_LEAFTUMBLING)
#define KEYWORD_PERMUTATION_7
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_8
#elif defined(_LEAFTURBULENCE) && defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_9
#elif defined(_LEAFTURBULENCE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_10
#elif defined(_LEAFTURBULENCE)
#define KEYWORD_PERMUTATION_11
#elif defined(LOD_FADE_CROSSFADE) && defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_12
#elif defined(LOD_FADE_CROSSFADE)
#define KEYWORD_PERMUTATION_13
#elif defined(_BAKEDBRANCHAXIS)
#define KEYWORD_PERMUTATION_14
#else
#define KEYWORD_PERMUTATION_15
#endif


// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMALMAP 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define _NORMAL_DROPOFF_WS 1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_TEXCOORD2
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define ATTRIBUTES_NEED_COLOR
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
#define VARYINGS_NEED_TEXCOORD0
#endif

#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_2D
#define _ALPHATEST_ON 1


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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2 : TEXCOORD2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
};
struct Varyings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct SurfaceDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator;
#endif
};
struct VertexDescriptionInputs
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceNormal;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpaceTangent;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 ObjectSpacePosition;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float3 TimeParameters;
#endif
};
struct PackedVaryings
{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float4 texCoord0 : INTERP0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 float2 CustomInterpolator : INTERP1;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
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
#endif

// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _EnableAdvancedEdgeBending;
half4 _HueVariation;
float4 _BaseMap_TexelSize;
float4 _BumpSpecMap_TexelSize;
float3 _WindMultipliers;
float _TumbleStrength;
float _TumbleFrequency;
float _LeafTurbulence;
float _EdgeFlutterInfluence;
half3 _Translucency;
half4 _SpecColor;
half _BumpScale;
half _Cutoff;
half _Smoothness;
half _BackFaceSmoothness;
float2 _AdvancedEdgeBending;
half _AmbientTranslucency;
float _EnableNormalRotation;
float _LeafNoise;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
TEXTURE2D(_BumpSpecMap);
SAMPLER(sampler_BumpSpecMap);

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
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _UV_77f387431f594193a17559adf992ae32_Out_0_Vector4 = IN.uv2;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float = _LeafNoise;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3 = _WindMultipliers;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean = _EnableNormalRotation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean = _EnableAdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float2 _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2 = _AdvancedEdgeBending;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float4 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4;
float3 _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3;
float2 _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2;
Unity_Combine_float(IN.TimeParameters.x, IN.TimeParameters.y, IN.TimeParameters.z, float(0), _Combine_7386a9a200a340ca970b2a35a4756eb3_RGBA_4_Vector4, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, _Combine_7386a9a200a340ca970b2a35a4756eb3_RG_6_Vector2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
float3 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
float2 _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
CTI_AnimateVertexSG_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, IN.VertexColor, (_UV_fb5e5feb58154de6b632709ad291ea1f_Out_0_Vector4.xy), (_UV_77f387431f594193a17559adf992ae32_Out_0_Vector4.xyz), _Property_d3eb256e8aa74a8ca4549af5e351f055_Out_0_Float, _Property_ed3f87ec8a6e461e8548f5cd696b3fa0_Out_0_Vector3, _Property_b2a61d67b9214c07ba65e680db4fdcc1_Out_0_Boolean, _Property_980297565a424e55aba5ea2a34bd6341_Out_0_Boolean, _Property_facc59513eab4249b94e87a549201564_Out_0_Vector2, _Combine_7386a9a200a340ca970b2a35a4756eb3_RGB_5_Vector3, 1, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3, _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2);
#endif
description.Position = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oPositionOS_6_Vector3;
description.Normal = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oNormalOS_7_Vector3;
description.Tangent = IN.ObjectSpaceTangent;
description.CustomInterpolator = _CTIAnimateVertexSGCustomFunction_1a7783c69af64d83a62cba24e164463e_oColorvarOcclusion_8_Vector2;
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
half Alpha;
half AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
UnityTexture2D _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMap);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.tex, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.samplerstate, _Property_bb3505150fcf458e8533fde167d667ea_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_R_4_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.r;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_G_5_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.g;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_B_6_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.b;
half _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half4 _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4 = _HueVariation;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float = IN.CustomInterpolator[0];
half _Split_23b32f3fae454a089979ed1811e308a6_G_2_Float = IN.CustomInterpolator[1];
half _Split_23b32f3fae454a089979ed1811e308a6_B_3_Float = 0;
half _Split_23b32f3fae454a089979ed1811e308a6_A_4_Float = 0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half3 _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
CTI_ColorVariation_half((_SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_RGBA_0_Vector4.xyz), _Property_8754a8ae700645d4a0b2cadd41eea67c_Out_0_Vector4, _Split_23b32f3fae454a089979ed1811e308a6_R_1_Float, _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
half _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float = _Cutoff;
#endif
surface.BaseColor = _CTIColorVariationCustomFunction_ffd467be0f07405691d40b25ab6ae86d_oAlbedo_3_Vector3;
surface.Alpha = _SampleTexture2D_c2038867d8cc4de18713266a1464e2d4_A_7_Float;
surface.AlphaClipThreshold = _Property_f6cb49e7cd104ecda13fc55373e6ef93_Out_0_Float;
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
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceNormal =                          input.normalOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.ObjectSpacePosition =                        input.positionOS;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv1 =                                        input.uv1;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv2 =                                        input.uv2;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.VertexColor =                                input.color;
    #endif
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.TimeParameters =                             _TimeParameters.xyz;
    #endif
    
    
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
    
    
    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15)
    output.uv0 = input.texCoord0;
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