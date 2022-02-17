// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityHourly {

    static HashMap<string, string> abbreviations;

    public static void initStatic() {
        abbreviations = new HashMap<string, string>();
        abbreviations["Showers And Thunderstorms"] = "Sh/Tst";
        abbreviations["Chance"] = "Chc";
        abbreviations["Slight"] = "Slt";
        abbreviations["Light"] = "Lgt";
        abbreviations["Scattered"] = "Sct";
        abbreviations["Rain"] = "Rn";
        abbreviations["Snow"] = "Sn";
        abbreviations["Rn And Sn"] = "Rn/Sn";
        abbreviations["Freezing"] = "Frz";
        abbreviations["Drizzle"] = "Drz";
        abbreviations["Isolated"] = "Iso";
        abbreviations["Likely"] = "Lkly";
        abbreviations["T-storms"] = "Tst";
        abbreviations["Showers"] = "Shwr";
        abbreviations["And Patchy Blowing"] = "Pa Bl";
    }

    static string getFooter() {
        var footer = GlobalVariables.newline;
        foreach (var k in abbreviations.keys) {
            footer += abbreviations[k] + ": " + k + GlobalVariables.newline;
        }
        return footer;
    }

    public static string get(int locationNumber) {
        if (UIPreferences.useNwsApiForHourly) {
            return UtilityHourly.getHourlyString(locationNumber)[0];
        }
        return UtilityHourlyOldApi.getHourlyString(locationNumber);
    }

    static ArrayList<string> getHourlyString(int locNumber) {
        var html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locNumber));
        if (html == "") {
            print("hourly 2nd download attempt\n");
            html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locNumber));
        }
        var header = Too.StringPadLeft("Time", 7) + Too.StringPadLeft("T", 4) + Too.StringPadLeft("Wind", 8) + Too.StringPadLeft("WindDir", 6) + GlobalVariables.newline;
        var footer = getFooter();
        return UtilityList.wrap({header + parse(html) + footer, html});
    }

    static string parse(string html) {
        var startTime = UtilityString.parseColumn(html, "\"startTime\": \"(.*?)\",");
        var temperatures = UtilityString.parseColumn(html, "\"temperature\": (.*?),");
        var windSpeeds = UtilityString.parseColumn(html, "\"windSpeed\": \"(.*?)\"");
        var windDirections = UtilityString.parseColumn(html, "\"windDirection\": \"(.*?)\"");
        var shortForecasts = UtilityString.parseColumn(html, "\"shortForecast\": \"(.*?)\"");
        var stringValue = "";
        foreach (var index in UtilityList.range(startTime.size)) {
            var time = translateTime(startTime[index]);
            var temperature = Utility.safeGet(temperatures, index);
            var windSpeed = Utility.safeGet(windSpeeds, index).replace(" to ", "-");
            var windDirection = Utility.safeGet(windDirections, index);
            var shortForecast = Utility.safeGet(shortForecasts, index);
            stringValue += Too.StringPadLeft(time, 7);
            stringValue += Too.StringPadLeft(temperature, 4);
            stringValue += Too.StringPadLeft(windSpeed, 8);
            stringValue += Too.StringPadLeft(windDirection, 4);
            stringValue += Too.StringPadLeft(shortenConditions(shortForecast), 18);
            stringValue += GlobalVariables.newline;
        }
        return stringValue;
    }

    static string shortenConditions(string str) {
        var hourly = str;
        foreach (var data in abbreviations.keys) {
            hourly = hourly.replace(data, abbreviations[data]);
        }
        return hourly;
    }

    static string translateTime(string originalTime) {
        var originalTimeComponents = originalTime.replace("T", "-").split("-");
        var hour = Too.Int(originalTimeComponents[3].replace(":00:00", ""));
        var hourString = Too.String(hour);
        var dayOfTheWeek = UtilityTime.hourlyDayOfWeek(originalTime);
        return dayOfTheWeek + " " + hourString;
    }
}
