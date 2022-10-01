// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

// Generic
public delegate void FnVoid();
public delegate void FnString(string s);
public delegate void FnInt(int i);

// Nexrad
public delegate void FnProduct(string s, int i);
public delegate void FnZoom(double d, int i);
public delegate void FnPosition(double d, double d1, int i);
public delegate void FnMasterDownload();
public delegate void FnSyncRadarSite(string s, int i, bool b);

public class WXmain : Gtk.Application {

    public WXmain() {
        Object(application_id: "wx.joshuatee", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate() {
        var win = new MainWindow(this);
        #if GTK4
            win.show();
        #else
            win.show_all();
        #endif
    }

    public static int main(string[] args) {
        MyApplication.onCreate();
        var program = new WXmain();
        return program.run(args);
    }
}
