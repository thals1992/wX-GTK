// *****************************************************************************
// * Copyright (c) 2020, 2021 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************


using Gee;

class UtilityNwsRadarMosaic {


    public const string baseUrl = "https://radar.weather.gov/ridge/lite/";

    public static ArrayList<string> sectors;
    public static HashMap<string, LatLon> cityToLatLon;

// TODO FIXME remove status class names

    public static string getNearestMosaic(LatLon latLon) {
        ArrayList<RID> sites = new ArrayList<RID>();
        foreach (var m in UtilityNwsRadarMosaic.cityToLatLon.entries) {
            sites.add(new RID(m.key, m.value));
            sites.last().distance = LatLon.distance(latLon, m.value);
        }
        sites.sort((a, b) => { return a.distance > b.distance ? 1 : -1; });
        return sites[0].name;
    }

    public static string get(string sector) {
        if (sector == "CONUS") {
            return "https://radar.weather.gov/ridge/lite/CONUS-LARGE_0.gif";
        }
        return UtilityNwsRadarMosaic.baseUrl + sector + "_0.gif";

    }

    public static string[] getAnimation(string product, string sector, int unused) {
        ArrayList<string> returnList = new ArrayList<string>();
        string add = "";
        if (sector == "CONUS") {
            add = "-LARGE";
        }
        for (var index = 9; index >= 0; index -= 1) {
        // foreach (int i in range3(9, -1, -1)) {
            returnList.add(UtilityNwsRadarMosaic.baseUrl + sector + add + "_" + Too.String(index) + ".gif");
        }
        return returnList.to_array();
    }

    public static void initStatic() {
        sectors = new ArrayList<string>();
        sectors = UtilityList.wrap({
            "CONUS",
            "ALASKA",
            "CARIB",
            "CENTGRLAKES",
            "GUAM",
            "HAWAII",
            "NORTHEAST",
            "NORTHROCKIES",
            "PACNORTHWEST",
            "PACSOUTHWEST",
            "SOUTHEAST",
            "SOUTHMISSVLY",
            "SOUTHPLAINS",
            "SOUTHROCKIES",
            "UPPERMISSVLY",
        });

        cityToLatLon = new HashMap<string, LatLon>();
        cityToLatLon.set("ALASKA", new LatLon.fromDouble(63.8683, -149.3669));
        cityToLatLon.set("CARIB", new LatLon.fromDouble(18.356, -69.592));
        cityToLatLon.set("CENTGRLAKES", new LatLon.fromDouble(42.4396, -84.7305));
        cityToLatLon.set("GUAM", new LatLon.fromDouble(13.4208, 144.7540));
        cityToLatLon.set("HAWAII", new LatLon.fromDouble(19.5910, -155.4343));
        cityToLatLon.set("NORTHEAST", new LatLon.fromDouble(42.7544, -73.4800));
        cityToLatLon.set("NORTHROCKIES", new LatLon.fromDouble(44.0813, -108.1309));
        cityToLatLon.set("PACNORTHWEST", new LatLon.fromDouble(43.1995, -118.9174));
        cityToLatLon.set("PACSOUTHWEST", new LatLon.fromDouble(35.8313, -119.2245));
        cityToLatLon.set("SOUTHEAST", new LatLon.fromDouble(30.2196, -82.1522));
        cityToLatLon.set("SOUTHMISSVLY", new LatLon.fromDouble(32.8184, -90.0434));
        cityToLatLon.set("SOUTHPLAINS", new LatLon.fromDouble(32.4484, -99.7781));
        cityToLatLon.set("SOUTHROCKIES", new LatLon.fromDouble(33.2210, -110.3162));
        cityToLatLon.set("UPPERMISSVLY", new LatLon.fromDouble(42.9304, -95.7488));

    }
}
