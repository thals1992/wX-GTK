// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectLocation {

    public string lat;
    string lon;
    string name;
    string countyCurrent;
    string zoneCurrent;
    string wfo;
    string rid;
    string nwsStateCurrent;
    string observation;
    string prefNumberstring;

    public string getLat() { return lat; }

    public string getLon() { return lon; }

    public LatLon getLatLon() { return new LatLon(getLat(), getLon()); }

    public string getName() { return name; }

    public string getWfo() { return wfo; }

    public string getRadarSite() { return rid; }

    public ObjectLocation(int locNumInt) {
        var jStr = Too.String(locNumInt + 1);
        prefNumberstring = jStr;
        lat = Utility.readPref("LOC" + jStr + "X", "35.231");
        lon = Utility.readPref("LOC" + jStr + "Y", "-97.451");
        name = Utility.readPref("LOC" + jStr + "LABEL", "Home");
        countyCurrent = Utility.readPref("COUNTY" + jStr, "");
        zoneCurrent = Utility.readPref("ZONE" + jStr, "");
        wfo = Utility.readPref("NWS" + jStr, "OUN");
        rid = Utility.readPref("RID" + jStr, "TLX");
        nwsStateCurrent = Utility.readPref("NWS" + jStr + "STATE", "OK");
        observation = Utility.readPref("LOC" + jStr + "OBSERVATION", "");
    }

    public void saveToNewSlot(int newLocNumInt) {
        var iStr = Too.String(newLocNumInt + 1);
        Utility.writePref("LOC" + iStr + "X", lat);
        Utility.writePref("LOC" + iStr + "Y", lon);
        Utility.writePref("LOC" + iStr + "LABEL", name);
        Utility.writePref("COUNTY" + iStr, countyCurrent);
        Utility.writePref("ZONE" + iStr, zoneCurrent);
        Utility.writePref("NWS" + iStr, wfo);
        Utility.writePref("RID" + iStr, rid);
        Utility.writePref("NWS" + iStr + "STATE", nwsStateCurrent);
        Utility.writePref("LOC" + iStr + "OBSERVATION", observation);
        Location.refresh();
    }
}
