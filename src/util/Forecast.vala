// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Forecast {

    public string name;
    public string temperature;
    public string windSpeed;
    public string windDirection;
    public string icon;
    public string shortForecast;
    public string detailedForecast;

    public Forecast(string name, string temperature, string windSpeed, string windDirection, string icon, string shortForecast, string detailedForecast) {
        this.name = name;
        this.temperature = temperature;
        this.windSpeed = windSpeed;
        this.windDirection = windDirection;
        this.icon = icon;
        this.shortForecast = shortForecast;
        this.detailedForecast = detailedForecast;
    }
}
