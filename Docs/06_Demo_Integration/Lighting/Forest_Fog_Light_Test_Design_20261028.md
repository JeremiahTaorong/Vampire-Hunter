# 森林雾与光照插件对照测试设计

> 目录整理：2026-11-08。文中 `Assets/`、`Evidence/` 和 `Art_Direction/` 路径均以 `VampireHunter_Demo_Independent` 工程根目录为基准。

日期：2026-10-28。范围：VampireHunter_Demo_Independent，设计草案，尚未实施或获得美术批准。

## 目标

比较森林近地雾、树间层次与暖灯在雾中的可见效果，同时保持角色、道路、敌人和目标可辨识。以 Unity 游戏相机实际画面及走动体验供用户审阅。

## 资源及状态

| 资源 | 来源 | 状态和注意事项 |
|---|---|---|
| Skyshin1 UnityURPVolumeFog | https://github.com/Skyshin1/UnityURPVolumeFog | 已下载至 Assets/Demo/ThirdParty/SkyshinVolumeFog；MIT，保留 LICENSE.md；声明 Unity 2022.3.18f1 起，尚未编译或运行验证。 |
| MicroAVL | https://akidevcat.itch.io/microavl | 免费，自选价格；下载和许可细节待确认，尚未导入。主要测试局部体积光。 |
| Better Fog | https://assetstore.unity.com/packages/vfx/shaders/better-fog-height-fog-light-scattering-more-259457 | 付费，尚未购买或导入；2022 URP 版本需确认可用。非体积雾；作者说明不支持 MSAA、正交相机。 |
| URP Dynamic Weather System | 用户截图 | 具体来源、版本及许可尚未确认，等待资源链接。 |

## 场景方案

从 PrologueForestFinalReview 复制新场景，保留原场景及其资源。先测试 Skyshin1 体积雾：使用独立渲染配置和 Volume，启用相机后处理，分别开启主光与选定暖色点光的雾贡献；对照原场景中现有 SoftMist，避免两种雾叠加导致误判。根据插件要求检查点光组件、深度和透明对象效果。不要未经验证变更所有场景共用的渲染配置。

MicroAVL 和 Better Fog 在合法取得后各自建立可比较的版本；先单独比较，再按实际效果决定是否组合，避免一次引入多个因素。天气系统待确认身份后再设计测试。

## 评估和证据

1. 固定相机、角色位置与灯光，记录原版与新方案的 Unity 实际截图，并标记参数。
2. 在播放模式沿森林路线检查近、中、远景，角色及目标可读性、雾与树叶边缘、遮挡渐隐、暖光是否过曝，以及动态移动时的闪烁。
3. 记录机器、分辨率、画质、帧率和帧时间；同条件对照，不以截图代替性能或玩法测试。
4. 单独记录实际键鼠、寻路、完整流程及未测项；截图或自动移动不能证明这些通过。
5. 提交实际画面供用户审美；样片和静态图不代表最终批准。

## 约束

不覆盖或删除现有场景与文件，不修改正式游戏和根目录基准；不擅自购买、改账号或发布。素材取得与许可证分别核验。需要用户决定可见灯具的造型时先提供图审阅。
