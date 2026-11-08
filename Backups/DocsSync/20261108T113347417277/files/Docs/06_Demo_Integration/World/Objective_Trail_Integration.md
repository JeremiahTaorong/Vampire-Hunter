# 任务点窄路与环境引导

> 目录整理：2026-11-08。文中 `Assets/`、`Evidence/` 和 `Art_Direction/` 路径均以 `VampireHunter_Demo_Independent` 工程根目录为基准。

2026-10-30（Asia/Shanghai），独立 Demo 环境调整，观感供用户审阅；不改变 GDD、任务规则或正式系统审批。

## 已实现

新场景 `Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity` 从当前举火把地图复制。原 `PrologueSettlement_HunterTorch.unity` 保留；新场景复制 TerrainData 到 `Assets/Demo/Environment/ObjectiveTrails/TrailTerrain.asset`，原地形资源不变。

保留村庄主路，沿现有可导航路线梳理主干和任务支路：猎人徽记、证人、拖拽痕迹、森林战斗地点、检查点和导师印记。森林段路心约0.96–1.22米，外缘约0.32米柔和过渡，叠加低强度随机变化，不增加箭头、发光路标或整齐围栏。

在副本中隐藏21处遮路的低矮植被，未删除原资源。使用已有素材零散放置18块小石头和3段短栅栏：
- `Assets/Polyeler/EssentialNaturePack/Prefabs/Rock_B.prefab`
- `Assets/Polyeler/EssentialNaturePack/Prefabs/Rock_D.prefab`
- `Assets/Viking Village/Prefabs/Props/pf_fence_01.prefab`

装饰尺寸约0.28–0.60米（石头）、1.35米（短栅栏），大致位于路心1.1–1.6米之外，间隔与朝向随机，不构成连续硬边界。新增装饰不带碰撞，避免缩窄现有可通行路线。未重建或覆盖原导航数据。

只在新场景把挡镜头植被的最低可见度从0.18降至0.055，树冠挡住角色时进一步淡出，保留周围树林。照明、火把与玩家战斗/翻滚代码不变。

## 实测与边界

Unity 2022.3.62f3 / macOS / URP。编辑器内校验每段主路与任务支路均为 PathComplete；真实Play Mode分别传送到任务点近处，再由原NavMeshAgent走完接近段，六处均 PathComplete、剩余距离0。不是完整键鼠流程或全图连续步行验收。

导师印记和敌人按原剧情阶段隐藏；本轮验证它们的位置与路线，没有改变显隐规则或自动完成任务。

证据目录 `Evidence/objective-trails-20261030/`：built.txt、sightline.txt、playmode.txt、六处gameplay/detail截图、spawn.png。默认游戏镜头与单独细节镜头分别记录；初轮曾发现拖拽痕迹处树冠遮镜头，随后调整副本的遮挡淡出参数，并把挡住拖拽痕迹视线的9棵树向侧方挪开（1.31–10.06米，详见canopy-spacing.txt）；重新检查拖拽痕迹与战斗地点的实际游戏截图，小路和角色可见。

仍需人工从出生点完整游玩、确认发现路线的难度与观感；导师位置靠近现有地图边缘，默认镜头仍可能看到边界，本轮未扩建地形。任务道具现有占位外观未替换。

## 最终保存

Saved and reopened  probe removed; errors=0 warnings=2。序列化检查不再含ObjectiveTrailProbe引用，开始Play后不会自动传送或巡视。原火把场景和原TerrainData保留。

![证人支路](../../../VampireHunter_Demo_Independent/Evidence/objective-trails-20261030/witness_detail.png)
![拖拽痕迹路线](../../../VampireHunter_Demo_Independent/Evidence/objective-trails-20261030/trail_gameplay.png)

2026-10-30：拖拽线索标识改为斜放圆盾（Viking Village pf_shield_03）+金色菱形及DRAG CLUE字样，位置仍(32,.1,-1.4)，保留clueId=trail和2.8m调查范围。Unity真实PlayMode射线选中通过，原BeginInteraction流程后examined/HasTrail为true，调查后提示隐藏。截图见Evidence/trail-clue-marker-20261030/gameplay.png和detail.png。saved and reopened=Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity; test probe removed; errors=0 warnings=2。未改变GDD或正式审批。

2026-10-30：新建起伏与室内窗光副本 PrologueSettlement_TerracedInteriors.unity，原HunterTrails及资源保留。村落房屋平台0.5–2.73m，道路增设最高1.05m连续坡顶，独立地形及导航重建。关闭32处室外环境灯、保留玩家火把/月光；11屋室内暖灯+25窗位投光，完整配置体积散射/去雾/窗面发光与Bloom。34环境贴图降一级副本、17材质副本，独立URP renderScale.9/阴影优化。真实PlayMode四线索PathComplete，出生点到村内道路实际步行高度0.637–2.625m，终点剩余0.380m；灯光去雾开关0/1通过。2940x1446编辑器三机位短测FPS12.69/14.27/10.75→17.66/19.20/12.73，不代表独立构建长期帧率。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=3。细节见 Terraced_Village_Integration.md 与Evidence/terraced-village-20261030；观感待审，未改变GDD或正式审批。
