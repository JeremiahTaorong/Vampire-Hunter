# Vampire Hunter — 项目状态

> 自动生成；源：workflow_state.json + requirements.json + 原始 SCM。不要手工改此派生文件。


更新日期：2026-11-07（Asia/Shanghai）。当前阶段：Phase2_S01_Review。

系统明确批准：**0/13**；开发状态为 NotStarted 的系统：**13/13**；基准测试通过：**0/16**。

当前目标：完成独立完整序章 Demo，只使用免费资源。Windows 血迹、断臂、原创徽章及检视保留；最新聚落僵尸外观和动作已接入，Mac 局部战斗/流程联动测试通过。完整连续试玩及美术观感待审，最终游戏系统仍逐份确认。

## 当前行动

完整序章 Demo 的最新聚落场景已将红色敌人替换为蹒跚追击、外张扣抓的僵尸；Mac 局部 Play Mode 验证追击、检视暂停、命中/落空、检查点重试及导师线索完成通过。下一步完整出生点连续键鼠试玩、观感审阅与 Windows/构建回归。正式系统仍为 0/13 批准。

- [Demo 目标与第一步草案](02_Systems/DEMO_GOAL_DRAFT.md)：独立 Demo 授权边界；最新实现及证据见当前行动。
- [S01 v0.1 待审正文](02_Systems/S01_Player_Control.md)：重点看 §9 的 Q1–Q6。
- [基准与文件名差异](00_Baseline/BASELINE_INDEX.md)；[目录/Git/Unity 检查](03_Management/INITIAL_INSPECTION.md)。
- [13 系统目录与状态](02_Systems/SYSTEM_INDEX.md)；[动态需求覆盖](01_Coverage/System_Coverage_Tracking.md)。
- [审阅记录](03_Management/REVIEW_REGISTER.md)；[变更日志](03_Management/CHANGE_LOG.md)；[测试索引](05_Testing/TEST_INDEX.md)。
- [同步与恢复用法](03_Management/RECOVERY_AND_SYNC.md)；[本次文档校验记录](03_Management/Evidence/BOOTSTRAP_VALIDATION.md)。

## 阶段门与限制

S02–S13 尚未起草；模板不是初稿。全部 13 份明确确认后才生成 Project_Plan.md / Task_Registry.md；当前没有开发任务 ID 或技术方案批准。

原有 5 份 Markdown 保留；独立工程 Unity 2022.3.62f3 / URP。2026-11-07 Mac 克隆以 4fc1b8f 为接手点，修改前 6431 文件迁移清单校验通过；Mac 最新场景导入与僵尸局部联动已测，完整键鼠、Windows 回归及构建未测。GitHub 历史同步证据保留，本次僵尸改动未提交或推送。

R/F 123 条都有主责映射，其中 3 条 ENG、2 条 PM。映射率不是细化率、批准率、实现率或测试通过率。T01–T16 的当前状态见测试索引；独立 Demo 的自动播放模式证据见独立工程 Evidence。

## 继续工作

先读根目录 AGENTS.md，按基准索引读取来源。更新前快照，修改后运行 sync 与 check。脚本不自动批准，不执行外部操作，不监视后台变化。初始副本在 Backups/Bootstrap_2026-10-28；导出恢复不覆盖当前文件。
