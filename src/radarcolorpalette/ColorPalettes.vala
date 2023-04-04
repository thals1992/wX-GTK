// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ColorPalettes {

    public static void initialize() {
        ColorPalette.radarColorPalette = new HashMap<int, string>();
        refreshPref();
        ColorPalette.colorMap = new HashMap<int, ColorPalette>();
        var colorMapInts = new int[]{19, 30, 56, 134, 135, 159, 161, 163, 165};
        ColorPalette cm94 = new ColorPalette(94);
        ColorPalette.colorMap[94] = cm94;
        ColorPalette.colorMap[94].initialize();
        ColorPalette.colorMap[153] = cm94;
        ColorPalette.colorMap[186] = cm94;
        ColorPalette.colorMap[180] = cm94;
        ColorPalette cm99 = new ColorPalette(99);
        ColorPalette.colorMap[99] = cm99;
        ColorPalette.colorMap[99].initialize();
        ColorPalette.colorMap[154] = cm99;
        ColorPalette.colorMap[182] = cm99;
        ColorPalette cm172 = new ColorPalette(172);
        ColorPalette.colorMap[172] = cm172;
        ColorPalette.colorMap[172].initialize();
        ColorPalette.colorMap[170] = cm172;
        foreach (var data in colorMapInts) {
            ColorPalette.colorMap[data] = new ColorPalette(data);
            ColorPalette.colorMap[data].initialize();
        }
        ColorPalette.colorMap[181] = ColorPalette.colorMap[19];
        ColorPalette.colorMap[37] = ColorPalette.colorMap[19];
        ColorPalette.colorMap[38] = ColorPalette.colorMap[19];
        ColorPalette.colorMap[2161] = ColorPalette.colorMap[161];
    }

    public static void refreshPref() {
        ColorPalette.radarColorPalette.clear();
        var radarProductCodes = new int[]{94, 99, 134, 135, 159, 161, 163, 165, 172};
        foreach (var data in radarProductCodes) {
            ColorPalette.radarColorPalette[data] = Utility.readPref("RADAR_COLOR_PALETTE_" + Too.String(data), "CODENH");
        }
    }
}
