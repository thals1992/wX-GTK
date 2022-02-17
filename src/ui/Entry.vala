// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Entry {

    public delegate void ConnectFn();
    Gtk.Entry entry = new Gtk.Entry();

    public void connect(ConnectFn fn) {
        entry.changed.connect(() => fn());
    }

    public void setText(string s) {
        entry.set_text(s);
    }

    public string getText() {
        return entry.get_text();
    }

    public Gtk.Entry get() {
        return entry;
    }
}
