# GitHub 私有工程迁移 — 2026-10-31

用户明确授权“全权负责，将我的项目上传github”，并允许Packages在Windows下载。原AGENTS中的不擅自推送规则在本轮已获得用户明确授权；不改变游戏设计审批。

目标：JeremiahTaorong/Vampire-Hunter，私有仓库。账号经本机GitHub CLI现有登录核对；不导出凭据。

上传范围：独立Demo完整Assets/Packages/ProjectSettings、原始保留工程、集中文档与开发记录、有效Evidence标记和截图，以及旧角色制作工作文件。Git LFS承载大型二进制，普通文本保留源字节。

排除可再生Unity缓存、用户编辑器设置、诊断日志与凭据。根目录可选DungeonEnvironment_91Assets_202.unitypackage约3GB未放入Git历史，随后以两个私有Release分卷上传；原文件在本地保留。当前已导入素材完整上传。

Windows入口与操作见根WINDOWS_SETUP.md。TransferManifest.json记录交付文件的大小和SHA-256；Tools/verify_checkout.py用于还原后核对。仓库推送及远程核验结果在完成后追加。本记录不声称Windows实机或全序章已验证。

## 工程上传与独立克隆核验

私有仓库已建立：https://github.com/JeremiahTaorong/Vampire-Hunter 。初始提交7bd5549，实际Git push成功。

本地迁移清单核对5,811文件的大小与SHA-256；Git LFS fsck通过。嵌套SkyshinVolumeFog Git元数据保存在本机`.git/vendor-backups/`，源码实际入库，没有残留gitlink导致克隆遗漏。

远端1,019个去重LFS对象全部返回可下载状态，missing=0；实际下载并哈希核验5个样本，含最新场景与原生角色FBX。重新克隆后，4,660普通文件实际下载SHA-256通过，1,151处LFS指针对应的原始大小/对象SHA-256与清单一致；没有完整再下载所有LFS以保留Windows取回额度。重新克隆的文档check也通过。

这确认Git/LFS上传和可取回性，不等于Windows Unity首次导入、完整玩法或长期性能通过。

## 可选原始安装包

原始约3GB地牢unitypackage不放Git历史，另使用私有Release的两个分卷附件保存，避免单文件限制。原文件保持不变，分卷合并流SHA-256与原包一致；合并工具与清单已加入工程。Release完整上传及服务端digest核验将在完成后追加。

## 最终附件与交付

私有Release已发布：https://github.com/JeremiahTaorong/Vampire-Hunter/releases/tag/optional-source-packages-20261031 。part01=1,879,048,192字节，part02=1,358,173,185字节；两分卷与清单均为uploaded，服务端sha256逐一匹配本地文件。合并流SHA-256匹配原始安装包。核验数据见根OptionalPackages/release-verification.json。

实际Windows电脑未连接，本轮没有在Windows启动Unity。文件校验、远程可取回性及原始安装包可重组性已验证，Windows首次导入、shader/操作/性能仍需当地验收。未修改GDD、正式审批或游戏功能。
