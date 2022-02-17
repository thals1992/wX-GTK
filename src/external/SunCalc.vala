/*
Vala port of code below. Anything moon related removed.
Please see COPYING.SunCalc2 for license specified at below URL

(c) 2011-2015, Vladimir Agafonkin
SunCalc is a JavaScript library for calculating sun/moon position and light phases.
https://github.com/mourner/suncalc
*/

using Gee;

class SunCalc {

    // shortcuts for easier to read formulas
    const double pi = Math.PI;
    const double rad = pi / 180.0;

    // sun calculations are based on http://aa.quae.nl/en/reken/zonpositie.html formulas
    // date/time constants and conversions
    const int dayMs = 1000 * 60 * 60 * 24;
    const int j1970 = 2440588;
    const int j2000 = 2451545;

    public double toJulian(DateTime date) {
        return UtilityTime.currentTimeMillis() / dayMs - 0.5 + j1970;
    }

    public DateTime fromJulian(double j) {
        double number = (j + 0.5 - j1970) * dayMs;
        return new DateTime.from_unix_local((int64)(number / (double)1000));
    }

    public double toDays(DateTime date) {
        return toJulian(date) - j2000;
    }

    // general calculations for position
    static double e = rad * 23.4397; // obliquity of the Earth

    // public double rightAscension(double l, double b) {
    //     return Math.atan2(Math.sin(l) * Math.cos(e) - Math.tan(b) * Math.sin(e), Math.cos(l));
    // }

    public double declination(double l, double b) {
        return Math.asin(Math.sin(b) * Math.cos(e) + Math.cos(b) * Math.sin(e) * Math.sin(l));
    }

    // general sun calculations

    public double solarMeanAnomaly(double d) {
        return rad * (357.5291 + 0.98560028 * d);
    }

    public double eclipticLongitude(double M) {
        double C = rad * (1.9148 * Math.sin(M) + 0.02 * Math.sin(2 * M) + 0.0003 * Math.sin(3 * M)); // equation of center
        double P = rad * 102.9372; // perihelion of the Earth
        return M + C + P + pi;
    }

    // sun times configuration (angle, morning name, evening name)
    // calculations for sun times

    const double j0 = 0.0009;

    public double julianCycle(double d, double lw) {
        return Math.round(d - j0 - lw / (2 * pi));
    }

    public double approximateTransit(double ht, double lw, double n) {
        return j0 + (ht + lw) / (2 * pi) + n;
    }

    public double solarTransitJ(double ds, double M, double L) {
        return j2000 + ds + 0.0053 * Math.sin(M) - 0.0069 * Math.sin(2 * L);
    }

    public double hourAngle(double h, double phi, double d) {
        return Math.acos((Math.sin(h) - Math.sin(phi) * Math.sin(d)) / (Math.cos(phi) * Math.cos(d)));
    }

    // returns set time for the given sun altitude
    public double getSetJ(double h, double lw, double phi, double dec, double n, double M, double L) {
        double w = hourAngle(h, phi, dec);
        double a = approximateTransit(w, lw, n);
        return solarTransitJ(a, M, L);
    }

    // calculates sun times for a given date and latitude/longitude
    public DateTime time(DateTime date, SolarEvent event, LatLon location) {
        double lw = rad * -1.0 * location.lon();
        double phi = rad * location.lat();
        double d = toDays(date);
        double n = julianCycle(d, lw);
        double ds = approximateTransit(0.0, lw, n);
        double m = solarMeanAnomaly(ds);
        double l = eclipticLongitude(m);
        double dec = declination(l, 0.0);
        double jNoon = solarTransitJ(ds, m, l);
        DateTime noon = fromJulian(jNoon);
        double angle = solarAngle(event);
        double jSet = getSetJ(angle * rad, lw, phi, dec, n, m, l);
        switch (event) {
            case SolarEvent.noon:
                return noon;
            case SolarEvent.nadir:
                DateTime nadir = fromJulian(jNoon - 0.5);
                return nadir;
            case SolarEvent.sunset:
                return fromJulian(jSet);
            case SolarEvent.dusk:
                return fromJulian(jSet);
            case SolarEvent.goldenHour:
                return fromJulian(jSet);
            case SolarEvent.astronomicalDusk:
                return fromJulian(jSet);
            case SolarEvent.nauticalDusk:
                return fromJulian(jSet);
            case SolarEvent.sunrise:
                double jRise = jNoon - (jSet - jNoon);
                return fromJulian(jRise);
            case SolarEvent.dawn:
                double jRise = jNoon - (jSet - jNoon);
                return fromJulian(jRise);
            case SolarEvent.goldenHourEnd:
                double jRise = jNoon - (jSet - jNoon);
                return fromJulian(jRise);
            case SolarEvent.astronomicalDawn:
                double jRise = jNoon - (jSet - jNoon);
                return fromJulian(jRise);
            case SolarEvent.nauticalDawn:
                double jRise = jNoon - (jSet - jNoon);
                return fromJulian(jRise);
            default:
                return new DateTime.now();
        }
    }

    public double solarAngle(SolarEvent event) {
        double returnVal = 0.0;
        switch (event) {
            case SolarEvent.sunrise:
                returnVal = -0.833;
                break;
            case SolarEvent.sunset:
                returnVal = -0.833;
                break;
            case SolarEvent.sunriseEnd:
                returnVal = -0.3;
                break;
            case SolarEvent.sunsetEnd:
                returnVal = -0.3;
                break;
            case SolarEvent.dawn:
                returnVal = -6.0;
                break;
            case SolarEvent.dusk:
                returnVal = -6.0;
                break;
            case SolarEvent.nauticalDawn:
                returnVal = -12.0;
                break;
            case SolarEvent.nauticalDusk:
                returnVal = -12.0;
                break;
            case SolarEvent.astronomicalDawn:
                returnVal = -18.0;
                break;
            case SolarEvent.astronomicalDusk:
                returnVal = -18.0;
                break;
            case SolarEvent.goldenHourEnd:
                returnVal = 6.0;
                break;
            case SolarEvent.goldenHour:
                returnVal = 6.0;
                break;
            case SolarEvent.noon:
                returnVal = 90.0;
                break;
            case SolarEvent.nadir:
                returnVal = -90.0;
                break;
        }
        return returnVal;
    }
}

public enum SolarEvent {
    sunrise,
    sunset,
    sunriseEnd,
    sunsetEnd,
    dawn,
    dusk,
    nauticalDawn,
    nauticalDusk,
    astronomicalDawn,
    astronomicalDusk,
    goldenHourEnd,
    goldenHour,
    noon,
    nadir
}
