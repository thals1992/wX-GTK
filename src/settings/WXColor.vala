// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class WXColor {

    public string uiLabel = "";
    string prefVar = "";
    int defaultRed = 0;
    int defaultGreen = 0;
    int defaultBlue = 0;
    int red = 0;
    int green = 0;
    int blue = 0;
    int defaultcolorAsInt = 0;
    int colorAsInt = 0;

    public WXColor(string uiLabel, string prefVar, int defaultRed, int defaultGreen, int defaultBlue) {
        this.uiLabel = uiLabel;
        this.prefVar = prefVar;
        this.defaultRed = defaultRed;
        this.defaultGreen = defaultGreen;
        this.defaultBlue = defaultBlue;
        defaultcolorAsInt = Color.rgb(defaultRed, defaultGreen, defaultBlue);
        colorAsInt = Utility.readPrefInt(prefVar, Color.rgb(defaultRed, defaultGreen, defaultBlue));
        red = Color.red(colorAsInt);
        green = Color.green(colorAsInt);
        blue = Color.blue(colorAsInt);
    }

    public static int colorsToInt(int red, int green, int blue) {
        int retVal = 0xFF << 24;
        retVal += (red << 16) + (green << 8) + blue;
        return retVal;
    }

    public Gdk.RGBA getRGBA() {
        var bgColor = Gdk.RGBA();
        bgColor.red = (double)red / 255.0; //GTK4_DELETE
        bgColor.green = (double)green / 255.0; //GTK4_DELETE
        bgColor.blue = (double)blue / 255.0; //GTK4_DELETE
        bgColor.alpha = 1.0; //GTK4_DELETE
        /// bgColor.red = (float)red / 255.0f;
        /// bgColor.green = (float)green / 255.0f;
        /// bgColor.blue = (float)blue / 255.0f;
        /// bgColor.alpha = 1.0f;
        return bgColor;
    }

    public void setValue(Gdk.RGBA newValue) {
        red = (int)(newValue.red * 255.0);
        green = (int)(newValue.green * 255.0);
        blue = (int)(newValue.blue * 255.0);
        colorAsInt = colorsToInt(red, green, blue);
        Utility.writePrefInt(prefVar, colorAsInt);
        RadarPreferences.initialize();
    }

    public void setDefault() {
        red = defaultRed;
        green = defaultGreen;
        blue = defaultBlue;
        colorAsInt = colorsToInt(red, green, blue);
        Utility.writePrefInt(prefVar, colorAsInt);
        RadarPreferences.initialize();
    }

    public float[] getRGBList() {
        var redF = red / 255.0f;
        var greenF = green / 255.0f;
        var blueF = blue / 255.0f;
        return {redF, greenF, blueF};
    }
}
