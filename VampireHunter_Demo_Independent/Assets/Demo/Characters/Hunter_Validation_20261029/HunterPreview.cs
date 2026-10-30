using UnityEngine;
public class HunterPreview : MonoBehaviour {
 public Animator animator; float timer;
 void Update(){timer+=Time.deltaTime; int mode=(int)(timer/6)%3; if(Input.GetKeyDown(KeyCode.Alpha1)) {timer=0;mode=0;} if(Input.GetKeyDown(KeyCode.Alpha2)){timer=6;mode=1;} if(Input.GetKeyDown(KeyCode.Alpha3)){timer=12;mode=2;} animator.SetInteger("Mode",mode);}
}
