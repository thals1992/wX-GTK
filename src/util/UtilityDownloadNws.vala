// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityDownloadNws {

    public static string getHourlyData(LatLon latLon) {
        var pointsData = getLocationPointData(latLon);
        var hourlyUrl = UtilityString.parse(pointsData, "\"forecastHourly\": \"(.*?)\"");
        return UtilityIO.getHtml(hourlyUrl);
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
        UtilityLog.d(url);
        var session = new Soup.Session();
        var message = new Soup.Message("GET", url);
        message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
        message.request_headers.append("Accept", "Application/atom+xml");
        session.send_message(message);
        return (string)message.response_body.data;
    }

    // libsoup-3.0
    //  public static string getHtmlWithXml(string url) {
    //      if (url != "") {
    //          UtilityLog.d(url);
    //          try {
    //              Soup.Session session = new Soup.Session();
    //              Soup.Message message = new Soup.Message("GET", url);
    //              message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
    //              message.request_headers.append("Accept", "Application/atom+xml");
    //              var data = session.send_and_read(message).get_data();
    //              if (data == null) {
    //                  return "";
    //              }
    //              return (string)data;
    //          } catch (Error e) {
    //              return "";
    //          }
    //      } else {
    //          return "";
    //      }
    //  }
}
