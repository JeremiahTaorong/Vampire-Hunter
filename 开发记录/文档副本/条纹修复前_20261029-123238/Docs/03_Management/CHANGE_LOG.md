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
