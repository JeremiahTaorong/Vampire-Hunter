using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEngine;
using UnityEngine.Rendering;

namespace AkiDevCat.MicroAVL.Editor
{
    public class MicroAVLMaterialEditor : ShaderGUI
    {
        private enum BlendMode { Additive, Premultiply }
        
        private const string AssetStoreURL = "https://assetstore.unity.com/packages/vfx/shaders/fullscreen-camera-effects/analytical-volumetric-lighting-urp-performant-raytraced-volumetr-266586";
        
        private MaterialProperty _colorProperty;
        private MaterialProperty _intensityProperty;
        private MaterialProperty _scatteringProperty;
        private MaterialProperty _rampPowerProperty;
        private MaterialProperty _enableHDRCorrectionProperty;

        private bool _lightPropertiesFoldout = true;
        private bool _blendPropertiesFoldout = true;
        private bool _renderPropertiesFoldout = true;
        
        private void FindProperties(MaterialProperty[] properties)
        {
            _colorProperty = FindProperty("_Color", properties);
            _intensityProperty = FindProperty("_Intensity", properties);
            _scatteringProperty = FindProperty("_Scattering", properties);
            _rampPowerProperty = FindProperty("_RampPower", properties);
        }
        
        public override void OnGUI (MaterialEditor materialEditorIn, MaterialProperty[] properties)
        {
            var material = (Material)materialEditorIn.target;
            FindProperties(properties);
            
            var style = new GUIStyle("AM MixerHeader")
            {
                alignment = TextAnchor.MiddleCenter
            };
        
            EditorGUILayout.Space(15.0f);
            EditorGUILayout.LabelField("MicroAVL Point Light", new GUIStyle(style));
            EditorGUILayout.Space(15.0f);
            
            
            
            
            
        
            if (((Material)materialEditorIn.target).name == "M_DefaultLight")
            {
                GUI.enabled = false;
            }
            
            _lightPropertiesFoldout = CoreEditorUtils.DrawHeaderFoldout("Light Properties", _lightPropertiesFoldout);
            if (_lightPropertiesFoldout)
            {
                EditorGUI.indentLevel++;
                DrawSurfaceInputs(material, materialEditorIn);
                EditorGUI.indentLevel--;
            }
            
            EditorGUILayout.Space(5.0f);
            
            _blendPropertiesFoldout = CoreEditorUtils.DrawHeaderFoldout("Blend Properties", _blendPropertiesFoldout);
            if (_blendPropertiesFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUI.BeginChangeCheck();

                var mode = material.shader.name switch
                {
                    "Shader Graphs/MicroAVL_OmniLight_Additive" => BlendMode.Additive,
                    "Shader Graphs/MicroAVL_OmniLight_Premultiply" => BlendMode.Premultiply,
                    _ => BlendMode.Additive
                };

                mode = (BlendMode)EditorGUILayout.EnumPopup("Blend Mode", mode);
                
                if (EditorGUI.EndChangeCheck())
                {
                    var newShader = Shader.Find(mode switch
                    {
                        BlendMode.Additive => "Shader Graphs/MicroAVL_OmniLight_Additive",
                        BlendMode.Premultiply => "Shader Graphs/MicroAVL_OmniLight_Premultiply",
                        _ => "Shader Graphs/MicroAVL_OmniLight_Additive"
                    });
                    if (newShader)
                    {
                        materialEditorIn.SetShader(newShader, true);
                    }
                }

                if (mode == BlendMode.Premultiply)
                {
                    EditorGUILayout.HelpBox("Premultiply light sources might conflict when intersecting each other.", MessageType.Info);
                }
                
                EditorGUI.indentLevel--;
            }
            
            EditorGUILayout.Space(5.0f);
            
            _renderPropertiesFoldout = CoreEditorUtils.DrawHeaderFoldout("Render Properties", _renderPropertiesFoldout);
            if (_renderPropertiesFoldout)
            {
                EditorGUI.indentLevel++;
                materialEditorIn.EnableInstancingField();
                if (SupportedRenderingFeatures.active.editableMaterialRenderQueue)
                    materialEditorIn.RenderQueueField();
                EditorGUI.indentLevel--;
            }
        
            if (!GUI.enabled)
            {
                GUI.enabled = true;
                EditorGUILayout.Space(15.0f);
                EditorGUILayout.LabelField("Default Material Editing is Disabled", new GUIStyle("BoldLabel") { alignment = TextAnchor.MiddleCenter});
            }
            
            EditorGUILayout.Space(10.0f);
            var rect = EditorGUILayout.GetControlRect(false, 300);
            rect.min -= new Vector2(15, 0);
            materialEditorIn.DrawPreview(rect);
            
            EditorGUILayout.Space(5.0f);
            
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (EditorGUILayout.LinkButton("Check out our full Analytical Volumetric"))
            {
                Application.OpenURL(AssetStoreURL);
            }
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (EditorGUILayout.LinkButton("Lighting package on the Asset Store"))
            {
                Application.OpenURL(AssetStoreURL);
            }
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            
            EditorGUILayout.Space(5.0f);
        }
        
