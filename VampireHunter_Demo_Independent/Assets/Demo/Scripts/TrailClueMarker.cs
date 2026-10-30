using UnityEngine;
public class TrailClueMarker:MonoBehaviour {
 public DemoInteractable clue;public Transform badge;public Camera view;
 void LateUpdate(){if(!badge)return;if(clue&&clue.examined){badge.gameObject.SetActive(false);return;}if(view)badge.rotation=view.transform.rotation;}
}
