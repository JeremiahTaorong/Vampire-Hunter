# T01–T16 基准测试索引

> 自动生成；源：workflow_state.json + requirements.json + 原始 SCM。不要手工改此派生文件。


这些是 GDD/SCM 既有设计验收用例，不是已执行测试，也不是完整测试计划。文档脚本的校验日志不能填作这些用例通过的证据。

| 用例 | 验证目标（原 SCM） | 主责/关联 | 执行状态 | 实际证据 |
|---|---|---|---|---|
| T01 | Human 隐藏 C、04 感染后 C 不越阈 | S03 / S04/S09/S11 | NotRun | 无 |
| T02 | 必要血术 + 主线净化 + 三碎片 + Reject 可达 Humanity | S04 / S02/S03/S10 | NotRun | 无 |
| T03 | 战前非永久 Fallen，Accept；战中新增 Fallen 仍 Inheritance | S10 / S03/S04/S12 | NotRun | 无 |
| T04 | 战前永久 Fallen 任意立场均 Too Late | S10 / S03/S09 | NotRun | 无 |
| T05 | Reject 缺碎片、非永久 Fallen → Too Late 且不篡改 C | S10 / S04/S09 | NotRun | 无 |
| T06 | 03 BP=0 可开血门，血源不无限囤积且开门停用 | S08 / S04/S07/S12 | NotRun | 无 |
| T07 | 05/08 缺必备技能不可锁门，可补装与获得 BP | S02 / S04/S06/S07 | NotRun | 无 |
| T08 | 02 书架所有合法状态可返回、可解谜、跨 Scene 持久 | S08 / S01/S07/S12 | NotRun | 无 |
| T09 | 07 错序重试不会永久失去碎片 | S08 / S07/S10/S12 | NotRun | 无 |
| T10 | 房间 Cleared、敌人重试、精华过期/吸收不重复奖励 | S12 / S04/S05/S08 | NotRun | 无 |
| T11 | 技能/治疗前摇被打断不扣资源和 CD，动作正确恢复 | S02 / S01/S04 | NotRun | 无 |
| T12 | Dodge 无敌帧长于攻击冲刺，碰撞效果不重复结算 | S02 / S01/S04 | NotRun | 无 |
| T13 | 不可达目标、书架变路后不穿墙不无限寻路 | S01 / S07/S08 | NotRun | 无 |
| T14 | Boss 前双支线可回溯；锁定后重试保持立场 | S10 / S07/S12 | NotRun | 无 |
| T15 | 战斗中退出与存档损坏：pending 回滚，永久消耗保留，备份可恢复 | S12 / S04/ENG | NotRun | 无 |
| T16 | Temporary BP 裁剪与永久 Fallen 的圣强化一次性转换 | S03 / S04/S06 | NotRun | 无 |

未来实测记录：用例与 Task ID、输入配置/版本、运行环境和代码版本、步骤、预期/实际、时间、退出码、原始日志与适用截图。失败保留失败证据，未测明确 NotRun。完整用例拆分与排期在全部系统批准后制定。
