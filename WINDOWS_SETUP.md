# Windows 下载与继续开发

2026-10-31（Asia/Shanghai）。仓库为私有，使用拥有访问权的GitHub账号登录。

1. 安装Unity Hub与 **Unity 2022.3.62f3**：https://unity.com/releases/editor/whats-new/2022.3.62f3 。保持编辑器版本一致。
2. 安装Git for Windows和Git LFS。关闭并重新打开终端。
3. 使用以下命令下载（不要只下载网页ZIP，以免遗漏LFS大文件）：

```powershell
git lfs install
git clone https://github.com/JeremiahTaorong/Vampire-Hunter.git D:\VH
cd D:\VH
git lfs pull
```

如果GitHub要求登录，使用自己的账号完成浏览器授权；不要把访问令牌写进文件或发到聊天。

4. 有Python 3时，在仓库根目录运行 `python Tools/verify_checkout.py`（也可用`py -3 Tools/verify_checkout.py`）；应显示文件校验通过。无需Python也能用Unity打开，但不能据此宣称已完成全部SHA-256核对。
5. Unity Hub选择“Add project from disk”，选择 **VampireHunter_Demo_Independent** 子文件夹，等依赖下载及素材导入完成。
6. 打开 `Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`，按Play。

## 素材包与Packages

已导入的Character Constructor、Viking Village及其他当前使用素材位于Assets，随仓库提供，无须重新导入原unitypackage。
`Packages/manifest.json`及`packages-lock.json`随仓库提供，Unity会联网下载URP等依赖；其中UOSLauncher来自Git，Windows必须能运行Git并访问其远程地址。Library/PackageCache不上传，也不需要复制Mac版本缓存。

原始约3GB地牢安装包另存于私有Releases附件，不放入Git历史；当前Demo不依赖它。取回方式见下节。其他排除类别见根README及.gitignore。

## 本工程特别注意

保留Evidence内的完成标记。不要先删除Evidence再打开Unity，否则一些历史编辑器自动制作工具可能再次执行。历史审阅场景及备用工程不代表最新功能入口。

遇到Forst-Conifers素材安装提示，当前URP资源已经导入，可关闭提示后继续；不要重复安装覆盖当前资源。

Windows首次测试应检查：Console、材质是否正常、猎人移动/攻击/翻滚、左手火把、篝火/窗光、点击证人后放臂等待1.5秒再左手指路。完整流程与性能仍以Windows实际验证为准。

## 可选：下载原始地牢安装包

访问 https://github.com/JeremiahTaorong/Vampire-Hunter/releases/tag/optional-source-packages-20261031 ，登录同一GitHub账号。下载两个`DungeonEnvironment_91Assets_202.unitypackage.part01/part02`附件到同一文件夹；不要把它们当ZIP解压。

在仓库根目录执行（默认从当前用户Downloads目录读取）：

```powershell
python Tools/restore_optional_package.py
```

或指定位置：`python Tools/restore_optional_package.py --parts-folder D:\Downloads`。
工具校验分卷并合并为仓库根目录`Assets/DungeonEnvironment_91Assets_202.unitypackage`，再次校验原包SHA-256。它在Unity工程子文件夹之外，不会自动改变现有Demo；需要时再从Unity手动导入。

建议克隆到短路径D:\VH，避免深层历史文档路径超出Windows路径限制。
