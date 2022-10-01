// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Color {

    public const int redInt = -65536;
    public const int greenInt = -16711936;
    public const int yellowInt = -256;
    public const int magentaInt = -65281;
    public const int blueInt = -65281;

    public static int rgb(int red, int green, int blue) {
        int retVal = 0xFF << 24;
        retVal += (red << 16) + (green << 8) + blue;
        return retVal;
    }

    public static uint8 red(int color) {
        return (uint8)((color >> 16) & 0xFF);
    }

    public static uint8 green(int color) {
        return (uint8)((color >> 8) & 0xFF);  // 255 or 0xFF ??
    }

    public static uint8 blue(int color) {
        return (uint8)(color & 0xFF);
    }

    public static void setCairoColor(Cairo.Context ctx, int color) {
        ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
    }

    public static double[] colorToHsv(int color) {
        // https://www.cs.rit.edu/~ncs/color/t_convert.html
        var r = (double)red(color) / 255.0;
        var g = (double)green(color) / 255.0;
        var b = (double)blue(color) / 255.0;
        var h = 0.0;
        var s = 0.0;
        var v = 0.0;
        double delta;
        var min = r < g ? r : g;
        min = min < b ? min : b;
        var max = r > g ? r : g;
        max = max > b ? max : b;
        v = max;
        delta = max - min;
        if (delta < 0.00001) {
            s = 0;
            h = 0; // undefined, maybe nan?
            return {h, s, v};
        }
        if ( max > 0.0 ) { // NOTE: if Max is == 0, this divide would cause a crash
            s = (delta / max);
        } else {
            // if max is 0, then r = g = b = 0
            // s = 0, h is undefined
            s = 0.0;
            h = double.NAN;                          // its now undefined
            return {h, s, v};
        }
        if (r >= max) {                          // > is bogus, just keeps compilor happy
            h = (g - b) / delta;        // between yellow & magenta
        } else {
            if (g >= max) {
                h = 2.0 + ( b - r ) / delta;  // between cyan & yellow
            } else {
                h = 4.0 + ( r - g ) / delta;  // between magenta & cyan
            }
        }
        h *= 60.0;  // degrees
        if (h < 0.0) {
            h += 360.0;
        }
        return { h / 360.0, s, v};
    }

    // input for all 3 double is in 0.0 .. 1.0
    public static int hsvToColor(double[] hsv) {
        double hh;
        double p;
        double q;
        double t;
        double ff;
        long i;
        double r;
        double g;
        double b;
        var h = hsv[0];
        var s = hsv[1];
        var v = hsv[2];
        if (s <= 0.0) {
            r = v;
            g = v;
            b = v;
            var redI = (int)(r * 255.0);
            var greenI = (int)(g * 255.0);
            var blueI = (int)(b * 255.0);
            return rgb(redI, greenI, blueI);
        }
        hh = h * 360.0;
        if (hh >= 360.0) {
            hh = 0.0;
        }
        hh /= 60.0;
        i = (long)hh;
        ff = hh - i;
        p = v * (1.0 - s);
        q = v * (1.0 - (s * ff));
        t = v * (1.0 - (s * (1.0 - ff)));
        switch (i) {
            case 0:
                r = v;
                g = t;
                b = p;
                break;
            case 1:
                r = q;
                g = v;
                b = p;
                break;
            case 2:
                r = p;
                g = v;
                b = t;
                break;
            case 3:
                r = p;
                g = q;
                b = v;
                break;
            case 4:
                r = t;
                g = p;
                b = v;
                break;
            case 5:
            default:
                r = v;
                g = p;
                b = q;
                break;
        }
        var redI = (int)(r * 255.0);
        var greenI = (int)(g * 255.0);
        var blueI = (int)(b * 255.0);
        return rgb(redI, greenI, blueI);
    }
}
