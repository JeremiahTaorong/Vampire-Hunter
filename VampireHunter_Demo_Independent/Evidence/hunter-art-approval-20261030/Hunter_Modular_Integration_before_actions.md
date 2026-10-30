# Hunter Modular Integration

2026-10-30（Asia/Shanghai）。状态：Testing，候选美术待审阅；尚不满足完整主角验收。

## 素材与组装
本地包：`~/Library/Unity/Asset Store-5.x/the disaster artist/3D ModelsCharactersHumanoidsFantasy/Character ConstructorMedievalFantasy armorModular Prototype.unitypackage`。通过 Unity Package Manager 导入，源资源位于 `Assets/SopaDopa/`，URP 与 HDRP 原资源均保留。
基础男性预设：`Assets/SopaDopa/URP_Medieval_Fantasy/Constructor_URP.prefab`；通过原预设的模块启用/禁用方式组装，无额外组装脚本。原 Prefab Animator 未指定 Avatar，已绑定 FBX 子资源 `Constructor_2_1Avatar`，Unity 验证 valid / human。
原模块骨骼均为原生 DEF 骨架，审计见 `Evidence/hunter-modular-audit.txt`：SkinnedMeshRenderer 使用 66 骨引用，未发现空引用。未重建权重、未估算骨骼位置。

当前银甲黑袍版：Body_Base、Body_Hands、Robe、Steel_cuirass_1、Chain_Mail_Chest、Steel_Collar_2、双侧 Steel_Sholder_plate_1 / Steel_pauldron_1 / Steel_bracer_1、Lether_pants、双侧 Steel_legs_protection / Steel_kneecap / Steel_boot、Lether_wide_belt、Hood_Cloth_1、Cape_3。禁用互斥备选装备。
URP 材质使用独立副本，保留原 PBR 贴图；银甲 Metallic / Smoothness 调整，袍子、兜帽与披风黑色。颜色属于审阅候选。

## 交付文件
- `Assets/Demo/Characters/Hunter/Hunter_Modular.prefab`：初版皮甲候选。
- `Assets/Demo/Characters/Hunter/Hunter_Modular_Armored.prefab`：当前银甲黑袍候选。
- `Assets/Demo/Characters/Hunter/Hunter_Animator.controller`：Idle / Walk / Run 独立状态。
- `Assets/Demo/Scenes/HunterCharacterReview.unity`：初版测试场景。
- `Assets/Demo/Scenes/HunterCharacterReview_Armored.unity`：当前审阅场景。
按 Play 后自动依次播放并采集五视图；1/2/3 切换 Idle/Walk/Run，Q/E 环绕。

## 动画及兼容性
复用工程已有 `Assets/Demo/Characters/Hunter_Validation_20261029/Mixamo/Idle.fbx`、`Walking.fbx`、`Running.fbx` 的 Humanoid clip，生成独立循环副本。来源为工程已有 Mixamo 文件，本轮未新下载；原始下载/授权证据未重新核实，不将其标为 CC0。Animator.applyRootMotion=false。
现有玩家逻辑集中在 DemoMovement（NavMeshAgent 移动、TryDodge、定时伤害与交互），并非独立 CombatController。未改旧脚本、旧玩家或序章场景。候选只有 Visual/Animator 与审阅工具，尚未创建接入现有控制器并实测通过的完整玩家版本。

## Unity 实测
Unity 2022.3.62f3 / macOS / URP，可见编辑器实际进入 Play Mode。确认 Idle 动作、跑步肘膝弯曲；自动切换 Idle/Walk/Run 并采集正面、背面、侧面、行走、跑步画面，root 保持 (0,0,0)。原始状态记录和截图：`Evidence/hunter-modular-screenshots/`。
实际画面发现并修正：浅色兜帽改黑；长 Cape_1 换 Cape_3；补全胸甲与链甲内层；匕首挂接尺寸异常，已禁用挂件，未声称武器通过。
没有看到 locomotion 的身体断裂；未做完整帧范围的穿模量化、脚滑速度匹配、性能测试或与玩家 Capsule 尺寸的最终对比。长袍运动仍需细查。

## 未完成
Dodge、Attack、Hit、Death、Interaction 尚无接通动作，未测试通过；本轮检索到 Quaternius Universal Animation Library 官方 CC0 来源 https://quaternius.com/packs/universalanimationlibrary.html ，未下载/导入。
武器握持、手套覆盖、正式移动/攻击/闪避事件接线与兼容场景测试未完成。未重新打开场景核查持久化，未做最终 Console 全量清理审计；日志未检索到新增 C# 编译错误，不等于整个工程零错误。
保留候选，不能标为正式美术批准或完整任务完成。GDD 与正式审批状态未改。
