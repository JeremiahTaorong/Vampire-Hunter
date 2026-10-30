# 本地文档同步与恢复

工具仅使用 Python 标准库，项目根目录由脚本位置确定，支持桌面实际路径，不依赖当前终端目录。不安装后台任务或 Git 钩子，不联网、不提交。

在项目根目录运行：

```sh
python3 Tools/docs_workflow.py check
python3 Tools/docs_workflow.py snapshot
python3 Tools/docs_workflow.py sync
python3 Tools/docs_workflow.py check
```

`check` 只读：核对全部原有文件摘要、123 条主责及协作映射、13 模板、S01、审批证据/版本、测试证据字段、生成文档是否过期、Markdown 本地链接与阶段门。退出码 0 只表示文档一致。
`snapshot` 在 Backups/DocsSync 保存本轮管理文件的完整副本与摘要；每次人工编辑前执行。`sync` 验证源数据后，先快照既有生成文档，再更新 5 份派生文档；写入使用同目录临时文件替换。中途失败可重跑，由 check 检出尚未同步的文件。
同步不会改变源文档、批准、S01 正文、workflow_state 或 requirements。审批无记录不能自动升为 Approved；测试无证据不能改 Passed。它不监视用户文件，也不自动操作 Unity。

恢复示例（将实际快照相对路径替换到命令中）：

```sh
python3 Tools/docs_workflow.py restore-to Backups/Bootstrap_2026-10-28 Backups/Recovered/initial-copy
python3 Tools/docs_workflow.py restore-to Backups/DocsSync/实际快照目录 Backups/Recovered/review-copy
```

目标目录必须不存在；只能在项目内恢复到独立目录。工具先检查快照摘要再复制，不覆盖现有文件。Bootstrap 导出原有 5 文件；DocsSync 导出对应快照的管理文件。恢复后比较差异，再执行已授权的选定恢复；不能自动用旧状态覆盖用户的新审阅决定。
基准摘要变化时 check/sync 都停止；恢复导出仍可用于检查旧副本。不要直接改摘要以消除报警。更新基准须经批准、保留旧版，再调整基准版本和全部映射。

审阅记录格式：workflow_state.approvals 元素包含 system、version、sha256、decision=Approved、approver=user、date、quote、source、evidence（项目内已有的审阅原话记录）。脚本校验元数据与文件摘要及引文存在性，不能自行判断用户真实意图；记录人须据真实用户决定填写。
本轮 approvals=[]。未来测试通过记录需 evidence 指向真实结果日志，并包含 mode、environment、revision、expected、actual、run_at、exit_code；没有真实运行不填写通过。
完整 Task Registry 尚未获准建立；未来任务同步要在计划批准后扩展工具，当前不能将此脚本视为已完成开发管理功能。
