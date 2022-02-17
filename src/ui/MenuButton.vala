// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class MenuButton {

    int iconSize = 42;
    Gtk.MenuButton button = new Gtk.MenuButton();
    Photo image = new Photo.icon();
    Gdk.Pixbuf pix;

    public MenuButton(string imageName, string label) {
        if (imageName != "") {
            pix = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, iconSize, iconSize);
            try {
                pix = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + imageName);
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
            pix = pix.scale_simple(iconSize, iconSize, Gdk.InterpType.BILINEAR);
            image.setPix(pix);
            button.set_image(image.get()); //GTK4_DELETE
            /// // button.set_child(image.get()); // GTK 4.6+
            /// button.set_label(label);
            button.set_tooltip_text(label);
        }
        if (label != "" && imageName == "") {
            button.set_label(label);
        }
    }

    public void setPopover(Gtk.Popover p) {
        button.set_popover(p);
    }

    public Gtk.MenuButton get() {
        return button;
    }
}
