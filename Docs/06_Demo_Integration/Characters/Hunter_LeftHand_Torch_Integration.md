# 猎人左手探路火把整合

> 目录整理：2026-11-08。文中 `Assets/`、`Evidence/` 和 `Art_Direction/` 路径均以 `VampireHunter_Demo_Independent` 工程根目录为基准。

日期：2026-10-30（Asia/Shanghai）。状态：本轮实现与指定 Play Mode 检查已完成，手动试玩可用；完整序章与极限姿态仍待验收。

## 用户确认与范围
- 左手抬到肩前、举火把探路，不能垂在腰侧。
- 最新指示覆盖最初攻击让位方案：**攻击时保持左手举火把，右手执行原攻击**。
- 待机、移动、攻击保持举火把；翻滚、受击、死亡、交互让出左臂，结束后平滑恢复。
- 火焰/烟雾/火星随火把；按后续纠错要求，主光源、体积光、MicroAVL 与减雾改随火头，原辅助补光仍随玩家。
- 原场景、原素材和已批准银甲黑袍 Prefab 保留，GDD 与正式审批不变。

## 资源与交付路径
原火把：`Assets/Viking Village/Prefabs/Props/pf_torch_fire_01.prefab`（项目已有 Viking Village 资源）。含火把网格、fx_fire、fx_smoke、fx_sparks 与自带 Point light。
持握动画：项目已有 Quaternius CC0 `Rig|Idle_Torch_Loop`，来源许可证见 `Assets/Demo/ThirdParty/QuaterniusHunterAnimations/`。

- 场景：`Assets/Demo/Scenes/PrologueSettlement_HunterTorch.unity`
- 玩家：`Assets/Demo/Characters/Hunter/Torch/Hunter_TorchPlayer.prefab`
- 火把视觉：`Assets/Demo/Characters/Hunter/Torch/Hunter_TorchVisual.prefab`
- 控制器/遮罩/材质：`Assets/Demo/Characters/Hunter/Torch/`
- 证据：`Evidence/hunter-torch-20261030/`

## 已实现
### 火把与粒子
火把挂接 Humanoid LeftHand，保留世界尺度 0.65，补偿骨骼 100 倍缩放；关闭火把自带灯并移除碰撞与丢失脚本副本，避免干扰攻击射线或增加照明。烟雾与网格使用独立 URP 材质副本；火焰直接复用地面火把的 `Assets/Viking Village/Materials/Effects/mat_fx_fire_01.mat`，完整保留其 HDR 自发光（源资源未修改）。
保留三个循环粒子系统。最后修正将火焰改为 Local simulation，烟雾/火星保留 World simulation，以避免手部动作导致火焰留在原位置；已在解锁后的最终 Play Mode 复测。

### 探路姿态与动画隔离
复制现有 Controller，新增 Left Hand Torch 层，遮罩仅允许 LeftArm、LeftFingers、LeftHandIK。使用循环持握动画及左手 Humanoid IK，当前目标相对视觉朝向为 (-0.31, 1.49, 0.32) 米；左肘提示随手部目标移动，偏移 (-0.10,-0.29,-0.13)。仅左手受 IK 控制，不修改权重或重建骨骼。
HunterGameplayAnimator 新增只读 `CurrentVisualState`，原伤害/移动/闪避代码不变。HunterTorchPose 以 0.12 秒混合权重：Idle/Walk/Run/Attack 为 1，其余为 0。火把举起时保持竖直，翻滚时随手旋转。
最后修正使 IK 目标相对角色 Visual 的朝向旋转，避免攻击时 Visual 转向而左手目标仍朝旧方向；已在解锁后的最终 Play Mode 复测。
Root Motion 关闭，翻滚时长保持 0.8 秒，未修改伤害或无敌参数。

