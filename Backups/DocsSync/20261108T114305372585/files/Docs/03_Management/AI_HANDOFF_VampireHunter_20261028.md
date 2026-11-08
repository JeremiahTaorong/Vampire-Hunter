# Vampire Hunter / 独立 Demo — AI 开发交接

记录日期：2026-10-28（Asia/Shanghai）。本文件根据当前对话、项目文件和证据整理，是交接快照；后续发生变化时更新记录，不得把此文件视为用户批准或新的设计基准。

## 1. 项目范围与用户要求

- 工作根目录：`/Users/dorimiah/Desktop/vampire/`（Finder 中显示为 `Vampire`；macOS 当前路径可解析）。正式游戏工程：`VampireHunter/`；**本轮实际开发目标是独立工程 `VampireHunter_Demo_Independent/`**。用户明确说 Demo 与最终游戏无关，不能把 Demo 的玩法、美术或数据自动当作正式设计。
- 最初用户要求文档驱动：保留已有文件，建立 AGENTS、状态、覆盖与 S01–S13 策划模板；系统逐个审阅，全部获用户明确确认后才能创建正式 Project_Plan / Task_Registry，再进入正式开发。规则详见根目录 `AGENTS.md`，用户后续对独立 Demo 的明确授权优先于一般流程。
- 最终游戏当前 S01 待审，S02–S13 仅模板，明确批准 0/13；基准测试 T01–T16 为 0/16。机器状态以 `Docs/03_Management/workflow_state.json` 为准，`Docs/PROJECT_STATUS.md` 为自动生成。不要将独立 Demo 的测试写成正式游戏通过。
- 用户希望地图不要太小，序章氛围近黑、用灯光和雾营造层次，参考 INSIDE 的氛围，不复制其素材。游戏内字体希望稍大。涉及需要确定美术时，应停止并给用户视觉图审阅；不要把生成的概念图当作实际游戏截图或已批准美术。
- 用户希望使用 Unity Cloud 以便在另一台电脑下载，但云端仓库、项目同步及另一台电脑的打开/下载**未验证**。不得假称已配置或可靠同步。素材包的授权与账号关联，未经确认不要公开原始素材。
- 用户此前报告已测试 WASD、鼠标、闪避，以及 ProloguePrototype 整体流程；具体步骤和覆盖边界未提供。不要把这些报告扩大为新场景或所有测试通过。

## 2. 首次接手与文档规范

1. 阅读 `AGENTS.md` → `Docs/PROJECT_STATUS.md` → `Docs/00_Baseline/BASELINE_INDEX.md` → 与任务相关的冻结 GDD、决策登记、覆盖矩阵、剧情 → 相关系统/审阅/变更记录。
2. 在项目根目录执行 `python3 Tools/docs_workflow.py check`。2026-10-28 本次交接前结果 PASS：5 个原始文件哈希、123 项需求映射、13 份模板与阶段门等文档一致；**这不是 Unity 测试**。
3. 文档变更前执行 `python3 Tools/docs_workflow.py snapshot`；按规范更新机器源 `workflow_state.json`、变更记录，再执行 `python3 Tools/docs_workflow.py sync` 和 `check`。不要手工改生成的 `PROJECT_STATUS.md`。
4. 原始 GDD、决策登记、剧情、覆盖矩阵和开放资源清单留在根目录；实际文件名及冻结与优先级以 `BASELINE_INDEX.md`、`AGENTS.md` 为准。不得覆盖、删除或悄悄更新基准哈希。
5. `Backups/Bootstrap_2026-10-28/originals/` 保存原始备份；`Backups/DocsSync/` 保存文档快照，恢复规则见 `Docs/03_Management/RECOVERY_AND_SYNC.md`。Demo 内 `Evidence/Before*` 保存部分场景工作前备份。
6. 2026-10-28 检查：项目根目录与独立 Demo 均不是 Git 仓库（`git status` 返回 not a git repository）；没有据此声称已提交、推送或具有版本控制。用户要求保留文件，创建新场景/资产前检查同名文件，不覆盖旧场景。

## 3. 环境与工程结构

- 独立工程 `ProjectSettings/ProjectVersion.txt`：Unity **2022.3.62f3 (96770f904ca7)**，URP。当前机器编辑器路径 `/Applications/Unity/Unity.app/Contents/MacOS/Unity`；路径仅适用于本机。
- 场景：`Assets/Demo/Scenes/`；代码：`Assets/Demo/Scripts/`；编辑器工具：`Assets/Demo/Editor/`；材质 `Assets/Demo/Atmosphere/`；着色器 `Assets/Demo/Shaders/`；美术方向和截图 `Art_Direction/`；证据日志 `Evidence/`。
- `README.md` 按步骤记录过往工作，但部分叙述是当时快照，不能覆盖后来的用户反馈或新场景；`Art_Direction/Asset_Sample_Sources.md` 中森林包未取得的描述也早于后续 Pine Forest 导入。
- `Prologue_Greybox_Map.md` 为灰盒地图和剧情流程草案。地面约 120 × 64 Unity 单位，入口至森林敌人直线约 78 单位，未证明满足试玩时长。

