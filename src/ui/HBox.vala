// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class HBox {

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);

    public void getAndShow(Gtk.Window w) {
        #if GTK4
            w.set_child(box);
        #else
            w.add(box);
            w.show_all();
        #endif
        w.show();
    }

    public void addLayout(Gtk.Widget w) {
        #if GTK4
            box.append(w);
        #else
            box.add(w);
            box.show_all();
        #endif
    }

    public void addWidgetFirst(Gtk.Widget w) {
        #if GTK4
            box.append(w);
            box.reorder_child_after(w, null);
        #else
            box.add(w);
            box.reorder_child(w, 0);
            box.show_all();
        #endif
    }

    public void addWidget(Gtk.Widget w) {
        #if GTK4
            box.append(w);
        #else
            box.add(w);
            box.show_all();
        #endif
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
        foreach (var index in range(urls.length)) {
            images.add(new Image.withIndex(index));
            addWidget(images.last().get());
        }
    }

    public Gtk.Box get() { return box; }
}