### 当前主光源位置（后续用户纠错覆盖最初方案）
原 Carried lantern Light 已迁移到火把 fx_fire 下，局部位置为零；强度 3.5、范围 9 保持。其 SettlementFogLight、UniversalAdditionalLightData、VolumetricAdditionalLight 与 MicroAVL 随同保留。旧灯笼网格隐藏；火把自带 Point light 仍关闭，没有叠加第二盏主灯。Lantern near fill 仍随玩家，强度 0.9、范围 5。
旧 `lighting-before/after.txt` 只证明初版配置，本轮主动改变主灯父级，因此不再代表当前父级相等。

### 固定手掌绑定
修正原素材网格的偏移与约 26 度倾斜：网格局部位置 (0,.15,0)、旋转归零。火焰发射点调整到归正后的火头。
最终结构：LeftHand → **Left Palm Torch Grip** → Hunter Left Torch → fx_fire → 原主 Light。
握点由当前手腕到食指/小指掌指关节中点的 68% 标定，骨骼 100 倍缩放已补偿。握点位置和旋转已保存到场景及玩家 Prefab。火把局部位置和旋转均为零，完全继承手掌挂点；运行时不再每帧独立写入火把世界朝向。待机/移动/攻击时通过手腕骨骼校正火把竖直；翻滚让位时随手腕倾斜。火把自身没有独立世界旋转更新。

## 已完成的 Unity 实测
Unity 2022.3.62f3 / macOS / URP，可见 Play Mode；测试直接调用原行为，未模拟完整键鼠流程。
- 修正后 Idle 左手世界高度约 1.60 米；已查看正面/侧面/背面截图，火把举起并竖直。
- 移动采样为 Run、持握层权重 1，路径 PathComplete，已移动 1.419476 米，速度约 4m/s。
- Dodge 权重降至 0，原翻滚接受成功，时长 0.8 秒，无敌已结束；恢复 Idle 后权重回到 1、左手高度约 1.60 米。
- Attack 权重保持 1，左手高度约 1.57 米，右手执行攻击；连续攻击令目标生命 30→0，消息 Target defeated。
- 三个粒子系统始终 Playing，采样火焰约 3、烟雾约 13–14、火星约 10–20 粒子。
- 烟雾白色方块错误已在后续实播中消失。

原始记录：`playmode.txt`；截图：`idle_0.png`、`idle_1.png`、`idle_2.png`、`moving.png`、`dodge.png`、`attack.png`。这些截图已由解锁后的最终实播更新。`lighting_visual_off.png` 与 `idle_0.png` 为固定位置、同机位的火把视觉隐藏/显示对照，实际 Light 未开关；动态粒子与场景氛围随时间变化，不据此宣称逐像素相等。

## 最终保存与验证结果
用户手动解锁后，已重新进入 Unity Play Mode，复测 Local 火焰跟随与相对 Visual 朝向的左手 IK；实际查看游戏画面，火焰位于火把顶部，烟雾不再出现白色方块。
最终状态记录 `playmode.txt`：Idle 权重 1、左手高约 1.60m；Run 权重 1，移动 1.419476m，PathComplete；Dodge 权重 0、时长 0.8s、无敌已结束；恢复后权重 1；Attack 权重 1、左手高约 1.57m，目标 HP 30→0，火焰/烟雾/火星全程 Playing。

已移除临时 HunterTorchProbe，保存 `Hunter_TorchPlayer.prefab` 与新场景，重新打开场景，序列化文件确认不再引用测试组件。`final.txt`：Console **0 errors / 2 warnings**。完整原始编辑器日志位于本地证据目录；含 Unity 运行环境诊断，不作为对外分享文件。

