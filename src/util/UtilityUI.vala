// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityUI {

    public static void maximize(Gtk.Window win) {
        var bounds = getScreenBounds();
        //  win.set_default_size(bounds[0], bounds[1] - 100); //GTK4_DELETE
        win.set_default_size(bounds[0], bounds[1]); //GTK4_DELETE
        /// win.set_size_request(bounds[0], bounds[1] - 100);
    }

    public static int[] getScreenBounds() {
        var display = Gdk.Display.get_default();
        Gdk.Monitor firstMonitor = display.get_monitor(0);  //GTK4_DELETE
        /// var firstMonitor = display.get_monitors().get_object(0) as Gdk.Monitor;
        Gdk.Rectangle rect = firstMonitor.geometry;
        // Gdk.Rectangle rect = firstMonitor.workarea;
        var width = rect.width;
        var height = rect.height;
        return {width, height};
    }

    public static int getImageWidth(int numberOfImages) {
        var dim = getScreenBounds();
        return (int)(dim[0] / (double)numberOfImages) - 10;
    }

    public static void removeChildren(Gtk.Box c) {
        foreach (Gtk.Widget element in c.get_children()) { //GTK4_DELETE
            c.remove(element); //GTK4_DELETE
        } //GTK4_DELETE
        /// Gtk.Widget w;
        /// w = c.get_first_child();
        /// while (w != null) {
        ///     c.remove(w);
        /// w = c.get_first_child();
        /// }
    }

    public static bool isScreenSmall() {
        var dimens = getScreenBounds();
        if (dimens[0] > 1800) {
            return false;
        }
        return true;
    }
}
