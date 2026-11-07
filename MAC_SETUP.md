# Mac 同步与打开最新 Demo

2026-11-07（Asia/Shanghai）。仓库：https://github.com/JeremiahTaorong/Vampire-Hunter ，使用有访问权限的 GitHub 账号。

先关闭本机 Unity。需要 Git、Git LFS 和 Unity **2022.3.62f3**（Hub 中选择适合 Intel / Apple silicon 的编辑器）。已有 Git LFS 则直接运行以下命令；缺少时先安装 Git LFS。

## 已有克隆

在你的仓库目录执行：

```bash
git status --short
git lfs install
git pull --ff-only origin main
git lfs pull
```

如果 Mac 有未提交改动，先在 Mac 提交或备份再拉取；不要使用 reset --hard 或强制覆盖。若当前不是 main，先确认本地改动，再切换到 main 拉取。

## 首次下载

```bash
git lfs install
git clone https://github.com/JeremiahTaorong/Vampire-Hunter.git
cd Vampire-Hunter
git lfs pull
```

使用 Git 克隆，不用 GitHub 网页 ZIP 替代 LFS 下载。私有仓库登录使用本机正常认证，不把令牌写进项目。

## 校验与启动

在仓库根目录运行（需 Python 3）：

```bash
python3 Tools/verify_checkout.py
python3 Tools/docs_workflow.py check
```

TransferManifest.json 是当前交付文件的大小/SHA-256 清单（不包含自身和重建缓存）；旧清单备份在 Docs/03_Management/Evidence/GITHUB_SYNC_20261107_before/。文件校验不代表 Mac 玩法验证。

Unity Hub 添加子目录 **VampireHunter_Demo_Independent**，等待包恢复和素材重新导入。不要打开根 Assets 或备用 VampireHunter 工程作为最新 Demo。打开：

`Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`

Play 后点徽章/断臂，走近自动打开检视，拖动模型旋转，阅读故事，Esc 或按钮返回。原证人交互仍保留。若出现 Forst - Conifers Installer，已有 URP 素材，可关闭提示。

保留 Evidence 的完成标记，一些历史制作工具会据此避免重复执行。Library/Temp/Logs/用户编辑器设置不跨平台同步；Packages 清单和锁文件已纳入，Unity 可能需要联网恢复依赖。原约 3GB 可选地牢包仍保留在既有私有 Release，当前 Demo 不需要重下载。

首次 Mac 检查：Console 错误、Metal 材质/虚化、两个物品的打开/旋转/关闭、WASD 恢复，以及完整调查→证词→推理→森林流程。Windows 局部测试不能代替 Mac 运行结果。
