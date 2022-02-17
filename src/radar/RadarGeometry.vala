// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class RadarGeometry {

    public static float[] stateLines;
    public static float[] countyLines;
    public static float[] hwLines;
    public static float[] lakeLines;
    public static float[] hwExtLines;
    public static float[] caLines;
    public static float[] mxLines;

    public static void initialize() {
        loadData("statev2.bin", out stateLines);
        loadData("county.bin", out countyLines);
        loadData("hwv4.bin", out hwLines);
        loadData("hwv4ext.bin", out hwExtLines);
        loadData("lakesv3.bin", out lakeLines);
        loadData("ca.bin", out caLines);
        loadData("mx.bin", out mxLines);
    }

    static void loadData(string fileName, out float[] destData) {
        uint8[] fileData = UtilityIO.readBinaryFileFromResource(GlobalVariables.resDir + fileName);
        destData = new float[fileData.length / 4];
        var j = 0;
        foreach (var index in UtilityList.range3(0, fileData.length, 4)) {
            var c = new uint8[]{fileData[index + 3], fileData[index + 2], fileData[index + 1], fileData[index]};
            var f = 0.0f;
            Posix.memcpy(&f, c, 4);
            destData[j] = f;
            j += 1;
        }
    }
}
