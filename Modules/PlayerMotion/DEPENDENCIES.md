# 复用范围与依赖

本模块是本仓库内的共享玩家入口。独立 Unity 项目导入还需保留代码、资源、输入和渲染依赖。

- Unity 2022.3.62f3；URP 14.0.12；AI Navigation 1.1.6；Input Manager（Old）及项目原有输入轴；火把特效所需的项目渲染配置。
- 根组件沿用 DemoMovement、DemoHealth、NavMeshAgent、Collider、HunterGameplayAnimator 和 HunterTorchPose；视觉子节点保留 Animator、HunterTorchHandIK、持握挂点、火焰粒子、灯光及相关光雾组件。
- 相机绑定采用新 SharedPlayerChapterBinding；DemoCamera 为可选跟随实现。
- DemoMovement / DemoHealth 仍在编译时引用 DemoEnemy、DemoInteractable、DemoInvestigation、DemoPrologueFlow、EvidenceInspection、DemoUiStyle 等原型类型。共享 Prefab 不挂载序章任务组件，但这些支持代码仍属于同一 Unity 项目的依赖。
- [dependencies.txt](../../VampireHunter_Demo_Independent/Assets/Shared/PlayerMotion/dependencies.txt) 是 Unity 对 Prefab 枚举的 105 条 Assets 依赖，不代替 C# 类型依赖闭包或 Packages/ProjectSettings。
- 动作、模型、衣物、火把、材质和第三方光照仍引用原 Assets 路径与 GUID；未复制或改变原素材许可。导出或跨工程使用时保留原许可证并按各自授权使用。

独立验证可由 `PlayerMotionModuleVerification.Run` 运行。测试工具只存在 Editor 文件夹，示例场景和共享 Prefab 不保存临时测试组件。
