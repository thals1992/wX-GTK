// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class StatusBar {

    Gtk.Statusbar statusBar = new Gtk.Statusbar();

    public void setText(string t) {
        uint messageId = statusBar.get_context_id(t);
        statusBar.push(messageId, t);
    }

    public void setVisible(bool b) {
        statusBar.visible = b;
    }

    public Gtk.Statusbar get() {
        return statusBar;
    }
}
