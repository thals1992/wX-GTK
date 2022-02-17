// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityNexradColors {

    static double interpolate(double colorA, double colorB, double proportion) {
        return (colorA + ((colorB - colorA) * proportion));
    }

    static double interpolateHue(double colorA, double colorB, double proportion) {
        var diff = colorB - colorA;
        var total = 1.0;
        if (diff > total / 2) {
            var ret = (total - (colorB - colorA)) * -1.0;
            if (ret < 0) {
                return ret + total;
            }
            return ret;
        }
        return colorA + ((colorB - colorA) * proportion);
    }

    public static int interpolateColor(int colorA, int colorB, double proportion) {
        var hsva = Color.colorToHsv(colorA);
        var hsvb = Color.colorToHsv(colorB);
        foreach (var index in UtilityList.range(3)) {
            if (index > 0) {
                hsvb[index] = interpolate(hsva[index], hsvb[index], proportion);
            } else {
                hsvb[index] = interpolateHue(hsva[index], hsvb[index], proportion);
            }
        }
        return Color.hsvToColor(hsvb);
    }
}
