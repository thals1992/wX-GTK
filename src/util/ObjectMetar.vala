// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectMetar {

    public string condition = "";
    public string temperature = "";
    public string dewpoint = "";
    public string windDirection = "";
    public string windSpeed = "";
    public string windGust = "";
    public string seaLevelPressure = "";
    public string visibility = "";
    public string relativeHumidity = "";
    public string windChill = "";
    public string heatIndex = "";
    public string conditionsTimeStr = "";
    public string timeStringUtc = "";
    public string icon = "";
    public string metarSkyCondition = "";
    public string metarWeatherCondition = "";
    public string[] metarDataList;
    public RID obsClosest;
    string metarData = "";

    public ObjectMetar(LatLon location, int order) {
        obsClosest = Metar.findClosestObservation(location, order);
    }

    public void process() {
        metarData = UtilityIO.getHtml(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsClosest.name + ".TXT");
        temperature = UtilityString.parse(metarData, "Temperature: (.*?) F");
        dewpoint = UtilityString.parse(metarData, "Dew Point: (.*?) F");
        windDirection = UtilityString.parse(metarData, "Wind: from the (.*?) \\(.*? degrees\\) at .*? MPH ");
        windSpeed = UtilityString.parse(metarData, "Wind: from the .*? \\(.*? degrees\\) at (.*?) MPH ");
        windGust = UtilityString.parse(metarData, "Wind: from the .*? \\(.*? degrees\\) at .*? MPH \\(.*? KT\\) gusting to (.*?) MPH");
        seaLevelPressure = UtilityString.parse(metarData, "Pressure \\(altimeter\\): .*? in. Hg \\((.*?) hPa\\)");
        visibility = UtilityString.parse(metarData, "Visibility: (.*?) mile");
        relativeHumidity = UtilityString.parse(metarData, "Relative Humidity: (.*?)%");
        windChill = UtilityString.parse(metarData, "Windchill: (.*?) F");
        heatIndex = UtilityMath.heatIndex(temperature, relativeHumidity);
        metarSkyCondition = (UtilityString.parse(metarData, "Sky conditions: (.*?)" + GlobalVariables.newline));
        metarWeatherCondition = (UtilityString.parse(metarData, "Weather: (.*?)" + GlobalVariables.newline));
        metarSkyCondition = UtilityString.title(metarSkyCondition);
        metarWeatherCondition = UtilityString.title(metarWeatherCondition);
        metarDataList = metarData.split(GlobalVariables.newline);
        if (metarWeatherCondition == "" || metarWeatherCondition.contains("Inches Of Snow On Ground")) {
            condition = metarSkyCondition;
        } else {
            condition = metarWeatherCondition;
        }
        condition = condition.replace("; Lightning Observed", "");
        condition = condition.replace("; Cumulonimbus Clouds, Lightning Observed", "");
        if (condition == "Mist") {
            condition = "Fog/Mist";
        }
        icon = decodeIconFromMetar(condition, obsClosest);
        condition = condition.replace(";", " and");
        if (metarDataList.length > 2) {
            var localStatus = metarDataList[1].split("/");
            if (localStatus.length > 1) {
                conditionsTimeStr = ObjectDateTime.convertFromUTCForMetar(localStatus[1].replace(" UTC", "")) + " " + obsClosest.name;
                timeStringUtc = localStatus[1].strip();
            }
        }
        seaLevelPressure = changePressureUnits(seaLevelPressure);
        temperature = changeDegreeUnits(temperature);
        dewpoint = changeDegreeUnits(dewpoint);
        windChill = changeDegreeUnits(windChill);
        heatIndex = changeDegreeUnits(heatIndex);
        if (windSpeed == "") {
            windSpeed = "0";
        }
        if (condition == "") {
            condition = "NA";
        }
    }

    public string decodeIconFromMetar(string condition, RID obs) {
        var timeOfDay = ObjectDateTime.isDaytime(obs) ? "day" : "night";
        var conditionModified = condition.split(";")[0];
        var shortCondition = UtilityMetarConditions.iconFromCondition[conditionModified] ?? "";
        shortCondition = translateCondition(shortCondition);
        return "https://api.weather.gov/icons/land/" + timeOfDay + "/" + shortCondition + "?size=medium";
    }

    public string translateCondition(string condition) {
        var newCondition = condition.replace("minus", "");
        newCondition = newCondition.replace("fg", "fog");
        newCondition = newCondition.replace("fzrain", "rainfzra");
        if (!condition.contains("ts") && !condition.contains("fz")) {
            newCondition = newCondition.replace("ra", "rain");
        }
        return newCondition;
    }

    public string changeDegreeUnits(string value) {
        if (value != "") {
            var tempD = Too.Double(value);
            return UtilityMath.roundDTostring(tempD);
        } else {
            return "NA";
        }
    }

    public string changePressureUnits(string value) {
        return value + " mb";
    }
}
