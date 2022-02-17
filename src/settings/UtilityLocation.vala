// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityLocation {

    static ArrayList<string> metarDataRaw;
    static ArrayList<RID> metarSites;
    const string resDir = "res/";

    public static ArrayList<RID> getNearestRadarSites(LatLon location, int cnt, bool includeTdwr) {
        var radarSites = new ArrayList<RID>();
        var allRadars = new ArrayList<string>();
        allRadars.add_all_array(GlobalArrays.radars);
        if (includeTdwr) {
            allRadars.add_all_array(GlobalArrays.tdwrRadarsForMap);
        }
        foreach (var radar in allRadars) {
            var labels = radar.split(":");
            var latLon = Utility.getRadarSiteLatLon(labels[0]);
            latLon.setLon(-1.0 * latLon.lon());
            var rid = new RID(labels[0], latLon);
            radarSites.add(rid);
        }
        var currentDistance = 0.0;
        foreach (var index in UtilityList.range(radarSites.size)) {
            currentDistance = LatLon.distance(location, radarSites[index].location);
            radarSites[index].distance = currentDistance;
        }
        radarSites.sort((a, b) => { return a.distance > b.distance ? 1 : -1;});
        var returnList = new ArrayList<RID>();
        foreach (var index in UtilityList.range(cnt)) {
            returnList.add(radarSites[index]);
        }
        return returnList;
    }

    public static string getNearestOffice(string officeType, LatLon location) {
        var officeArray = (officeType == "WFO") ? GlobalArrays.wfos : GlobalArrays.radars;
        var sites = new ArrayList<RID>();
        foreach (var office in officeArray) {
            var labelArr = office.split(":");
            if (officeType == "WFO") {
                var latLon = Utility.getWfoSiteLatLon(labelArr[0]);
                sites.add(new RID(labelArr[0], latLon));
            } else {
                var latLon = Utility.getRadarSiteLatLon(labelArr[0]);
                latLon.setLon(-1.0 * latLon.lon());
                sites.add(new RID(labelArr[0], latLon));
            }
        }
        var shortestDistance = 30000.00;
        var currentDistance = 0.0;
        var bestIndex = -1;
        foreach (var index in UtilityList.range(sites.size)) {
            currentDistance = LatLon.distance(location, sites[index].location);
            if (currentDistance < shortestDistance) {
                shortestDistance = currentDistance;
                bestIndex = index;
            }
        }
        return sites[bestIndex].name;
    }

    static void readMetarData() {
        var metarFileName = resDir + "us_metar3.txt";
        if (metarDataRaw == null || metarDataRaw.size == 0) {
            metarDataRaw = UtilityIO.rawFileToStringArrayFromResource(metarFileName);
            metarSites = new ArrayList<RID>();
            foreach (var metar in metarDataRaw) {
                var items = metar.split(" ");
                if (items.length > 1) {
                    metarSites.add(new RID(items[0], new LatLon(items[1], items[2])));
                }
            }
        }
    }

    public static RID findClosestObservation(LatLon latLon) {
        readMetarData();
        var shortestDistance = 1000.00;
        var bestIndex = -1;
        foreach (var i in UtilityList.range(metarSites.size)) {
            var currentDistance = LatLon.distance(latLon, metarSites[i].location);
            metarSites[i].distance = currentDistance;
            if (currentDistance < shortestDistance) {
                shortestDistance = currentDistance;
                bestIndex = i;
            }
        }
        if (bestIndex == -1) {
            return metarSites[0];
        }
        return metarSites[bestIndex];
    }

    public static LatLon getCenterOfPolygon(ArrayList<LatLon> latLons) {
        var x = 0.0;
        var y = 0.0;
        foreach (var latLon in latLons) {
            x += latLon.lat();
            y += latLon.lon();
        }
        var totalPoints = (double)latLons.size;
        x /= totalPoints;
        y /= totalPoints;
        return new LatLon.fromDouble(x, -1.0 * y);
    }
}
