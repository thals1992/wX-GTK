// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class ComboBox {

    string[] items;
    #if GTK4
        Gtk.DropDown cb;
    #else
        Gtk.ComboBoxText cb = new Gtk.ComboBoxText();
    #endif
    ulong conn = 0;

    public ComboBox(string[] items) {
        #if GTK4
            this.items = items;
            cb = new Gtk.DropDown.from_strings(this.items);
            cb.enable_search = true;
        #else
            if (items != null) {
                this.items = items;
                foreach (var s in items) {
                    cb.append_text(s);
                }
            }
            cb.set_margin_start(5);
            cb.set_margin_end(5);
        #endif
    }

    public ComboBox.empty() {
        #if GTK4
            this.items = new string[]{};
            cb = new Gtk.DropDown.from_strings(this.items);
            cb.enable_search = true;
        #else
            this.items = {};
            foreach (var s in items) {
                cb.append_text(s);
            }
            cb.set_margin_start(5);
            cb.set_margin_end(5);
        #endif
    }

    public ComboBox.fromList(ArrayList<string> items) {
        this.items = items.to_array();
        #if GTK4
            cb = new Gtk.DropDown.from_strings(items.to_array().copy());
            cb.enable_search = true;
        #else
            foreach (var s in this.items) {
                cb.append_text(s);
            }
            cb.set_margin_start(5);
            cb.set_margin_end(5);
        #endif
    }

    public void setList(string[] items) {
        this.items = items;
        #if GTK4
            cb.model = new Gtk.StringList(items.copy());
        #else
            removeAll();
            foreach (var s in items) {
                cb.append_text(s);
            }
        #endif
    }

    public void setArrayList(ArrayList<string> items) {
        this.items = items.to_array();
        #if GTK4
            cb.model = new Gtk.StringList(items.to_array().copy());
        #else
            removeAll();
            foreach (var s in items) {
                cb.append_text(s);
            }
        #endif
    }

    public void connect(FnVoid fn) {
        #if GTK4
            conn = cb.notify["selected-item"].connect((c) => fn());
        #else
            conn = cb.changed.connect((c) => fn());
        #endif
    }

    public void setIndexByPref(string s, int i) {
        setIndex(Utility.readPrefInt(s, i));
    }

    public void setIndex(int i) {
        #if GTK4
            cb.set_selected(i);
        #else
            cb.set_active(i);
        #endif
    }

    public void block() {
        GLib.SignalHandler.block(cb, conn);
    }

    public void unblock() {
        GLib.SignalHandler.unblock(cb, conn);
    }

    #if GTK4
    #else
        void removeAll() {
            cb.remove_all();
        }
    #endif

    public int getIndex() {
        #if GTK4
            int i = (int)cb.get_selected();
            return i;
        #else
            return cb.get_active();
        #endif
    }

    public string getValue() {
        #if GTK4
            string s = items[getIndex()];
            return s;
        #else
            return cb.get_active_text();
        #endif
    }

    public void setIndexByValue(string value) {
        setIndex(findex(value, items));
    }

    #if GTK4
        public Gtk.DropDown get() {
    #else
        public Gtk.ComboBox get() {
    #endif
            return cb;
        }
}
