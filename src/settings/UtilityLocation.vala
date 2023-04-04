// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityLocation {

    public static Gee.List<RID> getNearestRadarSites(LatLon location, int cnt, bool includeTdwr) {
        var radarSites = new ArrayList<RID>();
        var allRadars = new ArrayList<string>();
        allRadars.add_all_array(GlobalArrays.radars);
        if (includeTdwr) {
            allRadars.add_all_array(GlobalArrays.tdwrRadars);
        }
        foreach (var radar in allRadars) {
            var labels = radar.split(":");
            var latLon = getRadarSiteLatLon(labels[0]);
            latLon.setLon(-1.0 * latLon.lon());
            radarSites.add(new RID(labels[0], latLon));
        }
        foreach (var radar in radarSites) {
            radar.distance = LatLon.distance(location, radar.location);
        }
        radarSites.sort((a, b) => { return a.distance > b.distance ? 1 : -1; });
        return radarSites[0:cnt];
    }

    public static string getNearestOffice(OfficeTypeEnum officeType, LatLon location) {
        var officeArray = (officeType == OfficeTypeEnum.Wfo) ? GlobalArrays.wfos : GlobalArrays.radars;
        var sites = new ArrayList<RID>();
        foreach (var office in officeArray) {
            var labelArr = office.split(":");
            if (officeType == OfficeTypeEnum.Wfo) {
                var latLon = getWfoSiteLatLon(labelArr[0]);
                sites.add(new RID(labelArr[0], latLon));
            } else {
                var latLon = getRadarSiteLatLon(labelArr[0]);
                latLon.setLon(-1.0 * latLon.lon());
                sites.add(new RID(labelArr[0], latLon));
            }
        }
        foreach (var site in sites) {
            site.distance = LatLon.distance(location, site.location);
        }
        sites.sort((a, b) => { return a.distance > b.distance ? 1 : -1; });
        return sites[0].name;
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

    public static string getRadarSiteName(string radarSite) {
        return RadarSites.name[radarSite] ?? "";
    }

    public static LatLon getRadarSiteLatLon(string radarSite) {
        var lat = RadarSites.lat[radarSite] ?? "";
        var lon = RadarSites.lon[radarSite] ?? "";
        return new LatLon(lat, lon);
    }

    public static string getRadarSiteX(string radarSite) {
        return RadarSites.lat[radarSite] ?? "";
    }

    public static string getRadarSiteY(string radarSite) {
        return RadarSites.lon[radarSite] ?? "";
    }

    public static LatLon getWfoSiteLatLon(string wfo) {
        var lat = WfoSites.lat[wfo] ?? "";
        var lon = WfoSites.lon[wfo] ?? "";
        return new LatLon(lat, lon);
    }

    public static string getNearest(LatLon latLon, HashMap<string, LatLon> sectorToLatLon) {
        ArrayList<RID> sites = new ArrayList<RID>();
        foreach (var m in sectorToLatLon.entries) {
            sites.add(new RID(m.key, m.value));
            sites.last().distance = LatLon.distance(latLon, m.value);
        }
        sites.sort((a, b) => { return a.distance > b.distance ? 1 : -1; });
        return sites[0].name;
    }
}
