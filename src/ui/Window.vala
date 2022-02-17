// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Window : Gtk.Window {

    /// Gtk.EventControllerKey controller = new Gtk.EventControllerKey();

    protected Window() {
        // controller = new Gtk.EventControllerKey(this); //GTK4_DELETE
        /// ((Gtk.Widget)this).add_controller(controller);
        /// controller.key_pressed.connect(window_key_pressed);
        try { //GTK4_DELETE
            this.icon = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + "wx_launcher.png"); //GTK4_DELETE
        } catch (Error e) { //GTK4_DELETE
            print("Error " + e.message + "\n"); //GTK4_DELETE
        } //GTK4_DELETE
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

    // GTK3
    protected override bool key_press_event(Gdk.EventKey event) { //GTK4_DELETE
        if (event.keyval == Gdk.Key.Escape) { //GTK4_DELETE
            processEscape(); //GTK4_DELETE
            close(); //GTK4_DELETE
            return true; //GTK4_DELETE
        } //GTK4_DELETE
        var default_modifiers = Gtk.accelerator_get_default_mod_mask(); //GTK4_DELETE
        if ((event.state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) { //GTK4_DELETE
            processKey(event.keyval); //GTK4_DELETE
        } //GTK4_DELETE
        return true; //GTK4_DELETE
    } //GTK4_DELETE

    ///  bool window_key_pressed(Gtk.EventControllerKey controller, uint keyval, uint keycode, Gdk.ModifierType state) {
    ///      if (keyval == Gdk.Key.Escape) {
    ///          processEscape();
    ///          close();
    ///          return true;
    ///      }
    ///      var default_modifiers = Gtk.accelerator_get_default_mod_mask();
    ///      if ((state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) {
    ///          processKey(keyval);
    ///      }
    ///      return true;
    ///  }

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
