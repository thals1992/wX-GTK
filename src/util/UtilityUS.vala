// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityUS {

    public static ArrayList<string> getCurrentConditionsUS(string x, string y) {
        var result = new ArrayList<string>();
        var html = getLocationHtml(x, y);
        var regexpList = new string[]{
            "<temperature type=.apparent. units=.Fahrenheit..*?>(.*?)</temperature>",
            "<temperature type=.dew point. units=.Fahrenheit..*?>(.*?)</temperature>",
            "<direction type=.wind.*?>(.*?)</direction>",
            "<wind-speed type=.gust.*?>(.*?)</wind-speed>",
            "<wind-speed type=.sustained.*?>(.*?)</wind-speed>",
            "<pressure type=.barometer.*?>(.*?)</pressure>",
            "<visibility units=.*?>(.*?)</visibility>",
            "<weather-conditions weather-summary=.(.*?)./>.*?<weather-conditions>",
            "<temperature type=.maximum..*?>(.*?)</temperature>",
            "<temperature type=.minimum..*?>(.*?)</temperature>",
            "<conditions-icon type=.forecast-NWS. time-layout=.k-p12h-n1[0-9]-1..*?>(.*?)</conditions-icon>",
            "<wordedForecast time-layout=.k-p12h-n1[0-9]-1..*?>(.*?)</wordedForecast>",
            "<data type=.current observations.>.*?<area-description>(.*)</area-description>.*?</location>",
            "<moreWeatherInformation applicable-location=.point1.>http://www.nws.noaa.gov/data/obhistory/(.*).html</moreWeatherInformation>",
            "<data type=.current observations.>.*?<start-valid-time period-name=.current.>(.*)</start-valid-time>",
            "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p12h-n1[0-9]-1</layout-key>(.*?)</time-layout>",
            "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p24h-n[678]-1</layout-key>(.*?)</time-layout>",
            "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p24h-n[678]-2</layout-key>(.*?)</time-layout>",
            "<weather time-layout=.k-p12h-n1[0-9]-1.>.*?<name>.*?</name>(.*)</weather>", // 3 to [0-9] 3 places
            "<hazards time-layout.*?>(.*)</hazards>.*?<wordedF",
            "<data type=.forecast.>.*?<area-description>(.*?)</area-description>",
            "<humidity type=.relative..*?>(.*?)</humidity>"
        };
        var rawData = UtilityString.parseXmlExt(regexpList, html);
        result.add(rawData[10]);
        result.add(get7DayExt(rawData));
        return result;
    }

    static string getLocationHtml(string x, string y) {
        return UtilityIO.getHtml("https://forecast.weather.gov/MapClick.php?lat=" + x + "&lon=" + y + "&unit=0&lg=english&FcstType=dwml");
    }

    static string get7DayExt(ArrayList<string> rawData) {
        var timeP12n13List = UtilityList.wrap(new string[14]);
        var weatherSummaries = UtilityList.wrap(new string[14]);
        var forecast = UtilityString.parseXml(rawData[11], "text");
        weatherSummaries = UtilityString.parseColumn(rawData[18], GlobalVariables.utilUsWeatherSummaryPattern);
        weatherSummaries.insert(0, "");
        timeP12n13List = UtilityString.parseColumn(rawData[15], GlobalVariables.utilUsPeriodNamePattern);
        timeP12n13List.insert(0, "");
        var forecastString = "";
        foreach (var j in UtilityList.range3(1, forecast.length, 1)) {
            forecastString += timeP12n13List[j];
            forecastString += ": ";
            forecastString += forecast[j];
            forecastString += GlobalVariables.newline;
        }
        return forecastString;
    }
}
