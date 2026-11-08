# Shirtless zombie integration

Source: FREE Shirtless Zombie, Studio New Punch
https://assetstore.unity.com/packages/3d/characters/humanoids/free-shirtless-zombie-276762
Downloaded using the user's Unity account. Original vendor assets and GUIDs retained in Assets/NewPunch/ShirtlessZombieFree; original Asset Store license applies.

Zombie_Shamble.anim and Zombie_Bite.anim are custom baked skeleton animations from the independent zombie-validation project, revised to open-arm zombie clasp, outward release and target clearance checks. No facial animation. The source retains a humanoid avatar; these clips play as transform curves on the same skeleton.

The visual prefab has no gameplay controller or damage collider. DemoEnemy and its original root collider/nav agent retain health, player targeting, damage checks, checkpoint reset and prologue ownership. DemoZombieVisual maps navigation and attack-start/reset notifications to animation, and plants the agent during the grab. Source Demo health/damage/windup/cooldown are retained. Scene-only fit parameters: .85 m/s approach, .9 m stopping distance, 1.05 m grab distance.
