# 起伏村落、室内窗光与性能副本

日期：2026-10-30（Asia/Shanghai）。独立 Demo 场景候选，不改变 GDD 或正式系统审批。

## 场景与原资源保护

新场景：`Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`。
来源：`Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity`。源场景仅用于读取和未保存的基线测试组件；新场景独立保存，未覆盖源场景。
新资源统一存放：`Assets/Demo/Environment/TerracedVillage/`。地形、导航、渲染管线、环境材质和降采样贴图均为独立资源；角色、装备、攻击、翻滚与交互规则未改。

## 地形层次与道路

初版新地形高度约0.08–3.54米。11栋房屋有平整平台，高度约0.50–2.73米，以约3.2米的软边过渡到周边地形。道路再增加最高约1.05米的连续坡顶与低谷，约21米一个起伏周期，靠近房屋地基时减弱，不做生硬台阶。横向道路采样高度约0.59–2.98米；详见证据中的road-relief-final.txt。

植被、道具、线索、玩家、敌人和检查点按地形变化重新落地，保留各自原有离地偏移。重建新导航网格，未覆盖旧导航资源。另修复了源B06木屋网格与自身组节点相差约52米的问题，仅修正新副本，使它回到南侧房屋位置。

## 室内灯与窗光效果

关闭副本中原32个室外环境灯及室外火焰粒子，隐藏原灯笼发光网格。玩家火把与近身补光、天空/月光方向光保留；“灯移入室内”针对场景局部环境灯。

11栋房屋各有室内暖灯。优先复用原模型独立Windows子网格；没有独立窗面的4间木屋新增带木框的暖色窗面。共25处窗位向屋外投光，光源位于窗面内侧约0.15米，使用四格窗Cookie。窗面自发光颜色(4.8,2.25,0.57)，保留原Bloom后处理。

每处窗光同时配置：
- VolumetricAdditionalLight：Scattering 0.9、Anisotropy 0.15、Radius 0.25。
- SettlementFogLight：innerRadius 0.7、outerRadius 3.5、minimumDensity 0.22、referenceIntensity 7。
- 暖色Spot：强度7、范围9米，向外及下方投射。

窗光注册进原SettlementFogManager；保留原体积雾Renderer Feature与雾配置，不以关闭雾换帧率。实际近景已观察到从窗面向外的暖色体积光束。窗灯关闭时去雾强度0、恢复时1；保存同机位体积散射开/关截图。

这是适合当前封闭房屋模型的视觉近似：窗面自发光，加不投实时阴影的室内侧窗位投光；没有切割墙面网格，也未声称做了物理准确的室内光传输。窗格光束的精确裁切、个别门窗接缝仍可继续手工细调。

## 性能调整范围

34张环境贴图使用降一级分辨率的独立副本，通常保留1024–2048上限；17份环境材质副本保留PBR属性与贴图类型。角色贴图不降采样。低矮植被取消投射阴影。

新场景独立URP管线：renderScale 1→0.9；主阴影4096→2048；附加阴影图4096→1024；阴影距离150→55米。环境窗灯不投实时阴影，体积散射、局部去雾、发光与Bloom继续工作。降低分辨率会略微变软，远处小物体阴影细节减少。

## 验证方法与边界

Unity 2022.3.62f3 / macOS / URP，真实可见Play Mode。帧率测试在2940×1446编辑器Game视图，取消VSync与targetFrameRate限制，三个相同玩家XZ/跟随机位，各预热1秒、采样约3秒，测试结束恢复限制设置。新地形会改变相同XZ处的镜头高度，属于相同游戏视角的场景对比，并非相同世界空间绝对机位。短采样包含编辑器开销，不能视为独立构建或长期FPS保证。

检查四处线索导航、原NavMeshAgent运动、出生点到村内的整段起伏道路步行，保存道路低机位、村落总览和B01/B02/B10窗户近景。不是完整序章键鼠/战斗回归，也没有在全部房屋内部做可玩测试。

原始证据：`Evidence/terraced-village-20261030/`，包括audit.txt、built.txt、window-effects.txt、road-relief-final.txt、before/after_playmode.txt、同游戏视角截图、窗光及体积散射关闭对照。

## 最终实测结果

| 游戏机位（玩家XZ） | 原场景FPS | 新副本FPS（保留体积窗光） |
|---|---:|---:|
| (-30,-8) | 12.69 | 17.66 |
| (-9,-5) | 14.27 | 19.20 |
| (16,-4) | 10.75 | 12.73 |

最终四条线索寻路均PathComplete；起伏道路实际步行覆盖高度0.637–2.625米，终点剩余0.380米、PathComplete。三处窗户的散射0.9、去雾强度1；关闭测试窗灯去雾强度0，恢复为1。实际检查窗户近景和道路低机位截图。独立构建、长期帧率、全序章/战斗仍未回归。

![窗户发光与体积光](Evidence/terraced-village-20261030/window_B02.png)
![起伏道路低机位](Evidence/terraced-village-20261030/road_relief.png)

## 保存收尾

Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=3。场景重开后确认未序列化临时测试组件；36个启用环境局部灯均在房屋组下，25处窗光均具有体积光与去雾组件。玩家局部灯另保留2处，月光方向光保留。

2026-10-30：按用户新指示恢复广场篝火（3循环粒子、闪烁灯、体积光及去雾），玩家火把强度3.5→6.5/范围9→13m。使用原Character Constructor模块组装村民证人第一版：灰绿布衣、棕裤、皮靴、露脸男性，独立Prefab和NPCVillagerReview场景。原Humanoid/66骨蒙皮保留，Idle实播，7启用模块无空骨；地图原证人调查流程实测HasWitness=True。Saved world=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity probe removed Saved review=Assets/Demo/Scenes/NPCVillagerReview.unity probe removed; errors=0 warnings=2 。停在用户候选外观审阅，不继续AI或更多NPC，不改变正式审批。证据Evidence/villager-candidate-20261030，说明NPC_Villager_Candidate.md；本轮未重新测FPS。
