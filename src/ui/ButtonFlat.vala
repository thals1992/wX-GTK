// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ButtonFlat : Widget {

    int iconSize = 42;
    Gtk.Button button = new Gtk.Button();
    Photo image = new Photo.icon();

    public ButtonFlat(string imageName, string label) {
        #if GTK4
            button.set_has_frame(false);
        #else
            button.set_relief(Gtk.ReliefStyle.NONE);
        #endif

        if (imageName != "") {
            var pix = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, iconSize, iconSize);
            try {
                pix = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + imageName);
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
            button.set_tooltip_text(label);
            pix = pix.scale_simple(iconSize, iconSize, Gdk.InterpType.BILINEAR);
            image.setPix(pix);
            #if GTK4
                button.set_child(image.getView());
            #else
                button.set_image(image.getView());
            #endif
        }
        if (label != "" && imageName == "") {
            button.set_label(label);
        }
    }

    public void connect(FnVoid fn) {
        button.clicked.connect(() => fn());
    }

    public Gtk.Widget getView() { return button; }
}
