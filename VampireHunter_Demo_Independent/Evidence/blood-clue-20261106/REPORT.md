# 序章血泊与拖拽痕迹集成

日期：2026-11-06，Asia/Shanghai。记录标签：DEMO-BLOOD-CLUE-20261106；未建立正式 Task Registry，本标签不是正式开发 Task ID。

## 授权与范围

本聊天用户明确要求所有资源免费，并指定 Severed Arm、Bloody Drag Mark Decal (PSX)、blood decals psx。随后用户明确调整本轮范围：**“断臂先不管了。等下载完再放。先完善其他的”**。

本轮交付两款血迹资源在现有拖拽调查点的集成。断臂尚未导入；徽记模型未在本轮替换。用户尚未审阅本轮美术观感，不登记美术批准。正式系统批准仍为 0/13，T01–T16 状态不变。

来源：GDD v4 的序章范围 R53/R59；SCM 对应 S09 主责、S07/S08/S11/S13 协作；Narrative v2 §三的现场物证、血迹与林地方向；F23 环境叙事、F24 美术方向、F27 英文游戏文本。没有修改冻结规则、调查状态转换或最终游戏系统。

## 实际文件与改动

- 场景：Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity。
- 线索锚点沿用世界位置 (32, 2.57, -1.4)，clueId=trail，调查范围 2.8m。
- 原圆盾子物件停用；附近旧长方体拖痕渲染停用；保留原调查组件与完成后隐藏的金色提示。
- 导入 dohnjoe / raydevv 的两款免费 CC BY 4.0 资源，原始资源、纹理与来源记录在 Assets/Demo/ThirdParty/BloodClues。
- 使用原拖痕 PNG 制作两段贴合地形的血液拖痕，叠加血泊与飞溅。生成网格和 URP 材质位于 Assets/Demo/Environment/BloodClue。
- 修复首次预览的矩形底色：拖痕使用原始 FBX 包内 RGBA 纹理，关闭透明材质保留高光，使用正确的 Alpha 混合。
- BloodClueSetup.cs 提供显式编辑器命令；BloodClueProbe.cs 为按需添加的验证组件。场景已保存并重开，临时验证组件已移除。
- 工程原有四处材质浮点差异保留，未纳入本轮修改。

## 实际验证

环境：Windows Editor，Unity 2022.3.62f3 (96770f904ca7)，DX11。代码基点 main / 067a9e882ea5ca94e314030a91e7873dda99a020，加本轮未提交的场景、资源、集成工具和验证脚本。非干净工作区；未提交、推送或发布。

模式：真实 Unity Play Mode，使用真实 NavMeshAgent 和 DemoMovement.BeginInteraction；没有模拟操作系统鼠标/键盘。最终运行时间为 2026-11-06 16:01:10 至约 16:01:16（Asia/Shanghai）。

步骤：载入保存的场景；在调查点西南约 5m 的导航网格处放置角色；从真实跟随镜头向线索发射射线；执行 BeginInteraction；等待实际寻路和原调查流程；检查状态与提示；保存游戏相机渲染；退出 Play Mode；移除探针并重开保存的场景。

| 用例 | 预期 | 实际 |
| --- | --- | --- |
| 资源显示 | 所有血迹材质存在且着色器可用 | 4 个视觉渲染器，allShadersSupported=True |
| 射线选中 | 射线命中原调查对象 | raycastSelectable=True |
| 靠近调查 | 路径完整且能到达范围内 | PathComplete；1.41 秒；角色最终距锚点约 0.295m |
| 记录线索 | examined 与 HasTrail 为 true | 两者均 true |
| 完成反馈 | 调查后金色提示隐藏 | badgeHidden=True |
| 透明与摆放 | 无矩形底色，贴地且血迹明显 | 最终 detail.png 已人工查看，透明底色问题修复 |

最终结果：**血迹集成 PASS，验证脚本报告 exit_code=0**。这是验证脚本结果码，不是 Unity 进程退出码；编辑器仍保持打开。验证窗口内未捕获新的 Error/Exception/Assert。

原始结果：playmode.txt；游戏相机图：gameplay.png、detail.png；保存重开：saved.txt；构建参数：built.txt；本轮完整编辑器日志：../blood-clue-editor-20261106.log。

before-arm-playmode.txt 是早期仅血迹阶段的原始记录，当时旧脚本未将断臂存在性纳入总判定，其 PASS **不表示断臂完成**。最终 playmode.txt 已明确标注 blood-only 范围。initial-command-error.txt 保留初次命令早于脚本刷新造成的错误，已刷新后重跑成功，不删除历史证据。

## 未测与待办

断臂：下载尚未得到可用完整包，按用户要求暂缓，未导入/未测试；不得记为完成。未来 Build Selected Free Assets 会要求实际断臂 FBX，缺失时不会开始覆盖场景。

尚未执行本轮完整序章连续通关、Windows 独立构建、长期性能测试、全部鼠标点击角度或全部植被遮挡组合。Rock_A 凸碰撞多边形限制属于原有警告，本轮没有修改其碰撞体。徽记后续只筛选免费徽章/十字架资源。

恢复：scene-before.unity.txt 为编辑前完整场景副本，SHA-256 D9EE82AF9FE7B0A5BA990BFC06351A711BC292906F283424DF559ABB6D5E7F93；管理快照见仓库 Backups/DocsSync/20261106T154215938205 和 20261106T160233223492。恢复时先导出并比较，不自动覆盖当前场景。
