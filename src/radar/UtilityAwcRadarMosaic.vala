// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityAwcRadarMosaic {

    const string baseUrl = "https://www.aviationweather.gov/data/obs/";
    public const string[] productLabels = {
        "Reflectivity",
        "Composite Reflectivity",
        "Echo Tops",
        "Infrared (BW)",
        "Infrared (Col)",
        "Infrared (NWS)",
        "Visible",
        "Water Vapor"
    };
    public static string[] sectorLabels;
    public static string[] sectors;
    public static string[] products;
    static HashMap<string, LatLon> cityToLatLon;

    public static void initStatic() {
        cityToLatLon = new HashMap<string, LatLon>();
        cityToLatLon["NY, Albany"] = new LatLon.fromDouble(42.65, -73.75);
        cityToLatLon["MD, Baltimore"] = new LatLon.fromDouble(39.29, -76.60);
        cityToLatLon["NC, Charlotte"] = new LatLon.fromDouble(35.22, -80.84);
        cityToLatLon["FL, Tampa"] = new LatLon.fromDouble(27.96, -82.45);
        cityToLatLon["MI, Detroit"] = new LatLon.fromDouble(42.33, -83.04);
        cityToLatLon["IN, Evansville"] = new LatLon.fromDouble(37.97, -87.55);
        cityToLatLon["AL, Montgomery"] = new LatLon.fromDouble(32.36, -86.29);
        cityToLatLon["MN, Minneapolis"] = new LatLon.fromDouble(44.98, -93.25);
        cityToLatLon["AR, Little Rock"] = new LatLon.fromDouble(34.74, -92.28);
        cityToLatLon["SD, Pierre"] = new LatLon.fromDouble(44.36, -100.33);
        cityToLatLon["KS, Wichita"] = new LatLon.fromDouble(37.69, -97.31);
        cityToLatLon["TX, Austin"] = new LatLon.fromDouble(30.28, -97.73);
        cityToLatLon["WY, Cody"] = new LatLon.fromDouble(44.52, -109.05);
        cityToLatLon["CO, Denver"] = new LatLon.fromDouble(39.74, -104.99);
        cityToLatLon["NM, Albuquerque"] = new LatLon.fromDouble(35.10, -106.62);
        cityToLatLon["ID, Lewiston"] = new LatLon.fromDouble(46.41, -117.01);
        cityToLatLon["NV, Winnemuca"] = new LatLon.fromDouble(40.97, -117.73);
        cityToLatLon["NV, Las Vegas"] = new LatLon.fromDouble(36.11, -115.17);

        sectorLabels = {
            "CONUS US",
            "AL, Montgomery",
            "AR, Little Rock",
            "CO, Denver",
            "FL, Tampa",
            "ID, Lewiston",
            "IN, Evansville",
            "KS, Wichita",
            "MD, Baltimore",
            "MI, Detroit",
            "NC, Charlotte",
            "NV, Las Vegas",
            "NV, Winnemuca",
            "NY, Albany",
            "NM, Albuquerque",
            "MN, Minneapolis",
            "SD, Pierre",
            "TX, Austin",
            "WY, Cody"
        };

        sectors = {
            "us",
            "mgm",
            "lit",
            "den",
            "tpa",
            "lws",
            "evv",
            "ict",
            "bwi",
            "dtw",
            "clt",
            "las",
            "wmc",
            "alb",
            "abq",
            "msp",
            "pir",
            "aus",
            "cod"
        };

        products = {
            "rad_rala",
            "rad_cref",
            "rad_tops-18",
            "sat_irbw",
            "sat_ircol",
            "sat_irnws",
            "sat_vis",
            "sat_wv"
        };
    }

    public static string getNearestMosaic(LatLon location) {
        var shortestDistance = 1000.00;
        var currentDistance = 0.0;
        var bestIndex = "";
        foreach (var k in cityToLatLon.keys) {
            currentDistance = LatLon.distance(location, cityToLatLon[k]);
            if (currentDistance < shortestDistance) {
                shortestDistance = currentDistance;
                bestIndex = k;
            }
        }
        if (bestIndex == "") {
            return "BLAH";
        }
        var index = UtilityList.findex(bestIndex, sectorLabels);
        return sectors[index];
    }

    public static string get(string product, string sector) {
        var baseAddOn = "radar/";
        var imageType = ".gif";
        if (product.contains("sat")) {
            baseAddOn = "sat/us/";
            imageType = ".jpg";
        }
        var url = baseUrl + baseAddOn + product + "_" + sector + imageType;
        return url;
    }

    public static string[] getAnimation(string product, string sector) {
        var baseAddOn = "radar/";
        var baseAddOnTopUrl = "radar/";
        var imageType = ".gif";
        var topUrlAddOn = "";
        if (product.contains("sat_")) {
            baseAddOnTopUrl = "satellite/";
            baseAddOn = "sat/us/";
            imageType = ".jpg";
            topUrlAddOn = "&type=" + product.replace("sat_", "");
        } else if (product.has_prefix("rad_")) {
            topUrlAddOn = "&type=" + product.replace("rad_", "") + "&date=";
        }
        var productUrl = "https://www.aviationweather.gov/" + baseAddOnTopUrl + "plot?region=" + sector + topUrlAddOn;
        var html = UtilityIO.getHtml(productUrl);
        var regexp = "image_url.[0-9]{1,2}. = ./data/obs/" + baseAddOn + "([0-9]{8}/[0-9]{2}/[0-9]{8}_[0-9]{4}_" + product + "_" + sector + imageType + ").";
        var urls = UtilityString.parseColumn(html, regexp);
        var returnList = new ArrayList<string>();
        foreach (var data in urls) {
            returnList.add(baseUrl + baseAddOn + data);
        }
        return UtilityList.listToArray(returnList);
    }
}
