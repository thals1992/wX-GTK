// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class VBox {

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
    ArrayList<HBox> boxRows = new ArrayList<HBox>();

    public Gtk.Box get() {
        return box;
    }

    public void getAndShow(Gtk.Window w) {
        /// w.set_child(box);
        w.add(box); //GTK4_DELETE
        w.show_all(); //GTK4_DELETE
        w.show();
    }

    public void addLayout(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void addWidget(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void addWidgetCenter(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void addWidgetAndCenter(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void setSpacing(int o) {
        box.set_spacing(o);
    }

    public void removeChildren() {
        UtilityUI.removeChildren(get());
    }

    public void addImageRows(ArrayList<string> urls, ArrayList<Image> images, int imagesAcross) {
        foreach (var index in UtilityList.range(urls.size)) {
            images.add(new Image.withIndex(index));
            if ((boxRows.size <= (int)(index / imagesAcross))) {
                boxRows.add(new HBox());
            }
            boxRows.last().addWidget(images.last().get());
        }
        foreach (var b in boxRows) {
            /// box.append(b.get());
            box.add(b.get());  //GTK4_DELETE
        }
    }

    // Qt no-op
    public void addStretch() {
    }
}
