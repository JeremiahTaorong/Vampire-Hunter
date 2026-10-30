# Vampire Hunter — 工程与开发记录

Unity 2022.3.62f3 / URP / macOS 开发，迁移至 Windows 时保持同版本。

## 打开正确的工程

在 Unity Hub 中添加 **VampireHunter_Demo_Independent** 子文件夹。
最新场景：`Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`。
它包含当前猎人、左手火把、起伏村落、室内窗光、篝火和证人抱拳/交互/指路。
`VampireHunter` 是原始保留工程，不是最新 Demo 入口。

[Windows 下载与打开步骤](WINDOWS_SETUP.md) · [当前开发交接](开发记录/2026-10-30_独立Demo当前交接.md) · [集中开发记录](开发记录/开发记录.md)

## 仓库内容

保留工程源码、已导入素材、全部Unity `.meta`、Packages依赖配置、场景/Prefab、历史审阅场景、开发文档与有效测试标记。模型、纹理等二进制通过Git LFS保存；源文件禁用Git换行归一化，以保留跨平台字节一致性。

不上传可再生的Library/Temp/Logs/obj/UserSettings、个人编辑器配置、诊断`.log`、签名或环境凭据。Evidence的`.txt`完成标记及截图保留，避免初始化工具重新执行旧制作步骤。原始历史日志在Mac仍保留。

唯一未上传的大型原始安装包是根目录`Assets/DungeonEnvironment_91Assets_202.unitypackage`（约3GB）。它超过当前普通LFS计划的单文件上限，且不是当前Demo的已导入依赖。原文件在Mac保留；需要后续制作地牢时，再从原素材来源下载。其他已导入Asset Store素材和项目实际使用的资源均随工程上传。

## 验证与边界

克隆并拉取LFS后，在仓库根目录运行 `python Tools/verify_checkout.py` 可校验迁移清单的文件大小与SHA-256。具体上传核验见`Docs/03_Management/Evidence/GITHUB_TRANSFER_20261031.md`。

仓库还原不等于Windows实机验收；Windows的首次导入、渲染、键鼠和完整序章仍需验证。现有功能已测/未测范围以开发交接记录为准。GDD和正式系统审批不因上传改变。
