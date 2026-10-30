using UnityEngine;

// Small fire flicker for lanterns and torches so village light reads as alive at night.
public class LanternFlicker : MonoBehaviour
{
    public Light source;
    public float baseIntensity = 4f;
    public float amplitude = .35f;
    public float speed = 2.2f;
    float seed;

    void Start()
    {
        if (!source) source = GetComponent<Light>();
        seed = Random.value * 10f;
    }

    void Update()
    {
        if (!source) return;
        float n = Mathf.PerlinNoise(seed, Time.time * speed);
        source.intensity = baseIntensity * (1f - amplitude + amplitude * 2f * n);
    }
}
