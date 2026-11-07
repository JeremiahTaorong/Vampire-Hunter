# System Coverage — 当前追踪

> 自动生成；源：workflow_state.json + requirements.json + 原始 SCM。不要手工改此派生文件。


原始 SCM 保持不变；下表严格保留 123 条 ID、唯一主责、协作与原摘要。正文细化需要逐项审阅，不凭映射或文件存在宣称覆盖完成。

| 需求 | 基准摘要 | 主责 | 协作 | 当前策划/模板 | 设计阶段 | 实现证据 |
|---|---|---|---|---|---|---|
| R01 | 血术消耗 BP；Infected 施放产生 C | S04 | S02, S03 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R02 | 普攻命中、击杀和有限补给提供 BP，不得刷取 | S04 | S02, S05 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R03 | 治疗来源为尸体精华与主动血液再生 | S04 | S02, S08 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R03.1 | 精华不增加 C；血液再生在 Infected 增 C | S04 | S02, S08 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R04 | Human 无 BP/精华/血术；04 感染后解锁 | S03 | S04, S09 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R05 | 感染和污染分离；Permanent Fallen 不可普通逆转 | S03 | S04, S10 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R06 | 圣/血强化祭坛仅感染后可用 | S06 | S03, S07 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R07 | Fallen 禁圣系主动；已购圣系强化转通用属性 | S03 | S06 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R08 | 单次祭坛二选一；强化永久累积 | S06 | S12 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R09 | 血祭坛强强化加 C；圣祭坛强化并减 C | S06 | S04 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R10 | 剧情压力有 C 代价；玩家谨慎选择可不永久堕落 | S04 | S09, S10 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R11 | 部分特殊战斗必须血术；有净化补偿路线 | S02 | S04, S07 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R12 | 主线有限基础净化；支线增加容错 | S04 | S07 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R13 | 主线净化点与支线净化圣物一次性；圣祭坛另算 | S04 | S06, S08 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R14 | 有限回溯、关键封锁须提前提示，资源/清房不刷新 | S07 | S11, S12 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R15 | 死亡回最近检查点；永久状态、剧情和清房保留 | S12 | S03, S04, S07 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R16 | 失败战斗产生的 pending C 回滚；永久事件不回滚 | S04 | S12 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R17 | 临时 C 触阈值仅 Temporary Fallen；胜利才可永久锁定 | S03 | S04, S12 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R18 | 净化圣物只能非战斗使用 | S04 | S02, S11 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R19 | Boss 前最后检查点和有限回溯提示 | S07 | S10, S11, S12 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R20 | Permanent Fallen 之后未用祭坛只能血系强化 | S06 | S03 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R21 | Permanent Fallen 锁 C 上限；血技能仍耗 BP | S03 | S04 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R22 | Fallen 攻击血系化、血爪/血刃和血雾外观 | S03 | S02, S13 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R23 | Fallen 免费基础血爪命中赚 BP；高级技能耗 BP | S02 | S03, S04 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R24 | 强制血系 Boss 可通过普攻与周期场地补给获得 BP | S04 | S05, S07 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R25 | Temporary Fallen 自动换血技能；结束可恢复原配置 | S03 | S02, S06 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R26 | 变形不刷新技能槽 CD；已释放攻击继续生效 | S02 | S03 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R27 | Human 渐进解锁圣技；感染解锁首血技，后续解锁第二血技 | S06 | S02, S07 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R28 | Infected 两槽可分别装备圣/血技能；仅非战斗改装 | S06 | S02, S03 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| R29 | 强制战斗需 Preparation、技能检查及主动开战 | S02 | S06, S07 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R30 | 强制战开始 BP 不足则仅补到一次必要技能费用 | S04 | S02, S07 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R31 | Fallen 提高 BP 容量；提升不自动填满 BP | S03 | S04, S06 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R32 | 命中、一次性击杀和精华同时提供不同 BP 来源 | S04 | S05, S08 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R33 | 长按交互引导吸收精华；有效受击打断、成功结算 | S08 | S01, S02, S04 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| R34 | 战斗中精华限时；Cleared 后仅现存精华永久留存 | S08 | S07, S12 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| R35 | 药剂对 Human 正常，对 Infected 弱，对 Fallen 失效 | S04 | S03 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R36 | Fallen 保留药剂库存但禁用 | S03 | S04, S11 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| R37 | 饮药引导可被有效受击打断；成功才耗道具回血 | S02 | S04, S11 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R38 | 药剂有上限；检查点补给与拾取不能反复刷新 | S04 | S07, S12 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R39 | 检查点首次有限回血；死亡回满，重复经过不刷 | S12 | S04, S07 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R40 | 死亡后 BP 设为形态上限基础比例，不叠加 | S12 | S03, S04 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R41 | 主动血液再生引导、可打断；成功扣 BP/回血/增 C | S02 | S03, S04 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R42 | Fallen 血液再生略增强但仍有成本与 CD | S04 | S02, S03 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| R43 | 药剂、血液再生和精华吸收分别有快捷操作 | S01 | S02, S08 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| R44 | 三种治疗动作互斥且开始后不得主动取消 | S02 | S01, S04 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R45 | Dodge i-frames、Hitstun 与短受击保护 | S02 | S01, S03 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R46 | 有效受击打断未释放普通攻击/技能；已释放保留 | S02 | S03 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R47 | 正式 Release 才扣 BP/加 C/进入 CD；前摇打断不结算 | S02 | S04, S12 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| R48 | 最终 Boss 为主角失踪的猎人导师 | S09 | S05, S10 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| R49 | Humanity 须集齐完整解药碎片 | S10 | S07, S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R50 | 结局以 F01 当前精确优先级解释；旧简式索引不覆盖新版 | S10 | S03, S04 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R51 | 最终立场在导师 Boss 战前决定；胜利后结算 | S10 | S05, S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R52 | 旧主题区域构想；**房间数已由 R61 缩为八房** | S07 | S09 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R53 | 序章必须有调查、外围猎杀、导师背景 | S09 | S05, S07 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| R54 | 主线/支线碎片须有日记与环境线索 | S09 | S07, S10 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| R55 | 战前已有 Permanent Fallen 仍能表态但不能治愈 | S10 | S03, S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R56 | 序章目标 5–8 分钟，三环节不得裁剪 | S09 | S07 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| R57 | 三份解药：主线 1，支线 2 | S10 | S07, S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R58 | 导师 Boss 仅一套两阶段框架；立场影响变体 | S05 | S09, S10 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| R59 | 序章用物证、NPC 证词和一次简单推理，不做复杂证据板 | S09 | S08 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| R60 | 05 主线、03 密室、07 钟楼各有一份解药 | S10 | S07, S08 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R61 | 古堡八间房（不含城外序章） | S07 | S09 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R62 | 线性主线、可选支线、实体捷径和有限回溯 | S07 | S12 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R63 | 战斗与探索谜题交替，不是全房间必战 | S07 | S05, S08 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R64 | 图书馆初访展示血印门；感染后可返回开启 | S08 | S07, S09 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| R65 | 感染后提醒可回溯，但不强迫 | S07 | S09, S10 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R66 | 05 首场必用血术精英破盾，不增设中 Boss | S05 | S02, S07 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| R67 | 感染前后、礼拜堂、Boss 前设关键检查点 | S12 | S07 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R68 | 最终战明确确认前 03 和 07 保证可达 | S07 | S10, S12 | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| R69 | 拒绝且三碎片齐、Boss 后非永久 Fallen 才服药 | S10 | S03, S04 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R70 | Phase 1 分别验证序章/墓穴/Boss；Phase 2 做齐八房 | PM | S07, S05 | 后续阶段保留 | Deferred | 无；未实施 |
| R71 | 战前接受是主动继承力量，区别于临时数值状态 | S10 | S03, S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| R72 | 最终 Boss 必须血术，同时保留谨慎路线可能治愈 | S05 | S02, S04 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| R73 | Phase 1 用独立测试入口；Phase 2 接入主线和三结局 | PM | S07, S10 | 后续阶段保留 | Deferred | 无；未实施 |
| R74 | Diablo 式鼠标点击为主，WASD 手动接管 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| R75 | 主题区域内无缝；跨区域异步 Scene 切换 | ENG | S07, S12 | 后续阶段保留 | Deferred | 无；未实施 |
| R76 | 轻量组件化：行为、配置、GameState 职责分离 | ENG | S02, S12 | 后续阶段保留 | Deferred | 无；未实施 |
| R77 | 全局 GameState + 本地 JSON 存档；关键事件保存 | S12 | ENG | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R78 | 统一移动仲裁者使 WASD 优先于点击寻路 | S01 | ENG | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| R79 | 三类基础敌人分别独立决策 AI，可共享底层能力 | S05 | ENG | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| R80 | 血仆近战、血兽扑击、精英防御重击 | S05 | S02 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| R81 | 左键地面/敌人/物品智能识别与对应行动 | S01 | S02, S08 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| R82 | 战斗中退出按失败处理；永久资源/剧情保留 | S12 | S04, S05 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| R83 | 按模块组织代码；独立 AI 复用底层；SO 配技能 | ENG | S02, S05, S12 | 后续阶段保留 | Deferred | 无；未实施 |
| R84 | 保存玩家、房间、机关、奖励等世界进度；持久对象稳定 ID | S12 | S07, S08 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| F01 | 结局优先级：旧永久 Fallen > Accept > Reject+完整药+非 Fallen > Too Late | S10 | S03, S04, S12 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| F02 | Human 隐藏累计 CommittedC；无 BP、不判 Fallen；感染后揭示 | S04 | S03, S11 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| F03 | 固定污染增减且谨慎路线可治愈；支线净化增容错 | S04 | S07, S10 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| F04 | 必要非战斗血术机关设低阈值环境血源，不可囤积 | S04 | S08, S07 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| F05 | Dodge 防御短闪；Skill B 攻击冲刺，圣/血版本不同 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F06 | 点击敌人自动靠近并连续普攻，不自动放高级技能 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F07 | WASD 抢占并暂停自动攻击，松开后仅就地恢复 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F08 | Skill A 朝鼠标落点；Skill B 朝鼠标方向/有效敌人 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F09 | 普通互动点击靠近执行；精华点击靠近、长按 E 吸收 | S08 | S01, S02 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| F10 | 三类敌人独立 AI，增加距离变招与连续组合 | S05 | S02 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| F11 | Holy Water 范围短控；Blood Burst 范围爆发并破盾 | S02 | S05, S06 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| F12 | Skill B 起步有极短 i-frames，短于 Dodge | S02 | S01 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| F13 | 技能结束后目标合法且范围内，非 WASD 时自动恢复普攻 | S01 | S02 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F14 | 02 旋转书架实际改变走廊路线；布局图提供解法 | S08 | S07, S01 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| F15 | 04 主动调查古血印机关触发强制感染 | S09 | S03, S04 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| F16 | 05 强制 Blood Burst 破盾；08 强制 Blood Mist Dash 穿血锁 | S02 | S05, S07, S08 | [S02](../02_Systems/Templates/S02_Combat_Skills_Template.md) | Template | 无；未实施 |
| F17 | 07 根据遗书与钟面推理敲钟顺序 | S08 | S09, S07 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| F18 | 实体捷径/双向区域门；异步 Scene；无任意快传 | S07 | S12, ENG | [S07](../02_Systems/Templates/S07_World_Level_Template.md) | Template | 无；未实施 |
| F19 | Boss 一阶段猎人+少量血术；二阶段血爪/雨/锁 | S05 | S02, S09 | [S05](../02_Systems/Templates/S05_Enemy_Boss_Template.md) | Template | 无；未实施 |
| F20 | 主角不具名；导师工作名 Elias Voss | S09 | S11 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| F21 | 失踪者多数遇难、少数幸存；静态互动不设复杂护送 | S09 | S07 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| F22 | 击败导师解除其控制，战后解药才有效；血源本体不毁 | S10 | S09 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| F23 | 环境叙事、日记、短 NPC 对话与关键短过场 | S09 | S13 | [S09](../02_Systems/Templates/S09_Narrative_Quests_Template.md) | Template | 无；未实施 |
| F24 | Stylized Gothic Dark Fantasy 风格、红金冷蓝灯光与轮廓 | S13 | S07 | [S13](../02_Systems/Templates/S13_Camera_Art_Audio_Template.md) | Template | 无；未实施 |
| F25 | 固定 40–50 度斜俯视镜头、跟随、有限缩放 | S13 | S01 | [S13](../02_Systems/Templates/S13_Camera_Art_Audio_Template.md) | Template | 无；未实施 |
| F26 | Human HUD 仅 HP；感染后显示 BP/C/形态提示 | S11 | S03, S04 | [S11](../02_Systems/Templates/S11_UI_UX_Template.md) | Template | 无；未实施 |
| F27 | 游戏 UI、字幕、日记统一英文 | S11 | S09, S13 | [S11](../02_Systems/Templates/S11_UI_UX_Template.md) | Template | 无；未实施 |
| F28 | 关键短过场、字幕、环境音、BGM；无完整配音要求 | S13 | S09 | [S13](../02_Systems/Templates/S13_Camera_Art_Audio_Template.md) | Template | 无；未实施 |
| F29 | 首轮 Cmax=100（原型值），固定增减与谨慎路线验算 | S04 | S10 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| F30 | 03 血源与门绑定、只补必要 BP、门开永久停用 | S08 | S04, S12 | [S08](../02_Systems/Templates/S08_Puzzles_Interactables_Template.md) | Template | 无；未实施 |
| F31 | 背包满时保留检查点一次性药剂待领取资格 | S04 | S12, S07 | [S04](../02_Systems/Templates/S04_Resources_Corruption_Template.md) | Template | 无；未实施 |
| F32 | Fallen 时已购圣强化按配置比例转换为通用属性 | S06 | S03, S04 | [S06](../02_Systems/Templates/S06_Progression_Loadouts_Template.md) | Template | 无；未实施 |
| F33 | Temporary Fallen 结束 BP 上限复位，溢出 BP 裁剪 | S03 | S04 | [S03](../02_Systems/Templates/S03_Character_Forms_Template.md) | Template | 无；未实施 |
| F34 | JSON 先写临时文件、安全替换并保留有效备份 | S12 | ENG | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| F35 | Boss 失败重试保留回溯锁与首次立场 | S10 | S12 | [S10](../02_Systems/Templates/S10_Endings_Template.md) | Template | 无；未实施 |
| F36 | 不可达目标移向最近真实安全可达点并提示，避免穿墙 | S01 | S07, S08 | [S01](../02_Systems/S01_Player_Control.md) | AwaitingReview | 无；未实施 |
| F37 | 每个持久场景对象稳定 GUID，编辑器校验重复 | S12 | ENG | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |
| F38 | 战斗失败重置临时战斗，已消费永久资源不回滚 | S12 | S04, S05 | [S12](../02_Systems/Templates/S12_Checkpoints_Persistence_Template.md) | Template | 无；未实施 |

[原始 SCM（N 节拍、C 契约、O 开放项、T 测试定义）](../../Vampire_Hunter_System_Coverage_Matrix_v1_2026-10-28.md)。N-P/N-01…N-08/N-E 共 10；C-01…C-11 共 11；O-01…O-11 共 11 均沿用基准，不因本轮建模板关闭。

S01 主责 10 条已在正文 §2 展开且待审；协作系统仍为模板。T11/T12/T13 已关联 S01 设计验收场景，但全部未执行。后续任务 ID 与证据列要在计划获准后扩展，当前未分配。
