// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class SearchEntry {

    Gtk.SearchEntry entry = new Gtk.SearchEntry();

    public string text {
        get { return entry.text; }
        set { entry.text = value; }
    }

    public void connect(FnVoid fn) {
        entry.changed.connect(() => fn());
    }

    public Gtk.SearchEntry get() { return entry; }
}
