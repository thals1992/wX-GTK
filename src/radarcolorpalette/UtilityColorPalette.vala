// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityColorPalette {

    public static string getColorMapStringFromDisk(int product, string code) {
        var cmFileInt = "";
        var text = "";
        switch (product) {
            case 94:
                cmFileInt = "colormapref" + code.ascii_down() + ".txt";
                break;
            case 99:
                cmFileInt = "colormapbv" + code.ascii_down() + ".txt";
                if (code == "CODENH") {
                    cmFileInt = "colormapbvcod.txt";
                }
                break;
            case 135:
                cmFileInt = "colormap135cod.txt";
                break;
            case 155:
                cmFileInt = "colormap155cod.txt";
                break;
            case 161:
                cmFileInt = "colormap161cod.txt";
                break;
            case 163:
                cmFileInt = "colormap163cod.txt";
                break;
            case 159:
                cmFileInt = "colormap159cod.txt";
                break;
            case 134:
                cmFileInt = "colormap134cod.txt";
                break;
            case 165:
                cmFileInt = "colormap165cod.txt";
                break;
            case 172:
                cmFileInt = "colormap172cod.txt";
                break;
            case 56:
                cmFileInt = "colormap56.txt";
                break;
            case 19:
                cmFileInt = "colormap19.txt";
                break;
            case 30:
                cmFileInt = "colormap30.txt";
                break;
            case 41:
                cmFileInt = "colormap41.txt";
                break;
            default:
                break;
        }
        if (text != "") {
            //return text;
        } else {}
        return UtilityIO.readTextFileFromResource(GlobalVariables.resDir + cmFileInt);
    }
}
