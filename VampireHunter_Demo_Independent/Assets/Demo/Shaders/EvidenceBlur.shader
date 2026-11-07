Shader "Hidden/Demo/EvidenceBlur"
{
 Properties { _MainTex("Texture", 2D) = "white" {} }
 SubShader {
  Tags { "RenderType"="Opaque" }
  Pass {
   ZTest Always Cull Off ZWrite Off
   CGPROGRAM
   #pragma vertex vert_img
   #pragma fragment frag
   #include "UnityCG.cginc"
   sampler2D _MainTex;
   float4 _MainTex_TexelSize;
   fixed4 frag(v2f_img i) : SV_Target
   {
    float2 d = _MainTex_TexelSize.xy * 2.5;
    fixed4 c = tex2D(_MainTex,i.uv)*.25;
    c += (tex2D(_MainTex,i.uv+float2(d.x,0))+tex2D(_MainTex,i.uv-float2(d.x,0))+tex2D(_MainTex,i.uv+float2(0,d.y))+tex2D(_MainTex,i.uv-float2(0,d.y)))*.125;
    c += (tex2D(_MainTex,i.uv+d)+tex2D(_MainTex,i.uv-d)+tex2D(_MainTex,i.uv+float2(d.x,-d.y))+tex2D(_MainTex,i.uv+float2(-d.x,d.y)))*.0625;
    return c;
   }
   ENDCG
  }
 }
}
