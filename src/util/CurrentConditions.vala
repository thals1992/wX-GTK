// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CurrentConditions {

    string data1 = "";
    public string iconUrl = "";
    string conditionsTimeStr = "";
    string ccLine3 = "";
    string temperature = "";
    string windChill = "";
    string heatIndex = "";
    string dewpoint = "";
    string relativeHumidity = "";
    string seaLevelPressure = "";
    string windDirection = "";
    string windSpeed = "";
    string windGust = "";
    string visibility = "";
    string condition = "";
    string locationstring = "";
    public LatLon latLon;
    public string middleLine = "";
    public string topLine = "";
    public string bottomLine = "";
    string obsStation = "";
    string timeStringUtc = "";

    public void process(LatLon latLon, int order) {
        this.latLon = latLon;
        var sb = "";
        var objectMetar = new ObjectMetar(latLon, order);
        objectMetar.process();
        obsStation = objectMetar.obsClosest.name;
        conditionsTimeStr = objectMetar.conditionsTimeStr;
        temperature = objectMetar.temperature + GlobalVariables.degreeSymbol;
        windChill = objectMetar.windChill + GlobalVariables.degreeSymbol;
        heatIndex = objectMetar.heatIndex + GlobalVariables.degreeSymbol;
        dewpoint = objectMetar.dewpoint + GlobalVariables.degreeSymbol;
        relativeHumidity = objectMetar.relativeHumidity + "%";
        seaLevelPressure = objectMetar.seaLevelPressure;
        windDirection = objectMetar.windDirection;
        windSpeed = objectMetar.windSpeed;
        windGust = objectMetar.windGust;
        visibility = objectMetar.visibility;
        condition = objectMetar.condition;
        timeStringUtc = objectMetar.timeStringUtc;
        sb += temperature;
        if (objectMetar.windChill != "NA") {
            sb += "(" + windChill + ")";
        } else if (objectMetar.heatIndex != "NA") {
            sb += "(" + heatIndex + ")";
        }
        sb += " / " + dewpoint + "(" + relativeHumidity + ")" + " - ";
        sb += seaLevelPressure + " - " + windDirection + " " + windSpeed;
        if (windGust != "") {
            sb += " G ";
        }
        sb += windGust + " mph" + " - " + visibility + " mi - " + condition;
        data1 = sb;
        iconUrl = objectMetar.icon;
        formatCurrentConditions();
    }

    void formatCurrentConditions() {
        var sep = " - ";
        var tmpArrCc = data1.split(sep);
        var retStr = "";
        var retStr2 = "";
        if (tmpArrCc.length > 4) {
            var tempArr = tmpArrCc[0].split("/");
            var tmp1 = tmpArrCc[4].replace("^ ", "");
            var tmp2 = tempArr[1].replace("^ ", "");
            retStr = tmp1 + " " + tempArr[0] + tmpArrCc[2];
            retStr2 = tmp2 + sep + tmpArrCc[1] + sep + tmpArrCc[3];
        }
        topLine = retStr;
        middleLine = retStr2.strip();
        bottomLine = conditionsTimeStr + " " + getObsFullName();
        ccLine3 = locationstring;
    }

    string getObsFullName() {
        var lines = UtilityIO.rawFileToStringArrayFromResource(GlobalVariables.resDir + "stations_us4.txt");
        foreach (var line in lines) {
            if (line.has_suffix(obsStation)) {
                return line.split(",")[1];
            }
        }
        return "NA";
    }

    // compare the timestamp in the metar to the current time
    // if older then a certain amount, download the 2nd closest site and process
    public void timeCheck() {
        var obsTime = new ObjectDateTime.fromObs(timeStringUtc);
        var currentTime = ObjectDateTime.getCurrentTimeInUTC();
        var isTimeCurrent = ObjectDateTime.timeDifference(currentTime, obsTime.get(), 120);
        //  print(@"$obsTime\n");
        //  print(@"$currentTime\n");
        if (!isTimeCurrent) {
            process(latLon, 1);
        }
    }
}
