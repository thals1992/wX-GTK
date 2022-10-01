// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityUI {

    public static void maximize(Gtk.Window win) {
        var bounds = getScreenBounds();
        #if GTK4
            win.set_size_request(bounds[0], bounds[1] - 100);
        #else
            //  win.set_default_size(bounds[0], bounds[1] - 100);
            win.set_default_size(bounds[0], bounds[1]);
        #endif
    }

    public static int[] getScreenBounds() {
        var display = Gdk.Display.get_default();
        #if GTK4
            var firstMonitor = display.get_monitors().get_object(0) as Gdk.Monitor;
        #else
            Gdk.Monitor firstMonitor = display.get_monitor(0);
        #endif
        Gdk.Rectangle rect = firstMonitor.geometry;
        // Gdk.Rectangle rect = firstMonitor.workarea;
        return {rect.width, rect.height};
    }

    public static int getImageWidth(int numberOfImages) {
        var dim = getScreenBounds();
        return (int)(dim[0] / (double)numberOfImages) - 10;
    }

    public static void removeChildren(Gtk.Box c) {
        #if GTK4
            Gtk.Widget w;
            w = c.get_first_child();
            while (w != null) {
                c.remove(w);
            w = c.get_first_child();
            }
        #else
            foreach (Gtk.Widget element in c.get_children()) {
                c.remove(element);
            }
        #endif
    }

    public static bool isScreenSmall() {
        var dimens = getScreenBounds();
        if (dimens[0] > 1800) {
            return false;
        }
        return true;
    }
}
