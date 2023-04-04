// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityRtma {

    public static string getNearest(LatLon latLon) {
        return UtilityLocation.getNearest(latLon, sectorToLatLon);
    }

    public static ArrayList<string> getTimes() {
        var html = UtilityIO.getHtml("https://mag.ncep.noaa.gov/observation-parameter.php?group=Observations%20and%20Analyses&obstype=RTMA&area=MI&ps=area");
        // title="20221116 00 UTC"
        var v = UtilityString.parseColumn(html, "([0-9]{8} [0-9]{2} UTC)");
        v = UtilityList.removeDup(v);
        v = UtilityList.reversed(v);
        return v;
    }

    public static string getUrl(int index, int indexSector, string runTime) {
        var currentRun = runTime.split(" ")[1];
        return "https://mag.ncep.noaa.gov/data/rtma/" + currentRun + "/rtma_" + sectors[indexSector] + "_000_" + labels[index] + ".gif";
    }

    public static string getUrlForHomeScreen(string product) {
        var sector = getNearest(Location.getLatLonCurrent());
        var runTimes = getTimes();
        var runTime = runTimes.first();
        var currentRun = runTime.split(" ")[1];
        return "https://mag.ncep.noaa.gov/data/rtma/" + currentRun + "/rtma_" + sector + "_000_" + product + ".gif";
    }

    public const string[] labels = {
        "2m_temp",
        "10m_wnd",
        "2m_dwpt"
    };

    public const string[] sectors = {
        "alaska",
        "ca",
        "co",
        "fl",
        "guam",
        "gulf-coast",
        "mi",
        "mid-atl",
        "mid-west",
        "mt",
        "nc",
        "nd",
        "new-eng",
        "nw-pacific",
        "ohio-valley",
        "sw",
        "tx",
        "wx"
    };

    static HashMap<string, LatLon> sectorToLatLon;

    public static void initStatic() {
        sectorToLatLon = new HashMap<string, LatLon>();
        sectorToLatLon["alaska"] = new LatLon.fromDouble(63.25, -156.5);
        sectorToLatLon["ca"] = new LatLon.fromDouble(38.0, -118.5);
        sectorToLatLon["co"] = new LatLon.fromDouble(39.0, -105.25);
        sectorToLatLon["fl"] = new LatLon.fromDouble(27.5, -83.25);
        sectorToLatLon["guam"] = new LatLon.fromDouble(13.5, 144.75);
        sectorToLatLon["gulf-coast"] = new LatLon.fromDouble(32.75, -90.25);
        sectorToLatLon["mi"] = new LatLon.fromDouble(43.75, -84.75);
        sectorToLatLon["mid-atl"] = new LatLon.fromDouble(39.75, -75.75);
        sectorToLatLon["mid-west"] = new LatLon.fromDouble(39.5, -93.0);
        sectorToLatLon["mt"] = new LatLon.fromDouble(45.0, -109.25);
        sectorToLatLon["nc_sc"] = new LatLon.fromDouble(34.5, -79.75);
        sectorToLatLon["nd_sd"] = new LatLon.fromDouble(45.5, -98.25);
        sectorToLatLon["new-eng"] = new LatLon.fromDouble(43.0, -71.25);
        sectorToLatLon["nw-pacific"] = new LatLon.fromDouble(45.5, -122.75);
        sectorToLatLon["ohio-valley"] = new LatLon.fromDouble(39.0, -84.75);
        sectorToLatLon["sw_us"] = new LatLon.fromDouble(34.5, -104.25);
        sectorToLatLon["tx"] = new LatLon.fromDouble(32.0, -100.25);
        sectorToLatLon["wi"] = new LatLon.fromDouble(44.25, -89.75);
    }
}
