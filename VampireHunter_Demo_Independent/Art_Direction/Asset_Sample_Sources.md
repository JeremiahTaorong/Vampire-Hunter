# 序章素材样片来源与状态

2026-10-28 用户同意此前推荐的三包素材用于统一风格样片。实际获取情况：

| 素材 | 实际状态 | 来源及许可 |
|---|---|---|
| Kenney Particle Pack | 已使用 `smoke_03.png` 作为多处雾粒子纹理；另保存 `smoke_06.png`，未在场景中引用 | [Kenney 官方页](https://kenney.nl/assets/particle-pack) 标注 CC0。官方下载迟滞；采用 [Calinou 公开镜像](https://github.com/Calinou/kenney-particle-pack)，压缩包所载修订 `ab7086639ee73be31abd87feb21bf1402d4e8144`，压缩包 SHA-256 `9d4ad2b3f9dbef4c34e8778e6ec372506333b7317e01ec1c852febfc91c8e0ee`。原包 LICENSE.txt 随纹理保留；未能与官方压缩包逐字比较。 |
| Quaternius Medieval Village | 未取得、未导入 | [作者官方页](https://quaternius.com/packs/medievalvillage.html) 标注 CC0；官方共享文件返回下载配额限制。 |
| Free Low Poly Nature Forest | 未取得、未导入 | [Unity Asset Store 页面](https://assetstore.unity.com/packages/3d/environments/landscapes/free-low-poly-nature-forest-205742) 标注免费及标准 Asset Store 许可；当前页面未显示领取入口，尚未完成账号领取或导入。 |

`PrologueFogSample.unity` 只加入 Kenney 纹理驱动的低密度村庄/入口/森林/远景雾粒子；房屋树木仍是几何体。Unity 脚本编译、材质与场景生成成功；本轮按用户要求未做画面、玩法或性能测试。分层雾的浓度、真实画面和视线遮挡均未验证；不能将概念图当成实际游戏截图。原 `PrologueAtmosphere.unity` 保留。

2026-10-28：用户反馈原雾团重复且太小。新 `PrologueSoftFog.unity` 使用自编程序化分层地面雾，不再引用 Kenney 烟团粒子；此前粒子样片和来源记录保留。Unity 静态摄像机预览已生成，动态与操作未测。
