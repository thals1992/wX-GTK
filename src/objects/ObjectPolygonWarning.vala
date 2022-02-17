// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectPolygonWarning {

    const string baseUrl = "https://api.weather.gov/alerts/active?event=";
    const string pVtec = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)";
    public static HashMap<PolygonType, ObjectPolygonWarning> polygonDataByType;
    public static HashMap<PolygonType, string> longName;
    public static HashMap<PolygonType, int> defaultColors;
    public const PolygonType[] polygonList = {
        PolygonType.tor,
        PolygonType.tst,
        PolygonType.ffw
    };
    DataStorage storage;
    bool isEnabled = false;
    PolygonType type;
    DownloadTimer timer;

    public ObjectPolygonWarning(PolygonType type) {
        this.type = type;
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        storage = new DataStorage(prefTokenStorage());
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
        return storage.getValue();
    }

    string prefTokenEnabled() {
        return "RADARSHOW" + typeName();
    }

    string prefTokenStorage() {
        return "SEVEREDASHBOARD" + typeName();
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

    public static void load( ) {
        polygonDataByType = new HashMap<PolygonType, ObjectPolygonWarning>();
        longName = new HashMap<PolygonType, string>();
        defaultColors = new HashMap<PolygonType, int>();
        foreach (var data in ObjectPolygonWarning.polygonList) {
            polygonDataByType[data] = new ObjectPolygonWarning(data);
        }
        init();
    }

    static void init() {
        longName[PolygonType.smw] = "Special%20Marine%20Warning";
        longName[PolygonType.sqw] = "Snow%20Squall%20Warning";
        longName[PolygonType.dsw] = "Dust%20Storm%20Warning";
        longName[PolygonType.sps] = "Special%20Weather%20Statement";
        longName[PolygonType.tor] = "Tornado%20Warning";
        longName[PolygonType.tst] = "Severe%20Thunderstorm%20Warning";
        longName[PolygonType.ffw] = "Flash%20Flood%20Warning";

        defaultColors[PolygonType.smw] = Color.rgb(255, 165, 0);
        defaultColors[PolygonType.sqw] = Color.rgb(199, 21, 133);
        defaultColors[PolygonType.dsw] = Color.rgb(255, 228, 196);
        defaultColors[PolygonType.sps] = Color.rgb(255, 228, 181);
        defaultColors[PolygonType.tor] = Color.rgb(243, 85, 243);
        defaultColors[PolygonType.tst] = Color.rgb(255, 255, 0);
        defaultColors[PolygonType.ffw] = Color.rgb(0, 255, 0);
    }
}
