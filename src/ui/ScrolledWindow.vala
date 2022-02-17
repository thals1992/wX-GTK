// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ScrolledWindow {

    Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow(null, null);  //GTK4_DELETE
    /// private Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow();

    public ScrolledWindow(Gtk.Window win, VBox box) {
        /// swin.set_child(box.get());
        swin.add(box.get()); //GTK4_DELETE
        swin.set_margin_start(UIPreferences.swinMargin);
        swin.set_margin_end(UIPreferences.swinMargin);
        swin.set_margin_top(UIPreferences.swinMargin);
        swin.set_margin_bottom(UIPreferences.swinMargin);
        /// win.set_child(swin);
        win.add(swin);  //GTK4_DELETE
        win.show_all();  //GTK4_DELETE
        win.show();
    }
}
