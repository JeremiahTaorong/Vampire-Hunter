# 随身暖光与黑雾测试：用户审阅记录

日期：2026-10-28（Asia/Shanghai）  
范围：VampireHunter_Demo_Independent 独立 Demo

## 用户反馈

用户在查看本轮随身暖光与黑雾测试后明确表示：

> 很好，这一次雾气效果非常完美。写入md

来源：本次 Codex 对话中的用户消息。此反馈确认的是本轮雾气视觉效果；不推断对整张地图、灯具造型、所有美术或正式游戏设计的批准。

## 对应场景与效果

- 场景：`Assets/Demo/Scenes/PrologueCarriedDarkReview.unity`。
- 此版本停用原有场景灯光，由玩家携带暖色点光和 MicroAVL 光晕。
- 使用浓黑雾，玩家周围的雾按距离平滑减弱，随身光与局部减雾区域跟随玩家。
- 配置位于 `Assets/Demo/CarriedDarkReview/`；局部减雾使用单独的 `Assets/Demo/CarriedDarkFogShaders/`，不修改原始雾插件。
- 暖光球为效果占位，并非已确定的灯具实体或最终角色美术。

## 验证边界

Unity 编辑器 Play 模式检查过出生位置和一小段移动，画面中可见随身暖光；未完成整条路线、各种区域的可读性、玩法全流程或帧率测试。用户对雾效的正面反馈不等于这些测试通过。场景仍是独立 Demo 的美术测试版本，与正式游戏系统审批分开。
