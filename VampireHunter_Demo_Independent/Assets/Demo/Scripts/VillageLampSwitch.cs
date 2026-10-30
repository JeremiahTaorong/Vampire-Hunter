using UnityEngine;
public class VillageLampSwitch : MonoBehaviour {
 public Light lamp; public float reach=5f; Transform player;
 void Start(){var p=GameObject.Find("Player");if(p) player=p.transform;}
 void Update(){if(player && lamp && Vector3.Distance(player.position,transform.position)<reach && Input.GetKeyDown(KeyCode.E)) lamp.enabled=!lamp.enabled;}
 void OnGUI(){if(player && Vector3.Distance(player.position,transform.position)<reach) GUI.Label(new Rect(Screen.width/2-100,Screen.height-90,300,30),"Press E to toggle house light");}
}
