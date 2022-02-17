// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectCurrentConditions {

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

    public ObjectCurrentConditions(LatLon latLon) {
        this.latLon = latLon;
    }

    public void process() {
        var sb = "";
        var objMetar = new ObjectMetar(latLon);
        objMetar.process();
        obsStation = objMetar.obsClosest.name;
        conditionsTimeStr = objMetar.conditionsTimeStr;
        temperature = objMetar.temperature + GlobalVariables.degreeSymbol;
        windChill = objMetar.windChill + GlobalVariables.degreeSymbol;
        heatIndex = objMetar.heatIndex + GlobalVariables.degreeSymbol;
        dewpoint = objMetar.dewpoint + GlobalVariables.degreeSymbol;
        relativeHumidity = objMetar.relativeHumidity + "%";
        seaLevelPressure = objMetar.seaLevelPressure;
        windDirection = objMetar.windDirection;
        windSpeed = objMetar.windSpeed;
        windGust = objMetar.windGust;
        visibility = objMetar.visibility;
        condition = objMetar.condition;
        sb += temperature;
        if (objMetar.windChill != "NA") {
            sb += "(" + windChill + ")";
        } else if (objMetar.heatIndex != "NA") {
            sb += "(" + heatIndex + ")";
        }
        sb += " / " + dewpoint + "(" + relativeHumidity + ")" + " - ";
        sb += seaLevelPressure + " - " + windDirection + " " + windSpeed;
        if (windGust != "") {
            sb += " G ";
        }
        sb += windGust + " mph" + " - " + visibility + " mi - " + condition;
        data1 = sb;
        iconUrl = objMetar.icon;
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
}
