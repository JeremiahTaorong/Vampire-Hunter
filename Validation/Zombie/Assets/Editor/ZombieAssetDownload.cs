using System;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

public static class ZombieAssetDownload
{
    static object operation;
    static double deadline;
    static string lastState;
    static double transferStarted;
    static readonly BindingFlags Flags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static;
    static Type Internal(string name) => AppDomain.CurrentDomain.GetAssemblies().Select(a => a.GetType("UnityEditor.PackageManager.UI.Internal." + name)).First(t => t != null);
    public static void OpenValidation()
    {
        UnityEditor.PackageManager.UI.Window.Open("276762");
        Debug.Log("ZOMBIE: Independent validation project. Sign in to the account owning asset 276762 before downloading.");
    }
    public static void Download()
    {
        var containerType = Internal("ServicesContainer");
        var instance = containerType.BaseType.GetProperty("instance", Flags).GetValue(null);
        var resolve = containerType.GetMethod("Resolve", Flags);
        Func<string, object> service = name => resolve.MakeGenericMethod(Internal(name)).Invoke(instance, null);
        var connect = service("UnityConnectProxy");
        Debug.Log("ZOMBIE loggedIn=" + connect.GetType().GetProperty("isUserLoggedIn", Flags).GetValue(connect));
        var manager = service("AssetStoreDownloadManager");
        operation = Activator.CreateInstance(Internal("AssetStoreDownloadOperation"), Flags, null,
            new object[] { service("AssetStoreUtils"), service("AssetStoreRestAPI"), service("AssetStoreCachePathProxy"), "276762", null }, null);
        manager.GetType().GetMethod("SetupDownloadOperation", Flags).Invoke(manager, new[] { operation });
        manager.GetType().GetMethod("RegisterDownloadDelegate", Flags).Invoke(manager, null);
        operation.GetType().GetMethod("Download", Flags).Invoke(operation, new object[] { false });
        deadline = EditorApplication.timeSinceStartup + 1200;
        EditorApplication.update += Poll;
    }
    public static void ResumeTracking()
    {
        if (operation != null) return;
        var type = Internal("ServicesContainer");
        var instance = type.BaseType.GetProperty("instance", Flags).GetValue(null);
        var manager = type.GetMethod("Resolve", Flags).MakeGenericMethod(Internal("AssetStoreDownloadManager")).Invoke(instance, null);
        var existing = manager.GetType().GetMethod("GetDownloadOperation", Flags).Invoke(manager, new object[] { "276762" });
        if (existing == null) return;
        operation = existing;
        deadline = EditorApplication.timeSinceStartup + 1200;
        EditorApplication.update += Poll;
    }
    static void Poll()
    {
        if (operation == null) return;
        var type = operation.GetType();
        string state = type.GetProperty("state", Flags).GetValue(operation).ToString();
        if (state != lastState)
        {
            Debug.Log("ZOMBIE download=" + state);
            lastState = state;
            if (state == "Downloading") transferStarted = EditorApplication.timeSinceStartup;
        }
        if (state == "Downloading" && EditorApplication.timeSinceStartup - transferStarted > 100)
        {
            type.GetMethod("Pause", Flags).Invoke(operation, null);
            transferStarted = EditorApplication.timeSinceStartup;
        }
        if (state == "Paused") type.GetMethod("Download", Flags).Invoke(operation, new object[] { true });
        if (state == "Completed")
        {
            string path = (string)type.GetProperty("packageNewPath", Flags).GetValue(operation);
            System.IO.File.WriteAllText("Evidence/package-path.txt", path);
            Debug.Log("ZOMBIE DOWNLOAD PASS " + path);
            EditorApplication.Exit(0);
        }
        else if (state == "Error" || state == "Aborted" || EditorApplication.timeSinceStartup > deadline)
        {
            Debug.LogError("ZOMBIE DOWNLOAD FAILED: " + type.GetProperty("errorMessage", Flags).GetValue(operation));
            EditorApplication.Exit(1);
        }
    }
    public static void Inspect()
    {
        foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
        foreach (var type in assembly.GetTypes().Where(t => t.FullName.Contains("PackageManager") &&
            (t.Name == "AssetStoreDownloadOperation" || t.Name == "AssetStorePackage" || t.Name == "ServicesContainer" || t.Name == "AssetStoreUtils" || t.Name == "UnityConnectProxy")))
        {
            Debug.Log("ZOMBIE API " + type.FullName);
            foreach (var ctor in type.GetConstructors(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)) Debug.Log("ZOMBIE CTOR " + ctor);
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static)) Debug.Log("ZOMBIE PROP " + prop);
            foreach (var method in type.GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly))
                Debug.Log("ZOMBIE METHOD " + method);
        }
        EditorApplication.Exit(0);
    }
}
