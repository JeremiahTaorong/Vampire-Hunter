using UnityEngine;
using UnityEditor;
using System.Linq;
public static class HunterSetup {
 public static void Run() {
  string path="Assets/Demo/Characters/Hunter_Validation_20261029/Hunter_Rigged_Candidate.fbx";
  var i=(ModelImporter)AssetImporter.GetAtPath(path); i.animationType=ModelImporterAnimationType.Human; i.avatarSetup=ModelImporterAvatarSetup.CreateFromThisModel;
  var hd=i.humanDescription;
  string[,] pairs={{"Hips","Hips"},{"Spine","Spine"},{"Chest","Chest"},{"Neck","Neck"},{"Head","Head"},{"LeftShoulder","Shoulder.L"},{"LeftUpperArm","UpperArm.L"},{"LeftLowerArm","LowerArm.L"},{"LeftHand","Hand.L"},{"RightShoulder","Shoulder.R"},{"RightUpperArm","UpperArm.R"},{"RightLowerArm","LowerArm.R"},{"RightHand","Hand.R"},{"LeftUpperLeg","UpperLeg.L"},{"LeftLowerLeg","LowerLeg.L"},{"LeftFoot","Foot.L"},{"LeftToes","Toes.L"},{"RightUpperLeg","UpperLeg.R"},{"RightLowerLeg","LowerLeg.R"},{"RightFoot","Foot.R"},{"RightToes","Toes.R"}};
  var bones=new HumanBone[pairs.GetLength(0)]; for(int j=0;j<bones.Length;j++){ bones[j].humanName=pairs[j,0]; bones[j].boneName=pairs[j,1]; bones[j].limit.useDefaultValues=true; } hd.human=bones; i.humanDescription=hd; i.SaveAndReimport();
  var avatar=AssetDatabase.LoadAllAssetsAtPath(path).OfType<Avatar>().FirstOrDefault(); Debug.Log("HUNTER_AVATAR "+(avatar==null?"missing":$"valid={avatar.isValid} human={avatar.isHuman}"));
 }
}
