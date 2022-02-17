// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class ButtonToggle {

    public delegate void delegate0();
    Gtk.ToggleButton button = new Gtk.ToggleButton();
    Gdk.Pixbuf pix;
    Photo image = new Photo.icon();
    int iconSize = 42;

    public ButtonToggle(Icon imageName, string label) {
        if (imageName != Icon.None) {
            pix = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, iconSize, iconSize);
            try {
                pix = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + IconMapping.toString(imageName));
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
            pix = pix.scale_simple(iconSize, iconSize, Gdk.InterpType.BILINEAR);
            image.setPix(pix);
            button.set_image(image.get()); //GTK4_DELETE
            /// button.set_child(image.get());
            button.set_tooltip_text(label);
        }
        if (label != "" && imageName == Icon.None) {
            button.set_label(label);
        }
    }

    public void connect(delegate0 fn) {
        button.clicked.connect(() => fn());
    }

    public void setText(string s) {
        button.set_label(s);
    }

    public Gtk.ToggleButton get() {
        return button;
    }

    public bool getActive() {
        return button.get_active();
    }

    public void setActive(bool b) {
        button.set_active(b);
    }
}
