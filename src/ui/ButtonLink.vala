// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class ButtonLink : Widget {

    Gtk.LinkButton button;

    public ButtonLink(string url, string label) {
        button = new Gtk.LinkButton.with_label(url, label);
        button.set_halign(Gtk.Align.START);
    }

    public Gtk.Widget getView() { return button; }
}
