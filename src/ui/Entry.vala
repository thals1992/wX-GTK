// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Entry {

    Gtk.Entry entry = new Gtk.Entry();

    public void connect(FnVoid fn) {
        //  entry.set_focusable(true);
        entry.changed.connect(() => fn());
    }

    public string text {
        get { return entry.text; }
        set { entry.text = value; }
    }

    public Gtk.Entry get() { return entry; }
}
