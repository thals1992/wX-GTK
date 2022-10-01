// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Too {

    public static double Double(string s) {
        var d = double.parse(s);
        return d;
    }

    public static int Int(string s) {
        var d = int.parse(s);
        return d;
    }

    public static string String(int i) {
        var s = i.to_string();
        return s;
    }

    public static string StringFromD(double i) {
        var s = i.to_string();
        return s;
    }

    // TODO FIXME use above or below only, check other ports
    public static string StringD(double i) {
        var s = i.to_string();
        return s;
    }

    public static string StringF(float i) {
        var s = i.to_string();
        return s;
    }

    public static string StringPadLeft(string s, int padAmount) {
        return ("%-" + Too.String(padAmount) + "s").printf(s);
    }

    public static string StringPadLeftZerosString(string s, int padAmount) {
        return ("%0" + Too.String(padAmount) + "d").printf(Too.Int(s));
    }

    public static string StringPadLeftZeros(int i, int padAmount) {
        return ("%0" + Too.String(padAmount) + "d").printf(i);
    }

    public static string printf(double d, string format) {
        return format.printf(d);
    }
}
