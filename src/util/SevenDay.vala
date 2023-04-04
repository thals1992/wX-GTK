// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SevenDay {

    ArrayList<string> shortForecast = new ArrayList<string>();
    public ArrayList<string> detailedForecasts = new ArrayList<string>();
    public ArrayList<string> icons = new ArrayList<string>();
    ArrayList<Forecast> forecasts = new ArrayList<Forecast>();
    public LatLon latLon;

    public void process(LatLon latLon) {
        this.latLon = latLon;
        shortForecast.clear();
        detailedForecasts.clear();
        icons.clear();
        forecasts.clear();
        if (UIPreferences.useNwsApi) {
            var html = UtilityDownloadNws.get7DayData(latLon);
            var names = UtilityString.parseColumn(html, "\"name\": \"(.*?)\",");
            var temperatures = UtilityString.parseColumn(html, "\"temperature\": (.*?),");
            var windSpeeds = UtilityString.parseColumn(html, "\"windSpeed\": \"(.*?)\",");
            var windDirections = UtilityString.parseColumn(html, "\"windDirection\": \"(.*?)\",");
            var detailedForecastsLocal = UtilityString.parseColumn(html, "\"detailedForecast\": \"(.*?)\"");
            icons = UtilityString.parseColumn(html, "\"icon\": \"(.*?)\",");
            var shortForecastsLocal = UtilityString.parseColumn(html, "\"shortForecast\": \"(.*?)\",");
            foreach (var i in range(names.size)) {
                var name = Utility.safeGet(names, i);
                var temperature = Utility.safeGet(temperatures, i);
                var windSpeed = Utility.safeGet(windSpeeds, i);
                var windDirection = Utility.safeGet(windDirections, i);
                var icon = Utility.safeGet(icons, i);
                var shortForecast = Utility.safeGet(shortForecastsLocal, i);
                var detailedForecast = Utility.safeGet(detailedForecastsLocal, i);
                forecasts.add(new Forecast(name, temperature, windSpeed, windDirection, icon, shortForecast, detailedForecast));
            }
            foreach (var item in forecasts) {
                detailedForecasts.add(item.name + ": " + item.detailedForecast);
                shortForecast.add(item.name + ": " + item.shortForecast);
            }
        } else {
            var forecastStringList = UtilityUS.getCurrentConditionsUS(latLon.latStr(), latLon.lonStr());
            var forecastString = forecastStringList[1];
            var iconString = forecastStringList[0];
            var forecasts = forecastString.split("\n");
            var iconList = UtilityString.parseColumn(iconString, "<icon-link>(.*?)</icon-link>");
            foreach (var index in range(forecasts.length)) {
                if (forecasts[index] != "") {
                    detailedForecasts.add(forecasts[index].strip());
                    if (iconList.size > index) {
                        icons.add(iconList[index]);
                    } else {
                        icons.add("");
                    }
                }
            }
        }
    }
}
