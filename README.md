# Vampire Hunter — 工程与开发记录

仓库当前为 **Public**，可直接浏览和克隆。向主仓库提交修改仍需 Collaborator 权限；[访问说明与用户确认记录](Docs/03_Management/Evidence/GITHUB_VISIBILITY_20261108.md)。

[按用途浏览项目目录](目录导航.md) · [人物、地图和光雾说明](Docs/06_Demo_Integration/README.md)

Unity 2022.3.62f3 / URP / macOS 开发，迁移至 Windows 时保持同版本。

## 跨章节共享人物运动

**[Player Motion 模块入口](Modules/PlayerMotion/README.md)**：共享玩家 Prefab、导航/攻击/翻滚/受击/死亡、左手火把、章节相机绑定与 A/B 示例。已在两个独立场景实播验证；新章节复用同一份人物实现，剧情与存档留在章节层。现有序章保持原样。

## 打开正确的工程

在 Unity Hub 中添加 **VampireHunter_Demo_Independent** 子文件夹。
最新场景：`Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`。
它包含当前猎人、左手火把、起伏村落、室内窗光、篝火和证人抱拳/交互/指路。
`VampireHunter` 是原始保留工程，不是最新 Demo 入口。

[Windows 下载与打开步骤](WINDOWS_SETUP.md) · [当前开发交接](开发记录/2026-10-30_独立Demo当前交接.md) · [集中开发记录](开发记录/开发记录.md)

## 仓库内容

保留工程源码、已导入素材、全部Unity `.meta`、Packages依赖配置、场景/Prefab、历史审阅场景、开发文档与有效测试标记。模型、纹理等二进制通过Git LFS保存；源文件禁用Git换行归一化，以保留跨平台字节一致性。

不上传可再生的Library/Temp/Logs/obj/UserSettings、个人编辑器配置、诊断`.log`、签名或环境凭据。Evidence的`.txt`完成标记及截图保留，避免初始化工具重新执行旧制作步骤。原始历史日志在Mac仍保留。

根目录`Assets/DungeonEnvironment_91Assets_202.unitypackage`（约3GB）不放入Git历史，原包以两个分卷保存于[私有Release附件](https://github.com/JeremiahTaorong/Vampire-Hunter/releases/tag/optional-source-packages-20261031)。使用`Tools/restore_optional_package.py`合并并验证SHA-256；当前Demo不依赖重新导入它。其他已导入素材与项目实际资源随工程上传。

## 验证与边界

克隆并拉取LFS后，在仓库根目录运行 `python Tools/verify_checkout.py` 可校验迁移清单的文件大小与SHA-256。具体上传核验见`Docs/03_Management/Evidence/GITHUB_TRANSFER_20261031.md`。

仓库还原不等于Windows实机验收；Windows的首次导入、渲染、键鼠和完整序章仍需验证。现有功能已测/未测范围以开发交接记录为准。GDD和正式系统审批不因上传改变。


## 完整源码与验证工程

当前可玩 Demo 位于 `VampireHunter_Demo_Independent`；独立僵尸验证位于 [Validation/Zombie](Validation/Zombie/README.md)，早期森林源工程与交接归入 [Archive](Archive/README.md)，设计参考与工作区资料位于 [Reference](Reference/README.md)。Unity 缓存和个人配置由本机恢复。完整同步记录见 [2026-11-08 GitHub 同步](Docs/03_Management/Evidence/GITHUB_SYNC_20261108.md)。
