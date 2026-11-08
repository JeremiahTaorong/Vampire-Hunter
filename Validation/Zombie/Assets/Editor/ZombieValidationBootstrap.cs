using System.IO;
using UnityEditor;

[InitializeOnLoad]
public static class ZombieValidationBootstrap
{
    static ZombieValidationBootstrap()
    {
        EditorApplication.delayCall += () =>
        {
            const string request = "Evidence/download-request";
            if (!File.Exists(request)) { ZombieAssetDownload.ResumeTracking(); return; }
            File.Delete(request);
            ZombieAssetDownload.Download();
        };
    }
}
