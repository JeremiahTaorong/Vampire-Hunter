# GitHub 仓库可见性变更 — 2026-11-08

仓库：https://github.com/JeremiahTaorong/Vampire-Hunter

用户要求：“吧项目公开，我可以让我的组员有access”。告知当前仓库含第三方商店原始素材、完整历史，公开范围为所有访问者；同时提供保留私有并邀请组员的替代方案。用户随后明确回复：“确认公开当前整个仓库”。

已执行将现有整个仓库从 PRIVATE 改为 PUBLIC。GitHub CLI 核验返回 `isPrivate: false`、`visibility: PUBLIC`，仓库地址与名称匹配。未修改默认分支、仓库内容历史、成员名单或写权限。既有 Releases 随仓库可见性公开。

组员可直接浏览、克隆和下载；向主仓库推送代码仍需由所有者添加为 Collaborator。公开不自动授予所有人写权限。项目素材继续适用各自许可，公开设置本身不改变任何素材授权。
