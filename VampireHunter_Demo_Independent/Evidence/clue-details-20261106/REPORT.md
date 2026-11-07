# 血泊群与原创猎人徽章

日期：2026-11-06（Asia/Shanghai）。工作标签：DEMO-CLUE-DETAILS-20261106，不是正式 Task ID。

用户原话（当前聊天）：“好的。多加入一些散落的血泊聚集在一起。然后加入徽章。免费的”。此前已指定所有资源免费，并允许徽章或十字架类型；断臂仍按用户上一条要求暂缓。本轮没有付费采购、网络安装、推送、发布或正式系统批准。

依据：GDD v4 序章 R53/R59；SCM 对应 S09/S08/S13/S11；Narrative v2 §三的现场物证与导师徽记；F23 环境叙事、F24 哥特美术、F27 英文游戏文本。十字纹是当前独立 Demo 的视觉提案，不把它登记为已冻结的最终世界观设定。

## 实际结果

- 当前场景：Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity。
- 血迹点新增 **12 处**大小、角度不同的贴地血泊/飞溅；复用先前导入的 dohnjoe / raydevv 免费 CC BY 4.0 血迹。中心聚集，外圈散落，沿用向森林延伸的拖痕。
- 原创猎人十字徽章：暗色钢底、银色包边和凸起十字、四颗铆钉、小挂环，共 **620 三角面**、3 份材质。直接由 Unity 网格构造，不使用外部模型、图片或付费资源。
- 可复用模型在 Assets/Demo/Environment/HunterBadge/Hunter_Cross_Badge.prefab；来源说明在同目录 SOURCE.md。
- 徽记锚点仍为 (-2.2, 2.8, -0.8)、clueId=emblem、范围 2.6m；原占位渲染器与碰撞体停用，原创徽章缩放 0.68 后贴地，专用触发体覆盖实际可见徽章。锚点和调查逻辑保留。
- 拖痕锚点仍为 (32, 2.57, -1.4)、clueId=trail、范围 2.8m。没有修改状态机、导航或剧情进度条件。
- 已保存场景、重开并移除临时 ClueDetailsProbe。未处理此前暂缓的断臂。

## 实际验证

环境：Windows Editor / DX11，Unity 2022.3.62f3 (96770f904ca7)。基点 main / 067a9e882ea5ca94e314030a91e7873dda99a020，加本轮未提交修改；原四处材质浮点差异保留。

模式：真实 Unity Play Mode，真实 NavMeshAgent、镜头射线和 DemoMovement.BeginInteraction；未模拟操作系统鼠标/键盘。最终运行约 2026-11-06 16:15:15–16:15:22（Asia/Shanghai）。

复现：从当前保存场景添加临时探针；分别在 trail/emblem 附近采样导航网格；从跟随镜头向实际线索发射射线；执行原靠近交互；等待线索记录；检查血迹数量与徽章材质；拍摄实际游戏相机；退出播放并清理探针、重开场景。

| 检查 | 预期 | 最终实际 |
| --- | --- | --- |
| 拖痕选中/靠近 | 能选中，路径完整，进入范围后记录 | selectable=True，PathComplete，1.17s，距锚点约 0.328m |
| 拖痕完成反馈 | examined/HasTrail 为 true，提示隐藏 | 全部通过 |
| 血泊数量 | 新增 12 处 | clusterStains=12 |
| 徽章选中/靠近 | 射线命中实际徽章触发体，能靠近调查 | selectable=True，PathComplete，1.23s，距锚点约 0.305m |
| 徽章记录 | examined/HasEvidence 为 true | 两者均 true |
| 原创模型 | 材质非空、着色器支持、轻量网格 | badgeMaterialsValid=True，620 三角面 |
| 视觉 | 血泊自然聚集，徽章贴地且不悬空 | 最终 trail-detail.png 与 emblem-detail.png 已查看 |

最终 **PASS**，验证脚本结果码 exit_code=0；不是 Unity 进程退出码，编辑器保持打开。测试窗口未捕获新 Error/Exception/Assert。原始结果 playmode.txt；细节和默认机位分别为 trail-detail.png、emblem-detail.png、trail-gameplay.png、emblem-gameplay.png。截图前将角色放到侧边以免遮挡，截图本身不冒充完整通关证据。

首次近景发现徽章继承旧占位高度而悬空，已缩小贴地并重复验证；首次结果与图片保存在 before-grounding-playmode.txt、before-grounding.png。首次命令发布与编辑器读取同时发生过 Sharing violation，已将发布改为临时文件原子移动，并使读取端在文件暂时锁定时重试；原始完整日志保留在 ../blood-clue-editor-20261106.log。

## 恢复与边界

编辑前场景及本轮前 BloodClueSetup/BloodClueProbe 源文件副本在本目录；管理快照为 Backups/DocsSync/20261106T160737153809、20261106T161406106007、20261106T161605343256。恢复先比较或导出，不直接覆盖。

本轮不是完整序章连续试玩、性能测试或 Windows 构建验收；全部点击角度与遮挡组合未穷尽。美术观感待用户审阅；正式系统 0/13、T01–T16 状态不变，下一正式审阅项仍是 S01。
