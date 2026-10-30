# 桌面目录落盘验证

日期：2026-10-28T12:18:19.977442+08:00（Asia/Shanghai）
目标：`/Users/dorimiah/Desktop/vampire`
结果：PASS

新增 70 个文件；未覆盖、删除、移动任何已有文件。原有 5 文件 SHA-256 再核验：全部一致。
本轮无 Git 初始化/提交、Unity 工程创建或运行、玩法实现、外部操作。S01 批准仍为 0/13；T01–T16 全部未执行。

实际桌面目录检查命令退出码：0

```text
PASS: 5 original hashes, 123 requirement mappings, 13 independent templates, approvals, phase gate, test metadata, generated state and local links.
Document consistency only. No Unity or gameplay test was run by this tool.
```

## 新增文件与摘要（本记录自身除外）

| 文件 | SHA-256 |
|---|---|
| `AGENTS.md` | `426b470e1f98296699e87b4c9fba9d678e9dcad1584551067b9edb9576fffef9` |
| `Backups/Bootstrap_2026-10-28/manifest.json` | `2ea3319a531ece147d36d33aa1fae3845219ad725af01cec210b122e56a0744e` |
| `Backups/Bootstrap_2026-10-28/originals/Vampire_Hunter_Complete_Story_Narrative_v2_2026-10-28.md` | `8cbfb6671291a3335a8feec1c0baa4499486e4cd74c87329ede56c059685cd63` |
| `Backups/Bootstrap_2026-10-28/originals/Vampire_Hunter_Decision_Register_F01-F38_2026-10-28.md` | `f147e1f588aaf9a758b58290907d97d1d067c24c7478b963fe6bdf8c6eabf224` |
| `Backups/Bootstrap_2026-10-28/originals/Vampire_Hunter_GDD_v4_Design_Frozen_R01-R84_F01-F38_2026-10-28.md` | `dbf397a4d666df277df9c48d05dae66e4b954fed5c495d4cb6e7469b4116db41` |
| `Backups/Bootstrap_2026-10-28/originals/Vampire_Hunter_Open_Source_and_Free_Assets_2026-10-28.md` | `aa906cb56966efcc580c495d77f4a636ca94c99f80457ecffc9ab000324fe06d` |
| `Backups/Bootstrap_2026-10-28/originals/Vampire_Hunter_System_Coverage_Matrix_v1_2026-10-28.md` | `7611f00aef2500c21e871b90e47c221a46c1f97b6dc371ee774956706ee47ab3` |
| `Backups/DocsSync/20261028T121618461211/manifest.json` | `b5f371a0f02fe06311233a5ba987ca112884729ba9795c442cbf1bfe654a9ac5` |
| `Backups/DocsSync/20261028T121739067896/files/AGENTS.md` | `426b470e1f98296699e87b4c9fba9d678e9dcad1584551067b9edb9576fffef9` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/00_Baseline/BASELINE_INDEX.md` | `038730cbff075f0c9947ff335af9359c66ccc767ed5ccdee08fc8b9ddb27aa90` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/00_Baseline/Baseline_Manifest.json` | `2ea3319a531ece147d36d33aa1fae3845219ad725af01cec210b122e56a0744e` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/01_Coverage/System_Coverage_Tracking.md` | `9c6aae19cc341395119e850c5ba4a840b8ecdb6e0b066504a5136a3c8fa1a9c4` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/01_Coverage/requirements.json` | `9437e0363bfd47f686b9493e05401507d0e1305763116268a14aa36bf95103e4` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/S01_Player_Control.md` | `de906f4a741d9124dd189b3e1ec6a13fb2fc4717af36fc0877aadf945b84f596` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/SYSTEM_INDEX.md` | `a69120a1d2a0afa1aaa8c3826b982d36c4ba21fcff75761aeac447b556442778` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S01_Player_Control_Template.md` | `202039d0a727612c47f7911cfa6245ad3c907a677aa81013a110972bc4b2a3a1` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S02_Combat_Skills_Template.md` | `146e535169ed4f51bafe9a33c795fde8bd30aa3faf4f6c5185f256868ef26b82` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S03_Character_Forms_Template.md` | `fe7b37546d9e3c2cfeba4e11f841ee1a8540e126c9e2f2a9a7d31f3cd0a523e3` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S04_Resources_Corruption_Template.md` | `ea330bf0b97187c31caa520dfdd474d1015a3de9ffa03724ea33b04600b72f82` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S05_Enemy_Boss_Template.md` | `a9181f7b9331ee68b1df928823c06673e565d135bc4b8e7ef9a5bd9d0af06703` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S06_Progression_Loadouts_Template.md` | `d139f8ba4586f95f69b00dd72ec09c3b229262691974ce5f8ae85162a1000465` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S07_World_Level_Template.md` | `ec7e173a984270bd5de1b32d797c033b9368956c33589c4dcecadcf132603222` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S08_Puzzles_Interactables_Template.md` | `570cb8d9d205d79a1e471dd7ac58db2dfe422d7343fcfb96822644dde601334e` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S09_Narrative_Quests_Template.md` | `be0df2daacd6fe2dce4a2f154d23229bddcb41873cec1acf8433d39ec91b58b4` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S10_Endings_Template.md` | `ca519f5834428456dd59d4c55111bea2e9589205d37fa21b9e38ed75acedda1f` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S11_UI_UX_Template.md` | `7769d74ed996620a4c15563448dc5150d73c246f53645588db9abc03db5dbfed` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S12_Checkpoints_Persistence_Template.md` | `3a373c09111cd4dda7dc7b44e79a69327481e05c021c4cb0f6f13bf12aecbd10` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/02_Systems/Templates/S13_Camera_Art_Audio_Template.md` | `81cf7c7fe90be22473c8b6d5e48a1e70ddbc80d6dd97d8eff61dc63dc28d3d32` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/CHANGE_LOG.md` | `a8a59dd116759a2dc8841a082a3275632163b56e855427e43a10db88ae147a0d` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/CR_TEMPLATE.md` | `036010e73116bc83f132baff741e80047324edd1847d96ec5920179a5ac255cf` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/Evidence/BOOTSTRAP_VALIDATION.md` | `d3a22df2687c33881bdd8274e29405f090970002d3e8b4d657689a8e5519cfa0` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/Evidence/tool_test_results.json` | `9ad12a146938e75b5924a905acd27c87a828e0667eea19fa6bc04aa942ec5302` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/INITIAL_INSPECTION.md` | `ea8b0534fd2d71b1c8081a7a7dd2affb5db123e784eacbd3b237b7a46379f435` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/RECOVERY_AND_SYNC.md` | `a076813d111e0a69d794a3230426d506860057f37180742b7048ae7059fe582d` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/REVIEW_REGISTER.md` | `e9042fdd4e6ab979792f7c196df8436faafa06a2be2ddf9b965b45573c4906cc` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/03_Management/workflow_state.json` | `e788a905abe9384a088d7895c7451004253d43c339230c3f07407c2833047ad2` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/05_Testing/TEST_INDEX.md` | `2bac0259e0b5d1b9dbb7e687ccf7fe20ceaaea6b7393c81928a2078ea8208cf0` |
| `Backups/DocsSync/20261028T121739067896/files/Docs/PROJECT_STATUS.md` | `b79b1d4ba65f2caa1c3a822e29639f981a46764d1ede1426bffd778608f7a30a` |
| `Backups/DocsSync/20261028T121739067896/files/Tools/docs_workflow.py` | `f9cf44eedfc02e12fc9ef5e275cdf85334f49def888b85c687a9c076c78fcd08` |
| `Backups/DocsSync/20261028T121739067896/manifest.json` | `cbaf8b7fc6cb4bbbb352d7e669f692d451ac26cbd9f663489e559e3f4f48418a` |
| `Docs/00_Baseline/BASELINE_INDEX.md` | `038730cbff075f0c9947ff335af9359c66ccc767ed5ccdee08fc8b9ddb27aa90` |
| `Docs/00_Baseline/Baseline_Manifest.json` | `2ea3319a531ece147d36d33aa1fae3845219ad725af01cec210b122e56a0744e` |
| `Docs/01_Coverage/System_Coverage_Tracking.md` | `9c6aae19cc341395119e850c5ba4a840b8ecdb6e0b066504a5136a3c8fa1a9c4` |
| `Docs/01_Coverage/requirements.json` | `9437e0363bfd47f686b9493e05401507d0e1305763116268a14aa36bf95103e4` |
| `Docs/02_Systems/S01_Player_Control.md` | `de906f4a741d9124dd189b3e1ec6a13fb2fc4717af36fc0877aadf945b84f596` |
| `Docs/02_Systems/SYSTEM_INDEX.md` | `a69120a1d2a0afa1aaa8c3826b982d36c4ba21fcff75761aeac447b556442778` |
| `Docs/02_Systems/Templates/S01_Player_Control_Template.md` | `202039d0a727612c47f7911cfa6245ad3c907a677aa81013a110972bc4b2a3a1` |
| `Docs/02_Systems/Templates/S02_Combat_Skills_Template.md` | `146e535169ed4f51bafe9a33c795fde8bd30aa3faf4f6c5185f256868ef26b82` |
| `Docs/02_Systems/Templates/S03_Character_Forms_Template.md` | `fe7b37546d9e3c2cfeba4e11f841ee1a8540e126c9e2f2a9a7d31f3cd0a523e3` |
| `Docs/02_Systems/Templates/S04_Resources_Corruption_Template.md` | `ea330bf0b97187c31caa520dfdd474d1015a3de9ffa03724ea33b04600b72f82` |
| `Docs/02_Systems/Templates/S05_Enemy_Boss_Template.md` | `a9181f7b9331ee68b1df928823c06673e565d135bc4b8e7ef9a5bd9d0af06703` |
| `Docs/02_Systems/Templates/S06_Progression_Loadouts_Template.md` | `d139f8ba4586f95f69b00dd72ec09c3b229262691974ce5f8ae85162a1000465` |
| `Docs/02_Systems/Templates/S07_World_Level_Template.md` | `ec7e173a984270bd5de1b32d797c033b9368956c33589c4dcecadcf132603222` |
| `Docs/02_Systems/Templates/S08_Puzzles_Interactables_Template.md` | `570cb8d9d205d79a1e471dd7ac58db2dfe422d7343fcfb96822644dde601334e` |
| `Docs/02_Systems/Templates/S09_Narrative_Quests_Template.md` | `be0df2daacd6fe2dce4a2f154d23229bddcb41873cec1acf8433d39ec91b58b4` |
| `Docs/02_Systems/Templates/S10_Endings_Template.md` | `ca519f5834428456dd59d4c55111bea2e9589205d37fa21b9e38ed75acedda1f` |
| `Docs/02_Systems/Templates/S11_UI_UX_Template.md` | `7769d74ed996620a4c15563448dc5150d73c246f53645588db9abc03db5dbfed` |
| `Docs/02_Systems/Templates/S12_Checkpoints_Persistence_Template.md` | `3a373c09111cd4dda7dc7b44e79a69327481e05c021c4cb0f6f13bf12aecbd10` |
| `Docs/02_Systems/Templates/S13_Camera_Art_Audio_Template.md` | `81cf7c7fe90be22473c8b6d5e48a1e70ddbc80d6dd97d8eff61dc63dc28d3d32` |
| `Docs/03_Management/CHANGE_LOG.md` | `a8a59dd116759a2dc8841a082a3275632163b56e855427e43a10db88ae147a0d` |
| `Docs/03_Management/CR_TEMPLATE.md` | `036010e73116bc83f132baff741e80047324edd1847d96ec5920179a5ac255cf` |
| `Docs/03_Management/Evidence/BOOTSTRAP_VALIDATION.md` | `d3a22df2687c33881bdd8274e29405f090970002d3e8b4d657689a8e5519cfa0` |
| `Docs/03_Management/Evidence/tool_test_results.json` | `9ad12a146938e75b5924a905acd27c87a828e0667eea19fa6bc04aa942ec5302` |
| `Docs/03_Management/INITIAL_INSPECTION.md` | `ea8b0534fd2d71b1c8081a7a7dd2affb5db123e784eacbd3b237b7a46379f435` |
| `Docs/03_Management/RECOVERY_AND_SYNC.md` | `a076813d111e0a69d794a3230426d506860057f37180742b7048ae7059fe582d` |
| `Docs/03_Management/REVIEW_REGISTER.md` | `e9042fdd4e6ab979792f7c196df8436faafa06a2be2ddf9b965b45573c4906cc` |
| `Docs/03_Management/workflow_state.json` | `e788a905abe9384a088d7895c7451004253d43c339230c3f07407c2833047ad2` |
| `Docs/05_Testing/TEST_INDEX.md` | `2bac0259e0b5d1b9dbb7e687ccf7fe20ceaaea6b7393c81928a2078ea8208cf0` |
| `Docs/PROJECT_STATUS.md` | `b79b1d4ba65f2caa1c3a822e29639f981a46764d1ede1426bffd778608f7a30a` |
| `Tools/docs_workflow.py` | `f9cf44eedfc02e12fc9ef5e275cdf85334f49def888b85c687a9c076c78fcd08` |
