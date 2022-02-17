// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Utility {

    static HashMap<string, string> prefMap;
    static string prefFileName = "";
    const string sep = "ABC123";
    static Mutex mutex;
    public static string allSettings = "";

    public static void initMutex() {
        mutex = Mutex();
    }

    public static string getRadarSiteName(string radarSite) {
        return UtilityRadar.radarIdToName[radarSite] ?? "";
    }

    public static LatLon getRadarSiteLatLon(string radarSite) {
        var isTdwr = false;
        var radarPrefix = WXGLDownload.getRidPrefix(radarSite, isTdwr).ascii_up();
        if (radarSite.length == 4) {
            radarPrefix = "";
        }
        var lat = UtilityRadar.radarSiteToLat[radarPrefix + radarSite] ?? "";
        var lon = UtilityRadar.radarSiteToLon[radarPrefix + radarSite] ?? "";
        return new LatLon(lat, lon);
    }

    public static string getRadarSiteX(string radarSite) {
        var isTdwr = false;
        var radarPrefix = WXGLDownload.getRidPrefix(radarSite, isTdwr).ascii_up();
        if (radarSite.length == 4) {
            radarPrefix = "";
        }
        return UtilityRadar.radarSiteToLat[radarPrefix + radarSite] ?? "";
    }

    public static string getRadarSiteY(string radarSite) {
        var isTdwr = false;
        var radarPrefix = WXGLDownload.getRidPrefix(radarSite, isTdwr).ascii_up();
        if (radarSite.length == 4) {
            radarPrefix = "";
        }
        return UtilityRadar.radarSiteToLon[radarPrefix + radarSite] ?? "";
    }

    public static LatLon getWfoSiteLatLon(string wfo) {
        var lat = UtilityRadar.wfoSitetoLat[wfo] ?? "";
        var lon = UtilityRadar.wfoSitetoLon[wfo] ?? "";
        return new LatLon(lat, lon);
    }

    public static string safeGet(ArrayList<string> l, int index) {
        return (l.size <= index) ? "" : l[index];
    }

    public static string readPref(string key, string value) {
        return prefMap[key] ?? value;
    }

    public static int readPrefInt(string key, int value) {
        return Too.Int(prefMap[key] ?? Too.String(value));
    }

    public static void writePref(string key, string value) {
        mutex.lock();
        // can't support mulitine pref data at this time
        prefMap[key] = value.replace("\n", " ");
        mutex.unlock();
        prefSync();
    }

    public static void writePrefInt(string key, int value) {
        mutex.lock();
        prefMap[key] = Too.String(value);
        mutex.unlock();
        prefSync();
    }

    static void prefSync() {
        mutex.lock();
        var data = "";
        foreach (var key in prefMap.keys) {
            data += key;
            data += sep;
            data += prefMap[key];
            data += GlobalVariables.newline;
        }
        UtilityIO.writeTextFile(prefFileName, data);
        mutex.unlock();
    }

    public static void prefInit() {
        prefFileName = getPrefFile();
        prefMap = new HashMap<string, string>();
        var data = UtilityIO.readTextFile(prefFileName);
        var lines = data.split(GlobalVariables.newline);
        foreach (var line in lines) {
            if (line != "") {
                var items = line.split(sep);
                prefMap[items[0]] = items[1];
            }
        }
    }

    // get the location of the prefences file
    static string getPrefFile() {
        var path = UtilityFileManagement.getHomeDirectory() + "/" + ".config/" + GlobalVariables.appCreatorEmail + "/";
        var prefFileName = path + GlobalVariables.appName + ".conf";
        UtilityFileManagement.mkdir(path);
        return prefFileName;
    }

    // get all keys from the preferences map
    static ArrayList<string> prefGetAllKeys() {
        var keys = new ArrayList<string>();
        foreach (var k in prefMap.keys) {
            keys.add(k);
        }
        return keys;
    }

    // get all preference data as a string, sort keys
    // used to check if preferences have changed after closing
    // settings screens
    public static string getSettings() {
        var s = "";
        var keys = prefGetAllKeys();
        keys.sort();
        foreach (var key in keys) {
            s += key + ":" + readPref(key, "");
        }
        return s;
    }

    // store current settings to a static var for later comparison
    public static void recordAllSettings() {
        var s = "";
        var keys = prefGetAllKeys();
        keys.sort();
        foreach (var key in keys) {
            s += key + ":" + readPref(key, "");
        }
        allSettings = s;
    }
}
