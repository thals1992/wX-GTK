// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityLocationFragment {

    const string nws7dayTemp1 = "with a low around (-?[0-9]{1,3})\\.";
    const string nws7dayTemp2 = "with a high near (-?[0-9]{1,3})\\.";
    const string nws7dayTemp3 = "teady temperature around (-?[0-9]{1,3})\\.";
    const string nws7dayTemp4 = "Low around (-?[0-9]{1,3})\\.";
    const string nws7dayTemp5 = "High near (-?[0-9]{1,3})\\.";
    const string nws7dayTemp6 = "emperature falling to around (-?[0-9]{1,3}) ";
    const string nws7dayTemp7 = "emperature rising to around (-?[0-9]{1,3}) ";
    const string nws7dayTemp8 = "emperature falling to near (-?[0-9]{1,3}) ";
    const string nws7dayTemp9 = "emperature rising to near (-?[0-9]{1,3}) ";
    const string nws7dayTemp10 = "High near (-?[0-9]{1,3}),";
    const string nws7dayTemp11 = "Low around (-?[0-9]{1,3}),";
    const string sevenDayWind1 = "wind ([0-9]*) to ([0-9]*) mph";
    const string sevenDayWind2 = "wind around ([0-9]*) mph";
    const string sevenDayWind3 = "with gusts as high as ([0-9]*) mph";
    const string sevenDayWind4 = " ([0-9]*) to ([0-9]*) mph after";
    const string sevenDayWind5 = " around ([0-9]*) mph after ";
    const string sevenDayWind6 = " ([0-9]*) to ([0-9]*) mph in ";
    const string sevenDayWind7 = "around ([0-9]*) mph";
    const string sevenDayWind8 = "Winds could gust as high as ([0-9]*) mph\\.";
    const string sevenDayWind9 = " ([0-9]*) to ([0-9]*) mph.";
    const string sevenDayWinddir1 = "\\. (\\w+\\s?\\w*) wind ";
    const string sevenDayWinddir2 = "wind becoming (.*?) [0-9]";
    const string sevenDayWinddir3 = "wind becoming (\\w+\\s?\\w*) around";
    const string sevenDayWinddir4 = "Breezy, with a[n]? (.*?) wind";
    const string sevenDayWinddir5 = "Windy, with a[n]? (.*?) wind";
    const string sevenDayWinddir6 = "Blustery, with a[n]? (.*?) wind";
    const string sevenDayWinddir7 = "Light (.*?) wind";

    public static string extract7DayMetrics(string chunk) {
        var spacing = " ";
        // wind 24 to 29 mph
        var wind = UtilityString.parseTwo(chunk, sevenDayWind1);
        // wind around 9 mph
        var wind2 = UtilityString.parse(chunk, sevenDayWind2);
        // 5 to 10 mph after
        var wind3 = UtilityString.parseTwo(chunk, sevenDayWind4);
        // around 5 mph after
        var wind4 = UtilityString.parse(chunk, sevenDayWind5);
        // 5 to 7 mph in
        var wind5 = UtilityString.parseTwo(chunk, sevenDayWind6);
        // around 6 mph.
        var wind7 = UtilityString.parse(chunk, sevenDayWind7);
        // with gusts as high as 21 mph
        var gust = UtilityString.parse(chunk, sevenDayWind3);
        // 5 to 7 mph.
        var wind9 = UtilityString.parseTwo(chunk, sevenDayWind9);
        // Winds could gusts as high as 21 mph.
        if (gust == "") {
            gust = UtilityString.parse(chunk, sevenDayWind8);
        }
        gust = (gust != "") ? " G " + gust + " mph" : " mph";
        if (wind.length > 1) {
            return spacing + wind[0] + "-" + wind[1] + gust;
        } else if (wind2 != "") {
            return spacing + wind2 + gust;
        } else if (wind3.length > 1) {
            return spacing + wind3[0] + "-" + wind3[1] + gust;
        } else if (wind4 != "") {
            return spacing + wind4 + gust;
        } else if (wind5.length > 1) {
            return spacing + wind5[0] + "-" + wind5[1] + gust;
        } else if (wind7 != "") {
            return spacing + wind7 + gust;
        } else if (wind9.length > 1) {
            return spacing + wind9[0] + "-" + wind9[1] + gust;
        } else {
            return "";
        }
    }

    public static string extractWindDirection(string chunk) {
        var windDir = new HashMap<string, string>();
        windDir["north"] = "N";
        windDir["north northeast"] = "NNE";
        windDir["northeast"] = "NE";
        windDir["east northeast"] = "ENE";
        windDir["east"] = "E";
        windDir["east southeast"] = "ESE";
        windDir["south southeast"] = "SSE";
        windDir["southeast"] = "SE";
        windDir["south"] = "S";
        windDir["south southwest"] = "SSW";
        windDir["southwest"] = "SW";
        windDir["west southwest"] = "WSW";
        windDir["west"] = "W";
        windDir["west northwest"] = "WNW";
        windDir["northwest"] = "NW";
        windDir["north northwest"] = "NNW";
        var patterns = UtilityList.wrap({
            "Breezy, with a[n]? (.*?) wind",
            "wind becoming (\\w+\\s?\\w*) around",
            "wind becoming (.*?) [0-9]",
            "\\. (\\w+\\s?\\w*) wind ",
            "Windy, with a[n]? (.*?) wind",
            "Blustery, with a[n]? (.*?) wind",
            "Light (.*?) wind"
        });
        var windResults = new ArrayList<string>();
        foreach (var pattern in patterns) {
            windResults.add(UtilityString.parse(chunk, pattern));
        }
        var retStr = "";
        foreach (var windToken in windResults) {
            if (windToken != "") {
                retStr = windToken;
                break;
            }
        }
        if (retStr == "") {
            return "";
        } else {
            var ret = windDir[retStr.ascii_down()];
            return (ret != null) ? " " + ret : "";
        }
    }

    public static string extractTemp(string blob) {
        var regexps = UtilityList.wrap({
            nws7dayTemp1,
            nws7dayTemp2,
            nws7dayTemp3,
            nws7dayTemp4,
            nws7dayTemp5,
            nws7dayTemp6,
            nws7dayTemp7,
            nws7dayTemp8,
            nws7dayTemp9,
            nws7dayTemp10,
            nws7dayTemp11
        });
        foreach (var regexp in regexps) {
            var temp = UtilityString.parse(blob, regexp);
            if (temp != "") {
                return temp;
            }
        }
        return "";
    }
}