        // public override void DrawSurfaceOptions(Material material)
        // {
        //     // DoPopup(Styles.surfaceType, surfaceTypeProp, Styles.surfaceTypeNames);
        //     surfaceTypeProp.floatValue = (float)SurfaceType.Transparent;
        //     if ((surfaceTypeProp != null) && ((SurfaceType)surfaceTypeProp.floatValue == SurfaceType.Transparent))
        //         DoPopup(Styles.blendingMode, blendModeProp, Styles.blendModeNames);
        //
        //     cullingProp.floatValue = (float)RenderFace.Back;
        //     zwriteProp.floatValue = 2.0f; // Internal enum - ForceDisabled, cannot access here
        //     ztestProp.floatValue = 8.0f; // Internal enum - Always
        //     castShadowsProp.floatValue = 0;
        //
        //     // DoPopup(Styles.cullingText, cullingProp, Styles.renderFaceNames);
        //     DoPopup(Styles.zwriteText, zwriteProp, Styles.zwriteNames);
        //
        //     if (ztestProp != null)
        //         materialEditor.IntPopupShaderProperty(ztestProp, Styles.ztestText.text, Styles.ztestNames, Styles.ztestValues);
        //
        //     DrawFloatToggleProperty(Styles.alphaClipText, alphaClipProp);
        //
        //     if ((alphaClipProp != null) && (alphaCutoffProp != null) && (alphaClipProp.floatValue == 1))
        //         materialEditor.ShaderProperty(alphaCutoffProp, Styles.alphaClipThresholdText, 1);
        //
        //     DrawFloatToggleProperty(Styles.castShadowText, castShadowsProp);
        //     DrawFloatToggleProperty(Styles.receiveShadowText, receiveShadowsProp);
        // }
        
        private void DrawSurfaceInputs(Material material, MaterialEditor materialEditor)
        {
            // EditorGUILayout.LabelField("Light Properties", new GUIStyle("BoldLabel"));
            materialEditor.ColorProperty(_colorProperty, "Color");
            materialEditor.FloatProperty(_intensityProperty, "Intensity");
            if (_intensityProperty.floatValue < 0)
                _intensityProperty.floatValue = 0;
            materialEditor.FloatProperty(_scatteringProperty, "Scattering");
            if (_scatteringProperty.floatValue < 0)
                _scatteringProperty.floatValue = 0;
            materialEditor.FloatProperty(_rampPowerProperty, "Ramp Power");
            if (_scatteringProperty.floatValue < 0)
                _scatteringProperty.floatValue = 0;
        
            DrawKeywordProperty(new GUIContent("Enable HDR Correction"), "_ENABLE_HDR_CORRECTION", material);
            // material.IsKeywordEnabled("_ENABLE_HDR_CORRECTION");
            // materialEditor.ShaderProperty(, );
        }
        
        private static void DrawFloatToggleProperty(GUIContent styles, MaterialProperty prop)
        {
            if (prop == null)
                return;
        
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            bool newValue = EditorGUILayout.Toggle(styles, prop.floatValue == 1);
            if (EditorGUI.EndChangeCheck())
                prop.floatValue = newValue ? 1.0f : 0.0f;
            EditorGUI.showMixedValue = false;
        }
        
        private static void DrawKeywordProperty(GUIContent styles, string keywordName, Material material)
        {
            EditorGUI.BeginChangeCheck();
            bool newValue = EditorGUILayout.Toggle(styles, material.IsKeywordEnabled(keywordName));
            if (EditorGUI.EndChangeCheck())
            {
                if (newValue)
                    material.EnableKeyword(keywordName);
                else
                    material.DisableKeyword(keywordName);
            }
        }
    }
}