// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class DividerLine : Widget {

    Gtk.Separator separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);

    public Gtk.Widget getView() { return separator; }
}
