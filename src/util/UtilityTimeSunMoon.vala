// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityTimeSunMoon {

    public static DateTime[] getSunriseSunsetFromObs(RID obs) {
        var sunCalc = new SunCalc();
        var now = new DateTime.now();
        var sunRiseDate = sunCalc.time(now, SolarEvent.sunrise, Location.getLatLonCurrent());
        var sunSetDate = sunCalc.time(now, SolarEvent.sunset, Location.getLatLonCurrent());
        return {sunRiseDate, sunSetDate};
    }

    public static string getSunTimes(LatLon latLon) {
        var sunCalc = new SunCalc();
        var now = new DateTime.now();
        var sunRiseDate = sunCalc.time(now, SolarEvent.sunrise, latLon);
        var sunSetDate = sunCalc.time(now, SolarEvent.sunset, latLon);
        var sunRise = sunRiseDate.format("%H:%M");
        var sunSet = sunSetDate.format("%H:%M");
        return "Sunrise: " + sunRise + " Sunset: " + sunSet;
    }
}
