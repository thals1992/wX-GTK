// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityTimeSunMoon {

    public static ObjectDateTime[] getSunriseSunsetFromObs(RID obs) {
        var sunCalc = new SunCalc();
        var now = new ObjectDateTime.local();
        var sunRiseDate = new ObjectDateTime(sunCalc.time(now.get(), SolarEvent.sunrise, Location.getLatLonCurrent()));
        var sunSetDate = new ObjectDateTime(sunCalc.time(now.get(), SolarEvent.sunset, Location.getLatLonCurrent()));
        return {sunRiseDate, sunSetDate};
    }

    public static string getSunTimes(LatLon latLon) {
        var sunCalc = new SunCalc();
        var now = new ObjectDateTime.local();
        var sunRiseDate = new ObjectDateTime(sunCalc.time(now.get(), SolarEvent.sunrise, latLon));
        var sunSetDate = new ObjectDateTime(sunCalc.time(now.get(), SolarEvent.sunset, latLon));
        var sunRise = sunRiseDate.format("%H:%M");
        var sunSet = sunSetDate.format("%H:%M");
        return "Sunrise: " + sunRise + " Sunset: " + sunSet;
    }
}
