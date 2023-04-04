// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Button : Widget {

    int iconSize = 42;
    Gtk.Button button = new Gtk.Button();
    Photo image = new Photo.icon();
    unowned FnVoid fn;
    unowned FnInt fnInt;
    unowned FnString fnString;
    public int tag = 0;
    string tagString = "";

    public Button(Icon imageName, string label) {
        if (imageName != Icon.None) {
            var pix = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, iconSize, iconSize);
            try {
                pix = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + IconMapping.toString(imageName));
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
            pix = pix.scale_simple(iconSize, iconSize, Gdk.InterpType.BILINEAR);
            image.setPix(pix);
            button.set_tooltip_text(label);
            #if GTK4
                button.set_child(image.getView());
            #else
                button.set_image(image.getView());
            #endif
        }
        if (label != "" && imageName == Icon.None) {
            button.set_label(label);
        }
    }

    public void connect(FnVoid fn) {
        this.fn = fn;
        button.clicked.connect(() => fn());
    }

    public void connectInt(FnInt fnInt, int tag) {
        this.fnInt = fnInt;
        this.tag = tag;
        button.clicked.connect(() => fnInt(this.tag));
    }

    public void connectString(FnString fnString, string tagString) {
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

    public string getText() { return button.get_label(); }

    //  public Gtk.Widget get() { return button; }

    public Gtk.Widget getView() { return button; }
}
