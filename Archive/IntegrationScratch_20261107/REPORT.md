# 最新聚落场景：僵尸替换与回归

日期：2026-11-07，Asia/Shanghai。Unity 2022.3.62f3 / OSXEditor / URP 14.0.12。

## 来源与授权

接手仓库 `/Users/dorimiah/UnityProjects/Vampire-Hunter`，起点提交 `4fc1b8f872d8a0d546b6e7c37ba68d2225fad468`，首次 Git 状态干净。修改前 `Tools/verify_checkout.py` 通过 6431 文件的大小和 SHA-256，文档 check 通过。

用户本轮原话：“windows上新的更改已经git下来，读取，并把红色敌人换成我们的僵尸”。此前指定 FREE Shirtless Zombie，并要求丧尸外张扑抓、修正右手跨胸回收及穿模，不做张嘴。此次授权为独立 Demo 本地整合，不是最终游戏系统或正式美术审批。

## 实现与参数

在 `Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity` 的原 `Training enemy` 根对象上，隐藏红色胶囊 MeshRenderer，加入已验证的僵尸模型和动画。保留根对象、Collider、NavMeshAgent、DemoEnemy 及所有任务引用；按原 Agent baseOffset 放置模型脚底，并抵消原胶囊对象的非均匀缩放。没有重建地形、导航或调查内容，也未修改其他历史场景。

新 `DemoZombieVisual` 根据原 NavMesh 速度切换蹒跚动画，在攻击开始时触发扣抓，按原前摇调节动画速度，并在动作结束前停住导航。死亡和检查点重试沿用原流程；`DemoEnemy` 仅增加攻击开始/重试两个通知。

HP 30、伤害 15、前摇 0.7 秒、伤害后的冷却 1.5 秒保持原值。当前场景调参：接近速度由 2.6 降至 0.85 m/s，停止距离由 1.2 收近至 0.9 m，抓击范围由 1.6 收近至 1.05 m，使动作与真实接触距离匹配。这些是独立 Demo 测试参数，不是冻结设计改动。

原生 URP 材质、模型和 GUID 位于 `Assets/NewPunch/ShirtlessZombieFree`。自制动作及视觉 Prefab 位于 `Assets/Demo/Characters/Zombie`，不含独立验证工程的测试敌人脚本。

## 实测结果

`setup.txt`：场景已保存并重开，原敌人引用和替换保留。

`playmode.txt`、`playmode-retry.log`：真实 Unity Play Mode、通过 API 驱动，退出码 0。验证：

- 调查阶段仍隐藏敌人，进入 Hunt 才激活；徽章和断臂的检视模型、故事保留。
- 原林地 NavMesh 能追击，实际移动触发 Shamble，模型脚底对齐导航面。
- 攻击前打开物品检视，时间、伤害和僵尸动画暂停；关闭后恢复。
- 原 15 点伤害在抓击动画中结算，攻击期间导航停住；下一次前摇中移出范围不会扣血。
- 既有检查点可达，玩家战败后重试成功，猎人和僵尸 HP 恢复，抓击状态/动画/导航重置。
- 原玩家选中仍指向同一 DemoEnemy；击杀后解锁导师线索，随后能完成序章状态机。

截图 `pursuit-gameplay.png`、`grab-gameplay.png` 使用原游戏摄像机；`grab-closeup.png` 使用临时近景审阅摄像机，场景未保存该摄像机。图中光照、雾和植被来自当前真实聚落场景。

首轮 `playmode.log` 在“退开落空”检查失败：测试重复使用了猎人原地站立的坐标，而僵尸已追到该处。修正测试，按僵尸当前位置另取距离超过 3 米的可达点；保留原 `playmode-failure.txt`，第二轮整组通过。这不是放宽伤害判断。

播放导致四个既有材质的颜色序列化出现浮点尾数漂移；核对后恢复这四个文件到接手时的字节，未保留无关材质改动。

## 范围、恢复与复现

未执行从出生点开始的完整连续键鼠试玩、Windows 回归、独立构建或性能验收。扣抓是已烘焙骨骼动画，不是对任意猎人姿态/体型进行运行时 IK；不能把独立胶囊目标的避让测试扩大为所有场景零穿模。观感仍由用户审阅。正式系统仍 0/13 审批，基准测试 T01–T16 不变。

`before/` 保留原场景、敌人脚本、工作流状态及摘要；文档修改前快照在仓库 `Backups/DocsSync/20261107T184747071401`。无重置、强制覆盖、提交或推送。

复现：用 Unity 2022.3.62f3 打开 `VampireHunter_Demo_Independent`，进入上述最新聚落场景，完成原调查流程后接近森林敌人。编辑器回归可调用 `ZombieIntegrationVerification.Run`，场景保存检查可调用 `ZombieSceneIntegration.Build`；均不会自动在打开工程时运行。
