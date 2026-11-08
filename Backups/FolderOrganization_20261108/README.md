# Vampire Hunter — 独立 Demo

## 最新试玩入口（2026-11-07）

打开 `Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity` 后 Play。当前新增两款免费 CC BY 血迹、12 处聚集血泊、免费断臂及原创十字徽章。点击徽章或断臂，角色走近后打开全屏检视：虚化背景、模型放大/拖动旋转、下方英文故事；按钮或 Esc 返回。断臂交互点已对准模型，检视时场景暂停并阻挡世界操作。故事措辞待审。

[最新变更与 Mac 交接](../开发记录/2026-11-07_血迹断臂徽章与检视UI交接.md) · [Mac 同步步骤](../MAC_SETUP.md) · [检视运行证据](Evidence/evidence-inspection-20261106/REPORT.md)。Windows Unity 2022.3.62f3 局部测试通过；Mac、完整序章连续试玩、独立构建及性能未验证。

## 2026-10-30 历史试玩入口

打开 [PrologueSettlement_TerracedInteriors.unity](Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity) 后Play。当前版本包含起伏村落、窗光体积雾、恢复的篝火、左手火把与村民证人。靠近并点击证人完成原调查：抱拳→放臂→等待1.5秒→左手指向下个目标。

[当前交接与实测边界](../开发记录/2026-10-30_独立Demo当前交接.md) · [NPC手势说明](NPC_Villager_Gesture_Integration.md)。NPCVillagerReview仅供最初模型审阅；下文保留各轮历史入口及参数。最新NPC主路径已实播，完整键鼠序章、其他目标分支及当前整合FPS仍待回归。


独立 Unity 项目；不与最终游戏工程或设计审批状态共用。当前已有聚落、猎人、调查与战斗原型，尚未完成完整序章验收。Unity 2022.3.62f3，Universal 3D。

在 Unity Hub 选择 Add project from disk，打开本目录；在项目中打开 `Assets/Demo/Scenes/MovementDemo.unity`，按 Play。左键点击地面移动；WASD 接管并终止已有点击路径。镜头跟随角色。地面、角色、障碍均为占位。

Unity 批处理成功编译并生成场景；Unity Play Mode 自动烟雾检查验证了导航可用、代理沿路径移动、取消路径、直接手动移动和摄像机目标，日志见 Evidence。该检查不模拟鼠标/键盘，不证明实际输入体验；需在可见编辑器中手动检查点击、WASD、障碍和移动表现。不可达目标目前提示并停止；最近安全可达点策略还未实现。敌人已可接近并攻击；尚未实现完整章节。

项目使用 GitHub 私有仓库和 Git LFS，同步说明见根目录 MAC_SETUP.md / WINDOWS_SETUP.md。历史上传验证见 Docs/03_Management/Evidence/GITHUB_TRANSFER_20261031.md，当前同步见 GITHUB_SYNC_20261107.md。`Library` 等缓存不携带，Unity 首次打开会重建。

## 第二步：证物交互

点击场景中的方块证物，角色靠近后显示猎人纹章线索；WASD 接管会取消正在靠近的互动。Unity 自动播放模式检查通过靠近并查看证物；自动检查直接调用行为，没有模拟实际鼠标点击或 WASD 输入。证据见 `Evidence/interaction-playmode.log`；手动输入验证仍未完成。

## 第三步：训练目标与普攻

场景中红色胶囊体是临时训练目标，左键选择后角色靠近并连续普攻，目标生命耗尽后消失；WASD 接管会保留目标并暂停攻击，松手后仅在攻击范围内恢复。攻击数值为临时测试值。敌人现可接近并攻击，没有正式美术。

Unity 自动播放模式检查通过追击、攻击伤害和调用手动接管时保留目标；该测试通过代码调用行为，并未模拟真实鼠标/WASD，连续自动攻击与松手恢复仍需在编辑器手动验证。日志见 `Evidence/combat-playmode.log`。

## 第四步：基础战斗闭环

