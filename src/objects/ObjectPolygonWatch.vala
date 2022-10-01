// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectPolygonWatch {

    const string baseUrl = "https://api.weather.gov/alerts/active?event=";
    public static HashMap<PolygonType, int> defaultColors;
    public static HashMap<PolygonType, string> longName;
    public const PolygonType[] polygonList = {
        PolygonType.Watch,
        PolygonType.WatchTornado,
        PolygonType.Mcd,
        PolygonType.Mpd
    };
    public static HashMap<PolygonType, ObjectPolygonWatch> polygonDataByType;
    public static HashMap<PolygonType, int> colorDefaultByType;
    public static HashMap<PolygonType, string> colorPrefByType;

    public static DataStorage watchLatlonCombined;

    DataStorage storage;
    public DataStorage latLonList;
    public DataStorage numberList;
    public bool isEnabled = false;
    PolygonType type;
    DownloadTimer timer;
    public int colorInt;

    public ObjectPolygonWatch(PolygonType type) {
        this.type = type;
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        storage = new DataStorage(prefTokenStorage());
        storage.update();
        latLonList = new DataStorage(prefTokenLatLon());
        latLonList.update();
        numberList = new DataStorage(prefTokenNumberList());
        numberList.update();
        colorInt = Utility.readPrefInt(colorPrefByType[type], colorDefaultByType[type]);
        timer = new DownloadTimer("WATCH_" + getTypeName());
    }

    public void download() {
        if (timer.isRefreshNeeded()) {
            var html = UtilityIO.getHtml(getUrl());
            storage.setValue(html);
            if (type == PolygonType.Mpd) {
                var numberListString = "";
                var latLonString = "";
                var numbers = UtilityString.parseColumn(storage.getValue(), ">MPD #(.*?)</a></strong>");
                foreach (var number in numbers) {
                    var text = UtilityDownload.getTextProduct("WPCMPD" + number);
                    numberListString += number + ":";
                    latLonString += LatLon.storeWatchMcdLatLon(text);
                }
                latLonList.setValue(latLonString);
                numberList.setValue(numberListString);
            } else if (type == PolygonType.Mcd) {
                var numberListString = "";
                var latLonString = "";
                var numbers = UtilityString.parseColumn(html, "<strong><a href=./products/md/md.....html.>Mesoscale Discussion #(.*?)</a></strong>");
                foreach (var number in numbers) {
                    var numberModified = number.replace(" ", "");
                    numberModified = Too.StringPadLeftZeros(Too.Int(numberModified), 4);
                    var text = UtilityDownload.getTextProduct("SPCMCD" + numberModified);
                    numberListString += numberModified + ":";
                    latLonString += LatLon.storeWatchMcdLatLon(text);
                }
                latLonList.setValue(latLonString);
                numberList.setValue(numberListString);
            } else if (type == PolygonType.Watch) {
                var numberListString = "";
                var latLonString = "";
                var latLonTorString = "";
                var latLonCombinedString = "";
                var numbers = UtilityString.parseColumn(html, "[om] Watch #([0-9]*?)</a>");
                foreach (var number in numbers) {
                    numberListString += Too.StringPadLeftZerosString(number, 4) + ":";
                    var text = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + Too.StringPadLeftZerosString(number, 4) + ".html");
                    var preText = UtilityString.parseLastMatch(text, GlobalVariables.pre2Pattern);
                    if ("SEVERE TSTM" in preText) {
                        latLonString += LatLon.storeWatchMcdLatLon(preText);
                    } else {
                        latLonTorString += LatLon.storeWatchMcdLatLon(preText);
                    }
                    latLonCombinedString += LatLon.storeWatchMcdLatLon(preText);
                }
                latLonList.setValue(latLonString);
                numberList.setValue(numberListString);
                ObjectPolygonWatch.polygonDataByType[PolygonType.WatchTornado].latLonList.setValue(latLonTorString);
                ObjectPolygonWatch.watchLatlonCombined.setValue(latLonCombinedString);
            }
        }
    }

    string getUrl() {
        var downloadUrl = "";
        if (type == PolygonType.Mcd) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/";
        } else if (type == PolygonType.Watch) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/";
        } else if (type == PolygonType.WatchTornado) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/";
        } else if (type == PolygonType.Mpd) {
            downloadUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php";
        }
        return downloadUrl;
    }

    string prefTokenEnabled() {
        return "RADAR_SHOW_" + typeName().ascii_up();
    }

    string prefTokenLatLon() {
        return typeName() + "LATLON";
    }

    string prefTokenNumberList() {
        return typeName() + "NOLIST";
    }

    string prefTokenStorage() {
        return "SEVEREDASHBOARD" + typeName();
    }

    string typeName() {
        return type.to_string().replace("POLYGON_TYPE_", "");
    }

    string getTypeName() {
        return type.to_string().replace("POLYGON_TYPE_", "");
    }

    void update() {
        //  print(prefTokenEnabled() + "\n");
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        colorInt = Utility.readPrefInt(colorPrefByType[type], colorDefaultByType[type]);
    }

    static void init() {
        defaultColors[PolygonType.Watch] = WXColor.colorsToInt(255, 187, 0);
        defaultColors[PolygonType.WatchTornado] = WXColor.colorsToInt(255, 0, 0);
        defaultColors[PolygonType.Mcd] = WXColor.colorsToInt(153, 51, 255);
        defaultColors[PolygonType.Mpd] = WXColor.colorsToInt(0, 255, 0);
        longName[PolygonType.Smw] = "Special%20Marine%20Warning";


        colorDefaultByType[PolygonType.Mcd] = Color.rgb(153, 51, 255);
        colorDefaultByType[PolygonType.Mpd] = Color.rgb(0, 255, 0);
        colorDefaultByType[PolygonType.Watch] = Color.rgb(255, 187, 0);
        colorDefaultByType[PolygonType.WatchTornado] = Color.rgb(255, 0, 0);

        colorPrefByType[PolygonType.Mcd] = "RADAR_COLOR_MCD";
        colorPrefByType[PolygonType.Mpd] = "RADAR_COLOR_MPD";
        colorPrefByType[PolygonType.Watch] = "RADAR_COLOR_TSTORM_WATCH";
        colorPrefByType[PolygonType.WatchTornado] = "RADAR_COLOR_TOR_WATCH";
        //  const unordered_map<PolygonType, int> ObjectPolygonWatch::colorDefaultByType{
        //      {Mcd, Color::rgb(153, 51, 255)},
        //      {Mpd, Color::rgb(0, 255, 0)},
        //      {Watch, Color::rgb(255, 187, 0)},
        //      {WatchTornado, Color::rgb(255, 0, 0)},
        //  };
        //  const unordered_map<PolygonType, string> ObjectPolygonWatch::colorPrefByType{
        //      {Mcd, "RADAR_COLOR_MCD"},
        //      {Mpd, "RADAR_COLOR_MPD"},
        //      {Watch, "RADAR_COLOR_TSTORM_WATCH"},
        //      {WatchTornado, "RADAR_COLOR_TOR_WATCH"},
        //  };

    }

    public static void load() {
        if (polygonDataByType == null) {
            polygonDataByType = new HashMap<PolygonType, ObjectPolygonWatch>();
            defaultColors = new HashMap<PolygonType, int>();
            longName = new HashMap<PolygonType, string>();
            watchLatlonCombined = new DataStorage("WATCH_LATLON_COMBINED");
            defaultColors = new HashMap<PolygonType, int>();
            longName = new HashMap<PolygonType, string>();
            colorDefaultByType = new HashMap<PolygonType, int>();
            colorPrefByType = new HashMap<PolygonType, string>();
        }
        init();
        foreach (var data in polygonList) {
            if (!polygonDataByType.keys.contains(data)) {
                polygonDataByType[data] = new ObjectPolygonWatch(data);
            } else {
                polygonDataByType[data].update();
            }
        }
    }
}
