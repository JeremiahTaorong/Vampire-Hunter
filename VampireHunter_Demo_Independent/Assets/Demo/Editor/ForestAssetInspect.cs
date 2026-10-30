using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

public static class ForestAssetInspect {
 const string Fbx = "Assets/AssetPacks/Pine Forest_LowPoly/Mesh/Pine Forest_LowPoly.fbx";

 public static void Run() {
  var sb = new StringBuilder();
  var all = AssetDatabase.LoadAllAssetsAtPath(Fbx);
  sb.AppendLine("FBX=" + Fbx);
  sb.AppendLine("assets=" + all.Length);
  foreach (var o in all) {
   var m = o as Mesh;
   if (m == null) continue;
   sb.AppendLine();
   sb.AppendLine("MESH " + m.name + " verts=" + m.vertexCount + " tris=" + (m.triangles.Length / 3));
   sb.AppendLine("  bounds=" + m.bounds.size.ToString("F3") + " center=" + m.bounds.center.ToString("F3"));
   var uv = m.uv; var col = m.colors32;
   sb.AppendLine("  hasUV0=" + (uv != null && uv.Length > 0) + " hasColor=" + (col != null && col.Length > 0));
   if (uv != null && uv.Length > 0) {
    float ux0 = float.MaxValue, ux1 = float.MinValue, uy0 = float.MaxValue, uy1 = float.MinValue;
    foreach (var t in uv) { ux0 = Mathf.Min(ux0, t.x); ux1 = Mathf.Max(ux1, t.x); uy0 = Mathf.Min(uy0, t.y); uy1 = Mathf.Max(uy1, t.y); }
    sb.AppendLine("  uv0 range u=" + ux0.ToString("F4") + ".." + ux1.ToString("F4") + " v=" + uy0.ToString("F4") + ".." + uy1.ToString("F4"));
    var distinct = new HashSet<Vector2>(uv);
    sb.AppendLine("  uv0 distinct=" + distinct.Count);
   }
   if (col != null && col.Length > 0) {
    int[] hist = new int[11];
    double sA = 0, sR = 0, sG = 0, sB = 0;
    int minA = 255, maxA = 0;
    foreach (var c in col) {
     int b = Mathf.Clamp(c.a * 10 / 255, 0, 10); hist[b]++;
     sA += c.a; sR += c.r; sG += c.g; sB += c.b;
     minA = Mathf.Min(minA, c.a); maxA = Mathf.Max(maxA, c.a);
    }
    int n = col.Length;
    sb.AppendLine("  color mean r=" + (sR / n / 255).ToString("F3") + " g=" + (sG / n / 255).ToString("F3") + " b=" + (sB / n / 255).ToString("F3") + " a=" + (sA / n / 255).ToString("F3"));
    sb.AppendLine("  alpha min=" + (minA / 255f).ToString("F3") + " max=" + (maxA / 255f).ToString("F3"));
    sb.Append("  alpha histogram 0.0-1.0 by 0.1: ");
    for (int i = 0; i < hist.Length; i++) sb.Append((i / 10f).ToString("F1") + "=" + hist[i] + " ");
    sb.AppendLine();
    int a0 = 0, a255 = 0; foreach (var c in col) { if (c.a == 0) a0++; if (c.a == 255) a255++; }
    sb.AppendLine("  alpha==0 count=" + a0 + " (" + (100f * a0 / n).ToString("F1") + "%)  alpha==255 count=" + a255 + " (" + (100f * a255 / n).ToString("F1") + "%)");
   }
  }
  var path = Path.Combine(Directory.GetCurrentDirectory(), "Evidence", "forest-asset-inspect.log");
  File.WriteAllText(path, sb.ToString());
  Debug.Log("[ForestAssetInspect] wrote " + path);
  Debug.Log(sb.ToString());
 }
}
