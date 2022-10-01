// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Window : Gtk.Window {

    #if GTK4
    Gtk.EventControllerKey controller = new Gtk.EventControllerKey();
    #endif

    protected Window() {
        #if GTK4
        ((Gtk.Widget)this).add_controller(controller);
        controller.key_pressed.connect(window_key_pressed);
        #else
        // controller = new Gtk.EventControllerKey(this);
        try {
            this.icon = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + "wx_launcher.png");
        } catch (Error e) {
            print("Error " + e.message + "\n");
        }
        #endif
    }

    protected void setSize(int w, int h) {
        set_default_size(w, h);
    }

    protected void setTitle(string s) {
        set_title(s);
    }

    protected new void maximize() {
        UtilityUI.maximize(this);
    }

    #if GTK4
    bool window_key_pressed(Gtk.EventControllerKey controller, uint keyval, uint keycode, Gdk.ModifierType state) {
        if (keyval == Gdk.Key.Escape) {
            processEscape();
            close();
            return true;
        }
        var default_modifiers = Gtk.accelerator_get_default_mod_mask();
        if ((state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) {
            processKey(keyval);
        }
        return true;
    }
    #else
    // GTK3
    protected override bool key_press_event(Gdk.EventKey event) {
        if (event.keyval == Gdk.Key.Escape) {
            processEscape();
            close();
            return true;
        }
        var default_modifiers = Gtk.accelerator_get_default_mod_mask();
        if ((event.state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) {
            processKey(event.keyval);
        }
        return true;
    }
    #endif

    protected virtual void processEscape() {
    }

    protected virtual void processKey(uint keyval) {
        switch (keyval) {
            case Gdk.Key.w:
                close();
                break;
            default:
                break;
        }
    }
}
