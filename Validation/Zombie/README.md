# 僵尸独立可行性验证

状态：2026-11-07 已完成独立验证并停止；未接入 forest-preview Demo，未进行 Git 提交或推送。

Unity 2022.3.62f3；URP 14.0.12。

## 查看结果

在 Unity Hub 添加此文件夹，打开 `Assets/Validation/ZombieFeasibility.unity` 后按 Play。僵尸会以蹒跚步态接近蓝色目标，随后张开双臂、扭腰前扑，双手扣抓目标两侧，短暂停留后向外松开。重新播放可重置测试。

- `Assets/Validation/ShirtlessZombie.prefab`：模型、原包 URP 材质及动画控制器。
- `Assets/Validation/Zombie_Shamble.anim`：自制循环蹒跚动作。
- `Assets/Validation/Zombie_Bite.anim`：按最新反馈重做为丧尸外张扑抓，时长 1.6 秒。双腕使用各自身体外侧的目标轨迹及向外弯肘约束；手掌朝向目标，手指扣抓，接触阶段停留，恢复阶段向外松开，不再右手跨胸收回。保留原文件和 Animator 状态名称以兼容测试；不做张嘴和面部动画。
- `Assets/Validation/ZombieValidationEnemy.cs`：独立平地测试的接近、攻击时机和范围判断。接触时机 0.75 秒，伤害 15，恢复后冷却 0.6 秒。

原模型具有有效的人形 Avatar，可用于后续动画重定向。此次自制动画由人形姿态及脚部 IK 离线烘焙为该模型的骨骼曲线，验证预制体使用普通骨骼动画播放配置。它们不是商店附带动画，也不是动作捕捉动画。

## 实际验证

Unity 播放测试通过，证据见 `Evidence/play.log` 和 `Evidence/play-result.txt`：

1. 僵尸向目标移动。
2. 行走状态启用，腿部骨骼旋转随动画变化。
3. 撕咬状态启用，接触时目标生命从 100 降到 85。
4. 下一次撕咬开始后把目标移出范围，生命不再减少。

实际游戏相机截图：`Evidence/Shamble-play.png`、`Evidence/Bite-play.png`。已目视检查材质、姿态与脚部表现。

新版抓击连续预览：`Evidence/Grab-attack.gif`，来自 Unity 播放模式逐帧录制，共 49 帧；`Evidence/GrabFrames/` 保存原始画面。蓄力至扣抓阶段，实际采样骨骼的上身方向变化约 107.7°、右手位移约 0.68 米（见 `Evidence/grab-amplitude.txt`）。逐帧烘焙 LOD0 蒙皮网格，测得对当前测试胶囊的最大顶点穿入为 0，双腕距身体中心面的最小距离约 0.329 米（见 `Evidence/grab-clearance.txt`）。此检查只覆盖这个尺寸及位置的测试目标，未提供针对任意模型的运行时避让。这些检查不代表美术已获用户批准。上一版攻击截图和测试记录以 `Evidence/previous-` 前缀保留；横扫版动图以 `Evidence/previous-sweep-` 前缀保留。

范围仅限独立平地原型。未验证 Demo 场景集成、NavMesh 导航、障碍绕行、斜坡、最终美术品质或 Windows 工程兼容；这些工作留待 Windows 内容同步后决定。

## 素材来源

[FREE Shirtless Zombie — Studio New Punch](https://assetstore.unity.com/packages/3d/characters/humanoids/free-shirtless-zombie-276762)，使用已登录 Unity 账号下载。包本身不附带动画，原素材位于 `Assets/NewPunch/ShirtlessZombieFree`，适用原 Asset Store 授权。

下载缓存：`~/Library/Unity/Asset Store-5.x/Studio New Punch/3D ModelsCharactersHumanoids/FREE Shirtless Zombie.unitypackage`。首次下载连接截断，后通过 Unity 暂停及续传成功；成功记录见 `Evidence/download-resume.log`。

日志包含本机环境与 Unity 会话信息，不应公开发布；项目与第三方素材未上传。
