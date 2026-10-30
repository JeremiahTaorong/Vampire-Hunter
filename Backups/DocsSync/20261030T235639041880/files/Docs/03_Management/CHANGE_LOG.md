# 文档变更日志

| 日期 | 记录 | 范围与依据 | 审批/实测 | 恢复位置 |
|---|---|---|---|---|
| 2026-10-28 | DOCS-BOOTSTRAP | 按本轮用户授权建立 AGENTS、状态、13 独立模板、S01 v0.1 初稿、动态覆盖、审阅/测试索引与本地工具 | 文档检查见 Evidence；S01 待审；没有 Unity 实测 | Backups/Bootstrap_2026-10-28；Backups/DocsSync 下的更新前快照 |

未修改冻结 R/F；无设计变更 CR；无用户系统批准；无 Git commit；无外部发布。DOCS-BOOTSTRAP 是文档变更标签，不是提前分配的开发 Task ID。
后续追加：日期、来源/用户决定、文件及版本、需求/契约/任务影响、验证证据、恢复位置。不得用已批准历史行代表未批准新版本。

| 2026-10-28 | DOCS-DEMO-01 | 增加待审 Demo 目标与第一步范围；记录 Unity 空白工程及云仓库未验证；同步项目状态 | 未批准；无玩法测试 | 更新前 DocsSync 快照 |

2026-10-28 · DEMO-MOVEMENT-01：用户确认范围与移动方案，并明确 Demo 独立于最终游戏；创建独立 Unity 项目和移动场景。Play Mode 烟雾测试见独立项目 Evidence；鼠标/WASD 人工测试未执行，云仓库未验证。

2026-10-28 · DEMO-INTERACTION-02：独立 Demo 增加证物靠近与查看；Unity 播放模式检查通过，真实鼠标/WASD 输入仍未验证；改动前文件见独立工程 Evidence/BeforeInteraction_20261028。

2026-10-28 · DEMO-COMBAT-03：独立 Demo 增加训练目标、追击和自动普攻。Unity 播放模式自动检查通过；鼠标/WASD 人工检查未执行；正式美术未确定，测试占位体不代表风格决定。改动前备份见独立工程 Evidence/BeforeCombat_20261028。

2026-10-28 · DEMO-COMBATLOOP-04：独立 Demo 增加敌人接近/攻击、HP、胜败与重试；Unity 播放模式及原功能回归自动检查通过，键鼠和画面体验未测；备份见独立工程 Evidence/BeforeCombatLoop_20261028。

2026-10-28 · DEMO-DODGE-05：用户报告 WASD 和鼠标已验证；独立 Demo 增加 Space 闪避、短暂无敌和冷却。Unity 自动播放与战斗回归检查通过；Space 实际操作未测。原文件备份见独立工程 Evidence/BeforeDodge_20261028。

2026-10-28 · DEMO-INVESTIGATION-06：用户报告上一轮闪避测试通过；独立 Demo 加入证物、证词和可重试推理。Unity 调查自动播放及战斗回归检查通过；界面和鼠标体验未测。原文件备份见独立工程 Evidence/BeforeInvestigation_20261028。

2026-10-28 · DEMO-PROLOGUE-07：在独立场景中串联调查、战斗、导师标记与重试；Unity 自动播放及战斗回归通过，实际完整试玩未执行。修改前备份在独立工程 Evidence/BeforePrologue_20261028。

2026-10-28 · DEMO-PROLOGUE-REVIEW：用户反馈序章整体流程通过，证据见独立工程 Evidence/user-prologue-feedback-20261028.md；不扩大为最终游戏或 T01–T16 测试通过。

2026-10-28 · DEMO-GREYBOX-08：根据用户要求扩大并细化村庄、林地入口与外围空间；加入分散的三线索调查。Unity 自动可达性/流程测试与旧原型回归通过；未人工走图、未验证时长或最终美术。备份见独立工程 Evidence/BeforeGreybox_20261028。

2026-10-28 · DEMO-FOREST-09：按用户要求加入森林战斗引导、检查点重试、导师标记与结尾提示，界面字体统一放大；Unity 脚本编译与场景生成完成，本轮未运行玩法测试。备份见独立工程 Evidence/BeforeForest_20261028。

2026-10-28 · DEMO-ATMOSPHERE-10：用户确认整体方向并要求黑色、灯光和雾、参考 INSIDE；记录方向概念并生成独立氛围场景。仅脚本编译和场景生成，未运行画面或玩法测试；原灰盒保留，备份见 Evidence/BeforeAtmosphere_20261028。

2026-10-28 · DEMO-FOG-SAMPLE-11：用户同意三包素材；从 CC0 公开镜像导入 Kenney 烟雾纹理并生成分层雾样片。Quaternius 下载配额限制，Unity 森林包尚未领取；本轮不做画面或玩法测试。备份见 Evidence/BeforeFogSample_20261028。

