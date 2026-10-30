# Vampire Hunter — 项目状态

> 自动生成；源：workflow_state.json + requirements.json + 原始 SCM。不要手工改此派生文件。


更新日期：2026-10-30（Asia/Shanghai）。当前阶段：Phase2_S01_Review。

系统明确批准：**0/13**；开发状态为 NotStarted 的系统：**13/13**；基准测试通过：**0/16**。

当前目标：完成独立 Demo。范围已获用户确认；已生成移动原型，自动播放模式烟雾检查通过，实际输入待手动验证。最终游戏系统设计仍须逐份确认。

## 当前行动

独立 Demo 已新增 PrologueSettlement_Hunter 聚落场景，接入用户批准的银甲黑袍猎人，翻滚由0.25秒放慢到0.8秒，距离2.5米与无敌0.15秒保持；实际 Play Mode 移动/翻滚验证通过并截图，自动测试已移除，可手动试玩。原聚落场景哈希不变。需继续完整键鼠/调查/战斗路线回归及握柄、袍摆细化；Console 0 errors/16 warnings（含既有弃用与缺失脚本警告，未全量溯源）。正式系统仍0/13批准，详情见独立工程 Hunter_Modular_Integration.md。

- [Demo 目标与第一步草案](02_Systems/DEMO_GOAL_DRAFT.md)：范围已获确认；独立 Demo 的移动原型进行中。
- [S01 v0.1 待审正文](02_Systems/S01_Player_Control.md)：重点看 §9 的 Q1–Q6。
- [基准与文件名差异](00_Baseline/BASELINE_INDEX.md)；[目录/Git/Unity 检查](03_Management/INITIAL_INSPECTION.md)。
- [13 系统目录与状态](02_Systems/SYSTEM_INDEX.md)；[动态需求覆盖](01_Coverage/System_Coverage_Tracking.md)。
- [审阅记录](03_Management/REVIEW_REGISTER.md)；[变更日志](03_Management/CHANGE_LOG.md)；[测试索引](05_Testing/TEST_INDEX.md)。
- [同步与恢复用法](03_Management/RECOVERY_AND_SYNC.md)；[本次文档校验记录](03_Management/Evidence/BOOTSTRAP_VALIDATION.md)。

## 阶段门与限制

S02–S13 尚未起草；模板不是初稿。全部 13 份明确确认后才生成 Project_Plan.md / Task_Registry.md；当前没有开发任务 ID 或技术方案批准。

原有 5 份 Markdown 保留；本机有原空白 Unity 工程及独立 Demo 工程（2022.3.62f3）。Demo 移动原型已编写，未完成人工输入测试；云版本仓库和跨电脑下载尚未验证；未提交 Git。目标平台/组员/截止日/Rubric 未知。

R/F 123 条都有主责映射，其中 3 条 ENG、2 条 PM。映射率不是细化率、批准率、实现率或测试通过率。T01–T16 的当前状态见测试索引；独立 Demo 的自动播放模式证据见独立工程 Evidence。

## 继续工作

先读根目录 AGENTS.md，按基准索引读取来源。更新前快照，修改后运行 sync 与 check。脚本不自动批准，不执行外部操作，不监视后台变化。初始副本在 Backups/Bootstrap_2026-10-28；导出恢复不覆盖当前文件。
