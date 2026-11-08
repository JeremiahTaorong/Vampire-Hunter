# 证人抱拳、放臂与左手指路

> 目录整理：2026-11-08。文中 `Assets/`、`Evidence/` 和 `Art_Direction/` 路径均以 `VampireHunter_Demo_Independent` 工程根目录为基准。

2026-10-30（Asia/Shanghai）。用户同意第一版NPC并授权继续加入交互动画；不是正式系统策划审批。

当前场景：Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity。
可复用Prefab：Assets/Demo/Characters/NPC/Villager/NPC_Villager_Gesture.prefab。场景实例另保存玩家、调查对象和目标引用。

沿用原Character Constructor骨架蒙皮与Idle动画。独立Villager_Gesture.controller启用Humanoid IK；两个手指遮罩层以30条原Humanoid手指曲线制作握拳/包拳及左食指伸展，原始资源不改。不重建骨骼或蒙皮。

## 行为

- 待机时双手在身前抱拳，近处平滑转向主角，并用头部注视主角。
- 原DemoMovement点击接近调查流程成功后，DemoInteractable记录线索并发出Activated事件；NPC接收事件，不因主角仅仅靠近就开始指路。其他物件没有订阅者，原逻辑保留。
- 约0.45秒放臂过渡，完全放下后等待1.5秒，再约0.55秒抬左手并伸食指，保持指向下一目标。
- 优先指向未调查的拖拽痕迹，其次未调查的徽记；上述都完成时指向森林检查点，已进入导师线索阶段则指向导师目标。
- 指路时身体朝目标侧最多转65度，避免手臂反扭；主角离开8米后回到抱拳。动作执行中重复点击不重置等待，指路状态再次交互会平滑放臂后重播。
- 原移动、伤害、闪避、证人证言和任务阶段规则不变。Root Motion关闭。

## 实测

真实Unity 2022.3.62f3/macOS Play Mode。使用原BeginInteraction流程接近并激活证人，同时校验相机射线命中原交互Collider；不是完整鼠标输入自动化。
实测顺序Clasp→Lowering→Waiting→Pointing；HasWitness=True。检查抱拳、双臂放下及左手指路的真实截图，手部定位通过原Humanoid IK完成。证据Evidence/villager-gesture-20261030内保存built.txt、playmode.txt、clasp/lowered/point.png和saved.txt。

仍需全流程手动试玩、各方向接近时的极限姿态和不同目标分支回归；本轮重点验证未收集拖拽痕迹的主路径，不把其他分支标记为实测通过。未新增巡逻、配音或新的对话系统。

最终实测：等待1.516313s，左臂与目标水平夹角0.5059度，HasWitness=True。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=2

![抱拳待机](../../../VampireHunter_Demo_Independent/Evidence/villager-gesture-20261030/clasp.png)
![左手指路](../../../VampireHunter_Demo_Independent/Evidence/villager-gesture-20261030/point.png)

## 当前交接与反馈（文档整理）

用户最新回复“很好。完善开发记录”，按实际范围记录为对已展示主路径效果的认可。完整状态、日志/截图索引与待测清单见[集中交接记录](../../../开发记录/2026-10-30_独立Demo当前交接.md)。新增`Evidence/villager-gesture-20261030/documentation-review.json`保存当前场景、手势Prefab/Controller及相关运行代码SHA-256，便于后续比较；摘要不是额外测试结论。

最新功能只接入当前起伏村落场景。独立NPCVillagerReview仍是最初基础Idle审阅。可复用手势Prefab的玩家、交互与目标引用为空，复制使用时须像当前场景实例一样配置；不能仅拖入Prefab就宣称指路目标已接通。
