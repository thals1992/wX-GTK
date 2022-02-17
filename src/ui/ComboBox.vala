// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class ComboBox {

    public delegate void ComboBoxFunction();
    string[] items;
    Gtk.ComboBoxText cb = new Gtk.ComboBoxText(); //GTK4_DELETE
    /// Gtk.DropDown cb;
    ulong conn = 0;

    public ComboBox(string[] items) {
        if (items != null) { //GTK4_DELETE
            this.items = items; //GTK4_DELETE
            foreach (var s in items) { //GTK4_DELETE
                cb.append_text(s); //GTK4_DELETE
            } //GTK4_DELETE
        } //GTK4_DELETE
        cb.set_margin_start(5); //GTK4_DELETE
        cb.set_margin_end(5); //GTK4_DELETE
        /// this.items = items;
        /// cb = new Gtk.DropDown.from_strings(this.items);
        /// cb.enable_search = true;
    }

    public ComboBox.empty() {
        this.items = {}; //GTK4_DELETE
        foreach (var s in items) { //GTK4_DELETE
            cb.append_text(s); //GTK4_DELETE
        } //GTK4_DELETE
        cb.set_margin_start(5); //GTK4_DELETE
        cb.set_margin_end(5); //GTK4_DELETE
        /// this.items = new string[]{};
        /// cb = new Gtk.DropDown.from_strings(this.items);
        /// cb.enable_search = true;
    }

    public ComboBox.fromList(ArrayList<string> items) {
        this.items = UtilityList.listToArray(items);
        foreach (var s in this.items) { //GTK4_DELETE
            cb.append_text(s); //GTK4_DELETE
        } //GTK4_DELETE
        cb.set_margin_start(5); //GTK4_DELETE
        cb.set_margin_end(5); //GTK4_DELETE
        /// cb = new Gtk.DropDown.from_strings(this.items);
        /// cb.enable_search = true;
    }

    public void setList(string[] items) {
        this.items = items;
        removeAll(); //GTK4_DELETE
        foreach (var s in items) { //GTK4_DELETE
            cb.append_text(s); //GTK4_DELETE
        } //GTK4_DELETE
        /// cb.model = new Gtk.StringList(items);
    }

    public void setArrayList(ArrayList<string> items) {
        this.items = UtilityList.listToArray(items);
        removeAll(); //GTK4_DELETE
        foreach (var s in items) { //GTK4_DELETE
            cb.append_text(s); //GTK4_DELETE
        } //GTK4_DELETE
        /// cb.model = new Gtk.StringList(UtilityList.listToArray(items));
    }

    public void connect(ComboBoxFunction fn) {
        conn = cb.changed.connect((c) => fn()); //GTK4_DELETE
        /// conn = cb.notify["selected-item"].connect((c) => fn());
    }

    public void setIndexByPref(string s, int i) {
        setIndex(Utility.readPrefInt(s, i));
    }

    public void setIndex(int i) {
        cb.set_active(i); //GTK4_DELETE
        /// cb.set_selected(i);
    }

    public void block() {
        GLib.SignalHandler.block(cb, conn);
    }

    public void unblock() {
        GLib.SignalHandler.unblock(cb, conn);
    }

    void removeAll() { //GTK4_DELETE
        cb.remove_all(); //GTK4_DELETE
    } //GTK4_DELETE

    public int getIndex() {
        return cb.get_active(); //GTK4_DELETE
        /// int i = (int)cb.get_selected();
        /// return i;
    }

    public string getValue() {
        return cb.get_active_text(); //GTK4_DELETE
        /// string s = items[getIndex()];
        /// return s;
    }

    public void setIndexByValue(string value) {
        setIndex(UtilityList.findex(value, items));
    }

    /// public Gtk.DropDown get() {
    public Gtk.ComboBox get() { //GTK4_DELETE
        return cb;
    }
}
