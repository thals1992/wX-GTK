// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectWarning {

    string url;
    public string title;
    public string area;
    public string effective;
    public string expires;
    public string event1;
    public string sender;
    string polygon;
    string vtec;
    public bool isCurrent;

    public ObjectWarning(string url, string title, string area, string effective, string expires, string event1, string sender, string polygon, string vtec) {
        this.url = url;
        // detailed desc
        this.title = title;
        this.area = area;

        this.effective = effective;
        this.effective = this.effective.replace("T", " ");
        this.effective = UtilityString.replaceRegex(this.effective, ":00-0[0-9]:00", "");

        this.expires = expires;
        this.expires = this.expires.replace("T", " ");
        this.expires = UtilityString.replaceRegex(this.expires, ":00-0[0-9]:00", "");

        this.event1 = event1;
        this.sender = sender;
        this.polygon = polygon;
        this.vtec = vtec;
        this.isCurrent = WXGLNexrad.isVtecCurrent(this.vtec);
        if (vtec.has_prefix("O.EXP") || vtec.has_prefix("O.CAN")) {
            this.isCurrent = false;
        }
    }

    public static ArrayList<ObjectWarning> parseJson(string html) {
        var warnings = new ArrayList<ObjectWarning>();
        var urlList = UtilityString.parseColumn(html, "\"id\": \"(https://api.weather.gov/alerts/urn.*?)\"");
        var titleList = UtilityString.parseColumn(html, "\"description\": \"(.*?)\"");
        var areaDescList = UtilityString.parseColumn(html, "\"areaDesc\": \"(.*?)\"");
        var effectiveList = UtilityString.parseColumn(html, "\"effective\": \"(.*?)\"");
        var expiresList = UtilityString.parseColumn(html, "\"expires\": \"(.*?)\"");
        var eventList = UtilityString.parseColumn(html, "\"event\": \"(.*?)\"");
        var senderNameList = UtilityString.parseColumn(html, "\"senderName\": \"(.*?)\"");
        var data = html;
        data = data.replace("\n", "");
        data = data.replace(" ", "");
        var listOfPolygonRaw = UtilityString.parseColumn(data, GlobalVariables.warningLatLonPattern);
        var vtecs = UtilityString.parseColumn(html, GlobalVariables.vtecPattern);
        foreach (var index in range(urlList.size)) {
            warnings.add(new ObjectWarning(Utility.safeGet(urlList, index), Utility.safeGet(titleList, index), Utility.safeGet(areaDescList, index), Utility.safeGet(effectiveList, index), Utility.safeGet(expiresList, index), Utility.safeGet(eventList, index), Utility.safeGet(senderNameList, index), Utility.safeGet(listOfPolygonRaw, index), Utility.safeGet(vtecs, index)));
        }
        return warnings;
    }

    public string getClosestRadar() {
        var data = polygon;
        data = data.replace("[", "");
        data = data.replace("]", "");
        data = data.replace(",", " ");
        data = data.replace("-", "");
        var points = data.split(" ");
        if (points.length > 2) {
            var lat = points[1];
            var lon = "-" + points[0];
            var latLon = new LatLon(lat, lon);
            var radarSites = UtilityLocation.getNearestRadarSites(latLon, 1, false);
            if (radarSites.size == 0) {
                return "";
            } else {
                return radarSites[0].name;
            }
        } else {
            return "";
        }
    }

    public string getUrl() {
        return url;
    }

    public ArrayList<LatLon> getPolygonAsLatLons() {
        var polygonTmp = polygon;
        polygonTmp = polygonTmp.replace("[", "");
        polygonTmp = polygonTmp.replace("]", "");
        polygonTmp = polygonTmp.replace(",", " ");
        return LatLon.parseStringToLatLons(polygonTmp, 1, true);
    }
}
