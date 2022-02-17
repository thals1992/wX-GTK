// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityHourlyOldApi {

    public static string getHourlyString(int locNumber) {
        var latLon = Location.getLatLon(locNumber);
        var html = UtilityIO.getHtml("https://forecast.weather.gov/MapClick.php?lat=" +
                latLon.latStr() + "&lon=" +
                latLon.lonStr() + "&FcstType=digitalDWML");
        var header = Too.StringPadLeft("Time", 16) + " " + Too.StringPadLeft("Temp", 8) + Too.StringPadLeft("Dew", 8) + Too.StringPadLeft("Precip", 8) + Too.StringPadLeft( "Cloud", 8) + GlobalVariables.newline;
        return GlobalVariables.newline + header + UtilityHourlyOldApi.parseHourly(html);
    }

    static string parseHourly(string htmlF) {
        var regexpList = new string[]{
            "<temperature type=.hourly.*?>(.*?)</temperature>",
            "<temperature type=.dew point.*?>(.*?)</temperature>",
            "<time-layout.*?>(.*?)</time-layout>",
            "<probability-of-precipitation.*?>(.*?)</probability-of-precipitation>",
            "<cloud-amount type=.total.*?>(.*?)</cloud-amount>"
        };
        var html = htmlF.replace("<value xsi:nil=\"true\"/>", "<value>-</value>");
        var rawData = UtilityString.parseXmlExt(regexpList, html);
        var temp2List = UtilityString.parseXmlValue(rawData[0]);
        var temp3List = UtilityString.parseXmlValue(rawData[1]);
        var time2List = UtilityString.parseXml(rawData[2], "start-valid-time");
        var temp4List = UtilityString.parseXmlValue(rawData[3]);
        var temp5List = UtilityString.parseXmlValue(rawData[4]);
        var sb = "";
        var year = UtilityTime.getYear();
        var temp2Len = temp2List.length;
        var temp3Len = temp3List.length;
        var temp4Len = temp4List.length;
        var temp5Len = temp5List.length;
        foreach (var j in UtilityList.range2(1, temp2Len)) {
            time2List[j] = UtilityString.replaceRegex(time2List[j], "-0[0-9]:00", "");
            time2List[j] = UtilityString.replaceRegex(time2List[j], "^.*?-", "");
            time2List[j] = time2List[j].replace("T", " ");
            time2List[j] = time2List[j].replace("00:00", "00");
            var timeSplit = time2List[j].split(" ");
            var timeSplit2 = timeSplit[0].split("-");
            var month = Too.Int(timeSplit2[0]);
            var day = Too.Int(timeSplit2[1]);
            var dayOfTheWeek = "";
            dayOfTheWeek = UtilityTime.dayOfWeek(year, month, day);
            var temp3Val = ".";
            var temp4Val = ".";
            var temp5Val = ".";
            if (temp2Len == temp3Len) {
                temp3Val = temp3List[j];
            }
            if (temp2Len == temp4Len) {
                temp4Val = temp4List[j];
            }
            if (temp2Len == temp5Len) {
                temp5Val = temp5List[j];
            }
            time2List[j] = time2List[j].replace(":00", "");
            time2List[j] = time2List[j].strip();
            sb += Too.StringPadLeft(dayOfTheWeek + " " + time2List[j], 14);
            sb += "   ";
            sb += Too.StringPadLeft(temp2List[j], 8);
            sb += Too.StringPadLeft(temp3Val, 8);
            sb += Too.StringPadLeft(temp4Val, 8);
            sb += Too.StringPadLeft(temp5Val, 8);
            sb += GlobalVariables.newline;
        }
        return sb;
    }
}
