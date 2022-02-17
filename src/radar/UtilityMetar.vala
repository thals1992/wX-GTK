// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityMetar {

    const string metarFileName = "us_metar3.txt";
    const string pattern1 = ".*? (M?../M?..) .*?";
    const string pattern2 = ".*? A([0-9]{4})";
    const string pattern3 = "AUTO ([0-9].*?KT) .*?";
    const string pattern4 = "Z ([0-9].*?KT) .*?";
    const string pattern5 = "SM (.*?) M?[0-9]{2}/";
    static bool initializedObsMap = false;
    static HashMap<string, LatLon> obsLatlon;

    public static void getStateMetarArrayForWXOGL(string radarSite, FileStorage fileStorage) {
        if (fileStorage.obsDownloadTimer.isRefreshNeeded() || radarSite != fileStorage.obsOldRadarSite) {
            var obsAl = new ArrayList<string>();
            var obsAlExt = new ArrayList<string>();
            var obsAlWb = new ArrayList<string>();
            var obsAlWbGust = new ArrayList<string>();
            var obsAlX = new ArrayList<double?>();
            var obsAlY = new ArrayList<double?>();
            var obsAlAviationColor = new ArrayList<int>();
            fileStorage.obsOldRadarSite = radarSite;
            var obsList = getObservationSites(radarSite);
            var url = GlobalVariables.nwsAWCwebsitePrefix + "/adds/metars/index?submit=1&station_ids=" + obsList + "&chk_metars=on";
            var html = UtilityIO.getHtml(url);
            html = html.replace("\n", "");
            html = html.replace("\r", "");
            var metarArrTmp = UtilityString.parseColumn(html, "<FONT FACE=\"Monospace,Courier\">(.*?)</FONT><BR>");
            var metarArr = condenseObs(metarArrTmp);
            if (!initializedObsMap) {
                var lines = UtilityIO.rawFileToStringArrayFromResource(GlobalVariables.resDir + metarFileName);
                obsLatlon = new HashMap<string, LatLon>();
                foreach (var line in lines) {
                    var tmpArr = line.split(" ");
                    if (tmpArr.length > 2) {
                        obsLatlon[tmpArr[0]] = new LatLon(tmpArr[1], tmpArr[2]);
                    }
                }
                initializedObsMap = true;
            }
            foreach (var metar in metarArr) {
                var validWind = false;
                var validWindGust = false;
                if ((metar.has_prefix("K") || metar.has_prefix("P")) && !metar.contains("NIL")) {
                    var tmpArr2 = metar.split(" ");
                    var tmpBlob = UtilityString.parse(metar, pattern1);
                    var tempAndDewpointList = tmpBlob.split("/");
                    var timeBlob = "";
                    if (tmpArr2.length > 1) {
                        timeBlob = tmpArr2[1];
                    }
                    var pressureBlob = UtilityString.parse(metar, pattern2);
                    var windBlob = UtilityString.parse(metar, pattern3);
                    if (windBlob == "") {
                        windBlob = UtilityString.parse(metar, pattern4);
                    }
                    var conditionsBlob = UtilityString.parse(metar, pattern5);
                    var visBlob = UtilityString.parse(metar, " ([0-9].*?SM) ");
                    var visBlobArr = visBlob.split(" ");

                    var visBlobDisplay = "";
                    if (visBlobArr.length > 0) {
                        visBlobDisplay = visBlobArr[visBlobArr.length - 1];
                        visBlob = visBlobArr[visBlobArr.length - 1].replace("SM", "");
                    }

                    var visInt = 0;
                    if (visBlob.contains("/")) {
                        visInt = 0;
                    } else if (visBlob != "") {
                        visInt = Too.Int(visBlob);
                    } else {
                        visInt = 20000;
                    }
                    var ovcStr = UtilityString.parse(conditionsBlob, "OVC([0-9]{3})");
                    var bknStr = UtilityString.parse(conditionsBlob, "BKN([0-9]{3})");
                    var ovcInt = 100000;
                    var bknInt = 100000;
                    int lowestCig;
                    if (ovcStr != "") {
                        ovcStr += "00";
                        ovcInt = Too.Int(ovcStr);
                    }
                    if (bknStr != "") {
                        bknStr += "00";
                        bknInt = Too.Int(bknStr);
                    }
                    if (bknInt < ovcInt) {
                        lowestCig = bknInt;
                    } else {
                        lowestCig = ovcInt;
                    }
                    var aviationColor = Color.greenInt;
                    if (visInt > 5 && lowestCig > 3000) {
                        aviationColor = Color.greenInt;
                    }
                    if ((visInt >= 3 && visInt <= 5) || (lowestCig >= 1000 && lowestCig <= 3000)) {
                        aviationColor = Color.rgb(0, 100, 255);
                    }
                    if ((visInt >= 1 && visInt < 3) || (lowestCig >= 500 && lowestCig < 1000)) {
                        aviationColor = Color.redInt;
                    }
                    if (visInt < 1 || lowestCig < 500) {
                        aviationColor = Color.magentaInt;
                    }
                    if (pressureBlob.length == 4) {
                        pressureBlob = UtilityString.insert(pressureBlob, pressureBlob.length - 2, ".");
                        pressureBlob = UtilityMath.unitsPressure(pressureBlob);
                    }
                    var windDir = "";
                    var windInKt = "";
                    var windgustInKt = "";
                    if (windBlob.contains("KT") && windBlob.length == 7) {
                        validWind = true;
                        windDir = windBlob.substring(0, 3);
                        windInKt = windBlob.substring(3, 2);
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDir) + ") " + windInKt + " kt";
                    } else if (windBlob.contains("KT") && windBlob.length == 10) {
                        validWind = true;
                        validWindGust = true;
                        windDir = windBlob.substring(0, 3);
                        windInKt = windBlob.substring(3, 2);
                        windgustInKt = windBlob.substring(6, 2);
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDir) + ") " + windInKt + " G " + windgustInKt + " kt";
                    }
                    if (tempAndDewpointList.length > 1) {
                        var temperature = tempAndDewpointList[0];
                        var dewpoint = tempAndDewpointList[1];
                        temperature = UtilityMath.celsiusToFahrenheit(temperature.replace("M", "-")).replace(".0", "");
                        dewpoint = UtilityMath.celsiusToFahrenheit(dewpoint.replace("M", "-")).replace(".0", "");
                        var obsSite = tmpArr2[0];
                        var latlon = obsLatlon[obsSite] ?? LatLon.empty();
                        latlon.setLonStr(latlon.lonStr().replace("-0", "-"));
                        obsAl.add(latlon.latStr() + ":" + latlon.lonStr() + ":" + temperature + "/" + dewpoint);
                        obsAlExt.add(latlon.latStr() +
                                ":" +
                                latlon.lonStr() +
                                ":" +
                                temperature +
                                "/" +
                                dewpoint +
                                " (" +
                                obsSite +
                                ")" +
                                GlobalVariables.newline +
                                pressureBlob +
                                " - " +
                                visBlobDisplay +
                                GlobalVariables.newline +
                                windBlob +
                                GlobalVariables.newline +
                                conditionsBlob +
                                GlobalVariables.newline +
                                timeBlob);
                        if (validWind) {
                            obsAlWb.add(latlon.latStr() + ":" + latlon.lonStr() + ":" + windDir + ":" + windInKt);
                            obsAlX.add(latlon.lat());
                            obsAlY.add(latlon.lon() * -1.0);
                            //  print("wind: " + latlon.lat().to_string() + " " + (latlon.lon() * -1.0).to_string() + "\n");
                            obsAlAviationColor.add(aviationColor);
                        }
                        if (validWindGust) {
                            obsAlWbGust.add(latlon.latStr() + ":" + latlon.lonStr() + ":" + windDir + ":" + windgustInKt);
                        }
                    }
                }
            }
            fileStorage.obsArr.clear();
            fileStorage.obsArr.add_all(obsAl);
            fileStorage.obsArrExt.clear();
            fileStorage.obsArrExt.add_all(obsAlExt);
            fileStorage.obsArrWb.clear();
            fileStorage.obsArrWb.add_all(obsAlWb);
            fileStorage.obsArrWbGust.clear();
            fileStorage.obsArrWbGust.add_all(obsAlWbGust);
            fileStorage.obsArrX.clear();
            fileStorage.obsArrX.add_all(obsAlX);
            fileStorage.obsArrY.clear();
            fileStorage.obsArrY.add_all(obsAlY);
            fileStorage.obsArrAviationColor.clear();
            fileStorage.obsArrAviationColor.add_all(obsAlAviationColor);
        }
    }

    static string getObservationSites(string radarSite) {
        var obsListSb = "";
        var radarLocation = LatLon.fromRadarSite(radarSite);
        var text = UtilityIO.readTextFileFromResource(GlobalVariables.resDir + metarFileName);
        var lines = text.split(GlobalVariables.newline);
        var obsSites = new ArrayList<RID>();
        foreach (var line in lines) {
            var tmpArr = line.split(" ");
            if (tmpArr.length > 2) {
                obsSites.add(new RID(tmpArr[0], new LatLon(tmpArr[1], tmpArr[2])));
            }
        }
        var obsSiteRange = 200.0;
        var currentDistance = 0.0;
        foreach (var index in UtilityList.range(obsSites.size)) {
            currentDistance = LatLon.distance(radarLocation, obsSites[index].location);
            if (currentDistance < obsSiteRange) {
                obsListSb += obsSites[index].name + ",";
            }
        }
        return obsListSb.replace(",\\$", "");
    }

    // used to condense a list of metar that contains multiple entries for one site,
    // newest is first so simply grab first/append
    public static ArrayList<string> condenseObs(ArrayList<string> list) {
        var siteMap = new HashMap<string, bool>();
        var goodObsList = new ArrayList<string>();
        foreach (var item in list) {
            var tokens = item.split(" ");
            if (tokens.length > 3) {
                // TODO FIXME this should be a test of key in map
                if (siteMap[tokens[0]] != true) {
                    siteMap[tokens[0]] = true;
                    goodObsList.add(item);
                }
            }
        }
        return goodObsList;
    }

    public static RID findClosestObservation(LatLon location) {
        var lines = UtilityIO.rawFileToStringArrayFromResource(GlobalVariables.resDir + metarFileName);
        var metarSites = new ArrayList<RID>();
        foreach (var line in lines) {
            var tmpArr = line.split(" ");
            if (tmpArr.length > 2) {
                metarSites.add(new RID(tmpArr[0], new LatLon(tmpArr[1], tmpArr[2])));
            }
        }
        var shortestDistance = 1000.00;
        var currentDistance = 0.0;
        var bestIndex = -1;
        foreach (var i in UtilityList.range(metarSites.size)) {
            currentDistance = LatLon.distance(location, metarSites[i].location);
            metarSites[i].distance = currentDistance;
            if (currentDistance < shortestDistance) {
                shortestDistance = currentDistance;
                bestIndex = i;
            }
        }
        if (bestIndex == -1) {
            return metarSites[0];
        } else {
            return metarSites[bestIndex];
        }
    }
}
