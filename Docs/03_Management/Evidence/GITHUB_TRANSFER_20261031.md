# GitHub 私有工程迁移 — 2026-10-31

用户明确授权“全权负责，将我的项目上传github”，并允许Packages在Windows下载。原AGENTS中的不擅自推送规则在本轮已获得用户明确授权；不改变游戏设计审批。

目标：JeremiahTaorong/Vampire-Hunter，私有仓库。账号经本机GitHub CLI现有登录核对；不导出凭据。

上传范围：独立Demo完整Assets/Packages/ProjectSettings、原始保留工程、集中文档与开发记录、有效Evidence标记和截图，以及旧角色制作工作文件。Git LFS承载大型二进制，普通文本保留源字节。

排除可再生Unity缓存、用户编辑器设置、诊断日志与凭据。根目录可选DungeonEnvironment_91Assets_202.unitypackage约3GB未上传，因单文件超出普通LFS计划限制、且非当前Demo依赖；原文件在本地保留。当前已导入素材完整上传。

Windows入口与操作见根WINDOWS_SETUP.md。TransferManifest.json记录交付文件的大小和SHA-256；Tools/verify_checkout.py用于还原后核对。仓库推送及远程核验结果在完成后追加。本记录不声称Windows实机或全序章已验证。