## 4. Demo 已做内容与场景

以下为实现/场景存在的记录，不等于当前全部可用：

| 场景 | 内容和范围 |
|---|---|
| `MovementDemo.unity` | 独立移动和后续互动、战斗原型；WASD 与点击移动、证物、敌人、攻击、闪避、胜败/重试、调查与简单推理。具体操作以代码和 README 对应版本核对。 |
| `ProloguePrototype.unity` | 调查与选择森林、敌人战斗、导师标记、完成/重试的独立序章原型。用户报告整体流程通过，未提供详细测试步骤。 |
| `PrologueGreybox.unity` | 扩大的村庄与森林灰盒，三线索、森林入口、战斗、导师标记及古堡方向；后续检查点与结尾改动未进行完整玩法验证。 |
| `PrologueAtmosphere.unity` | 深色材质、灯光、雾氛围版本。人物、建筑和地形多为占位。 |
| `PrologueFogSample.unity` | Kenney 粒子雾尝试；用户反馈烟团重复且小。 |
| `PrologueSoftFog.unity` | 水平程序化多层雾（非真正体积雾），有起始位置 Unity 静态截图；动态、整图和性能未验证。 |
| `PrologueForestReview.unity` | 首版 Pine Forest 样片：树偏小、稀疏；展示截图临时将相机/角色放在森林，而 Play 初始位置仍在村庄。不能将截图当作实际出生点。 |
| `PrologueForestReviewV6.unity` | 森林出生点、更多/更高树木、视线遮挡渐隐；横倒枯木被禁用。视觉预览，不是完整序章。 |
| `PrologueForestDetailReview.unity` | 尝试恢复原素材程序化顶点颜色与针叶细节，仍有明显颗粒/网格。 |
| `PrologueForestAtmosphereReview.unity` | **最新审阅场景**：调整针叶/地面边缘、冷色灯光与分层雾，保留遮挡渐隐和森林出生点。树冠仍块状、地面边缘不自然、雾层次不足，未达到用户提供的原商店展示图或期望的最终美术。 |

角色和敌人仍有胶囊占位；黑色建筑、部分地面和地标仍为灰盒。森林树木用于视觉审阅，摆放工具移除了植被碰撞，不要声称森林有完整碰撞或重新烘焙导航。

## 5. 素材、账号和渲染问题

- **Pine Forest- LowPoly**，Brandon Gillespie，用户指定并已在新 Unity 账号的 My Assets 领取、下载和导入；原 `.unitypackage` 曾位于 `~/Library/Unity/Asset Store-5.x/Brandon Gillespie/3D ModelsEnvironmentsLandscapes/Pine Forest- LowPoly.unitypackage`，项目中为 `Assets/AssetPacks/Pine Forest_LowPoly/`。官方页面：<https://assetstore.unity.com/packages/3d/environments/landscapes/pine-forest-lowpoly-157608>。商店页面标为 Extension Asset，使用与协作应核对 Unity 当前许可与实际归属，保存领取记录，不保证跨账号授权自动转移。
- 旧账号登录全球 Asset Store 曾重定向到 restricted-region；用户新建账号并已领取素材。不要记录或索要密码、验证码，也不要擅自修改账号、地区或云端权限。
- Pine Forest 原模型为低多边形，但其原 Shader Forge 材质利用顶点颜色/透明度、UV 噪声等呈现更细的针叶和地面边缘。原着色器主要面向旧管线；为 URP 做的首版 `ForestPreviewVertex.shader` / `ForestFadeVertex.shader` 过度简化，导致整片树冠。`ForestDetailReview.shader` 恢复部分噪声但颗粒明显；最新 `ForestAtmosphereReview.shader` 使用连续噪声与边缘处理，减少一些屏幕颗粒，但细节和外观仍不理想。**不能说模型网格被提高清晰度，也不能说已复现原展示图。** 当前材质/光照实现与原图之间仍需技术和视觉核验。
- `ForestCameraFade.cs` 在相机与角色视线被植被包围盒遮挡时，使用材质属性逐渐降低可见度并恢复；采用屏幕点阵裁切，不是景深模糊。需实际走动检验抖动、画质与性能。原树木材质适配以及点光对自定义 shader 的影响不能假设已解决。
- **Kenney Particle Pack**：CC0，`smoke_03.png` 用于旧 `PrologueFogSample`；`smoke_06.png` 已保存但该样片未引用。来源、镜像及哈希见 `Art_Direction/Asset_Sample_Sources.md`。`PrologueSoftFog` 后续改用程序化水平雾，不等于体积雾。
- **Quaternius Medieval Village**：此前官方共享下载配额受限，未取得、未导入；**Free Low Poly Nature Forest (Pure Poly)** 是另一包，历史记录为未取得、未导入，不能与已导入的 Pine Forest 混为一谈。将来使用新的外部素材须遵照用户要求先询问，并核实来源、许可和渲染管线兼容性。