2026-10-28 · DEMO-SOFTFOG-12：用户反馈雾团太小且重复；生成独立连续分层地面雾场景并用 Unity 摄像机渲染静态预览，旧场景保留。角色仍偏暗；动态、键鼠和性能未测。备份见 Evidence/BeforeSoftFog_20261028。


- 2026-10-28：独立 Demo 新增 PrologueForestAtmosphereReview 预览，调整植被颗粒与边缘、冷色灯光和分层雾；实际播放截图及遮挡渐隐自动检查见 Demo Evidence。画面仍有树冠块状和地面边缘缺陷，待用户审阅；未验证实际走动或性能。不改变最终游戏设计审批。


- 2026-10-28：新增 AI_HANDOFF_VampireHunter_20261028.md，汇总独立 Demo、素材来源、已知问题、用户反馈及测试证据；不改变设计审批或开发状态。

- 2026-10-28 · DEMO-FOREST-SHADER-13：用户指出树叶/地面植被与素材商店展示差距大，要求聚焦灯光与柔和雾气。核对原素材确认其无贴图、外观由顶点色 alpha × UV 量化噪声决定；旧 URP 着色器阈值 0.66 与原版 1.5 不符，是树冠块状的直接原因。新增 ForestFoliageURP.shader、SoftMist.shader 与场景 PrologueForestFinalReview.unity（旧场景全部保留）。Unity Test Framework Play Mode 走动测试通过：出货机位遮挡渐隐 49.2% 帧、最小可见度 0.180、0 次突变、相机跟随误差 0.00；走动由脚本移动 Transform 驱动且关闭 NavMeshAgent，不代表导航或键鼠输入通过，性能未测，无虚化。证据见独立工程 Evidence/forest-final-review-20261028.md、forest-asset-inspect.log、forest-walk-playmode.log、forest-walk-results.xml。未获美术批准，不改变最终游戏设计审批。

- 2026-10-28 · DEMO-FOREST-LIGHTS-14：用户要求加强黄色光源并在森林必经目标附近加入暖黄照明。村庄与导师暖灯统一提升到强度 2.8 并放大范围；新增森林检查点、训练敌人、南北入口、古堡远景标记共 5 处暖黄点光，导师标记因已有专用灯未重复添加。工具 ForestObjectiveLights.cs 幂等且可撤销。预览图 Art_Direction/FinalReview/lights_01..06；日志 Evidence/forest-objective-lights.log；坐标表 Evidence/forest-objective-lights-20261028.md。仅有光效无灯体，实际走图引导效果与帧率未验证。

2026-10-29 · DEMO-SETTLEMENT-ATMOSPHERE：用户明确要求实施光雾与渐隐恢复计划，追加村庄灯默认开启。独立 Demo 迁移、局部验证及恢复位置见集中开发记录第三轮；未执行完整玩法测试或性能测试，正式设计审批状态不变。

2026-10-29 · DEMO-SETTLEMENT-STRIPES：按用户两张实机参考图修复植被点阵与体积雾叠加的运动条纹，改为连续透明渐隐。目标 PlayMode 测试修复前后各 1/1 PASS（修复前用于复现），原始证据位于独立工程 Evidence/settlement-stripes-20261029；雾配置及场景本体不变。正式设计批准与基准测试不变。

2026-10-29 · DEMO-GUNSLINGER-IMPORT：用户指定 Sketchfab 本地人物素材，已转换静态网格/URP 材质并生成独立预览与预制体，重载检查通过。源模型缺骨骼和蒙皮，动作尚未接通；用户确认后续配基础动作。未修改聚落玩家或正式审批；详情见集中人物导入记录。

2026-10-29 · DEMO-HUNTER-RIG-ATTEMPT：无 Blender 环境生成 OBJ/贴图 ZIP，Mixamo 完整模型自动绑定未成功，错误为 Unknown error while generating motion。Chrome 登录由用户完成。轻量副本已生成但未上传；用户明确停止，记录过程与未验证项。未取得骨骼 FBX，未验证 Unity Avatar/动作，原模型与场景不变。


- 2026-10-30：独立 Demo 猎人银甲黑袍外观按用户原话批准；新增 Quaternius CC0 动作、独立玩家兼容场景与真实 Play Mode 证据，状态 Testing。正式系统 0/13 批准保持不变。

- 2026-10-30：按用户要求放慢翻滚并接入聚落新场景，实际移动/翻滚验证及截图已记录；原场景保留，正式审批未变。

- 2026-10-30：完成左手肩前探路火把整合，按后续要求攻击时保留持握，实测并保存独立场景/玩家/Markdown，正式审批未变。