敌人会在一定距离内接近，攻击前有文字提示；命中会扣除 HP 并显示 HIT。玩家生命归零显示 Defeated，敌人生命归零显示 Victory；胜负后按 R 重新开始。全部伤害、距离与时长都是测试参数。

Unity 播放模式自动测试验证敌人造成伤害、战败状态、场景重载后 HP 恢复及胜利；此前移动、互动和普攻回归测试通过。测试使用代码调用/场景重载，**没有模拟实际点击、WASD 或 R 键**，敌人追击和预警的画面体验也需人工测试。日志见 Evidence/combat-loop-playmode.log 与 combat-loop-regression.log。

## 第五步：防御闪避

按 Space 闪避；按住 WASD 时按相应方向闪避，否则沿当前朝向。距离、动作时长、无敌窗口和冷却均是独立 Demo 的临时原型参数，并未确定最终游戏按键或数值。

Unity 播放模式自动检查验证位移、短暂无敌、无敌结束后受伤和冷却，战斗闭环回归检查通过；测试代码直接触发闪避，未模拟实际 Space 按键；用户随后报告测试通过，但未提供具体步骤，障碍边缘等覆盖范围尚不明确。证据见 Evidence/dodge-playmode.log 和 dodge-regression.log。用户报告 WASD 和鼠标已验证，详情见 Evidence/user-input-confirmation-20261028.md；不推断其他用例结果。

## 第六步：调查与简单推理

点击猎人纹章证物和占位证人，收集物证与证词；两项齐全后在调查面板选择搜索方向。错误选择允许重试，选择森林后显示推理结论。该场景还不是完整序章：森林、完整剧情与正式内容尚待制作。

Unity 自动播放模式检查通过线索门槛、重复调查、错误重试和正确结论；该检查直接调用行为，没有模拟鼠标点击或界面按钮。战斗闭环回归检查通过；调查 UI 的实际可读性和鼠标操作仍需人工验证。用户在闪避说明之后回复“测试通过”，记录见 Evidence/user-dodge-confirmation-20261028.md，具体步骤未提供。

## 第七步：独立序章流程原型

打开 `Assets/Demo/Scenes/ProloguePrototype.unity` 后按 Play。调查纹章与证人，在面板选择 Forest；敌人出现，击败它后点击出现的导师标记，即完成本次序章原型。战败或完成后可按 R 重新开始。之前的 `MovementDemo.unity` 保留为训练场。

所有人物、地面、障碍和剧情线索均为占位；当前两个功能区仍共处一个测试空间，不代表完整村庄或森林关卡。无主菜单或完整故事；未测序章 5–8 分钟目标。

Unity 播放模式自动测试验证调查门槛、敌人激活、击败后导师标记、完成与重载重试；测试通过代码直接触发，未模拟实际键鼠输入。原训练场战斗回归检查通过。日志见 Evidence/prologue-playmode.log 和 prologue-combat-regression.log；需人工体验完整流程。

## 第八步：较大序章灰盒与三线索调查

在 Unity 打开 `Assets/Demo/Scenes/PrologueGreybox.unity` 并按 Play。调查村庄纹章、证人和拖拽痕迹；收集后选择森林，向画面右侧穿过林地入口，击败敌人，再前往远处导师标记。布局与具体路径详见 `Prologue_Greybox_Map.md`。

Unity 自动检查通过线索/森林/导师标记可达性、三线索门槛、错误重试和流程重置；原序章回归通过。检查直接触发互动，没有模拟键鼠操作或计时；需要实际走图确认可读性与游玩节奏。地图仍是功能灰盒，非最终美术。

## 第九步：森林猎杀、序章结尾与字体

三条调查线索推理完成后，向右穿过森林入口。靠近入口处的圆柱检查点可激活战斗重试；左键敌人自动攻击，WASD 移动，Space 闪避。战败后按 R：检查点已激活且仍处于森林战斗时，尝试在检查点恢复 HP、重置敌人并保留调查进度；否则从场景开始重试。

