// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ColorPalettes {

    public static void initialize() {
        ObjectColorPalette.radarColorPalette = new HashMap<int, string>();
        refreshPref();
        ObjectColorPalette.colorMap = new HashMap<int, ObjectColorPalette>();
        var colorMapInts = new int[]{19, 30, 56, 134, 135, 159, 161, 163, 165};
        ObjectColorPalette cm94 = new ObjectColorPalette(94);
        ObjectColorPalette.colorMap[94] = cm94;
        ObjectColorPalette.colorMap[94].initialize();
        ObjectColorPalette.colorMap[153] = cm94;
        ObjectColorPalette.colorMap[186] = cm94;
        ObjectColorPalette.colorMap[180] = cm94;
        ObjectColorPalette cm99 = new ObjectColorPalette(99);
        ObjectColorPalette.colorMap[99] = cm99;
        ObjectColorPalette.colorMap[99].initialize();
        ObjectColorPalette.colorMap[154] = cm99;
        ObjectColorPalette.colorMap[182] = cm99;
        ObjectColorPalette cm172 = new ObjectColorPalette(172);
        ObjectColorPalette.colorMap[172] = cm172;
        ObjectColorPalette.colorMap[172].initialize();
        ObjectColorPalette.colorMap[170] = cm172;
        foreach (var data in colorMapInts) {
            ObjectColorPalette.colorMap[data] = new ObjectColorPalette(data);
            ObjectColorPalette.colorMap[data].initialize();
        }
        ObjectColorPalette.colorMap[181] = ObjectColorPalette.colorMap[19];
        ObjectColorPalette.colorMap[37] = ObjectColorPalette.colorMap[19];
        ObjectColorPalette.colorMap[38] = ObjectColorPalette.colorMap[19];
        ObjectColorPalette.colorMap[2161] = ObjectColorPalette.colorMap[161];
    }

    public static void refreshPref() {
        ObjectColorPalette.radarColorPalette.clear();
        const int[] radarProductCodes = {94, 99, 134, 135, 159, 161, 163, 165, 172};
        foreach (var data in radarProductCodes) {
            ObjectColorPalette.radarColorPalette[data] = Utility.readPref("RADAR_COLOR_PALETTE_" + Too.String(data), "CODENH");
        }
    }
}