### 2026-10-30 — 独立 Demo 火把纠错
用户反馈暗火、旧位置点光、攻击脱握。手持火焰直接复用地面火把 HDR 材质；原主 Light 连同体积光/减雾/MicroAVL 移至火头，强度3.5范围9保留，辅助补光不动。新增 LeftHand 固定掌心挂点，火把同时继承位置与旋转，避免攻击时独立世界朝向脱握。真实 Play Mode 检查三面、移动、0.8秒翻滚、连续攻击与恢复；12次攻击采样挂点位置/旋转误差0，目标HP30→0。保存重开场景与玩家Prefab，测试驱动已移除，Console0错误/2警告。证据见独立工程 Evidence/hunter-torch-correction-20261030；完整键鼠/极限姿态仍待回归。未修改GDD、正式系统审批或原批准外观。

2026-10-30：举火把姿态细化，收回左手并屈肘，手/肘目标随实际步伐同步起伏，通过手腕校正竖直且保持掌心刚性绑定。真实Play Mode16次Run采样手高1.55–1.60m、倾角0度；12次攻击采样挂点误差0，目标HP30→0，0.8秒翻滚与恢复正常。Saved and reopened; probe removed; errors=0 warnings=2。证据 Evidence/hunter-torch-natural-20261030，观感待用户审阅；未改变GDD或正式审批。

2026-10-30：独立Demo任务窄路版已保存至 Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity，TerrainData独立副本。整理六类任务点的约1米窄土路，隐藏21处低矮植被，零散放18块石头/3段短栅栏，疏开拖拽痕迹视线中的9棵树。沿用玩家火把、灯光、任务状态和移动逻辑。真实PlayMode六处接近段均PathComplete/剩余0，保存游戏视角和细节截图；Saved and reopened  probe removed; errors=0 warnings=2。完整出生点连续键鼠流程与观感待用户试玩审阅，未改变GDD或正式审批。详情 Objective_Trail_Integration.md、Evidence/objective-trails-20261030。

2026-10-30：拖拽线索标识改为斜放圆盾（Viking Village pf_shield_03）+金色菱形及DRAG CLUE字样，位置仍(32,.1,-1.4)，保留clueId=trail和2.8m调查范围。Unity真实PlayMode射线选中通过，原BeginInteraction流程后examined/HasTrail为true，调查后提示隐藏。截图见Evidence/trail-clue-marker-20261030/gameplay.png和detail.png。saved and reopened=Assets/Demo/Scenes/PrologueSettlement_HunterTrails.unity; test probe removed; errors=0 warnings=2。未改变GDD或正式审批。

2026-10-30：新建起伏与室内窗光副本 PrologueSettlement_TerracedInteriors.unity，原HunterTrails及资源保留。村落房屋平台0.5–2.73m，道路增设最高1.05m连续坡顶，独立地形及导航重建。关闭32处室外环境灯、保留玩家火把/月光；11屋室内暖灯+25窗位投光，完整配置体积散射/去雾/窗面发光与Bloom。34环境贴图降一级副本、17材质副本，独立URP renderScale.9/阴影优化。真实PlayMode四线索PathComplete，出生点到村内道路实际步行高度0.637–2.625m，终点剩余0.380m；灯光去雾开关0/1通过。2940x1446编辑器三机位短测FPS12.69/14.27/10.75→17.66/19.20/12.73，不代表独立构建长期帧率。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=3。细节见 Terraced_Village_Integration.md 与Evidence/terraced-village-20261030；观感待审，未改变GDD或正式审批。

2026-10-30：按用户新指示恢复广场篝火（3循环粒子、闪烁灯、体积光及去雾），玩家火把强度3.5→6.5/范围9→13m。使用原Character Constructor模块组装村民证人第一版：灰绿布衣、棕裤、皮靴、露脸男性，独立Prefab和NPCVillagerReview场景。原Humanoid/66骨蒙皮保留，Idle实播，7启用模块无空骨；地图原证人调查流程实测HasWitness=True。Saved world=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity probe removed Saved review=Assets/Demo/Scenes/NPCVillagerReview.unity probe removed; errors=0 warnings=2 。停在用户候选外观审阅，不继续AI或更多NPC，不改变正式审批。证据Evidence/villager-candidate-20261030，说明NPC_Villager_Candidate.md；本轮未重新测FPS。

2026-10-30：用户同意村民第一版并要求抱拳/交互指路。当前起伏村落证人接入原Humanoid IK与独立手指动作层，待机抱拳面向主角；原调查成功后0.45s放臂，双臂放下再等1.5s，左手指下个目标。原DemoInteractable仅加Activated通知，原记录/任务规则保留。真实PlayMode射线命中及BeginInteraction流程通过，Waiting采样确认，实际等待1.516s、左臂朝目标角差约0.51度，HasWitness=True；保存截图clasp/lowered/point.png。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=2。未回归全部目标分支、极端接近角度或完整序章。详情NPC_Villager_Gesture_Integration.md与Evidence/villager-gesture-20261030；正式审批不变。
