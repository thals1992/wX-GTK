// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class HBox {

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);

    public Gtk.Box get() {
        return box;
    }

    public void getAndShow(Gtk.Window w) {
        /// w.set_child(box);
        w.add(box);  //GTK4_DELETE
        w.show_all();  //GTK4_DELETE
        w.show();
    }

    public void addLayout(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void addWidgetFirst(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.reorder_child(w, 0); //GTK4_DELETE
        /// box.reorder_child_after(w, null);
        box.show_all(); //GTK4_DELETE
    }

    public void addWidget(Gtk.Widget w) {
        /// box.append(w);
        box.add(w); //GTK4_DELETE
        box.show_all(); //GTK4_DELETE
    }

    public void setSpacing(int o) {
        box.set_spacing(o);
    }

    public void setHExpand(bool o) {
        box.set_hexpand(o);
    }

    public void setVExpand(bool o) {
        box.set_vexpand(o);
    }

    public void removeChildren() {
        UtilityUI.removeChildren(get());
    }

    public void addImageRow(string[] urls, ArrayList<Image> images) {
        foreach (var index in UtilityList.range(urls.length)) {
            images.add(new Image.withIndex(index));
            addWidget(images.last().get());
        }
    }
}
