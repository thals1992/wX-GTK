// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityDownloadNws {

    public static string getHourlyData(LatLon latLon) {
        var pointsData = getLocationPointData(latLon);
        var hourlyUrl = UtilityString.parse(pointsData, "\"forecastHourly\": \"(.*?)\"");
        var html = UtilityIO.getHtml(hourlyUrl);
        return html;
    }

    public static string get7DayData(LatLon latLon) {
        var pointsData = getLocationPointData(latLon);
        var forecastUrl = UtilityString.parse(pointsData, "\"forecast\": \"(.*?)\"");
        return UtilityIO.getHtml(forecastUrl);
    }

    public static string getLocationPointData(LatLon latLon) {
        var url = GlobalVariables.nwsApiUrl + "/points/" + latLon.latStr() + "," + latLon.lonStr();
        return UtilityIO.getHtml(url);
    }

    public static string getCap(string sector) {
        if (sector == "us") {
            return getHtmlWithXml("https://api.weather.gov/alerts/active?region_type=land");
        }
        return getHtmlWithXml("https://api.weather.gov/alerts/active?state=" + sector.ascii_up());
    }

    public static string getHtmlWithXml(string url) {
        return URL.getTextXmlAcceptHeader(url);
    }
}
