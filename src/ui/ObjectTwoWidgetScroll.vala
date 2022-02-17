// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectTwoWidgetScroll {

    Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow(null, null);  //GTK4_DELETE
    /// Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow();
    VBox vbox0 = new VBox();
    VBox vbox1 = new VBox();
    HBox hbox = new HBox();

    public ObjectTwoWidgetScroll(Gtk.Window win, Gtk.Widget w1, Gtk.Widget w2) {
        vbox0.addWidget(w1);
        vbox1.addWidget(w2);
        hbox.addLayout(vbox0.get());
        hbox.addLayout(vbox1.get());
        /// swin.set_child(hbox.get());
        swin.add(hbox.get());   //GTK4_DELETE
        swin.set_margin_start(UIPreferences.swinMargin);
        swin.set_margin_end(UIPreferences.swinMargin);
        swin.set_margin_top(UIPreferences.swinMargin);
        swin.set_margin_bottom(UIPreferences.swinMargin);
        /// win.set_child(swin);
        /// win.show();
        win.add(swin);  //GTK4_DELETE
        win.show_all();  //GTK4_DELETE
    }
}