击败敌人后调查导师标记，画面显示通往古堡的线索和完成提示；按 R 从头重试。界面提示、按钮与生命值字体统一调整为 16 号，均为临时排版与美术占位。

按用户要求，本轮没有运行玩法测试；编译及场景生成完成仅说明 Unity 接受生成过程，不证明检查点、交互、布局、键鼠、遮挡或战斗正确。此前灰盒自动测试是在这次修改之前运行的，不能作为本次改动通过的证据。

## 第十步：序章光雾方向

在 Unity 打开 `Assets/Demo/Scenes/PrologueAtmosphere.unity`，可查看以黑灰为主、暖色稀疏灯光与冷色雾构成的氛围草案；原 `PrologueGreybox.unity` 保留用于比较。灰盒地图和人物仍为几何占位，不代表最终资产。

用户要求先不测试，本次仅完成脚本编译和场景生成；未运行画面、操作或性能验证。亮度、雾遮挡、线索和敌人可读性仍待实际查看与调整。方向概念图与说明在 `Art_Direction/`。

## 第十一步：分层雾素材样片（部分完成）

打开 `Assets/Demo/Scenes/PrologueFogSample.unity`。在原光雾场景上加入使用 Kenney Particle Pack `smoke_03.png` 的村庄、入口、森林、远景粒子雾。来源与许可见 `Art_Direction/Asset_Sample_Sources.md`。

此样片尚未导入 Quaternius 村庄或 Unity Asset Store 森林模型：前者下载被来源配额限制，后者领取入口未能使用。当前仍为几何体。Unity 已生成场景和材质；按用户先不测试的要求，尚未验证画面、性能或操作。

## 第十二步：连续分层地面雾

在 Unity 打开 `Assets/Demo/Scenes/PrologueSoftFog.unity`。依据用户对小型、重复烟团的反馈，保留旧 `PrologueFogSample`，在新场景以三个覆盖大范围、透明渐变、参数不同的程序化雾层替代重复粒子，预设缓慢漂移；额外调节玩家附近的补光。此方法属于水平雾层，不是真正的体积雾，后续仍需要实际调节以避免遮挡。

`Art_Direction/SoftFog_UnityPreview_20261028.png` 是 Unity 编辑器摄像机直接渲染的起始位置静态预览，并非概念图或完整运行截图；截图不包含游戏 UI。编辑器渲染成功，画面中不再出现重复小团，但角色仍较暗；动态漂移、实际操作、性能和整张地图的效果尚未测试。

## 第十三步：树叶着色器还原与柔和雾

打开 `Assets/Demo/Scenes/PrologueForestFinalReview.unity`。旧场景 `PrologueForestAtmosphereReview.unity` 及更早版本全部保留，可对照。

原素材没有贴图，树冠外观完全由顶点色 alpha 叠加 UV 量化噪声决定。此前 URP 版本把裁切阈值写成 0.66（原版是 1.5），噪声也从逐格哈希换成平滑噪声，本该被镂空的面积变成实心，这才是「树冠块状、地面边缘不自然」的原因。新 `ForestFoliageURP.shader` 还原了原公式，并补上阴影与深度通道。

雾换成新的 `SoftMist.shader`：按相机距离淡入淡出、深色、宽过渡，不再是盖在画面上的亮灰。

Unity Test Framework 的 Play Mode 测试（`Assets/Demo/Tests/PlayMode/`）驱动玩家走了一小段：出货机位下有遮挡渐隐的帧占 49.2%，最小可见度 0.180，可见度突变 0 次，相机跟随误差 0.00。截图见 `Art_Direction/PlayModeCapture/`。

**注意**：走动是脚本移动玩家 Transform 完成的，NavMeshAgent 在测试运行器下不推进所以被关闭，因此这次**不代表导航或寻路通过**；也没有模拟真实键鼠。帧率未测量。目前仍然只有透明渐隐，没有虚化。细节见 `Evidence/forest-final-review-20261028.md`。

