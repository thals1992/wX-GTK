// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class RadarGeomInfo {

    RadarGeometryTypeEnum type;
    public float[] lineData;
    //  public ArrayList<uint8> colorData;
    public int colorInt;
    public bool isEnabled;
    double lineSizeDefault = 10.0;
    public double lineSize;
    double lineFactor = 10.0;

    static HashMap<RadarGeometryTypeEnum, string> typeToFileName;
    static HashMap<RadarGeometryTypeEnum, string> prefToken;
    static HashMap<RadarGeometryTypeEnum, string> defaultPref;
    static HashMap<RadarGeometryTypeEnum, string> prefTokenLineSize;
    static HashMap<RadarGeometryTypeEnum, string> prefTokenColorInt;
    static HashMap<RadarGeometryTypeEnum, int> prefTokenColorIntDefault;

    public RadarGeomInfo(RadarGeometryTypeEnum type) {
        this.type = type;
        isEnabled = Utility.readPref(prefToken[type], defaultPref[type]).has_prefix("t");
        if (isEnabled) {
            loadData(typeToFileName[type], out lineData);
        } else {
            //  lineData.clear();
        }
        colorInt = Utility.readPrefInt(prefTokenColorInt[type], prefTokenColorIntDefault[type]);
        lineSize = Utility.readPrefInt(prefTokenLineSize[type], (int)lineSizeDefault) / lineFactor;
    }

    public void update() {
        isEnabled = Utility.readPref(prefToken[type], defaultPref[type]).has_prefix("t");
        if (isEnabled) {
            loadData(typeToFileName[type], out lineData);
        } else {
            //  lineData.clear();
        }
        colorInt = Utility.readPrefInt(prefTokenColorInt[type], prefTokenColorIntDefault[type]);
        lineSize = Utility.readPrefInt(prefTokenLineSize[type], (int)lineSizeDefault) / lineFactor;
    }

    static void loadData(string fileName, out float[] destData) {
        var fileData = UtilityIO.readBinaryFileFromResource(GlobalVariables.resDir + fileName);
        destData = new float[fileData.length / 4];
        var j = 0;
        foreach (var index in range3(0, fileData.length, 4)) {
            var c = new uint8[]{fileData[index + 3], fileData[index + 2], fileData[index + 1], fileData[index]};
            //  var f = 0.0f;
            Posix.memcpy(&destData[j], c, 4);
            //  destData[j] = f;
            j += 1;
        }
    }

    public static void initStatic() {
        typeToFileName = new HashMap<RadarGeometryTypeEnum, string>();
        prefToken = new HashMap<RadarGeometryTypeEnum, string>();
        defaultPref = new HashMap<RadarGeometryTypeEnum, string>();
        prefTokenLineSize = new HashMap<RadarGeometryTypeEnum, string>();
        prefTokenColorInt = new HashMap<RadarGeometryTypeEnum, string>();
        prefTokenColorIntDefault = new HashMap<RadarGeometryTypeEnum, int>();

        typeToFileName[RadarGeometryTypeEnum.StateLines] = "statev2.bin";
        typeToFileName[RadarGeometryTypeEnum.CountyLines] = "county.bin";
        typeToFileName[RadarGeometryTypeEnum.HwLines] = "hwv4.bin";
        typeToFileName[RadarGeometryTypeEnum.HwExtLines] = "hwv4ext.bin";
        typeToFileName[RadarGeometryTypeEnum.LakeLines] = "lakesv3.bin";
        typeToFileName[RadarGeometryTypeEnum.CaLines] = "ca.bin";
        typeToFileName[RadarGeometryTypeEnum.MxLines] = "mx.bin";

        prefToken[RadarGeometryTypeEnum.StateLines] = "RADAR_SHOW_STATELINES";
        prefToken[RadarGeometryTypeEnum.CountyLines] = "RADAR_SHOW_COUNTY";
        prefToken[RadarGeometryTypeEnum.HwLines] = "COD_HW_DEFAULT";
        prefToken[RadarGeometryTypeEnum.HwExtLines] = "RADAR_HW_ENH_EXT";
        prefToken[RadarGeometryTypeEnum.LakeLines] = "COD_LAKES_DEFAULT";
        prefToken[RadarGeometryTypeEnum.CaLines] = "RADARCANADALINES";
        prefToken[RadarGeometryTypeEnum.MxLines] = "RADARMEXICOLINES";

        defaultPref[RadarGeometryTypeEnum.StateLines] = "true";
        defaultPref[RadarGeometryTypeEnum.CountyLines] = "true";
        defaultPref[RadarGeometryTypeEnum.HwLines] = "false";
        defaultPref[RadarGeometryTypeEnum.HwExtLines] = "false";
        defaultPref[RadarGeometryTypeEnum.LakeLines] = "false";
        defaultPref[RadarGeometryTypeEnum.CaLines] = "false";
        defaultPref[RadarGeometryTypeEnum.MxLines] = "false";

        prefTokenLineSize[RadarGeometryTypeEnum.StateLines] = "RADAR_STATE_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.CountyLines] = "RADAR_COUNTY_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.HwLines] = "RADAR_HW_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.HwExtLines] = "RADAR_HWEXT_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.LakeLines] = "RADAR_LAKE_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.CaLines] = "RADAR_STATE_LINESIZE";
        prefTokenLineSize[RadarGeometryTypeEnum.MxLines] = "RADAR_STATE_LINESIZE";

        prefTokenColorInt[RadarGeometryTypeEnum.StateLines] = "RADAR_COLOR_STATE";
        prefTokenColorInt[RadarGeometryTypeEnum.CountyLines] = "RADAR_COLOR_COUNTY";
        prefTokenColorInt[RadarGeometryTypeEnum.HwLines] = "RADAR_COLOR_HW";
        prefTokenColorInt[RadarGeometryTypeEnum.HwExtLines] = "RADAR_COLOR_HW_EXT";
        prefTokenColorInt[RadarGeometryTypeEnum.LakeLines] = "RADAR_COLOR_LAKES";
        prefTokenColorInt[RadarGeometryTypeEnum.CaLines] = "RADAR_COLOR_STATE";
        prefTokenColorInt[RadarGeometryTypeEnum.MxLines] = "RADAR_COLOR_STATE";

        prefTokenColorIntDefault[RadarGeometryTypeEnum.StateLines] = Color.rgb(255, 255, 255);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.CountyLines] = Color.rgb(75, 75, 75);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.HwLines] = Color.rgb(135, 135, 135);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.HwExtLines] = Color.rgb(91, 91, 91);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.LakeLines] = Color.rgb(0, 0, 255);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.CaLines] = Color.rgb(255, 255, 255);
        prefTokenColorIntDefault[RadarGeometryTypeEnum.MxLines] = Color.rgb(255, 255, 255);
    }
}
