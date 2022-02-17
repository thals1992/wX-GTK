// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityMath {

    public static string unitsPressure(string value) {
        var tmpNum = Too.Double(value);
        return (UIPreferences.unitsM) ? "%.2f".printf(tmpNum * 33.8637526) + " mb" : "%.2f".printf(tmpNum) + " in";
    }

    public static double[] computeTipPoint(double x0, double y0, double x1, double y1, bool right) {
        var dx = x1 - x0;
        var dy = y1 - y0;
        var length = Math.sqrt(dx * dx + dy * dy);
        var dirX = dx / length;
        var dirY = dy / length;
        var height = Math.sqrt(3) / 2 * length;
        var cx = x0 + dx * 0.5;
        var cy = y0 + dy * 0.5;
        var pDirX = -dirY;
        var pDirY = dirX;
        var rx = 0.0;
        var ry = 0.0;
        if (right) {
            rx = cx + height * pDirX;
            ry = cy + height * pDirY;
        } else {
            rx = cx - height * pDirX;
            ry = cy - height * pDirY;
        }
        return {rx, ry};
    }

    public static double[] computeMiddishPoint(double x0, double y0, double x1, double y1, double fraction) {
        return {x0 + fraction * (x1 - x0), y0 + fraction * (y1 - y0)};
    }

    public static double distanceOfLine(double x1, double y1, double x2, double y2) {
        return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
    }

    public static string celsiusToFahrenheit(string value) {
        return UIPreferences.unitsF ? Too.String((int)Math.round(Too.Double(value) * 9.0 / 5.0 + 32.0)) : value;
    }

    static double degreesToRadians(double deg) {
        return deg * Math.PI / 180.0;
    }

    public static double pixPerDegreeLon(double centerX, double factor) {
        var radius = (180.0 / Math.PI) * (1.0 / Math.cos(degreesToRadians(30.51))) * factor;
        return radius * (Math.PI / 180.0) * Math.cos(degreesToRadians(centerX));
    }

    public static double deg2rad(double deg) {
        return deg * Math.PI / 180.0;
    }

    public static double rad2deg(double rad) {
        return rad * 180.0 / Math.PI;
    }


    public static string convertWindDir(string direction) {
        var windDirections = new string[]{"N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"};
        var normalizedDirection = Too.Int(direction) % 360;
        //  normalizedDirection = normalizedDirection % 360;
        var listIndex = (int)Math.round(normalizedDirection / 22.5);
        var windDirectionAsstring = windDirections[listIndex];
        return windDirectionAsstring;
    }

    public static string roundDTostring(double valueD) {
        return Too.String((int)Math.round(valueD));
    }

    //  // https://training.weather.gov/wdtd/tools/misc/beamwidth/index.htm
    //  static double getRadarBeamHeight(double degree, double distance) =>
    //          3.281 * (Math.sin(toRadians(degree)) * distance + distance * distance / 15417.82) * 1000.0;

    public static string heatIndex(string temperature, string relativeHumidity) {
        // temp >= 80 and RH >= 40
        var T = Too.Double(temperature);
        var R = Too.Double(relativeHumidity);
        if (T > 80.0 && R > 40.0) {
            var s1 = -42.379;
            var s2 = 2.04901523 * T;
            var s3 = 10.14333127 * R;
            var s4 = 0.22475541 * T * R;
            var s5 = 6.83783 * Math.pow(10.0, -3.0) * Math.pow(T, 2.0);
            var s6 = 5.481717 * Math.pow(10.0, -2.0) * Math.pow(R, 2.0);
            var s7 = 1.22874 * Math.pow(10.0, -3.0) * Math.pow(T, 2.0) * R;
            var s8 = 8.5282 * Math.pow(10.0, -4.0) * T * Math.pow(R, 2.0);
            var s9 = 1.99 * Math.pow(10.0, -6.0) * Math.pow(T, 2.0) * Math.pow(R, 2.0);
            var res1 = roundDTostring(s1 + s2 + s3 - s4 - s5 - s6 + s7 + s8 - s9);
            return res1;
        } else {
            return "";
        }
    }
}
