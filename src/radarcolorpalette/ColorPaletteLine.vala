// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

// represents the items in a single line of a colorpal file
// dbz r g b
class ColorPaletteLine {

    public int dbz;
    public int red;
    public int green;
    public int blue;

    public ColorPaletteLine(ArrayList<string> items) {
        dbz = Too.Int(items[1]);
        red = Too.Int(items[2]);
        green = Too.Int(items[3]);
        blue = Too.Int(items[4]);
    }

    public ColorPaletteLine.withDbzNoList(double dbz, string red, string green, string blue) {
        this.dbz = (int)dbz;
        this.red = Too.Int(red);
        this.green = Too.Int(green);
        this.blue = Too.Int(blue);
    }

    public ColorPaletteLine.withDbz(double dbz, ArrayList<string> items) {
        this.dbz = (int)dbz;
        red = Too.Int(items[2]);
        green = Too.Int(items[3]);
        blue = Too.Int(items[4]);
    }

    public ColorPaletteLine.fourBit(string[] items) {
        dbz = 0;
        red = Too.Int(items[0]);
        green = Too.Int(items[1]);
        blue = Too.Int(items[2]);
    }

    public int asInt() {
        return Color.rgb(red, green, blue);
    }
}