## 第十四步：森林任务目标暖黄照明

`PrologueForestFinalReview.unity` 内所有暖色灯笼强度提升到 2.8（范围同步放大，重复应用不再叠加），并在森林区域每个必经目标上方新增一盏暖黄点光：森林检查点 (8,0,0)、训练敌人 (28,0,0)、南北森林入口 (2,±11)、古堡远景标记 (57,0,0)。导师标记原本已有专用暖灯，未重复添加。

工具是菜单命令 `Vampire Demo / Apply Forest Objective Lights`（`Assets/Demo/Editor/ForestObjectiveLights.cs`），幂等且可撤销，运行时会自动出预览图到 `Art_Direction/FinalReview/lights_*.png`。细节与坐标表见 `Evidence/forest-objective-lights-20261028.md`。

灯目前**只有光、没有灯体**；实际走完全程的引导效果和帧率尚未验证。

## 第十五步：序章聚落与森林重建（PrologueSettlement）

打开 `Assets/Demo/Scenes/PrologueSettlement.unity`，按 Play 从村口出生。旧场景（含 `PrologueNatureReview`、`PrologueForestFinalReview` 等）全部保留未改。

场景按用户提供的聚落俯视图重建：地图左侧为紧凑村落（B01–B11 共 11 栋建筑、广场水井、火塘、集市棚、木桶与木料堆），右侧为高密度针阔混交林，主路从村口经广场、村东、拖拽痕迹到森林入口并继续深入林内；北支通磨坊与长屋，南支通 B06/B07/B05。

- **地面**：120×64 地形，四层 splat（林地 / 草地 / 压实土路 / 落叶），森林有起伏，道路与广场压平。
- **建筑**：逐栋按目标宽度等比缩放（高 3.3–8.8 m），按地形落地，门朝向道路或广场；每栋生成 door 标记，门灯从 door 位置派生。
- **植被**：约 420 棵乔木、565 丛灌木、250 株蕨、1350 丛草、125 块岩石/落叶；按类别间距避让道路、建筑、广场与线索点。
- **光照**：月光 + 逆光补光、暖色门灯/广场灯/火塘、玩家手提灯笼、指数平方雾、Bloom/Vignette/ACES 后处理。
- **调查流程**：纹章、证人、拖拽痕迹、导师标记、森林检查点与敌人已按新坐标重建；`DemoInvestigation` 与 `DemoPrologueFlow` 挂在玩家对象上。

重建设计与构建入口：`Assets/Demo/Editor/BuildSettlementScene.cs`（可重复执行，会重建地形、建筑、植被、导航与场景）。核查用 `AuditSettlementScene.cs`（渲染俯视、斜视、门面照与几何/寻路数据）。素材实机核查见 `AuditSettlementAssets.cs`。

**未完成**：没有实机走图、键鼠操作、帧率与战斗/检查点验证；森林东南角仍有一块偏空的落叶地；广场生活道具仍可加密。已知问题与核对清单见 `../开发记录/已知问题与验收清单_20261029.md`。PlayMode 测试 `Assets/Demo/Tests/PlayMode/SettlementWalkPlayModeTest.cs` 已就绪但未执行完。

## 第十六步：聚落光雾与植被渐隐恢复（2026-10-29）

打开 `Assets/Demo/Scenes/PrologueSettlement.unity`。迁移用户认可的 PrologueCarriedDarkReview 浓黑体积雾和随身暖光/MicroAVL 配置，33 盏现有局部灯默认开启并参与局部减雾；1002 株植被及其 LOD 接入遮挡渐隐。聚落新增灯光和原后期效果使广场比原单灯测试更亮、更暖，仍待用户审阅。

证据见 `Evidence/settlement-atmosphere-20261029/`。已执行编译、重载、固定机位渲染、灯开关和人工构造遮挡核查；不代表实际键鼠、完整走图、战斗或帧率通过。开发记录集中于上级 `开发记录/`，恢复快照见 `Evidence/BeforeSettlementAtmosphere_20261029-120245/`。

