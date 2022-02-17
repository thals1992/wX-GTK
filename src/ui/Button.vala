// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Button {

    public delegate void ConnectFnButton();
    public delegate void ConnectFnIntButton(int i);
    public delegate void ConnectFnStringButton(string s);
    int iconSize = 42;
    Gtk.Button button = new Gtk.Button();
    Photo image = new Photo.icon();
    Gdk.Pixbuf pix;
    unowned ConnectFnButton fn;
    unowned ConnectFnIntButton fnInt;
    unowned ConnectFnStringButton fnString;
    public int tag = 0;
    string tagString = "";

    public Button(Icon imageName, string label) {
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
            button.set_tooltip_text(label);
            /// button.set_child(image.get());
        }
        if (label != "" && imageName == Icon.None) {
            button.set_label(label);
        }
    }

    public void connect(ConnectFnButton fn) {
        this.fn = fn;
        button.clicked.connect(() => fn());
    }

    public void connectInt(ConnectFnIntButton fnInt, int tag) {
        this.fnInt = fnInt;
        this.tag = tag;
        button.clicked.connect(() => fnInt(this.tag));
    }

    public void connectString(ConnectFnStringButton fnString, string tagString) {
        this.fnString = fnString;
        this.tagString = tagString;
        button.clicked.connect(() => fnString(this.tagString));
    }

    public void setVisible(bool b) {
        button.visible = b;
    }

    public void setText(string s) {
        button.set_label(s);
    }

    public string getText() {
        return button.get_label();
    }

    public Gtk.Button get() {
        return button;
    }
}
