// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Location {

    public static ArrayList<ObjectLocation> locations;
    static int numberOfLocations = 1;
    static int currentLocationIndex = 0;
    static string currentLocationStr = "1";
    public static ComboBox comboBox;

    public static int getNumLocations() { return numberOfLocations; }

    public static void setNumLocations(int newValue) {
        numberOfLocations = newValue;
        Utility.writePrefInt("LOCNUMINT", newValue);
    }

    public static string getRadarSite(int locNum) { return locations[locNum].getRadarSite(); }

    public static string radarSite() { return locations[currentLocationIndex].getRadarSite(); }

    public static string getWfo(int locNum) { return locations[locNum].getWfo(); }

    public static string office() { return locations[currentLocationIndex].getWfo(); }

    // from py
    public static string wfo() { return locations[currentLocationIndex].getWfo(); }

    // from py
    public static string name() { return locations[currentLocationIndex].getName(); }

    public static string locationName() { return locations[currentLocationIndex].getName(); }

    public static string getName(int locNum) {
        return (locNum >= locations.size) ? "" : locations[locNum].getName();
    }

    public static void setName(int locNum, string newName) {
        var iStr = Too.String(locNum + 1);
        Utility.writePref("LOC" + iStr + "LABEL", newName);
    }

    public static LatLon getLatLonCurrent() { return locations[currentLocationIndex].getLatLon(); }

    static string[] getWfoRadarSiteFromPoint(LatLon latLon) {
        var url = "https://api.weather.gov/points/" + latLon.latStr() + "," + latLon.lonStr();
        var pointData = UtilityIO.getHtml(url);
        // "cwa": "IWX",
        // "radarStation": "KGRR"
        var wfo = UtilityString.parse(pointData, "\"cwa\": \"(.*?)\"");
        var radarStation = UtilityString.parse(pointData, "\"radarStation\": \"(.*?)\"");
        radarStation = UtilityString.getLastXChars(radarStation, 3);
        return {wfo, radarStation};
    }

    public static string[] save(LatLon latLon, string labelStr) {
        setNumLocations(getNumLocations() + 1);
        var locNum = Too.String(getNumLocations());
        Utility.writePref("LOC" + locNum + "X", latLon.latStr());
        Utility.writePref("LOC" + locNum + "Y", latLon.lonStr());
        Utility.writePref("LOC" + locNum + "LABEL", labelStr);
        Utility.writePref("LOCNUMINT", locNum);
        var wfoAndRadar = getWfoRadarSiteFromPoint(latLon);
        var wfo = wfoAndRadar[0];
        var radarSite = wfoAndRadar[1];
        if (wfo == "") {
            wfo = UtilityLocation.getNearestOffice("WFO", latLon).ascii_down();
        }
        if (radarSite == "") {
            radarSite = UtilityLocation.getNearestOffice("RADAR", latLon);
            radarSite = UtilityString.getLastXChars(radarSite, 3);
        }
        Utility.writePref("RID" + locNum, radarSite.ascii_up());
        Utility.writePref("NWS" + locNum, wfo.ascii_up());
        refresh();
        return {locNum, "Saving location " + locNum + " as " + labelStr + " (" + latLon.latStr() + "," + latLon.lonStr() + ") " + "/" + " " + wfo.ascii_up() + "(" + radarSite.ascii_up() + ")"};
    }

    public static void deleteLocation(string locToDeleteStr) {
        var locToDeleteInt = Too.Int(locToDeleteStr);
        var locNumIntCurrent = getNumLocations();
        if (locToDeleteInt > locNumIntCurrent) {
            return;
        }
        if (locToDeleteInt == locNumIntCurrent) {
            setNumLocations(locNumIntCurrent - 1);
        } else {
            foreach (var index in range2(locToDeleteInt, locNumIntCurrent)) {
                var jIndex = index + 1;
                var jStr = Too.String(jIndex);
                var iStr = Too.String(index);
                var locObsCurrent = Utility.readPref("LOC" + jStr + "OBSERVATION", "");
                var locXCurrent = Utility.readPref("LOC" + jStr + "X", "");
                var locYCurrent = Utility.readPref("LOC" + jStr + "Y", "");
                var locLabelCurrent = Utility.readPref("LOC" + jStr + "LABEL", "");
                var countyCurrent = Utility.readPref("COUNTY" + jStr, "");
                var zoneCurrent = Utility.readPref("ZONE" + jStr, "");
                var nwsCurrent = Utility.readPref("NWS" + jStr, "");
                var ridCurrent = Utility.readPref("RID" + jStr, "");
                var nwsStateCurrent = Utility.readPref("NWS" + jStr + "STATE", "");
                Utility.writePref("LOC" + iStr + "OBSERVATION", locObsCurrent);
                Utility.writePref("LOC" + iStr + "X", locXCurrent);
                Utility.writePref("LOC" + iStr + "Y", locYCurrent);
                Utility.writePref("LOC" + iStr + "LABEL", locLabelCurrent);
                Utility.writePref("COUNTY" + iStr, countyCurrent);
                Utility.writePref("ZONE" + iStr, zoneCurrent);
                Utility.writePref("NWS" + iStr, nwsCurrent);
                Utility.writePref("RID" + iStr, ridCurrent);
                Utility.writePref("NWS" + iStr + "STATE", nwsStateCurrent);
                setNumLocations(locNumIntCurrent - 1);
            }
        }
        var locFragCurrentInt = currentLocationIndex + 1;
        if (locToDeleteInt == locFragCurrentInt) {
            Utility.writePref("CURRENTLOCFRAGMENT", "1");
            setCurrentLocationStr("1");
        } else if (locFragCurrentInt > locToDeleteInt) {
            var shiftNum = Too.String(locFragCurrentInt - 1);
            Utility.writePref("CURRENTLOCFRAGMENT", shiftNum);
            setCurrentLocationStr(shiftNum);
        }
        refresh();
    }

    public static LatLon getLatLon(int index) { return locations[index].getLatLon(); }

    public static string getObs() {
        return UtilityMetar.findClosestObservation(getLatLonCurrent(), 0).name;
    }

    public static void refresh() {
        initNumLocations();
        locations = new ArrayList<ObjectLocation>();
        foreach (var index in range(getNumLocations())) {
            locations.add(new ObjectLocation(index));
        }
        setCurrentLocationStr(Utility.readPref("CURRENTLOCFRAGMENT", "1"));
        checkCurrentLocationValidity();
    }

    public static void initNumLocations() {
        setNumLocations(Utility.readPrefInt("LOCNUMINT", 1));
    }

    public static void checkCurrentLocationValidity() {
        if (currentLocationIndex >= locations.size) {
            currentLocationIndex = locations.size - 1;
            setCurrentLocationStr(Too.String(currentLocationIndex + 1));
        }
    }

    public static void setCurrentLocationStr(string currentLocationStr) {
        Location.currentLocationStr = currentLocationStr;
        currentLocationIndex = Too.Int(currentLocationStr) - 1;
        Utility.writePref("CURRENTLOCFRAGMENT", currentLocationStr);
    }

    public static void setCurrentLocation(int index) {
        currentLocationIndex = index;
        var locationAsString = Too.String(currentLocationIndex + 1);
        currentLocationStr = locationAsString;
        Utility.writePref("CURRENTLOCFRAGMENT", locationAsString);
        Utility.writePref("LOCNUMINT", Too.String(getNumLocations()));
    }

    public static int getCurrentLocation() { return currentLocationIndex; }

    public static ArrayList<LatLon> getListLatLons() {
        var latLons = new ArrayList<LatLon>();
        foreach (var index in range(locations.size)) {
            latLons.add(getLatLon(index));
        }
        return latLons;
    }

    public static string[] listOfNames() {
        var names = new ArrayList<string>();
        foreach (var location in locations) {
            names.add(location.getName());
        }
        return names.to_array();
    }

    public static void setMainScreenComboBox() {
        comboBox.block();
        comboBox.setList(listOfNames());
        comboBox.setIndex(getCurrentLocation());
        comboBox.unblock();
    }
}