## 第十七步：修复游戏运动视角的点阵条纹（2026-10-29）

将聚落植被的屏幕点阵渐隐改为连续透明渐隐；恢复时切回原始材质和深度渲染，保留雾参数及默认开启的村庄灯。修复前后短时 PlayMode 游戏机位测试各 1/1 PASS，截图/逐帧记录见 `Evidence/settlement-stripes-20261029/`；完整走图、键鼠、战斗及帧率未测。集中记录见上级 `开发记录/游戏镜头条纹修复_20261029.md`。

## 第十八步：Midnight Gunslinger 静态人物导入（2026-10-29）

在 Unity 打开 `Assets/Demo/Scenes/MidnightGunslingerImportReview.unity`；预制体为 `Assets/Demo/Characters/MidnightGunslinger/MidnightGunslinger_StaticReview.prefab`。已导入网格、URP 材质及贴图，含帽高度 1.9 m。原 GLB 没有骨骼、蒙皮或动画，当前为静态外观审阅，不代表四类基础动作已接通。动作需先绑骨蒙皮/取得带骨骼版本，再进行 Humanoid 与动作控制器接入。证据见 `Evidence/gunslinger-import-20261029/`；集中记录见上级 `开发记录/人物导入与动作接入检查_20261029.md`。聚落玩家未替换。


## 模块猎人动作与玩家兼容测试（2026-10-30）

银甲黑袍外观已通过用户审阅。打开 `Assets/Demo/Scenes/HunterActionReview.unity`，Play 后用 1–8 查看八类动作，Q/E 环绕；打开 `HunterGameplayCompatibility.unity` 可按原操作试玩新模型，旧场景保留。玩家候选为 `Assets/Demo/Characters/Hunter/Hunter_PlayerCandidate.prefab`。动作及移动/闪避/攻击已进行直接行为 Play Mode 检查，完整键鼠流程未回归；握柄、袍摆及 0.25 秒闪避的动作节奏仍需细化。详见 `Hunter_Modular_Integration.md`。


## 历史聚落猎人入口（2026-10-30）

打开 `Assets/Demo/Scenes/PrologueSettlement_Hunter.unity` 后按 Play，以原键鼠操作试玩。新猎人已替换聚落占位人物，Space 翻滚时长为 0.8 秒，距离及无敌窗口未增加。原 `PrologueSettlement.unity` 保留。新玩家 Prefab 为 `Hunter_SettlementPlayer.prefab`，自动测试已移除。移动/翻滚已实际 Play Mode 验证，完整序章流程尚未回归；详情与截图见 `Hunter_Modular_Integration.md`。


## 历史左手火把入口（2026-10-30）
打开 `Assets/Demo/Scenes/PrologueSettlement_HunterTorch.unity` 后 Play，使用原键鼠操作。猎人左手肩前举火把探路，攻击时保持持握，翻滚时让位并恢复。实际照明配置保持稳定，原场景保留；测试驱动已移除。实现、截图和验收边界见 `Hunter_LeftHand_Torch_Integration.md`。

2026-10-30 火把纠错：复用地面 HDR 火焰材质；原主灯迁移火头；LeftHand 固定掌心挂点同时驱动位置与旋转，攻击保持持握。新增连续攻击采样与截图，保存重开并移除测试驱动。详见 Hunter_LeftHand_Torch_Integration.md。

2026-10-30：举火把姿态细化，收回左手并屈肘，手/肘目标随实际步伐同步起伏，通过手腕校正竖直且保持掌心刚性绑定。真实Play Mode16次Run采样手高1.55–1.60m、倾角0度；12次攻击采样挂点误差0，目标HP30→0，0.8秒翻滚与恢复正常。Saved and reopened; probe removed; errors=0 warnings=2。证据 Evidence/hunter-torch-natural-20261030，观感待用户审阅；未改变GDD或正式审批。

