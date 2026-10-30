using UnityEngine; using UnityEditor; using UnityEditor.Animations; using UnityEditor.SceneManagement; using UnityEngine.SceneManagement;
public static class HunterSceneSetup {
 const string D="Assets/Demo/Characters/Hunter_Validation_20261029/";
 static AnimationClip Clip(string name,float period,float amount){
  var c=new AnimationClip{name=name,frameRate=30};
  void Curve(string muscle,float a,float b,float d){ var curve=new AnimationCurve(new Keyframe(0,a),new Keyframe(period/4,b),new Keyframe(period/2,-a),new Keyframe(3*period/4,-b),new Keyframe(period,a)); c.SetCurve("",typeof(Animator),muscle,curve); }
  Curve("Left Upper Leg Front-Back",0,amount,0); Curve("Right Upper Leg Front-Back",0,-amount,0); Curve("Left Lower Leg Stretch",0,amount*.45f,0); Curve("Right Lower Leg Stretch",0,-amount*.45f,0); Curve("Left Arm Front-Back",0,-amount*.5f,0); Curve("Right Arm Front-Back",0,amount*.5f,0);
  var settings=AnimationUtility.GetAnimationClipSettings(c); settings.loopTime=true; AnimationUtility.SetAnimationClipSettings(c,settings); AssetDatabase.CreateAsset(c,D+name+".anim"); return c;
 }
 public static void Run(){
  var idle=Clip("Preview_Idle",2,0.015f); var walk=Clip("Preview_Walk",1.1f,.3f); var run=Clip("Preview_Run",.7f,.5f);
  var ctrl=AnimatorController.CreateAnimatorControllerAtPath(D+"Hunter_AnimationTest.controller"); ctrl.AddParameter("Mode",AnimatorControllerParameterType.Int); var sm=ctrl.layers[0].stateMachine; var clips=new[]{idle,walk,run}; var states=new AnimatorState[3];
  for(int j=0;j<3;j++){states[j]=sm.AddState(clips[j].name); states[j].motion=clips[j]; var tr=sm.AddAnyStateTransition(states[j]); tr.hasExitTime=false;tr.duration=.12f;tr.canTransitionToSelf=false;tr.AddCondition(AnimatorConditionMode.Equals,j,"Mode");}
  var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single); var src=AssetDatabase.LoadAssetAtPath<GameObject>(D+"Hunter_Rigged_Candidate.fbx"); var go=(GameObject)PrefabUtility.InstantiatePrefab(src); go.name="Hunter_Rigged_Validation"; var animator=go.GetComponent<Animator>(); animator.runtimeAnimatorController=ctrl; animator.applyRootMotion=false;
  var r=go.GetComponentInChildren<SkinnedMeshRenderer>(); var old=AssetDatabase.LoadAssetAtPath<Material>("Assets/Demo/Characters/MidnightGunslinger/GunslingerURP.mat"); if(old!=null && r!=null){var mat=new Material(old); AssetDatabase.CreateAsset(mat,D+"Hunter_Validation.mat"); r.sharedMaterial=mat;}
  var b=r.bounds; go.transform.position=new Vector3(0,-b.min.y,0); var p=go.AddComponent<HunterPreview>(); p.animator=animator; PrefabUtility.SaveAsPrefabAsset(go,D+"Hunter_Rigged_Validation.prefab");
  var light=new GameObject("Light"); light.AddComponent<Light>().type=LightType.Directional; light.transform.rotation=Quaternion.Euler(45,-30,0);
  var camera=new GameObject("Camera"); var cam=camera.AddComponent<Camera>(); camera.tag="MainCamera"; camera.transform.position=new Vector3(0,1.05f,-4); camera.transform.LookAt(new Vector3(0,1,0)); cam.orthographic=true; cam.orthographicSize=1.3f; cam.clearFlags=CameraClearFlags.SolidColor;cam.backgroundColor=new Color(.15f,.15f,.17f);
  EditorSceneManager.SaveScene(scene,D+"Hunter_Rigging_Validation.unity"); AssetDatabase.SaveAssets(); Debug.Log("HUNTER_SCENE_CREATED bounds="+b);
 }
}
