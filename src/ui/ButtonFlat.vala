// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ButtonFlat {

    public delegate void ConnectFnButtonFlat();
    int iconSize = 42;
    Gtk.Button button = new Gtk.Button();
    Photo image = new Photo.icon();
    Gdk.Pixbuf pix;

    public ButtonFlat(string imageName, string label) {
        button.set_relief(Gtk.ReliefStyle.NONE); //GTK4_DELETE
        /// button.set_has_frame(false);
        if (imageName != "") {
            pix = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, iconSize, iconSize);
            try {
                pix = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + imageName);
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
            button.set_tooltip_text(label);
            pix = pix.scale_simple(iconSize, iconSize, Gdk.InterpType.BILINEAR);
            image.setPix(pix);
            button.set_image(image.get()); //GTK4_DELETE
            /// button.set_child(image.get());
        }
        if (label != "" && imageName == "") {
            button.set_label(label);
        }
    }

    public void connect(ConnectFnButtonFlat fn) {
        button.clicked.connect(() => fn());
    }

    public Gtk.Widget get() {
        return button;
    }
}
