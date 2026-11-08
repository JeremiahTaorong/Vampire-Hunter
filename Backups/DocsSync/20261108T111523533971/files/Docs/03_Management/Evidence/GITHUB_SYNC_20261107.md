# GitHub → Mac 同步记录

2026-11-07 Asia/Shanghai。用户本聊天原话：“记录更新所作变化，同时全部push到github上。这样我就可以在mac上同步”。授权当前项目全部改动提交并推送已有私有 origin/main，不改变正式系统批准，不变更访问权限。

远端：https://github.com/JeremiahTaorong/Vampire-Hunter 。同步前 fetch 成功，本地 HEAD 与 origin/main 一致，为 067a9e882ea5ca94e314030a91e7873dda99a020。新增内容为 2026-11-06 血迹/断臂/徽章/检视 UI 及其文档证据，并包含原有四处材质精度差异。Unity 局部验证结果引用 Evidence/evidence-inspection-20261106/REPORT.md 等，本轮只做文档与 Git 文件传输验证，不冒充新 Unity 测试。

交付入口与 Mac 步骤见根 MAC_SETUP.md、开发记录/2026-11-07_血迹断臂徽章与检视UI交接.md。大文件用既有 LFS，并补充四轮 scene-before.unity.txt 快照策略。原始测试日志虽被常规日志忽略规则排除，本轮明确纳入必要的原始证据；缓存、凭据与可选原包的既有排除不变。TransferManifest.json 更新为当前交付文件清单；旧版本原样保存在 GITHUB_SYNC_20261107_before/。

恢复快照 Backups/DocsSync/20261107T171945731648；文档检查须通过、核对 staged diff、当前交付 SHA-256 与 LFS 一致性后提交和正常推送，不强推。最终提交号与远端一致性由交付时 Git 实测返回，并在聊天中报告。记录本身不把待执行的 push 预标为成功。

## 提交前实测

文档 sync/check 通过，5 份原文摘要及审批保持不变；当前 TransferManifest 覆盖 6,431 份文件，大小和 SHA-256 全部核对通过；新增 Unity 资源均有 .meta；Git LFS fsck OK。审阅 staged 变更，无删除，无玩法代码在先前实测后新增变化。全范围 whitespace 检查遇到 Unity 自动生成 .meta/.mat 和原始日志固有的行末空格，保留其原始字节；手写代码、当前文档及 Shader 单独检查。
