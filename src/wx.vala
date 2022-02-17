// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class WXmain : Gtk.Application {

    public WXmain() {
        Object(application_id: "wx.joshuatee", flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate() {
        var win = new MainWindow(this);
        win.show_all(); //GTK4_DELETE
        /// win.show();
    }

    public static int main(string[] args) {
        MyApplication.onCreate();
        var program = new WXmain();
        return program.run(args);
    }
}
