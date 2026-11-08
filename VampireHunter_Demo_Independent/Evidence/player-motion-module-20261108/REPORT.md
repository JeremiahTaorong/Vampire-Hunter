# 跨章节共享人物运动模块

2026-11-08，Unity 2022.3.62f3 / OSXEditor / URP 14.0.12。

用户要求：“完整的人物运动是不是在不同章节复用？能不能把这个单独领出来github上标注。”本轮在现有仓库单列模块入口，提取可复用玩家 Prefab 并实际验证双场景复用，未新建第二个 GitHub 仓库。

## 产物与归属

- GitHub 说明入口：`Modules/PlayerMotion/README.md`。
- Unity 模块：`Assets/Shared/PlayerMotion/`。
- `Prefabs/Hunter_SharedPlayer.prefab` 从最新 TerracedInteriors 场景的实际玩家提取；删除 DemoPrologueFlow、DemoInvestigation、场景相机引用和测试组件。
- `Runtime/SharedPlayerChapterBinding` 负责绑定本章节的 MainCamera 或显式传入的相机，并设置原 DemoCamera 的跟随目标。
- `Examples/PlayerMotion_ChapterA.unity` 与 `PlayerMotion_ChapterB.unity` 由相同 Prefab 实例生成，各自有独立 NavMesh、相机与测试地面。
- 原控制、生命、动画桥接、火把、模型、动作和材质继续引用同一份已有资源，没有每章复制第二套逻辑。Prefab 依赖清单 105 项。
- 提供同项目内的生成/导出菜单；尚未执行导出包在空白工程重新导入验证。

## 实测

`PlayerMotionModuleVerification.Run` 在真实 Unity Play Mode 中先运行 A，再通过 EditorSceneManager 异步切换到 B，B 再重新实例化相同 Prefab。`playmode.txt` 记录 28 项检查通过，`playmode.log` 保存本机原始日志，进程退出码 0。

两个场景分别通过：相机自动绑定、无序章调查/任务状态、注册章节 NavMesh、保留 0.8 秒翻滚参数、实际导航路径和 Run、翻滚启动/持续/位移、自动近战伤害、攻击时火把持握、关闭 Root Motion、受击 Hit、死亡 Death。测试通过 API 驱动，未模拟实际 WASD/鼠标。

`chapter-1.png`、`chapter-2.png` 是两场景实播攻击帧；另保存各自的死亡帧。已查看两场景画面。`source-before.json` 的原场景、原玩家 Prefab、DemoMovement 和三个动画/火把脚本摘要在提取后全部匹配，原最新序章未保存修改。

## 边界

当前序章保留原场景实例，本轮未强制把它重新连接到新 Prefab；同源底层脚本及资源继续共用。新章节从共享 Prefab 开始。每章实例初始化自身生命值，跨章血量/物品/存档延续由章节管理层处理。本模块仍依赖现有 Demo 类型，不是与原工程完全解耦的通用 SDK。

Walk 与 Interaction 动作状态存在；当前移动逻辑自动使用 Run，Interaction 尚未自动接入调查信号。未声明所有未来章节、完整键鼠、Windows、独立构建或角色极端衣物姿态已验证。正式设计审批仍 0/13，基准 T01–T16 不改变。