## 6. 视觉方向与下一步

- 已有参考概念图 `Art_Direction/Prologue_Dark_Fog_Concept_20261028.png`，它是方向草图，不是 Unity 实拍。用户给过 Pine Forest 商店展示图作为模型细节对照。
- 最新实际播放截图 `Art_Direction/ForestAtmosphereReview_Play.png`，前一版 `ForestDetailReview_Play.png`。当前画面仍显示胶囊人物、块状树冠、地面块和灰盒黑色墙体。
- 应优先诊断原模型 UV/顶点 alpha、原 shader 参数、URP 兼容与抗锯齿，再以同一镜头、相似光照和实机 Game 视图做原效果与新材质对照；对不同植被类别分别检查，不要一套材质无差别覆盖所有资产。没有经过证据验证，不要声称已经恢复原样。
- 与画质一起调近黑基底、冷/暖光、分层雾及角色可读性；避免屏幕被均匀灰雾洗平。用户希望树林更密、树更高，但不要通过过度缩放横倒模型或压住摄像机实现；对枯木和直立树按实际包围盒分别处理。
- 用户请求过近景遮挡时拉近、虚化或透明化；目前仅透明渐隐已实现，**没有虚化**。实机走动评估渐隐是否稳定、景别是否合适，随后给用户 Unity 实际截图/视频和清楚的审阅点。视觉批准之前不要当作最终美术。

## 7. 证据与限制

- `Evidence/user-input-confirmation-20261028.md`：用户报告 WASD 和鼠标已验证，详细步骤/场景未给出。
- `Evidence/user-dodge-confirmation-20261028.md`：根据上下文记录用户报告闪避测试通过，边界未知。
- `Evidence/user-prologue-feedback-20261028.md`：用户报告当时序章原型整体流程通过，不能延伸到后续灰盒或新场景。
- 原型自动测试日志包括 `interaction-playmode.log`、`combat-playmode.log`、`combat-loop-playmode.log`、`dodge-playmode.log`、`investigation-playmode.log`、`prologue-playmode.log`、`greybox-large-playmode.log`。这些测试范围和日期以日志/README 为准；许多直接调用行为，不能代替真实键鼠。
- 最新 `Evidence/forest-atmosphere-playmode.log` 记录播放模式摄像机截图及玩家位置、导航状态；`Evidence/forest-atmosphere-fade-playmode.log` 的人工构造遮挡自动检查记录 faded=0.18、restored=1。该检查证明测试条件下材质属性变化，不证明真实走动时画质、全部遮挡、性能或完整玩法。`Art_Direction/ForestAtmosphereReview_Play.png` 是该场景游戏相机静态渲染，不含完整用户体验。
- 此后用户尚未明确批准最新森林美术。实际玩家输入、行走路线、遮挡稳定性、动态雾与性能，以及新场景完整调查/战斗流程均未验证。

## 8. 建议下一位 AI 的工作方式

1. 从本文件和 `AGENTS.md` 继续，先阅读 `Docs/PROJECT_STATUS.md`、最新状态和相关证据；不要从零重建，也不要覆盖用户文件。
2. 在 Unity 打开 `VampireHunter_Demo_Independent/Assets/Demo/Scenes/PrologueForestAtmosphereReview.unity`；确认当前是否已有未保存改动，保留旧场景并制作新对照场景。
3. 先解释并复核素材与 shader 问题，恢复原始树叶视觉，再同时改进光雾；产生真实 Unity 画面，标明测试条件、未测内容和仍有的缺陷，交用户确认。
4. 不要把独立美术预览、用户的简单“继续”、测试脚本成功或截图生成当作正式系统批准。需要实测的内容按项目规范记录证据；同步状态与变更日志。
5. 云端同步需单独核验项目与账号、版本控制和第二台设备；未经用户授权不得推送、发布或共享。
