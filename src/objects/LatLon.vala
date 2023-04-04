// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class LatLon {

    double latNum;
    double lonNum;
    string latString;
    string lonString;

    public LatLon(string xStr, string yStr) {
        this.latString = xStr;
        this.lonString = yStr;
        this.latNum = Too.Double(latString);
        this.lonNum = Too.Double(lonString);
    }

    public static LatLon fromList(double[] latlon) {
        return new LatLon.fromDouble(latlon[0], latlon[1]);
    }

    public static LatLon empty() {
        return new LatLon("0.0", "0.0");
    }

    // TODO FIXME check other ports
    public LatLon.fromDouble(double latNum, double lonNum) {
        this.latString = Too.StringD(latNum);
        this.lonString = Too.StringD(lonNum);
        this.latNum = latNum;
        this.lonNum = lonNum;
    }

    public double lat() {
        return latNum;
    }

    public double lon() {
        return lonNum;
    }

    //  public void setLat(double d) {
    //      this.latString = Too.StringD(d);
    //      this.latNum = d;
    //  }

    public void setLon(double d) {
        this.lonString = Too.StringD(d);
        this.lonNum = d;
    }

    public string latStr() {
        return latString;
    }

    public string lonStr() {
        return lonString;
    }

    public void setLonStr(string s) {
        this.lonString = s;
        this.lonNum = Too.Double(s);
    }

    public static LatLon fromRadarSite(string radarSite) {
        var ridX = UtilityLocation.getRadarSiteX(radarSite);
        var ridY = UtilityLocation.getRadarSiteY(radarSite);
        var latNum = Too.Double(ridX);
        var lonNum = -1.0 * Too.Double(ridY);
        var latString = Too.StringD(latNum);
        var lonString = Too.StringD(lonNum);
        return new LatLon(latString, lonString);
    }

    public static LatLon fromWatchData(string temp) {
        var latString = temp.substring(0, 4);
        var lonString = temp.substring(4, 4);
        latString = UtilityString.addPeriodBeforeLastTwoChars(latString);
        lonString = UtilityString.addPeriodBeforeLastTwoChars(lonString);
        var tmpDbl = Too.Double(lonString);
        if (tmpDbl < 40.00) {
            tmpDbl += 100;
            lonString = Too.StringFromD(tmpDbl);
        }
        return new LatLon(latString, lonString);
    }

    public string printSpaceSeparated() {
        return latString + " " + lonString + " ";
    }

    public string printPretty() {
        var len = 7;
        return UtilityString.truncate(latString, len) + ", " + UtilityString.truncate(lonString, len) + " ";
    }

    public double[] getProjection(ProjectionNumbers pn) {
        return Projection.computeMercatorNumbersFromLatLon(this, pn);
    }

    public ExternalPoint asPoint() {
        return new ExternalPoint(lat(), lon());
    }

    // TODO FIXME check other ports for static vs non-static
    public static double distance(LatLon location1, LatLon location2) {
        var theta = location1.lonNum - location2.lonNum;
        var dist = Math.sin(UtilityMath.deg2rad(location1.latNum)) * Math.sin(UtilityMath.deg2rad(location2.latNum)) + Math.cos(UtilityMath.deg2rad(location1.latNum)) * Math.cos(UtilityMath.deg2rad(location2.latNum)) * Math.cos(UtilityMath.deg2rad(theta));
        dist = Math.acos(dist);
        dist = UtilityMath.rad2deg(dist);
        dist = dist * 60.0 * 1.1515;
        return dist;
    }

    // take a space separated list of numbers and return a list of LatLon, list is of the format
    // lon0 lat0 lon1 lat1 for watch
    // for UtilityWatch need to multiply Y by -1.0
    public static ArrayList<LatLon> parseStringToLatLons(string stringOfNumbers, double multiplier, bool isWarning) {
        var z = stringOfNumbers.split(" ");
        var x = new ArrayList<double?>();
        var y = new ArrayList<double?>();
        if (z.length > 1) {
            foreach (var i in range(z.length)) {
                if (isWarning) {
                    if (i % 2 == 0) {
                        y.add(Too.Double(z[i]) * multiplier);
                    } else {
                        x.add(Too.Double(z[i]));
                    }
                } else {
                    if (i % 2 == 0) {
                        x.add(Too.Double(z[i]));
                    } else {
                        y.add(Too.Double(z[i]) * multiplier);
                    }
                }
            }
        }
        var latLons = new ArrayList<LatLon>();
        if (y.size > 3 && x.size > 3 && x.size == y.size) {
            foreach (var index in range(x.size)) {
                latLons.add(new LatLon.fromDouble(x[index], y[index]));
            }
        }
        return latLons;
    }

    public static ArrayList<double?> latLonListToListOfDoubles(ArrayList<LatLon> latLons, ProjectionNumbers projectionNumbers) {
        var warningList = new ArrayList<double?>();
        if (latLons.size > 0) {
            var startCoordinates = Projection.computeMercatorNumbersFromLatLon(latLons[0], projectionNumbers);
            warningList.add(startCoordinates[0]);
            warningList.add(startCoordinates[1]);
            foreach (var index in range3(1, latLons.size, 1)) {
                var coordinates = Projection.computeMercatorNumbersFromLatLon(latLons[index], projectionNumbers);
                warningList.add(coordinates[0]);
                warningList.add(coordinates[1]);
                warningList.add(coordinates[0]);
                warningList.add(coordinates[1]);
            }
            warningList.add(startCoordinates[0]);
            warningList.add(startCoordinates[1]);
        }
        return warningList;
    }

    // 36517623 is 3651 -7623
    public static LatLon getLatLonFromString(string latLonString) {
        if (latLonString.length < 8) {
            return new LatLon.fromDouble(0.0, 0.0);
        }
        var latString = latLonString[0:4];
        var lonString = latLonString[4:latLonString.length];
        var lat = Too.Double(latString);
        var lon = Too.Double(lonString);
        lat /= 100.0;
        lon /= 100.0;
        if (lon < 40.0) {
            lon += 100.0;
        }
        return new LatLon.fromDouble(lat, -1.0 * lon);
    }

    public static string storeWatchMcdLatLon(string html) {
        var coordinates = UtilityString.parseColumn(html, "([0-9]{8}).*?");
        var value = "";
        foreach (var coor in coordinates) {
            var latLon = getLatLonFromString(coor);
            value += latLon.printSpaceSeparated();
        }
        value += ":";
        return value.replace(" :", ":");
    }

    public static string getWatchLatLon(string number) {
        var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html");
        return UtilityString.parseLastMatch(html, GlobalVariables.pre2Pattern);
    }
}
