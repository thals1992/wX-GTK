// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class StatusBar {

    Gtk.Statusbar statusBar = new Gtk.Statusbar();

    public string text {
        set {
            uint messageId = statusBar.get_context_id(value);
            statusBar.push(messageId, value);
        }
    }

    public bool visible {
        set { statusBar.visible = value; }
    }

    public Gtk.Statusbar get() { return statusBar; }
}