## 待完善与验收边界
- 手指与握柄接触、极限姿态装备穿模、长时间烟雾表现仍可细化；没有宣称所有动画帧均无穿模。
- 当前左手目标按当前猎人身高设置，不是适配任意体型的通用持物系统。
- 仅左臂被覆盖；右臂攻击、伤害与原闪避数值未改。攻击时保持左手持火把是用户后续明确要求，替代最初攻击让位方案。
- Walk 低速状态、Hit/Death/Interaction 的完整流程未单独回归；本轮验证了 Idle、实际导航 Run、Dodge、连续 Attack 及恢复。
- 检查使用直接 API 行为调用和真实 Play Mode 画面，未模拟完整键鼠、全序章路线或开展性能测试。
- 主光源父级已按用户要求迁移至火头；强度/范围和附属组件保留，原辅助补光仍在玩家根节点。
- 原素材、原聚落场景、已批准外观与 GDD 保留，正式系统审批未变化。

## 使用
打开 `Assets/Demo/Scenes/PrologueSettlement_HunterTorch.unity`，按 Play，使用原鼠标/WASD 移动、选择敌人攻击、Space 翻滚。左手在待机/移动/攻击时肩前举火把，翻滚结束后恢复。场景不再自动触发测试或战斗。

## 2026-10-30 后续纠错实测（当前版本）
用户指出火焰暗、主光源仍在旧位置、攻击时脱握。以上三处已修正。真实 Unity Play Mode 直接调用原行为，检查三面待机、导航奔跑、0.8 秒翻滚、连续攻击和恢复；目标生命 30→0，三个粒子系统持续播放。
连续攻击增加 12 次、每 0.05 秒的采样：火把相对固定掌心挂点的位置误差 0、旋转误差 0；手掌定位差在浮点微米级。另保存 attack_frame0/3/6/9.png 并查看真实攻击画面。测试为有限采样，不宣称覆盖所有动画帧。
证据：`Evidence/hunter-torch-correction-20261030/`，含 fixed.txt、grip.json、playmode.txt、saved.txt 及更新的三面/移动/翻滚/攻击截图。场景与 Prefab 已保存、重新打开，临时 HunterTorchCorrectionProbe 已移除；Console 0 errors / 2 warnings。旧章节数据保留作初版历史，当前以本节及固定绑定说明为准。

![当前正面举火把](../../../VampireHunter_Demo_Independent/Evidence/hunter-torch-correction-20261030/idle_1.png)
![当前攻击持握](../../../VampireHunter_Demo_Independent/Evidence/hunter-torch-correction-20261030/attack_frame3.png)

## 2026-10-30 举火把姿态与步伐调整（最新）
用户指出倾斜、运动时肘动而火把僵硬。将手目标收回至肩前 (-.31,1.49,.32)，减小伸臂程度；步伐相位由实际位移推进（1.65米一周期），手目标含垂直约±2.2厘米、横向±1.2厘米、前后±0.9厘米起伏，肘提示同步移动。静止时保留微弱呼吸起伏。
保留固定掌心挂点；在动画后旋转手腕骨骼，以补偿该模型 Humanoid IK 目标轴与实际手骨轴的差异，火把仍完全继承手腕。完整持握时保持竖直，翻滚/受击等让位时不强制竖直。
真实 Unity Play Mode 检查三面 Idle、16次奔跑采样、0.8秒翻滚及恢复、12次连续攻击采样；奔跑左手世界高度1.55–1.60米，手与火把一起起伏，采样火把倾角0度、挂点位置/旋转误差0。攻击目标HP30→0，粒子持续播放；查看实际待机、奔跑和攻击截图。有限采样不代表所有帧、所有地形均已验证。
场景及玩家Prefab保存重开，临时 HunterTorchNaturalProbe 已移除。Saved and reopened; probe removed; errors=0 warnings=2
证据目录：`Evidence/hunter-torch-natural-20261030/`（playmode.txt、summary.json、三面与stride0/4/8/12及攻击截图）。当前观感供用户审阅，未自动视为新的美术批准。完整键鼠和全序章回归仍待完成。

![最新侧面姿态](../../../VampireHunter_Demo_Independent/Evidence/hunter-torch-natural-20261030/idle_0.png)
![最新奔跑举火把](../../../VampireHunter_Demo_Independent/Evidence/hunter-torch-natural-20261030/stride8.png)
