# 村民证人 NPC 候选与照明修正

2026-10-30（Asia/Shanghai）。本文件保留第一版组装经过。用户随后同意继续加入手势，并认可已展示的主路径效果；当前交互版本见[NPC手势整合](NPC_Villager_Gesture_Integration.md)。不代表完整流程或正式系统审批。

## 已实现

当前场景：`Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity`。
广场篝火已恢复，校正到起伏地面上；独立复制已有Viking火焰/烟雾/火星循环效果，恢复强度约5、范围12m的闪烁火光及体积光、局部去雾。这是用户对上轮“环境灯移入屋内”的明确例外，其余窗光保持。
玩家Carried lantern（实际火把主光）强度3.5→6.5、范围9→13m；去雾半径至少内1.4/外6.5m，参考强度6.5，原火把动画、挂点、体积光和MicroAVL保留。

NPC素材：`Assets/SopaDopa/URP_Medieval_Fantasy/Constructor_URP.prefab`（用户Character Constructor包）。使用Body_Base、Body_Hands、Cloth_tunic、Cloth_pants、Lether_boot(left/right)、Lether_belt；暗灰绿布衣、棕裤、皮靴，露出面部。保留原PBR贴图及蒙皮，每模块66骨、无空骨引用。原Constructor_2_1Avatar有效Humanoid；复制独立Idle Controller，复用已有Idle动画，Root Motion关闭。

独立Prefab：`Assets/Demo/Characters/NPC/Villager/NPC_Villager_Witness_Candidate.prefab`。
独立审阅场景：`Assets/Demo/Scenes/NPCVillagerReview.unity`（中性补光，用于查看外观，不代表地图照明）。
当前地图隐藏旧证人的可视占位，保留其碰撞、clueId=witness、范围和原证言，挂入候选视觉；原素材包未修改。

## 已实测

真实Unity 2022.3.62f3/macOS Play Mode：BonfirePlaying=3；玩家火把强度6.5/范围13；调用原接近调查流程后witnessRecorded=True。NPC审阅场景实际播放Idle，Avatar valid/human=True，7个启用SkinnedMeshRenderer，nullBones=0，已查看多角度画面。
证据：`Evidence/villager-candidate-20261030/`，含built.txt、world-playmode.txt、npc-playmode.txt、bonfire.png、npc_world.png、npc_0/1/2.png。

## 第一版边界与未测项

第一版为无头发的成年男性村民，当前外观已获用户同意继续使用；发型、职业配件和脸部差异尚未继续细化；没有自动扩展更多NPC。仅验证待机和原证人调查，不代表走跑、战斗或全剧情验收。恢复篝火和扩大火把后未重做FPS对照，上一轮帧率不能直接作为当前版本的新结果。

## 保存收尾

Saved world=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity probe removed
Saved review=Assets/Demo/Scenes/NPCVillagerReview.unity probe removed; errors=0 warnings=2

世界与审阅场景临时测试驱动已移除；Unity停在NPC审阅场景，退出Play。

![NPC正面候选](Evidence/villager-candidate-20261030/npc_0.png)

2026-10-30：用户同意村民第一版并要求抱拳/交互指路。当前起伏村落证人接入原Humanoid IK与独立手指动作层，待机抱拳面向主角；原调查成功后0.45s放臂，双臂放下再等1.5s，左手指下个目标。原DemoInteractable仅加Activated通知，原记录/任务规则保留。真实PlayMode射线命中及BeginInteraction流程通过，Waiting采样确认，实际等待1.516s、左臂朝目标角差约0.51度，HasWitness=True；保存截图clasp/lowered/point.png。Saved and reopened=Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity; probe removed; errors=0 warnings=2。未回归全部目标分支、极端接近角度或完整序章。详情NPC_Villager_Gesture_Integration.md与Evidence/villager-gesture-20261030；正式审批不变。
