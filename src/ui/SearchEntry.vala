// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class SearchEntry {

    public delegate void delegate0();
    Gtk.SearchEntry entry = new Gtk.SearchEntry();

    public void setText(string s) {
        entry.text = s;
    }

    public string getText() {
        return entry.text;
    }

    public void connect(delegate0 fn) {
        entry.changed.connect(() => fn());
    }

    public Gtk.SearchEntry get() {
        return entry;
    }
}
