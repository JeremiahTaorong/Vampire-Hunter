# 共享人物运动

[完整使用说明、功能状态和跨章节接入](../../../../Modules/PlayerMotion/README.md)

- `Prefabs/Hunter_SharedPlayer.prefab`：共用人物入口。
- `Runtime/SharedPlayerChapterBinding.cs`：绑定章节相机。
- `Examples/`：引用同一 Prefab 的 A/B 两个独立示例及导航数据。
- `Editor/`：生成、导出与播放回归工具。
- `dependencies.txt`：Unity 枚举的原资源依赖。

控制与动画实现沿用项目原有代码；章节任务状态已从这个 Prefab 移除。当前序章场景保持原样。
