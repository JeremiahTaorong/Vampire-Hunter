# 共享人物运动模块 / Reusable Player Motion

**用途：在同一个 Unity 项目的不同章节，复用同一份玩家 Prefab、运动脚本、模型、Animator 和动作资源。** 每章配置自己的相机、出生点、NavMesh、敌人和剧情，不另写一套人物运动。

| 项目 | 当前状态 |
|---|---|
| 版本 | v0.1，独立 Demo 原型 |
| Unity | 2022.3.62f3，URP 14.0.12，AI Navigation 1.1.6 |
| 跨场景验证 | 同一个 Prefab 在 A、B 两个示例场景中实播，28 项检查通过 |
| 现有序章 | 保留原玩家实例；本模块从最新实例提取，底层控制、动画和火把资源共用 |

## 直接入口

- **[共享玩家 Prefab](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/Prefabs/Hunter_SharedPlayer.prefab)**
- [章节 A 示例](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/Examples/PlayerMotion_ChapterA.unity)
- [章节 B 示例](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/Examples/PlayerMotion_ChapterB.unity)
- [章节相机绑定组件](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/Runtime/SharedPlayerChapterBinding.cs)
- [Prefab 提取与 Unity Package 导出工具](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/Editor/PlayerMotionModuleTools.cs)
- [依赖清单](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/dependencies.txt)
- [28 项播放测试记录](../../VampireHunter_Demo_Independent/Evidence/player-motion-module-20261108/playmode.txt)

## 复用的内容

| 功能 | 实现和本次验证 |
|---|---|
| 点击寻路、WASD 接管 | 沿用 DemoMovement；本次用导航 API 驱动实际位移并观察 Run 状态，未模拟键盘/鼠标 |
| 自动近战攻击 | 沿用原目标选择、攻击间隔、伤害与 Attack 动画；两个示例均通过 |
| 翻滚 | 沿用 0.8 秒、2.5 米、0.15 秒无敌窗口及原冷却配置；两个示例实测翻滚启动、持续和位移 |
| 受击、死亡 | 原生命组件驱动 Hit / Death 动画，两个示例均通过 |
| 左手火把 | 原持握层、手腕/肘 IK、掌心挂点、粒子与照明复用，攻击中持握检查通过 |
| Idle / Run | 原控制桥接自动切换 |
| Walk / Interaction | 控制器保留这些状态；当前移动默认切到 Run，Interaction 尚未自动接入章节调查信号 |

主控制代码仍在 [DemoMovement.cs](../../VampireHunter_Demo_Independent/Assets/Demo/Scripts/DemoMovement.cs)，动画桥接在 [HunterGameplayAnimator.cs](../../VampireHunter_Demo_Independent/Assets/Demo/Characters/Hunter/Integration/HunterGameplayAnimator.cs)，火把表现见 [HunterTorchPose.cs](../../VampireHunter_Demo_Independent/Assets/Demo/Characters/Hunter/Integration/HunterTorchPose.cs) 与 [HunterTorchHandIK.cs](../../VampireHunter_Demo_Independent/Assets/Demo/Characters/Hunter/Integration/HunterTorchHandIK.cs)。这些脚本没有为 A/B 章节复制第二份，也没有在本次提取时改写。

## 给新章节接入

1. 用 Unity Hub 打开仓库内 `VampireHunter_Demo_Independent`。
2. 在新章节准备可行走的 NavMesh，设置出生点。
3. 将 `Assets/Shared/PlayerMotion/Prefabs/Hunter_SharedPlayer.prefab` 拖入章节，并放在 NavMesh 上。
4. 为章节相机设置 `MainCamera` 标签；共享玩家会自动绑定。也可通过 `SharedPlayerChapterBinding.Bind(camera)` 显式指定。相机带 `DemoCamera` 时会自动跟随该玩家。
5. 沿用项目的 Input Manager 设置（当前 `activeInputHandler=0`），保留 Horizontal、Vertical、鼠标和 Space 配置。
6. 在章节层接入剧情、交互和结束条件；跨章生命值、物品与存档由章节管理传入。每章重建实例默认重新初始化生命值，本模块未实现自动跨章存档。

共享 Prefab 已移除 `DemoPrologueFlow`、`DemoInvestigation` 与原场景相机引用。现有 `DemoHealth` 的无章节流程回退行为会把胜利视作完成；制作新章节时，应由章节自己的流程处理胜利/失败。战斗和交互仍依赖项目内的 Demo 类型，依赖说明见 [DEPENDENCIES.md](DEPENDENCIES.md)。

## 组员如何修改

通用角色外观、持握和默认运动参数优先改共享 Prefab；相机、出生点和章节规则在各自场景设置。现有序章保留其原场景实例的参数，不会因本次提取强制变更任务引用。

重新生成入口：Unity 菜单 `Vampire Demo → Shared Player Motion → Rebuild Shared Prefab and Examples`。此操作会从当前最新序章玩家重新生成共享 Prefab 和 A/B 示例，会覆盖这几个生成资产，手工修改前应先提交或备份。

导出入口：`Vampire Demo → Shared Player Motion → Export Unity Package With Dependencies`，生成到 `Builds/PlayerMotion/HunterPlayerMotion.unitypackage`。本轮提供导出工具，未执行空白工程重新导入验证；日常跨章节复用使用当前完整仓库。

## 已测与边界

当前实播验证覆盖两个独立示例场景；后续正式章节尚未制作或实测，不标记为“全部章节已通过”。原序章场景、原玩家 Prefab 和四个运动/动画脚本的 SHA-256 均保持不变。没有改动最终游戏系统审批。角色衣物极限姿态、完整实际键鼠与打包验收仍沿用原记录的待测范围。

![章节 A 中的共享玩家](../../VampireHunter_Demo_Independent/Evidence/player-motion-module-20261108/chapter-1.png)
