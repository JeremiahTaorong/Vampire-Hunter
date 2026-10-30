# Hunter Modular Integration

2026-10-30（Asia/Shanghai）。状态：Testing。银甲黑袍候选外观已获用户明确审阅通过；动作接入已推进，仍有下述细节待完善。

## 素材与组装
本地包：`~/Library/Unity/Asset Store-5.x/the disaster artist/3D ModelsCharactersHumanoidsFantasy/Character ConstructorMedievalFantasy armorModular Prototype.unitypackage`。通过 Unity Package Manager 导入，源资源位于 `Assets/SopaDopa/`，URP 与 HDRP 原资源均保留。
基础男性预设：`Assets/SopaDopa/URP_Medieval_Fantasy/Constructor_URP.prefab`；通过原预设的模块启用/禁用方式组装，无额外组装脚本。原 Prefab Animator 未指定 Avatar，已绑定 FBX 子资源 `Constructor_2_1Avatar`，Unity 验证 valid / human。
原模块骨骼均为原生 DEF 骨架，审计见 `Evidence/hunter-modular-audit.txt`：SkinnedMeshRenderer 使用 66 骨引用，未发现空引用。未重建权重、未估算骨骼位置。

当前银甲黑袍版：Body_Base、Body_Hands、Robe、Steel_cuirass_1、Chain_Mail_Chest、Steel_Collar_2、双侧 Steel_Sholder_plate_1 / Steel_pauldron_1 / Steel_bracer_1、Lether_pants、双侧 Steel_legs_protection / Steel_kneecap / Steel_boot、Lether_wide_belt、Hood_Cloth_1、Cape_3。禁用互斥备选装备。
URP 材质使用独立副本，保留原 PBR 贴图；银甲 Metallic / Smoothness 调整，袍子、兜帽与披风黑色。外观对应本聊天用户“可以，很好很好。通过审阅。下一步”，批准证据及版本摘要见 `Evidence/hunter-art-approval-20261030/approval.json`。批准范围仅为独立 Demo 外观。

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

## 2026-10-30 后续：动作及玩家候选
本节替代前文第一轮的未接入状态描述。用户批准外观后，保留已批准 `Hunter_Modular_Armored.prefab`（哈希对比未变化），在新场景继续整合。

### 新资源及文件
作者 Quaternius Universal Animation Library Standard，CC0 1.0。作者页面：https://quaternius.com/packs/universalanimationlibrary.html 。通过 Godot 官方 Asset Store 的作者发布页下载 Standard 版本，ZIP CRC 全量通过；仅导入 Unity FBX 与许可证。路径：`Assets/Demo/ThirdParty/QuaterniusHunterAnimations/`，来源、ZIP SHA-256、许可证均已保存。
有效 Humanoid Avatar 与片段审计：`Evidence/hunter-free-animations-audit.txt`。

| 状态 | 原动作 | 原始时长 |
|---|---|---|
| Attack | Rig&#124;Sword_Attack | 1.533 秒 |
| Dodge | Rig&#124;Roll（非 RM） | 1.467 秒 |
| Hit | Rig&#124;Hit_Chest | 0.333 秒 |
| Death | Rig&#124;Death01 | 2.4 秒 |
| Interaction | Rig&#124;Interact | 2 秒 |

新控制器 `Assets/Demo/Characters/Hunter/Hunter_Gameplay.controller` 保留 Idle/Walk/Run，新增以上状态。
`Assets/Demo/Scenes/HunterActionReview.unity`：原速动作审阅，1–8 分别为 Idle、Walk、Run、Dodge、Attack、Hit、Death、Interaction，Q/E 环绕。进入后自动采集一次动作序列。
`Assets/Demo/Scenes/HunterGameplayCompatibility.unity`：从 MovementDemo 复制，原玩家组件保留，Capsule Renderer 隐藏、碰撞保留；模型位于玩家脚底偏移。保持原键鼠操作。最终已移除自动测试驱动，可手动试玩。
`Assets/Demo/Characters/Hunter/Hunter_PlayerCandidate.prefab`：保留原玩家逻辑的新候选，带 Animator 适配组件。实例接入其他场景需重新指定该场景的 viewCamera。

### 适配及武器
未修改 DemoMovement / DemoHealth / DemoEnemy 等旧代码。独立 HunterGameplayAnimator 读取位移、原闪避状态、原攻击计时、HP；攻击朝向只作用于 Visual。原控制器无攻击事件，适配层使用缓存反射字段 `nextAttack`，字段更名后需更新适配层。
Root Motion 始终关闭，位移由原 NavMeshAgent 逻辑控制。攻击按原 0.7 秒间隔适配，翻滚按原 0.25 秒闪避适配；没有修改玩法时长或无敌窗口。翻滚因此明显加速，属于已知原型节奏限制。
原生匕首约 0.3 米；原手部骨骼含 100 倍缩放。通过保持武器世界尺寸挂接修正放大问题，并根据 Play Mode 画面修正反向刃尖。手指与握柄接触仍不够紧密，尚非最终握持。

