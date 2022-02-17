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
        PolygonType.watch,
        PolygonType.watchTornado,
        PolygonType.mcd,
        PolygonType.mpd
    };
    public static HashMap<PolygonType, ObjectPolygonWatch> polygonDataByType;
    public static DataStorage watchLatlonCombined;

    DataStorage storage;
    public DataStorage latLonList;
    public DataStorage numberList;
    bool isEnabled = false;
    PolygonType type;
    DownloadTimer timer;

    public ObjectPolygonWatch(PolygonType type) {
        this.type = type;
        isEnabled = Utility.readPref(prefTokenEnabled(), "false").has_prefix("t");
        storage = new DataStorage(prefTokenStorage());
        storage.update();
        latLonList = new DataStorage(prefTokenLatLon());
        latLonList.update();
        numberList = new DataStorage(prefTokenNumberList());
        numberList.update();
        timer = new DownloadTimer("WATCH_" + getTypeName());
    }

    public void download() {
        if (timer.isRefreshNeeded()) {
            var html = UtilityIO.getHtml(getUrl());
            storage.setValue(html);
            if (type == PolygonType.mpd) {
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
            } else if (type == PolygonType.mcd) {
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
            } else if (type == PolygonType.watch) {
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
                ObjectPolygonWatch.polygonDataByType[PolygonType.watchTornado].latLonList.setValue(latLonTorString);
                ObjectPolygonWatch.watchLatlonCombined.setValue(latLonCombinedString);
            }
        }
    }

    string getUrl() {
        var downloadUrl = "";
        if (type == PolygonType.mcd) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/";
        } else if (type == PolygonType.watch) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/";
        } else if (type == PolygonType.watchTornado) {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/";
        } else if (type == PolygonType.mpd) {
            downloadUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php";
        }
        return downloadUrl;
    }

    string prefTokenEnabled() {
        return "RADARSHOW" + typeName();
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
        return type.to_string().replace("PolygonType.", "");
    }

    string getTypeName() {
        return type.to_string().replace("PolygonType.", "");
    }

    static void init() {
        watchLatlonCombined = new DataStorage("WATCH_LATLON_COMBINED");
        defaultColors = new HashMap<PolygonType, int>();
        defaultColors[PolygonType.watch] = WXColor.colorsToInt(255, 187, 0);
        defaultColors[PolygonType.watchTornado] = WXColor.colorsToInt(255, 0, 0);
        defaultColors[PolygonType.mcd] = WXColor.colorsToInt(153, 51, 255);
        defaultColors[PolygonType.mpd] = WXColor.colorsToInt(0, 255, 0);
        longName = new HashMap<PolygonType, string>();
        longName[PolygonType.smw] = "Special%20Marine%20Warning";
    }

    public static void load() {
        defaultColors = new HashMap<PolygonType, int>();
        longName = new HashMap<PolygonType, string>();
        polygonDataByType = new HashMap<PolygonType, ObjectPolygonWatch>();
        foreach (var data in polygonList) {
            polygonDataByType[data] = new ObjectPolygonWatch(data);
        }
        init();
    }
}
