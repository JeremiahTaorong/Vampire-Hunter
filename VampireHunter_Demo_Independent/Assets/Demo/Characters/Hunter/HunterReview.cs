using UnityEngine;
public class HunterReview:MonoBehaviour {
 public Animator animator; public Camera reviewCamera; public int mode; public string[] states={"Idle","Walk","Run"}; float yaw; Vector3 last; public bool followMovement;
 public bool captureSequence=true;
 System.Collections.IEnumerator Capture(){
 string dir=System.IO.Path.GetFullPath("Evidence/hunter-modular-screenshots");System.IO.Directory.CreateDirectory(dir);
 string[] shots={"front","back","side","walk","run"};float[] angles={0,180,90,45,90};int[] modes={0,0,0,1,2};
 for(int i=0;i<shots.Length;i++){yaw=angles[i];Play(modes[i]);yield return new WaitForSeconds(1.6f);yield return new WaitForEndOfFrame();ScreenCapture.CaptureScreenshot(dir+"/"+shots[i]+".png");System.IO.File.AppendAllText(dir+"/playmode.txt",shots[i]+" state="+animator.GetCurrentAnimatorStateInfo(0).shortNameHash+" human="+animator.isHuman+" rootMotion="+animator.applyRootMotion+" root="+transform.position+"\n");}
 yaw=0;Play(0);}
 void Start(){if(captureSequence && reviewCamera)StartCoroutine(Capture());animator.applyRootMotion=false;last=transform.position;}
 void Update(){
 if(Input.GetKeyDown(KeyCode.Alpha1))Play(0);if(Input.GetKeyDown(KeyCode.Alpha2))Play(1);if(Input.GetKeyDown(KeyCode.Alpha3))Play(2);
 if(Input.GetKey(KeyCode.Q))yaw-=60*Time.deltaTime;if(Input.GetKey(KeyCode.E))yaw+=60*Time.deltaTime;
 if(reviewCamera){reviewCamera.transform.position=Quaternion.Euler(0,yaw,0)*new Vector3(0,1.15f,3.6f);reviewCamera.transform.LookAt(new Vector3(0,1,0));}
 if(followMovement){float speed=(transform.position-last).magnitude/Mathf.Max(Time.deltaTime,.001f);int next=speed>.1f?2:0;if(next!=mode)Play(next);last=transform.position;}
 }
 public void Play(int i){mode=i;animator.CrossFade(states[i],.15f);}
 void OnGUI(){if(!reviewCamera)return;GUI.Box(new Rect(16,16,540,90),"HUNTER | Modular candidate - art review pending\n1 Idle    2 Walk    3 Run    Q/E Orbit\nDodge / Attack: source animation unavailable; not validated");}
}