### 实际测试及边界
Unity 2022.3.62f3 / OSXEditor / URP，可见编辑器中实际播放，非仅编译。
- 动作场景：Attack / Dodge / Hit / Death / Interaction 均触发并保存四方向、多时刻截图；Root 保持 (0,0,0)。证据 `Evidence/hunter-actions-playmode/`。
- 玩家联动：导航位于 NavMesh，移动 2 米；TryDodge 成功，最后一次位移 2.491783 米；Dodge 状态 hash 1353639306；Attack 状态 hash 1080829965，原逻辑消息 Attacking target。证据 `Evidence/hunter-gameplay-validation/results.txt` 与对应 moving/dodge/attack PNG。
- 以上联动检查直接调用原行为，未模拟完整键鼠流程；截图已实际查看。未发现明显身体断裂或四肢脱落。长袍/披风在极限姿态仍有大幅折叠，尚未逐帧量化穿模；不将其宣称为最终质量通过。
- 两个新场景保存并重新打开，玩家候选已保存。收尾 Console 审计：0 errors / 2 warnings，详见 `Evidence/hunter-final-editor-audit.txt`；原生 Editor.log 仍出现 Unity GUIStateObj 诊断，未发现它对应角色运行失败。

### 待完善
手指握柄与手套、翻滚压缩节奏、袍摆极限姿态、脚滑与速度精配仍需细化。Hit/Death 适配逻辑已提供但本轮仅独立播放验证，未专门执行玩家受击/死亡联动回归；Interaction 仅审阅状态，尚未接入调查完成信号。
未替换正式序章玩家，未完整走序章流程，未做性能或全部键鼠边界回归。候选具备接入基础，不将完整任务标为 Verified；GDD 与正式审批状态不变。


## 2026-10-30：翻滚减速并接入聚落场景
用户要求：“翻滚的速度太快了，放慢，然后接入场景吧。”
已新增 `Assets/Demo/Scenes/PrologueSettlement_Hunter.unity`，将已批准银甲黑袍猎人与现有聚落 Player 根对象合并，保留原 NavMeshAgent、镜头、DemoMovement、DemoHealth、DemoInvestigation、DemoPrologueFlow、随身灯光和场景氛围。原 Hunter body/head 占位 Renderer 隐藏；灯笼占位方块 Renderer 隐藏而 Light 保留。新模型使用玩家脚底为原点，无 Root Motion。

翻滚时长由 0.25 秒改为 **0.8 秒**，动画播放速度相应由约 5.87 降至 1.83，约慢 3.2 倍。总距离仍为 2.5 米，无敌窗口仍为 0.15 秒，冷却未改。改动只应用于新的聚落玩家与 `Assets/Demo/Characters/Hunter/Hunter_SettlementPlayer.prefab`；旧测试场景保留原参数。

实测：Unity 2022.3.62f3 / OSXEditor 可见 Play Mode，导航路径完整，移动 2.000031 米；0.3665 秒仍在 Dodge，IsInvulnerable=False，动画 normalizedTime=0.285；0.7229 秒仍在 Dodge，normalizedTime=0.808；最终翻滚结束，实际位移 2.465095 米。截图已查看，人物可见且无明显网格断裂。本轮通过直接 API 调用验证，未模拟键盘；未完整回归调查、战斗、检查点和全序章路线。

证据：`Evidence/hunter-settlement-20261030/setup.txt`、`playmode.txt`、`spawn.png`、`moving.png`、`slow-roll.png`、`after-roll.png`、`final.txt`。自动测试组件已从新场景和 Prefab 移除，序列化文件核验通过，可正常手动试玩。Console 收尾 0 errors / 16 warnings；日志含既有 NavigationStatic 弃用及缺失脚本警告，尚未对聚落所有对象逐项溯源，不能宣称全工程零警告。Unity 退出大场景时短暂响应缓慢，随后恢复并保存完成。

原 `PrologueSettlement.unity` 前后 SHA-256 相同：`8defb2fcfa00c4073cd47806dec42efa44bba35084282e68e25bd39c9741d668`。原已批准外观 Prefab 与 GDD 未改，正式审批状态保持不变。后续手动试玩入口为新聚落场景。


## 2026-10-30：左手探路火把与攻击持握整合
用户确认左手抬到肩前探路，攻击时保留持握。新增 PrologueSettlement_HunterTorch 场景及独立火把玩家 Prefab，原聚落与已批准角色保留。复用 Viking Village 火把网格/三组粒子，URP 材质副本修正贴图；新增左臂遮罩层和仅左手 IK，攻击时保持权重1，翻滚时权重0后恢复。原玩家照明、体积光与减雾前后配置一致，火把自带灯关闭。
最终可见 Unity Play Mode 验证：Idle/Run 左手高约1.6m，Attack 权重1且连续伤害30→0，Dodge 0.8秒并恢复，三个粒子系统持续播放；已保存多视角截图。解锁后完成最后修正复测，移除临时驱动并保存/重开场景；Console 0 errors/2 warnings。未全序章键鼠与性能回归。详见独立工程 Hunter_LeftHand_Torch_Integration.md 与 Evidence/hunter-torch-20261030/。

2026-10-30 火把纠错：复用地面 HDR 火焰材质；原主灯迁移火头；LeftHand 固定掌心挂点同时驱动位置与旋转，攻击保持持握。新增连续攻击采样与截图，保存重开并移除测试驱动。详见 Hunter_LeftHand_Torch_Integration.md。

2026-10-30：举火把姿态细化，收回左手并屈肘，手/肘目标随实际步伐同步起伏，通过手腕校正竖直且保持掌心刚性绑定。真实Play Mode16次Run采样手高1.55–1.60m、倾角0度；12次攻击采样挂点误差0，目标HP30→0，0.8秒翻滚与恢复正常。Saved and reopened; probe removed; errors=0 warnings=2。证据 Evidence/hunter-torch-natural-20261030，观感待用户审阅；未改变GDD或正式审批。
