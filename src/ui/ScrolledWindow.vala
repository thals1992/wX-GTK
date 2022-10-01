// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ScrolledWindow {

    #if GTK4
        Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow();
    #else
        Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow(null, null);
    #endif

    public ScrolledWindow(Gtk.Window win, VBox box) {
        #if GTK4
            swin.set_child(box.get());
        #else
            swin.add(box.get()); //GTK4_DELETE
        #endif
        swin.set_margin_start(UIPreferences.swinMargin);
        swin.set_margin_end(UIPreferences.swinMargin);
        swin.set_margin_top(UIPreferences.swinMargin);
        swin.set_margin_bottom(UIPreferences.swinMargin);
        #if GTK4
            win.set_child(swin);
        #else
            win.add(swin);
            win.show_all();
        #endif
        win.show();
    }
}
