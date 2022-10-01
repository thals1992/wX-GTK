// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CapAlertXml {

    public string text = "";
    public string title = "";
    string summary = "";
    public string area = "";
    string instructions = "";
    string zones = "";
    public string vtec = "";
    public string url = "";
    public string event1 = "";
    public string effective = "";
    public string expires = "";
    string polygon = "";
    string[] points;

    public CapAlertXml(string s) {
        url = UtilityString.parse(s, "<id>(.*?)</id>");
        title = UtilityString.parse(s, "<title>(.*?)</title>");
        summary = UtilityString.parse(s, "<summary>(.*?)</summary>");
        instructions = UtilityString.parse(s, "</description>.*?<instruction>(.*?)</instruction>.*?<areaDesc>");
        area = UtilityString.parse(s, "<cap:areaDesc>(.*?)</cap:areaDesc>");
        effective = UtilityString.parse(s, "<cap:effective>(.*?)</cap:effective>");
        expires = UtilityString.parse(s, "<cap:expires>(.*?)</cap:expires>");
        event1 = UtilityString.parse(s, "<cap:event>(.*?)</cap:event>");
        vtec = UtilityString.parse(s, "<valueName>VTEC</valueName>.*?<value>(.*?)</value>");
        zones = UtilityString.parse(s, "<valueName>UGC</valueName>.*?<value>(.*?)</value>");
        polygon = UtilityString.parse(s, "<cap:polygon>(.*?)</cap:polygon>");
        text = "";
        text += title;
        text += GlobalVariables.newline;
        text += "Counties: ";
        text += area;
        text += GlobalVariables.newline;
        text += summary;
        text += GlobalVariables.newline;
        text += instructions;
        points = polygon.split(" ");
    }

    public string getClosestRadar() {
        if (points.length > 2) {
            var latTmp = points[0];
            var list1 = latTmp.split(",");
            var lat = list1[0];
            var lonTmp = points[0];
            var list2 = lonTmp.split(",");
            var lon = list2[1];
            var radarSites = UtilityLocation.getNearestRadarSites(new LatLon(lat, lon), 1, false);
            if (radarSites.size == 0) {
                return "";
            } else {
                return radarSites[0].name;
            }
        } else {
            return "";
        }
    }
}
