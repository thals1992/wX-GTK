// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class TwoWidgetScroll {

    #if GTK4
        Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow();
    #else
        Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow(null, null);
    #endif
    VBox vbox0 = new VBox();
    VBox vbox1 = new VBox();
    HBox hbox = new HBox();

    public TwoWidgetScroll(Gtk.Window win, Gtk.Widget w1, Gtk.Widget w2) {
        vbox0.addWidgetReal(w1);
        vbox1.addWidgetReal(w2);
        hbox.addLayout(vbox0);
        hbox.addLayout(vbox1);
        #if GTK4
            swin.set_child(hbox.getView());
        #else
            swin.add(hbox.getView());
        #endif
        swin.set_margin_start(UIPreferences.swinMargin);
        swin.set_margin_end(UIPreferences.swinMargin);
        swin.set_margin_top(UIPreferences.swinMargin);
        swin.set_margin_bottom(UIPreferences.swinMargin);
        #if GTK4
            win.set_child(swin);
            win.show();
        #else
            win.add(swin);
            win.show_all();
        #endif
    }
}
