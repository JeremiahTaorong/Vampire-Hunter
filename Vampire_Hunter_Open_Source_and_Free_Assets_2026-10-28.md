# Vampire Hunter：GitHub 工程与免费素材资源清单

> ECE3200 Unity 期末项目 · 核验日期：2026-10-28（北京时间）  
> 设计依据：用户上传的 **GDD v4、Complete Story / Narrative v2、Decision Register F01–F38**，同时保留 R01–R84 的已确认边界。  
> 使用背景：教授已批准课程内、非发布作品借用第三方项目；本清单积极采用现成工程和素材，同时把作者授权、免费版本和交付限制明确区分。  
> 核验层级：已查看所列项目主页、作者下载页或许可正文；**未下载全部素材、未逐文件审计第三方依赖、未在 Unity 导入或运行测试**。资源“适合哪个模块”和集成成本是基于设计的判断，不是实测结果。

## 目录

1. [先选这套组合](#1-先选这套组合)
2. [许可怎么读](#2-许可怎么读)
3. [完整工程与架构](#3-完整工程与架构)
4. [输入、导航、镜头和敌人 AI](#4-输入导航镜头和敌人-ai)
5. [存档、稳定 ID、对话和补间](#5-存档稳定-id对话和补间)
6. [场景、角色与道具](#6-场景角色与道具)
7. [角色动画](#7-角色动画)
8. [UI、字体与 VFX](#8-ui字体与-vfx)
9. [音效与音乐](#9-音效与音乐)
10. [序章与八房间资源分配](#10-序章与八房间资源分配)
11. [F01–F38 对应与必须保留的自定义逻辑](#11-f01f38-对应与必须保留的自定义逻辑)
12. [集成顺序与验收](#12-集成顺序与验收)
13. [补充候选及暂不优先项](#13-补充候选及暂不优先项)
14. [下载、记录与署名](#14-下载记录与署名)

## 1. 先选这套组合

**建议新建一个干净 Unity 工程，以现成组件和素材快速搭建；完整示例另外打开，按系统移植。** 这项选择针对的是本项目特殊的输入和存档规则，允许大量使用第三方内容。

优先级含义：**P0**＝先做可玩原型时优先采用/阅读；**P1**＝核心跑通后补足正式内容；**P2**＝备选、进阶或有额外交付条件。P0 不表示每一项都必须安装。集成成本“低/中/高”为相对工作量，未估算天数。

| 模块 | 推荐组合 | 为什么适合本项目 |
|---|---|---|
| 工程骨架 | A01 Chop Chop 架构 + 自己的 GameState | 借用 SO 事件通道、区域加载与系统解耦；保留 GDD 的统一持久状态 |
| 点击移动和手动接管 | B01 Input System + B02 AI Navigation + A03 小型点击移动示例 | 以现成寻路为底座，实现 F06–F09 的自动普攻、WASD 接管和互动 |
| 斜俯视相机 | B03 Cinemachine | 固定约 40–50°、跟随、有限缩放；不启用自由环绕 |
| 三敌人和导师 Boss | 独立 C# AI；需要时加入 B05 UnityHFSM | 共用状态机工具，不共用同一套敌人决策；Boss 使用嵌套阶段 |
| 美术主力 | D01 KayKit Dungeon + D02 Adventurers + E01 KayKit Animations | 环境、角色、动作更容易统一；血兽另外从 D04 选型 |
| 哥特氛围 | D05 Ruins / D08 Graveyard + 统一材质、灯光、雾 | 强化遗迹、墓穴与礼拜堂；尖拱、彩窗和标志性钟楼仍需补做 |
| 特效 | F05 Kenney Particle Pack + Unity Particle System | 烟雾、冲击和光粒直接作为血爆、圣水和精华表现的素材底座 |
| 存档 | 自建 SaveService + C01 GUID；JSON 简单结构用内置序列化，复杂结构选 C02 | 关键是 F34/F38 的安全写盘与事务边界，序列化库只解决其中一环 |
| 日记和终战选择 | 简单 SO 日记/对话；复杂后选择 C04 Yarn 或 C05 Ink **其中一个** | 只有少量分支，无需一开始导入重型任务系统 |
| 声音与 UI | G01/G02 Kenney + G03 Dungeon Ambience + F01 图标 + F03/F04 字体 | 免费或开放许可入口明确，能迅速完成反馈与英文界面 |

**资源数量不是安装清单。** 下面主体共 41 项，包含同模块替代方案；第一轮先取上表的一组，避免同时引入多个导航、存档或对话框架。

## 2. 许可怎么读

教授许可解决课程对借用内容的要求；第三方作者的授权仍按各资源标注处理。这里不把“能免费获取”“GitHub 可见”“开源”混为一谈。

| 标记 | 对本项目的实际含义 | 需要留下什么 |
|---|---|---|
| MIT | 可按许可复制、修改、集成代码；通常不要求把自己的整个游戏开源 | 原版权与许可正文；不能只用片尾鸣谢代替许可证 |
| Apache-2.0 | 可借用和修改；分发时遵守许可证、修改标记及适用的 NOTICE 要求 | LICENSE、适用的 NOTICE、修改说明 |
| CC0 | 所覆盖素材可自由使用、修改、再分发；通常无强制署名 | 建议仍记作者与来源，便于课程报告和追溯 |
| CC BY 3.0 | 可使用和改色，但需要作者署名、来源和许可链接，改编需适当说明 | 逐图标作者、图标名、来源、许可与修改记录 |
| SIL OFL 1.1 | 字体可嵌入游戏；字体本身的再分发与改名有条件 | 字体版权与 OFL 文本；修改时检查保留名称 |
| Unity Companion License（UCL） | 可在有效 Unity 引擎授权关联的项目中按条款使用；不属于通用 MIT/Apache 许可 | 原许可与版权；单独声明的第三方文件另算 |
| 自定义免费许可 / 平台 EULA | 可以免费用于游戏，不代表能把原始素材当资源包公开再分发 | 保存实际下载时条款；区分团队内部、课程工程提交和公开仓库 |
| 授权待确认 | 页面可访问，但不能仅凭此认定复制代码或素材已获许可 | 可作功能/设计参考；直接搬用前确认作者授权 |

官方依据：[GitHub 对无许可证仓库的说明](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)、[Unity Companion License](https://unity.com/legal/licenses/unity-companion-license)、[CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)、[Unity Asset Store EULA](https://unity.com/legal/as-terms)。**“免费 Asset Store 包”也不自动等于开源包。**

## 3. 完整工程与架构

### A01 · Unity Open Project #1 — Chop Chop

- **P0 / 架构阅读与按模块移植 / 成本：中–高。**
- [GitHub 工程](https://github.com/UnityTechnologies/open-project-1) · [系统 Wiki](https://github.com/UnityTechnologies/open-project-1/wiki) · [事件系统](https://github.com/UnityTechnologies/open-project-1/wiki/Event-system) · [Apache-2.0 正文](https://github.com/UnityTechnologies/open-project-1/blob/main/LICENSE)。
- **对应模块：** R75/R76/R77/R83；SceneManagement、SaveSystem、StateMachine、SO 事件通道、音频、对象池、输入与过场的组织方式。
- **借用建议：** 先读事件通道和场景切换，选出几个小模块移植；自己的 `GameState` 继续负责永久世界状态。事件通道用于通知，不代替持久数据源。
- **已核对修正：** 仓库说明项目自 2021 年 12 月起停止开发；当前主分支的 [ProjectVersion.txt](https://github.com/UnityTechnologies/open-project-1/blob/main/UOP1_Project/ProjectSettings/ProjectVersion.txt) 记录 **2020.3.17f1**，不是把早期 2019.4 一概当当前版本。
- **许可边界：** 根许可证是 Apache-2.0；对其覆盖的原创代码/资产按此处理。不能据此把依赖的 Unity 包及任何另附许可的第三方文件统一重新标成 Apache。
- **不直接照搬：** 它的存档不会自动满足本项目的 pending C 回滚、唯一精华、Boss 立场锁定；旧项目整包升级也可能消耗大量时间。

### A02 · Boss Room

- **P1 / 战斗与导航工程参考 / 成本：高。**
- [Unity 官方 GitHub](https://github.com/Unity-Technologies/com.unity.multiplayer.samples.coop) · [许可正文](https://github.com/Unity-Technologies/com.unity.multiplayer.samples.coop/blob/main/LICENSE.md)。
- **许可：UCL。** 可作为 Unity 项目参考或按条款抽取组成部分；不标为 MIT。
- **对应模块：** 点击移动、技能请求/执行、攻击范围、动画表现、场景中的门与导航阻挡；可用于 F06/F11/F16/F19 的实现参考。
- **借用建议：** 在独立工程研究动作和导航关系，移植到单人 `CombatAction`/技能执行器。它是联机 RPG 示例，整套网络生命周期、RPC、Lobby、Relay 不属于本项目需求。
- **核验范围：** 工程定位与根许可已确认；具体可借用的门、技能脚本要按选定分支继续定位，不承诺旧教程中的路径在当前分支保持不变。大型美术下载可能需要 Git LFS。

### A03 · LlamAcademy AI Series Part 1

- **P0 / 点击移动最小样例 / 成本：低–中。**
- [GitHub](https://github.com/llamacademy/ai-series-part-1) · [LICENSE](https://github.com/llamacademy/ai-series-part-1/blob/main/LICENSE)。
- **许可：MIT。** 仓库当前明确列出 MIT，修正“未看到明确许可”的旧结论；包内依赖仍保留各自许可。
- README 明确包含 **Simple click to move、追随玩家的敌人**，要求 Unity 2019.4 LTS 或更高，并使用旧 NavMesh Components。
- **对应模块：** F06–F09、F36 的寻路起点。把旧导航组件替换为目标 Unity 版本支持的 AI Navigation。
- **必须补写：** WASD 优先级、保留锁定目标、松手不恢复旧路径、自动持续普攻、可达性验证和 UI 输入屏蔽；该小样例本身不具备全部 GDD 行为。

## 4. 输入、导航、镜头和敌人 AI

| ID / 优先级 | 资源与获取入口 | 许可证据 | 对应模块与集成建议 |
|---|---|---|---|
| **B01 / P0** | [Unity Input System](https://github.com/Unity-Technologies/InputSystem)，从 Package Manager 安装 `com.unity.inputsystem` | [UCL](https://github.com/Unity-Technologies/InputSystem/blob/develop/LICENSE.md) | F06–F09/F13；分别配置点击、WASD、技能、Dodge、长按 E。由一个移动控制器仲裁位移。成本中 |
| **B02 / P0** | [AI Navigation 官方文档](https://docs.unity3d.com/Packages/com.unity.ai.navigation@2.0/manual/index.html)，安装 `com.unity.ai.navigation` | 包内 UCL；[Unity 许可文件的 UPM 镜像](https://github.com/needle-mirror/com.unity.ai.navigation/blob/master/LICENSE.md)，镜像非 Unity 官方，安装源选 Unity Registry | F14/F18/F36；NavMeshSurface、Agent、Obstacle；旋转书架和门需要动态路径验证。成本中 |
| **B03 / P0** | [Cinemachine 官方源码](https://github.com/Unity-Technologies/com.unity.cinemachine)，安装 `com.unity.cinemachine` | [UCL](https://github.com/Unity-Technologies/com.unity.cinemachine/blob/main/com.unity.cinemachine/LICENSE.md) | F25；固定俯角跟随、有限缩放、关键事件镜头；先锁定与 Editor 兼容的版本，2.x/3.x 教程 API 不混用。成本低–中 |
| **B04 / P1** | [Unity Timeline](https://docs.unity3d.com/Packages/com.unity.timeline@1.8/manual/index.html)，安装 `com.unity.timeline` | 包内 UCL；[Unity 许可文件的 UPM 镜像](https://github.com/needle-mirror/com.unity.timeline/blob/master/LICENSE.md) | F15/F23/F28；感染、Boss 转阶段、三结局短演出。剧情事件经 GameState 幂等提交，不能因重播重复污染/奖励。成本中 |
| **B05 / P1** | [UnityHFSM](https://github.com/Inspiaaa/UnityHFSM) | [MIT](https://github.com/Inspiaaa/UnityHFSM/blob/master/LICENSE.md) | F10/F19；三种 AI 各自实例化和编写独立状态转换；Boss 父状态分 Phase1/Phase2，子状态管预警/释放/恢复。成本中 |
| **B06 / P2** | [Fluid Behavior Tree](https://github.com/ashblue/fluid-behavior-tree) | [MIT](https://github.com/ashblue/fluid-behavior-tree/blob/develop/LICENSE.md) | 可替代 B05 做代码式行为树。适用于团队更熟悉行为树的情况；不要为三个普通敌人同时维护两套 AI 库。成本中–高 |

### 旋转书架的关键技术边界

[官方 Obstacle 文档](https://docs.unity3d.com/Packages/com.unity.ai.navigation@2.0/manual/AboutObstacles.html) 区分两种 carving 模式：默认 **Carve Only Stationary** 会在物体停稳达到时间阈值后重新挖洞；关闭该选项后，达到移动阈值也可更新。导航变化还有下一帧才可查询到的延迟。因此不能简化成“任何 Carve 配置都只能静止更新”。

本项目建议：书架旋转期间暂停受影响的自动交互，旋转落位后等待导航更新并重新验路；若仅旋转造成的拓扑更新不可靠，针对有限合法状态重建/更新导航数据。对每个合法书架状态检查入口、复位机关、主线出口，配合碰撞避免玩家进入书架扫掠区。最近 NavMesh 点不一定真实可达，必须验证完整路径、交互距离和遮挡后才执行动作。

## 5. 存档、稳定 ID、对话和补间

| ID / 优先级 | 资源 / 许可 | 对应模块 | 用法与限制 |
|---|---|---|---|
| **C01 / P0** | [Unity guid-based-reference](https://github.com/Unity-Technologies/guid-based-reference) · [UCL](https://github.com/Unity-Technologies/guid-based-reference/blob/master/LICENSE.md) | F37；门、祭坛、药剂、精华来源、机关、捷径 | 参考 GUID 生成和跨场景引用；自行补齐全项目重复扫描、Prefab 实例复制检测和构建前检查。GUID 引用工具不是完整世界存档。成本中 |
| **C02 / P1** | [Newtonsoft.Json](https://github.com/JamesNK/Newtonsoft.Json) · [MIT](https://github.com/JamesNK/Newtonsoft.Json/blob/master/LICENSE.md) | F34/F38；有字典、迁移等需要的 JSON 快照 | 使用与目标 Unity 兼容的包，不重复导入多个 DLL。只序列化数据，不把 GameObject/Transform 当持久 ID；写盘安全和战斗事务需自建。成本低–中 |
| **C03 / P2** | [Save Game Free](https://github.com/BayatGames/SaveGameFree) · [MIT](https://github.com/BayatGames/SaveGameFree/blob/master/LICENSE) | JSON 保存/加载的可替换工具层 | 可借 serializer/storage 实现；选择 JSON，不把示例默认设置视作 F34 已满足。先审查写盘与备份，再接入自己的 SaveService。成本中 |
| **C04 / P1** | [官方 Yarn Spinner for Unity](https://github.com/YarnSpinnerTool/YarnSpinner-Unity) · [MIT](https://github.com/YarnSpinnerTool/YarnSpinner-Unity/blob/main/LICENSE.md) | F20/F21/F23/F27/F35；证词、导师对话和战前选择 | 使用官方仓库 README 的 Git 安装路径及版本要求；商店付费入口不改变 GitHub 代码的 MIT 许可。旧 fork 不作首选。选择结果交给 GameState，不能仅存在对话局部变量中。成本中 |
| **C05 / P2** | [Ink Unity Integration](https://github.com/inkle/ink-unity-integration) · [MIT](https://github.com/inkle/ink-unity-integration/blob/master/LICENCE.md) | Yarn 替代方案；英文短分支、结局文本 | 自建文字显示 UI；以 GameState 决定结局，Ink 负责呈现和对话流程。只选 C04/C05 其一。成本中 |
| **C06 / P2** | [PrimeTween](https://github.com/KyryloKuzyk/PrimeTween) · [自定义许可](https://github.com/KyryloKuzyk/PrimeTween/blob/main/LICENSE) | HUD、提示、开门、书架表现、镜头过渡 | 当前并非 MIT。许可允许游戏二进制、团队内部源码使用；派生公开工程的依赖方式和源码打包有限制。对外工程优先按其 NPM/包依赖方式引用。补间只管表现，不能决定伤害、无敌或污染提交。成本低 |

**轻量默认选择：** 日记用 SO 数据 + 英文文本；终战只需 Accept/Reject 时，自己做简单对话节点也可完成。JSON 数据简单时，Unity 内置序列化即可起步；不存在必须引入 C02/C03 的要求。

## 6. 场景、角色与道具

下列低多边形资源是风格底座；灯光和调色可以拉近 F24，但不会自动产生哥特建筑细节。主力建议 KayKit 或 Quaternius 选一家，其他只补缺口。

| ID / 优先级 | 作者官方资源页 | 已确认授权与免费范围 | 对应模块 / 成本 |
|---|---|---|---|
| **D01 / P0** | [KayKit Dungeon Pack](https://kaylousberg.itch.io/kaykit-dungeon-pack) | CC0；页面列免费标准版约 200 件；EXTRA、SOURCE 另付费。旧 Dungeon Remastered 链接已重定向到现名 | 八房间的墙、地板、台阶、门和家具底座；Library 补书架，Chapel 补彩窗。低–中 |
| **D02 / P0** | [KayKit Adventurers](https://kaylousberg.itch.io/kaykit-adventurers) | CC0；免费版 5 个角色及配件；额外角色/替代纹理另付费 | 主角和导师人形底座，先复用骨架，靠武器、材质、披风/轮廓区分。不是现成吸血鬼猎人造型。中 |
| **D03 / P1** | [KayKit Skeletons](https://kaylousberg.itch.io/kaykit-skeletons) | CC0；免费版 4 个角色；Skeleton Golem、Necromancer 是额外付费内容 | 血仆、精英的战斗占位；若保留到最终展示，应改造成吸血鬼语义或替换，不能只换名。低–中 |
| **D04 / P0** | [Quaternius Ultimate Monsters](https://quaternius.com/packs/ultimatemonsters.html) | 页标 CC0；提供模型与动画入口，文件格式含 FBX/glTF 等 | 血兽的非人形候选，兼作 Fallen 外观参考；实际挑一个符合扑击轮廓的模型，检查骨架与动作。中 |
| **D05 / P1** | [Quaternius Ultimate Modular Ruins](https://quaternius.com/packs/ultimatemodularruins.html) | CC0；模块化遗迹/地牢与道具，FBX/OBJ/Blend | 庭院、墓穴、破败礼拜堂；破损石结构的补充底座。低–中 |
| **D06 / P1** | [Quaternius Medieval Village](https://quaternius.com/packs/medievalvillage.html) | CC0；提供中世纪村落建筑资源 | 城外序章村庄、失踪现场外围；只搭需要的几栋房与猎杀通路。低 |
| **D07 / P1** | [Kenney Castle Kit](https://kenney.nl/assets/castle-kit) | CC0；官方当前页列 75 件 | 古堡外墙、入口、塔体灰盒及远景；不要默认包含完整室内哥特装饰。低 |
| **D08 / P1** | [Kenney Graveyard Kit](https://kenney.nl/assets/graveyard-kit) | CC0；官方当前页列 90 件，含动画标记 | 墓穴入口、墓地、序章恐怖线索；先筛模型再导入。低 |
| **D09 / P2** | [KayKit Halloween Bits](https://kaylousberg.itch.io/halloween-bits) | CC0；免费版 60+ 模型；额外版本另付费 | 与 KayKit 主风格更一致的墓地替代包；和 D08 二选一优先。低 |
| **D10 / P2** | [Poly Haven 素材与授权](https://polyhaven.com/license) | 素材 CC0；网页标志/展示内容另有规定。此项是素材库入口，未指定单件 | 石材、木材、HDRI 候选；写实纹理可能与低模冲突，先小样测试，HDRI 不替代室内布光。中 |
| **D11 / P2** | [ambientCG 素材授权与入口](https://docs.ambientcg.com/license/) | 可下载素材 CC0；此项是素材库入口，未指定单件 | 石地板、旧木、金属表面。限制纹理分辨率与细节密度，避免局部写实破坏统一性。中 |

KayKit 页面对未改动素材转售表达了作者请求；同时明确标为 CC0。课程内组装、改色和使用属于页面明确允许的用途。**“免费模型”与“可编辑 .blend 源文件免费”需分开判断。**

尚未确认有现成且完全匹配的：旋转书架成套谜题、可读钟面机关、血锁机关、三份专属解药碎片、导师吸血鬼变身模型。建议用基础几何/现成模型改造，不为等素材改变已锁定玩法。

## 7. 角色动画

| ID / 优先级 | 官方资源页 | 许可 / 免费范围 | 本项目用法 |
|---|---|---|---|
| **E01 / P0** | [KayKit Character Animations](https://kaylousberg.itch.io/kaykit-character-animations) | CC0；页面称全部动画免费，当前列 161 个，免费档为 150+；.blend 源文件为付费档 | KayKit 人形首选：移动、受击、死亡、Dodge、近战与施法类别；Rig_Medium/Large 覆盖量不同。中 |
| **E02 / P1** | [Quaternius Universal Animation Library](https://quaternius.itch.io/universal-animation-library) | CC0；有免费 Standard；当前另列付费 Pro/Source。120+ 是整套介绍，不能直接承诺免费档全含 | 人形移动与通用动作补缺；已有无 Root Motion 和有 Root Motion 版本说明。中 |
| **E03 / P1** | [Quaternius Universal Animation Library 2](https://quaternius.itch.io/universal-animation-library-2) | CC0；整套介绍 130+；当前下载区列 Standard 与付费 Source，未列独立 Pro 档。未下载核数，**不沿用“免费只含 45 个”的旧结论** | 近战连段、僵尸移动等候选；先核对免费 ZIP 中所需动作是否实际存在。中 |
| **E04 / P2** | [Mixamo](https://www.mixamo.com/) · [Adobe 官方 FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html) | Adobe 自定义服务条款，非开源；FAQ 确认 Adobe ID 免费使用和个人/商业游戏免版税；[补充条款](https://wwwimages2.adobe.com/content/dam/cc/en/legal/servicetou/Mixamo-Addl-Terms-en_US-20210623.pdf) | 人形战斗动作补缺。官方 FAQ 同时列中国国家代码账户不可用等服务限制，故不把它作为唯一来源。原始文件分享、工程交付按当时账户适用条款核对，不承诺任意公开再分发。中 |

动画集成的必要改造：

- **位移只有一个仲裁者。** 首轮选 in-place 动作，由 PlayerMovementController 管 Agent/WASD/Dodge/Skill B；若选 Root Motion，必须显式纳入同一仲裁，不能双重位移。
- **动画与规则分开。** 每个攻击/技能定义 Windup → Release → Recovery；Release 才扣 BP、增加 C、进 CD。触发器多次回调或动画事件重复不能重复扣费/伤害。
- **Dodge 与 Skill B 独立窗口。** Dodge 防御窗口更长；Skill B 只有起步短窗口。Mist Dash 穿敌和标记血锁，不穿普通墙。
- **三种治疗互斥。** 药剂、精华吸收、血液再生引导不能主动取消；有效受击可中断，成功才提交消耗与恢复。
- **明确的动作缺口：** 咬自己手腕的血液再生、专属 Blood Burst、血雾冲刺变形未确认有现成完全匹配动作。可改通用施法动作、调整上半身姿势、配 VFX；血兽应优先使用其模型原生非人形动画。

## 8. UI、字体与 VFX

| ID / 优先级 | 资源 / 许可证据 | 对应模块与集成建议 |
|---|---|---|
| **F01 / P1** | [Game-icons.net 授权说明](https://game-icons.net/about.html)；例如 [Lorc 的 Holy symbol](https://game-icons.net/1x1/lorc/holy-symbol.html)，**CC BY 3.0** | 圣/血技能、药剂、污染、解药和日记图标候选；逐个记录作者，不统一写“Game-icons 作者”。SVG 转适当分辨率 PNG 或走矢量流程。低 |
| **F02 / P0** | [Kenney Input Prompts](https://kenney.nl/assets/input-prompts)，**CC0** | 左键、WASD、长按 E、技能键、Dodge 教学；与实际绑定一致，英文提示。低 |
| **F03 / P1** | [Inter 字体源码/下载入口](https://github.com/rsms/inter/blob/master/LICENSE.txt)，**SIL OFL 1.1** | HP/BP/C 数值、正文、字幕；用可读字号。保留字体许可。低 |
| **F04 / P1** | [Cormorant Garamond 字体目录与许可](https://github.com/google/fonts/blob/main/ofl/cormorantgaramond/OFL.txt)，**SIL OFL 1.1** | 标题、章节名和日记抬头；正文与数值仍用清晰字体。低 |
| **F05 / P0** | [Kenney Particle Pack](https://kenney.nl/assets/particle-pack)，**CC0** | 80 张粒子素材入口；是纹理资源，不是装好即用的血术系统。配 Particle System 做精华、血爆、圣水、烟雾。中 |
| **F06 / P2** | [Unity VisualEffectGraph-Samples](https://github.com/Unity-Technologies/VisualEffectGraph-Samples) · [UCL](https://github.com/Unity-Technologies/VisualEffectGraph-Samples/blob/master/LICENSE.md) | 血雨、溶解、能量流动的图形思路参考；不同样例/分支可能依赖 HDRP 或特定版本，不能整包导入就假定适配 URP。高 |
| **F07 / P1** | [Wallcoeur Free Fire Toon Particle](https://wallcoeur.itch.io/unity-urp-vfx-fire-toon-particle)，**作者自定义免费条款** | 页面列 14 个免费 URP Particle System 火焰效果，允许用于项目、禁止转售素材；适合火把、祭坛、爆发表现的补充。不要标成 CC0/MIT。检查课程工程原始包交付范围。低–中 |

UI 实现建议：用 Unity UI 画布和文字组件搭 HUD、日记、证词与最后回溯确认面板；不引入整套 MMO 背包 UI。Human 仅显示 HP；感染后再显示 BP/C/形态。Temporary Fallen 和 Permanent Fallen 用不同文字/图形反馈，不只靠颜色区分。

VFX 制作建议：

| 技能/机关 | 直接借用的视觉材料 | 自己实现的效果与规则 |
|---|---|---|
| Holy Water | F05 光点、冲击纹理；金/冷蓝统一材质 | 圆形范围预警、落地爆散、普通敌人短控；Boss 抗性独立 |
| Blood Burst | F05 烟雾、冲击；可参考 F07 的爆发节奏 | 红色范围爆发；破盾由技能类型和目标规则决定，不能由粒子碰撞随意判定 |
| Blood Mist Dash | 烟雾纹理、Trail、角色材质淡出 | 控制器管理方向、短无敌和合法碰撞；每目标每次释放仅结算一次 |
| 血锁 / 血雨 | 自制发光带状网格、粒子、地面圆形提示 | 血锁必须有明确穿越标记；血雨先预警再伤害，不能靠特效播放长度决定伤害时刻 |
| 尸体精华 / 机关血源 | 光球、上升粒子、吸收线 | 与 StableID、过期、Consumed、门永久打开状态绑定，读档不复制奖励 |

## 9. 音效与音乐

| ID / 优先级 | 官方资源与授权 | 对应模块 / 使用方式 |
|---|---|---|
| **G01 / P0** | [Kenney Impact Sounds](https://kenney.nl/assets/impact-sounds)，**CC0**，当前列 130 个文件 | 命中、物体碰撞及材质反馈候选；不是完整吸血鬼音效套装。实际挑选后归一音量，按事件随机少量变体。低 |
| **G02 / P1** | [Kenney Interface Sounds](https://kenney.nl/assets/interface-sounds)，**CC0**，当前列 100 个文件 | UI 点击、确认、日记打开、技能不可用反馈。低 |
| **G03 / P0** | [Dungeon Ambience — yd](https://opengameart.org/content/dungeon-ambience)，作者页明确 **CC0**，提供 `dungeon002.ogg` | 墓穴/探索氛围 BGM 候选；已核对作者、许可和文件入口，尚未试听评估循环接缝。低 |
| **G04 / P1** | [Sonniss GameAudioGDC 官方下载归档](https://sonniss.com/gameaudiogdc/) · [GDC Bundle License](https://sonniss.com/gdc-bundle-license/)，**自定义免版税许可，非 CC0** | 从目录筛木门、金属、石室、风声、怪物、钟声等类别；不是每个具体音效已确认存在。只导入实际采用部分，避免整个数十 GB 库进入工程。中 |

Sonniss 当前许可 **v2.0，2026-08-27 生效**：允许用于个人/商业项目，无强制署名；允许项目团队内共享，限制把声音作为声音资源再供应/再分发。适用的是下载当日网页许可，不能只保留旧 ZIP 内许可。若需给非团队提交可提取原音频的完整工程，优先 CC0 或先核对交付方式。该库不能与训练素材混用。

F28 不要求全程配音，因此不需要先找配音系统。用 Unity AudioSource/AudioMixer 完成 BGM、环境声、SFX、UI 分组和淡入淡出即可。**Boss 战音乐、钟楼具体音高素材尚未指定并试听**；先以合法氛围音乐占位，钟声样本确定后再建立可辨认的敲击序列。

## 10. 序章与八房间资源分配

八间房不等于八个独立 Scene。按 GDD：`Prologue`、`Courtyard`、`Library(02+03)`、`Crypt(04+05)`、`Chapel(06+07)`、`ThroneRoom(08)`，另设独立测试 Scene。

| 区域/房间 | 优先资源 | 必须体现的设计 / 还需自制 |
|---|---|---|
| **Prologue 城外** | D06 村落、D02 角色、E01 动画、F02 提示、G01 音效 | 失踪现场证物 → NPC 证词 → 简单推理 → 森林猎杀 → 导师线索，目标 5–8 分钟；静态 NPC 即可，无复杂护送 |
| **01 Courtyard** | D07 城堡 + D05 遗迹，D02/D04 角色 | Human 战斗、点击移动和 Dodge 教学；感染前不提供必用血系交互 |
| **02 Library Hall** | D01 环境；自制/改造书架、布局图；B02 导航 | 旋转书架真实改变通路；所有合法状态可回安全区；03 血印门首访明显可见 |
| **03 Secret Library** | D01 小室、F05 血印/血源、英文日记 | 可选碎片；BP=0 仍可开门；血源只补必要低阈值，门开后永久停用 |
| **04 Crypt Entrance** | D08/D09 墓地、D05 石室、B04 过场 | 调查血印触发固定感染；感染前后检查点、HUD 切换；C 初次开放不能直接永久堕落 |
| **05 Blood Ritual Hall** | D01 祭坛/室内、D03 精英占位、F05 爆发 | Blood Burst 破盾、主线碎片、少数幸存者；准备区先检查技能/BP；不额外新增中 Boss |
| **06 Ruined Chapel** | D05 破损建筑、D01 台阶/祭坛、F07 火焰 | 一次性主线净化、圣血二选一成长；Blood Mist Dash 教学；彩窗/圣物可用简单模型补做 |
| **07 Bell Tower** | D07 塔体、D01 台阶；自制钟/钟面 | 遗书+钟面推理；敲错可重试，不永久封门；第三碎片；音乐库不替代谜题规则 |
| **08 Throne Room** | D01 室内、D02 导师、E01/E03 动作、F05 血术 | 最后回溯确认 → 立场 → 同一两阶段 Boss；血锁、普通攻击 BP 窗口与周期补给；胜利后唯一结局 |

三结局可复用王座厅和短演出镜头：Inheritance 红光王座、Humanity 黎明出城、Too Late 共用场景但区分永久 Fallen/缺碎片尾声。复用美术不改变 F01 的判定顺序。

## 11. F01–F38 对应与必须保留的自定义逻辑

通用 ARPG、AI 或存档插件无法直接提供这些项目特有规则。以下所有条款都需由本项目逻辑落实；资源只降低底层与表现制作成本。

| 决策覆盖 | 可借用资源 | 自定义逻辑 / 验收重点 |
|---|---|---|
| **F01、F35** | C04/C05 对话、B04 演出、C01 稳定 ID | 最终确认锁回溯；对话前保存旧 Permanent Fallen 快照；选择首次持久化；旧 Fallen → Too Late，否则 Accept → Inheritance，否则 Reject+三碎片+战后非 Fallen → Humanity，其余 Too Late；死亡重试不改立场 |
| **F02、F03、F29** | C02 序列化、F01/F03 HUD | Human 隐藏 CommittedC、不判 Fallen；感染后首次低于阈值；固定增减；Cmax=100 仅原型起点，不默认等于 Fallen 阈值。谨慎路线要逐节点验证 |
| **F04、F30** | D01 场景、F05 粒子、C01 GUID | 03 血源补至一次开门费用低阈值，不叠加；开门后永久停用；补 BP 本身不加 C，技能正常付费和增 C |
| **F05、F12、F16** | E01/E02/E03 动画、B02 导航、F05 VFX | Dodge 与攻击冲刺分开；Burst 破指定盾；Mist Dash 穿敌/指定血锁但不穿普通墙；阶段解锁与装备检查 |
| **F06、F07、F08、F09、F13** | A03 样例、B01 输入、B02 导航 | 点击持续普攻；WASD 暂停攻击保留目标；松手不恢复旧路径；A 点选/B 方向瞄准；精华长按 E；动作后合法恢复普攻但不刷新间隔 |
| **F10、F11、F19** | B05 或 B06、A02 战斗参考、D04 怪物 | 血仆连击、血兽扑击、精英盾与距离变招各自独立 AI；Boss 两阶段同一框架；圣水控制对 Boss 有独立抗性 |
| **F14、F17、F36** | B02 导航、D01 环境、G04 声音候选 | 书架空间谜题、钟声序列均需自制；错误可复位；不可达目标只走真实安全可达点，停下提示，不穿墙互动 |
| **F15、F18** | B04 过场、A01 SceneManagement | 感染事件只发生一次；实体双向区域门、异步加载和快捷门；终战确认前 03/07 始终可回，不新增任意传送 |
| **F20、F21、F22、F23、F27、F28** | C04/C05、B04、F03/F04、G03/G04 | 主角不具名、导师暂名 Elias Voss；少数幸存静态叙事；击败导师切断控制后才可治愈，不毁灭血之源；英文文字、短演出，无完整配音要求 |
| **F24、F25、F26** | D01/D05/D07/D08、B03、F01–F05 | 统一哥特暗黑表现、固定斜俯视；感染后才显示 BP/C；临时/永久形态反馈不能混淆 |
| **F31、F32、F33** | C01/C02、F01 UI | 满背包保留药剂待领资格；圣系成长按配置比例一次性转通用属性；临时容量恢复后裁剪超额 BP |
| **F34、F37、F38** | C01/C02/C03、A01 | 稳定 GUID、重复检测；完整快照临时写盘、安全替换、上一份有效备份；pending 战斗污染失败回滚，永久消费/奖励状态不回滚 |

另须保留 R 轮的 Release 时点付费、三治疗互斥、唯一敌人奖励、精华过期与 Cleared 后现存精华保留等机制。**不得把某个现成存档库接入成功视作这些事务规则已经实现。**

建议自建模块（这些名称是实施建议，不是已存在脚本）：

| 模块 | 职责与对外接口方向 |
|---|---|
| `PlayerMovementController` / `ActionController` | 唯一位移仲裁、目标保持、输入优先级、动作互斥、恢复普攻 |
| `CorruptionService` / `CombatTransaction` | Committed/Pending 分离、临时/永久形态、胜利提交与失败回滚 |
| `WorldState` / `RewardLedger` | StableID、一次性物品、敌人唯一奖励、精华 consumed/expired/preserved、满包待领 |
| `SaveService` | SchemaVersion、全量一致快照、临时文件/替换/备份、战斗中退出按失败恢复 |
| `ThrallAI` / `BeastAI` / `EliteVampireAI` / `MentorBossAI` | 各自独立决策；共享血量/感知/受击底层；Boss 两阶段及血锁机制 |
| `EndingResolver` | 纯数据判定，读取战前快照、立场、三碎片与战后状态，输出唯一 EndingID |

## 12. 集成顺序与验收

这是一份资源集成建议，不替代单独的 Development Plan。Unity 版本、目标平台、组员人数和课程截止日期尚未给出，因此不虚构兼容版本结论或排期。

### 第一步：锁定工程环境与最小素材组合

1. 采用课程支持的 Editor 版本，记录渲染管线；若无既定工程，可先评估 URP。官方图形源码及其 [UCL](https://github.com/Unity-Technologies/Graphics/blob/master/LICENSE.md) 仅是参考，包版本以目标 Editor 为准。
2. 安装 B01/B02/B03；导入一个 D02 主角、一个 D04 血兽、D01 的少量墙地和 E01 必需动作。
3. 先验证材质、尺寸、碰撞、骨架、动画、相机与点击位置，再批量取包。所有第三方文件集中到各自目录，保留许可文件。

### 第二步：Phase 1 三个独立原型

| 原型 | 首要借用项 | 通过标准 |
|---|---|---|
| **序章** | A03/B01/B02/B03，D02/D06，E01，F02 | 调查、证词、推理、猎杀、导师线索均可玩；Human 无 BP；WASD/鼠标切换正确 |
| **墓穴** | B05 可选，D01/D04，F05，C01/C02 | 感染只触发一次；Burst 破盾；最低 BP；Release 结算；临时污染失败回滚、永久消费保留 |
| **导师 Boss** | A02 参考，B04/B05，D02/E01，F05 | 两阶段、Mist Dash 血锁、BP 可再生、立场与封锁持久；Accept 后终战新 Fallen 仍 Inheritance |

### 第三步：完成八房间内容与回溯

按 `01→02→04→05→06→08` 主线以及 `03/07` 自愿支线搭建六个区域 Scene。加入书架、钟楼、双向捷径、日记和三份碎片。**Phase 1 的独立原型不代表删减 Phase 2 八房间。**

### 第四步：补足表现与最终检查

1. 再导入 UI/字体、环境音、所需 VFX；用暗红/金/冷蓝区分血系、圣系和空间，不让整体过暗影响敌人前摇可读性。
2. 用 GDD T01–T16 作为验收依据：先过 T01/T02/T03/T06/T07/T14/T15，再测书架 T08/T13、钟楼 T09、唯一奖励 T10、动作 T11/T12、容量与升级 T16。
3. 安全写盘要在目标平台模拟中断、损坏文件与备份恢复；把“战斗失败回滚 pending”与“永久物品消耗保留”一起检查。
4. 实际导入后才记录 FPS、包体与兼容性；本次网页核验没有得出性能通过结论。

## 13. 补充候选及暂不优先项

| 候选 | 本次核验结果 | 处理建议 |
|---|---|---|
| [lococoder-tx/Diablo-Clone](https://github.com/lococoder-tx/Diablo-Clone) | 仓库可访问；描述为 Unity 2019.1.11f 的 Diablo 风格原型，含装备、AI、自定义存档。当前主页未找到明确根 LICENSE；没有逐文件核查 Synty 或其他素材来源 | **保留为 P2 功能参考。** 可对照点击战斗和系统拆分；不把其全部代码/美术列作已确认授权可复制 |
| [Unity Behavior](https://docs.unity3d.com/Packages/com.unity.behavior@1.0/manual/index.html) | 官方文档确认有图形化行为树包；本次没有取得所选安装版本的完整许可正文 | Unity 版本合适时可评估；包许可/依赖待安装核对。三普通敌人仍按独立脚本决策，不因图形工具改变 F10/R79 |
| [Incompetech 音乐](https://incompetech.com/) | 本次未逐首核对授权与下载入口 | 作为继续找 Boss BGM 的入口，不概括成全站一个 CC BY 版本；选曲后记录曲名、作者、具体许可和署名文本 |
| [Freesound](https://freesound.org/) | 素材逐条授权，本清单未选定并核对具体声音 | 钟声/环境音补缺时优先筛 CC0；筛选结果页本身不代替单条声音许可 |
| BBC 音效及其他“仅非商业/教育”资源 | 没有作为本清单的确定采用项 | 课程用途下仍可作为进一步核对候选；不因“免费试听/下载”就认定工程原文件可任意分发 |
| 盗版 Asset Store 包、其他游戏提取素材、无来源镜像 | 不属于已确认可用资源 | 当前已核验的正式来源足够完成主体，无需依靠来源不明包 |

### 对用户补充清单的采纳与修正

- **采纳：** Chop Chop 架构、Boss Room 动作/导航参考、AI Navigation、KayKit/Kenney 环境、Quaternius 动画、Mixamo 备选，以及自己制作项目特有血术表现的方向。
- **更新：** LlamAcademy Part 1 当前有 MIT；Chop Chop 当前主分支版本为 2020.3.17f1；Yarn 使用官方 YarnSpinnerTool 仓库；Dungeon Remastered 现已改名 Dungeon Pack。
- **收紧证据范围：** 不把“120+/130+ 动画”直接等同于免费档数量；Library 2 当前下载档与旧说明不同；不宣称未导入的包已适配 URP；不把跨平台库或存档库当作游戏特有规则的成品。
- **保留大胆借用空间：** 有明确许可的代码、模型、动作和整套系统都可以采用；按模块改造是降低整合成本的建议，不是禁止使用现成工程。

## 14. 下载、记录与署名

### 获取方式

- **GitHub 工程/库：** 通过页面 Code → Download ZIP、Release 或 Git 获取；大型工程先看 Git LFS 要求。采用时记录具体 tag/commit，本清单中的分支链接是发现入口，尚未冻结依赖版本。
- **Unity 官方包：** 在 Package Manager 选择目标 Editor 支持的版本；AI Navigation/Timeline 的镜像许可链接仅用于核对文件，不建议拿镜像替代 Unity Registry 安装。
- **itch.io 免费档：** 在作者页 Download Now 选择免费或跳过捐赠入口，只领取明确免费的档位；Source/Pro/EXTRA 是否收费分别看当前页面。
- **Kenney：** 官方包页 Download，可继续选择不捐赠；单独包免费不代表 All-in-1 汇总商品也免费。
- **受自定义许可限制的包：** 先保存下载当日条款。游戏构建、团队工程和对外完整源工程分开登记；教授许可不要求把第三方原始包重新上传到公开仓库。

建议第三方记录表至少包含以下字段，实际采用后再填写，不把全部候选写成已经使用：

| 字段 | 示例或填写要求 |
|---|---|
| ResourceID | 本文 A01、D01 等编号 |
| Name / Author | 精确项目/素材名和作者 |
| SourceURL / LicenseURL | 作者页及实际许可来源 |
| Version / Commit / DownloadDate | 锁定版本与下载日期 |
| ImportedFiles / Module | 实际导入的文件与用于哪个模块 |
| Modifications | 改色、裁切、脚本移植、动作改造等 |
| LicenseCopy | 本地保存的许可正文/网页快照位置 |
| Attribution | 是否需要署名、实际署名文本 |
| SharingScope | 构建、团队内部、课程完整工程、公开仓库各自是否适用 |

片尾与课程报告可用下面的格式，**只填入实际使用的项目**：

```text
Third-party resources

[Resource title] — [Creator]
Source: [Exact resource URL]
License: [Exact license and URL]
Changes: [Recoloured / adapted / code modified / none]
```

例如若实际使用 Holy symbol 图标：`Holy symbol — Lorc; game-icons.net; CC BY 3.0; recoloured for Vampire Hunter`，同时保留该图标页与许可链接。MIT/Apache/UCL/OFL 的完整许可另随实际采用文件保留，不能只放这一句鸣谢。

---

**清单结论：** 本项目可以大量使用现成架构、导航、角色/环境/动画和声音素材；最值得保留为自主实现的部分，是混合输入、血系技能提交时点、Corruption 战斗事务、持久唯一奖励、书架/钟楼谜题以及三结局优先级。它们是设计的辨识度，也是通用框架不能替代的核心。
