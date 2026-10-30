# 森林美术第二轮：着色器还原、柔和雾与 Play Mode 走动记录

日期：2026-10-28（Asia/Shanghai）。范围：仅独立 Demo。未改动正式游戏文档、冻结 R/F、S01 审阅状态。

## 1. 找出的实际差异

原素材不携带任何贴图：`Pine Forest_LowPoly_material.mat` 引用的 `_MainTex` / `_BumpMap` GUID
在本工程内无法解析，而 `Materials/` 与整个包内均无图片文件。也就是说原材质外观完全由
**顶点色 RGB（颜色）+ 顶点色 alpha（镂空）+ UV 量化噪声** 决定。

原始片段着色器 `AssetPacks/Pine Forest_LowPoly/Shaders/Mobile_Vtx_Cutout.shader:138`：

```
alphaMask = lerp(vtxAlpha * _Vtx_Opacity * noise(uv) * _Opacity_NoiseAmnt, _All_Opacity, vtxAlpha)
clip(BinaryDither3x3(alphaMask - 1.5, screenUV))
```

其中 noise 先把 UV 量化成 150 格（`floor(uv*150)/149`）再逐格取哈希值。

对比旧 URP 版本 `ForestAtmosphereReview.shader`：阈值写成 `-0.66`（原版 1.5），且把逐格哈希
换成了平滑噪声。差异后果可以用网格数据量化：

| 网格 | 顶点 alpha 最大值 | 原版阈值 1.5 下的可见率 | 旧版阈值 0.66 下的可见率 |
|---|---|---|---|
| GroundCover_Grass1 | 0.800 | 约 12% 的格（n < 0.124） | 约 70% 的格 |
| GroundCover_Dirt | 1.000 | 内部可见、0.675 边缘带全裁 | 大面积变实心 |

数据来源：`Evidence/forest-asset-inspect.log`（Unity 批处理读取网格 UV 与顶点色分布）。

这解释了「树冠块状、地面边缘不自然」：本该被噪声打掉的面积被保留成了实心面。

## 2. 本轮改动

**新着色器** `Assets/Demo/Shaders/ForestFoliageURP.shader`

- 还原原版遮罩公式与 `_Vtx_Opacity=-18.2` / `_All_Opacity=2.1` / `_Cutoff=1.5` 参数。
- 原版的 3×3 Bayer 网点在近景会变成可见网格，改为 `fwidth` 覆盖率 + MSAA alpha-to-coverage。
- 补充 ShadowCaster / DepthOnly / DepthNormals 通道（旧版没有，因此树不投影、不参与深度法线）。
- 主光改用 Lambert + SH 环境光（旧版是 half-lambert 半兰伯特，会压平明暗）。
- 增加物体空间体素噪声：包内多个网格的 UV 岛几乎重合，只靠 UV 噪声永远出不了细节；
  `Evidence/forest-noise-steps-compare.log` 记录了该现象。

**新着色器** `Assets/Demo/Shaders/SoftMist.shader`

旧 `LayeredGroundFog.shader` 对整块面返回固定 alpha，等于把一层亮灰糊在画面上。新版按相机距离
淡入淡出、深色、宽过渡带，只在树层之间形成柔和的雾，不在镜头前出现。

**新场景** `Assets/Demo/Scenes/PrologueForestFinalReview.unity`

由 `PrologueForestAtmosphereReview.unity` 复制生成；旧场景及更早版本全部原样保留。
调整内容：植被材质分类（树木/灌木与地面植被分为两种材质）、外围加密与走廊收窄、
近黑三色环境光、冷色主光带阴影、雾层改为 SoftMist。

## 3. 实际播放验证（Unity Test Framework，Play Mode）

测试：`Assets/Demo/Tests/PlayMode/ForestWalkPlayModeTest.cs`
结果：`Evidence/forest-walk-results.xml`（通过）；日志：`Evidence/forest-walk-playmode.log`。

| 项目 | 出货机位 (0,10,-10) | 临时压低机位 (0,5.2,-8.2) |
|---|---|---|
| 行走帧数 | 315 | 318 |
| 有遮挡渐隐的帧 | 155（49.2%） | 86（27.0%） |
| 最小可见度 | 0.180 | 0.275 |
| 可见度突变次数（>0.35） | 0 | 1 |
| 相机跟随误差 | 0.00 | 0.00 |

截图（Play Mode 内由游戏相机渲染）：`Art_Direction/PlayModeCapture/rig_*.png`、`lowrig_*.png`。

结论：遮挡渐隐在真实相机运动下确实生效且平顺（出货机位 0 次跳变），最小透明度与
`occludedVisibility=0.18` 配置一致。**仍只有透明渐隐，没有虚化。**

## 4. 已验证 / 未验证

已验证：
- Play Mode 中相机跟随、遮挡渐隐数值随时间变化、无平台期突变。
- 树叶镂空、地面植被边缘、主光阴影、雾层在新场景中的实际渲染结果（截图为证）。

未验证：
- **真实键鼠输入**：走动由脚本移动玩家 Transform 驱动；NavMeshAgent 在测试运行器下
  接受完整路径但 25 秒内不推进（`pathPending` 恒真），因此本测试关闭了 Agent，
  **不代表导航/寻路通过**。
- **帧率与性能**：未测量。场景含约 1000 个植被渲染体。
- 长距离行走、其他地图区域、战斗与调查流程在新场景中的表现。
- 柔和雾在动态相机下的漂移观感（截图是静帧）。
- 是否达到用户对最终美术的期望——**未获批准**。

## 5. 已知缺陷

- 素材内 `Bush_block*` 是 26 顶点立方体，近景仍读作方块；新场景已停用走廊附近的实例，
  远处保留。这是素材本体，不是着色器可修的问题。
- 玩家、敌人、村庄建筑仍是胶囊与黑盒占位。
- 树干上的横向明暗带来自树冠投影与顶点色，属素材特征。
