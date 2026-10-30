# 猎人左手探路火把整合

日期：2026-10-30（Asia/Shanghai）。状态：Testing，最后修正待解锁后复测。

## 用户确认与范围
- 左手抬到肩前、举火把探路，不能垂在腰侧。
- 最新指示覆盖最初攻击让位方案：**攻击时保持左手举火把，右手执行原攻击**。
- 待机、移动、攻击保持举火把；翻滚、受击、死亡、交互让出左臂，结束后平滑恢复。
- 火焰/烟雾/火星随火把；实际照明、体积光、MicroAVL 与减雾稳定跟随玩家根节点。
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
火把挂接 Humanoid LeftHand，保留世界尺度 0.65，补偿骨骼 100 倍缩放；关闭火把自带灯并移除碰撞与丢失脚本副本，避免干扰攻击射线或增加照明。URP 材质使用独立副本，优先读取源 `_BaseMap`，修复最初烟雾贴图漏带造成的白色方块。
保留三个循环粒子系统。最后修正将火焰改为 Local simulation，烟雾/火星保留 World simulation，以避免手部动作导致火焰留在原位置；该最后修正待复测。

### 探路姿态与动画隔离
复制现有 Controller，新增 Left Hand Torch 层，遮罩仅允许 LeftArm、LeftFingers、LeftHandIK。使用循环持握动画及左手 Humanoid IK，目标相对视觉朝向为 (-0.40, 1.55, 0.46) 米，左肘提示 (-0.58, 1.12, 0.12)。仅左手受 IK 控制，不修改权重或重建骨骼。
HunterGameplayAnimator 新增只读 `CurrentVisualState`，原伤害/移动/闪避代码不变。HunterTorchPose 以 0.12 秒混合权重：Idle/Walk/Run/Attack 为 1，其余为 0。火把举起时保持竖直，翻滚时随手旋转。
最后修正使 IK 目标相对角色 Visual 的朝向旋转，避免攻击时 Visual 转向而左手目标仍朝旧方向；待最终复测。
Root Motion 关闭，翻滚时长保持 0.8 秒，未修改伤害或无敌参数。

### 稳定照明
原 Carried lantern 的 Light 保留在 Player，局部位置 (0.42,1.05,0.18)，强度 3.5、范围 9；Lantern near fill 强度 0.9、范围 5。原 SettlementFogLight、UniversalAdditionalLightData、VolumetricAdditionalLight 与 MicroAVL 子节点不迁移。未新增闪烁脚本；原组件照常保留。
`lighting-before.txt` 与 `lighting-after.txt` 比对一致，火把自身 Light 全部关闭，无重复启用光源。

## 已完成的 Unity 实测
Unity 2022.3.62f3 / macOS / URP，可见 Play Mode；测试直接调用原行为，未模拟完整键鼠流程。
- 修正后 Idle 左手世界高度约 1.60 米；已查看正面/侧面/背面截图，火把举起并竖直。
- 移动采样为 Run、持握层权重 1，路径 PathComplete，已移动 1.348346 米，速度约 4m/s。
- Dodge 权重降至 0，原翻滚接受成功，时长 0.8 秒，无敌已结束；恢复 Idle 后权重回到 1、左手高度约 1.60 米。
- Attack 权重保持 1，左手高度约 1.58 米，右手执行攻击；连续攻击令目标生命 30→0，消息 Target defeated。
- 三个粒子系统始终 Playing，采样火焰约 3、烟雾约 13–14、火星约 10–20 粒子。
- 烟雾白色方块错误已在后续实播中消失。

原始记录：`playmode.txt`；截图：`idle_0.png`、`idle_1.png`、`idle_2.png`、`moving.png`、`dodge.png`、`attack.png`。这些截图对应最后两项修正之前的实播。

## 尚待验证与收尾
电脑操作工具提示 Mac 已锁定，当前无法执行最后一轮 Unity 操作；已请求用户手动解锁。
待验证：Local 火焰跟随、随 Visual 朝向变化的 IK 目标、固定机位火把显示开关的照明对照；然后移除临时 HunterTorchProbe，保存玩家 Prefab，重开场景并记录 Console 数量。未将这些事项标为通过。
手指握柄贴合、极限姿态穿模与完整序章键鼠流程尚未全面验收；没有性能测试。
