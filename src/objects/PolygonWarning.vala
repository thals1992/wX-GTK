// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class PolygonWarning {

    const string baseUrl = "https://api.weather.gov/alerts/active?event=";
    const string pVtec = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)";
    public static HashMap<PolygonType, PolygonWarning> byType;
    public static HashMap<PolygonType, string> namesByEnumId;
    public static HashMap<PolygonType, string> longName;
    public static HashMap<PolygonType, int> defaultColors;
    public const PolygonType[] polygonList = {
        PolygonType.Tor,
        PolygonType.Tst,
        PolygonType.Ffw,
        PolygonType.Smw,
        PolygonType.Sqw,
        PolygonType.Dsw,
        PolygonType.Sps
    };
    DataStorage storage;
    public bool isEnabled = false;
    PolygonType type;
    DownloadTimer timer;
    public int colorInt;

    public PolygonWarning(PolygonType type) {
        this.type = type;
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        storage = new DataStorage(prefTokenStorage());
        colorInt = Utility.readPrefInt("RADAR_COLOR_" + namesByEnumId[type].ascii_up(), defaultColors[type]);
        timer = new DownloadTimer("WARNINGS_" + getTypeName());
        storage.update();
    }

    public void download() {
        if (timer.isRefreshNeeded()) {
            var html = UtilityIO.getHtml(getUrl());
            if (html != "") {
                storage.setValue(html);
            }
        }
    }

    public string getData() {
        //  print(storage.getValue());
        return storage.getValue();
    }

    public string prefTokenEnabled() {
        return "RADAR_SHOW_" + typeName().ascii_up();
    }

    string prefTokenStorage() {
        return "SEVEREDASHBOARD" + typeName();
    }

    public string name() {
        var tmp = longName[type];
        tmp = tmp.replace("%20", " ");
        return tmp;
    }

    string typeName() {
        return type.to_string().replace("PolygonType.", "");
    }

    string getTypeName() {
        return type.to_string().replace("PolygonType.", "");
    }

    string getUrlToken() {
        return longName[type];
    }

    string getUrl() {
        return baseUrl + getUrlToken();
    }

    void update() {
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        colorInt = Utility.readPrefInt("RADAR_COLOR_" + namesByEnumId[type].ascii_up(), defaultColors[type]);
    }

    public static void load() {
        if (byType == null) {
            byType = new HashMap<PolygonType, PolygonWarning>();
            longName = new HashMap<PolygonType, string>();
            defaultColors = new HashMap<PolygonType, int>();
            namesByEnumId = new HashMap<PolygonType, string>();
            initStatic();
        }
        foreach (var data in PolygonWarning.polygonList) {
            if (!byType.keys.contains(data)) {
                byType[data] = new PolygonWarning(data);
            } else {
                byType[data].update();
            }
        }
    }

    public static bool areAnyEnabled() {
        var anyEnabled = false;
        foreach (var it in PolygonWarning.polygonList) {
            if (byType[it].isEnabled) {
                anyEnabled = true;
            }
        }
        return anyEnabled;
    }

    public static bool isCountNonZero() {
        var count = 0;
        foreach (var it in PolygonWarning.polygonList) {
            if (byType[it].isEnabled) {
                count += Warnings.getCount(it);
            }
        }
        return count > 0;
    }


    static void initStatic() {
        longName[PolygonType.Smw] = "Special%20Marine%20Warning";
        longName[PolygonType.Sqw] = "Snow%20Squall%20Warning";
        longName[PolygonType.Dsw] = "Dust%20Storm%20Warning";
        longName[PolygonType.Sps] = "Special%20Weather%20Statement";
        longName[PolygonType.Tor] = "Tornado%20Warning";
        longName[PolygonType.Tst] = "Severe%20Thunderstorm%20Warning";
        longName[PolygonType.Ffw] = "Flash%20Flood%20Warning";
        //  longName[PolygonType.ffw] = "Flood%20Warning";

        defaultColors[PolygonType.Smw] = Color.rgb(255, 165, 0);
        defaultColors[PolygonType.Sqw] = Color.rgb(199, 21, 133);
        defaultColors[PolygonType.Dsw] = Color.rgb(255, 228, 196);
        defaultColors[PolygonType.Sps] = Color.rgb(255, 228, 181);
        defaultColors[PolygonType.Tor] = Color.rgb(243, 85, 243);
        defaultColors[PolygonType.Tst] = Color.rgb(255, 255, 0);
        defaultColors[PolygonType.Ffw] = Color.rgb(0, 255, 0);

        namesByEnumId[PolygonType.Tst] = "tst";
        namesByEnumId[PolygonType.Tor] = "tor";
        namesByEnumId[PolygonType.Ffw] = "ffw";
        namesByEnumId[PolygonType.Sqw] = "sqw";
        namesByEnumId[PolygonType.Dsw] = "dsw";
        namesByEnumId[PolygonType.Sps] = "sps";
        namesByEnumId[PolygonType.Smw] = "smw";
    }
}