2026-10-30：独立Demo任务窄路版已保存至 Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity，TerrainData独立副本。整理六类任务点的约1米窄土路，隐藏21处低矮植被，零散放18块石头/3段短栅栏，疏开拖拽痕迹视线中的9棵树。沿用玩家火把、灯光、任务状态和移动逻辑。真实PlayMode六处接近段均PathComplete/剩余0，保存游戏视角和细节截图；Saved and reopened  probe removed; errors=0 warnings=2。完整出生点连续键鼠流程与观感待用户试玩审阅，未改变GDD或正式审批。详情 Objective_Trail_Integration.md、Evidence/objective-trails-20261030。

2026-10-30：拖拽线索标识改为斜放圆盾（Viking Village pf_shield_03）+金色菱形及DRAG CLUE字样，位置仍(32,.1,-1.4)，保留clueId=trail和2.8m调查范围。Unity真实PlayMode射线选中通过，原BeginInteraction流程后examined/HasTrail为true，调查后提示隐藏。截图见Evidence/trail-clue-marker-20261030/gameplay.png和detail.png。saved and reopened=Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity; test probe removed; errors=0 warnings=2。未改变GDD或正式审批。

2026-10-30：新建起伏与室内窗光副本 PrologueSettlement_TerracedInteriors.unity，原HunterTrails及资源保留。村落房屋平台0.5–2.73m，道路增设最高1.05m连续坡顶，独立地形及导航重建。关闭32处室外环境灯、保留玩家火把/月光；11屋室内暖灯+25窗位投光，完整配置体积散射/去雾/窗面发光与Bloom。34环境贴图降一级副本、17材质副本，独立URP renderScale.9/阴影优化。真实PlayMode四线索PathComplete，出生点到村内道路实际步行高度0.637–2.625m，终点剩余0.380m；灯光去雾开关0/1通过。2940x1446编辑器三机位短测FPS12.69/14.27/10.75→17.66/19.20/12.73，不代表独立构建长期帧率。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=3。细节见 Terraced_Village_Integration.md 与Evidence/terraced-village-20261030；观感待审，未改变GDD或正式审批。

2026-10-30：按用户新指示恢复广场篝火（3循环粒子、闪烁灯、体积光及去雾），玩家火把强度3.5→6.5/范围9→13m。使用原Character Constructor模块组装村民证人第一版：灰绿布衣、棕裤、皮靴、露脸男性，独立Prefab和NPCVillagerReview场景。原Humanoid/66骨蒙皮保留，Idle实播，7启用模块无空骨；地图原证人调查流程实测HasWitness=True。Saved world=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity probe removed Saved review=Assets/Demo/Scenes/NPCVillagerReview.unity probe removed; errors=0 warnings=2 。停在用户候选外观审阅，不继续AI或更多NPC，不改变正式审批。证据Evidence/villager-candidate-20261030，说明NPC_Villager_Candidate.md；本轮未重新测FPS。

2026-10-30：用户同意村民第一版并要求抱拳/交互指路。当前起伏村落证人接入原Humanoid IK与独立手指动作层，待机抱拳面向主角；原调查成功后0.45s放臂，双臂放下再等1.5s，左手指下个目标。原DemoInteractable仅加Activated通知，原记录/任务规则保留。真实PlayMode射线命中及BeginInteraction流程通过，Waiting采样确认，实际等待1.516s、左臂朝目标角差约0.51度，HasWitness=True；保存截图clasp/lowered/point.png。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=2。未回归全部目标分支、极端接近角度或完整序章。详情NPC_Villager_Gesture_Integration.md与Evidence/villager-gesture-20261030；正式审批不变。


## 2026-11-07：最新聚落僵尸替换

最新入口仍是 `Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`。原红色敌人已替换为僵尸，接入蹒跚追击和外张扣抓，保留徽章/断臂检视及原任务流程。Mac 局部播放回归通过；完整键鼠和 Windows 回归待测。详情：[整合与测试记录](Evidence/zombie-integration-20261107/REPORT.md)。
