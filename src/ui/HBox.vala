// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class HBox : Box {

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

    public void addLayout(Box widget) {
        #if GTK4
            box.append(widget.getView());
        #else
            box.add(widget.getView());
            box.show_all();
        #endif
    }

    public void addWidgetFirst(Widget widget) {
        #if GTK4
            box.append(widget.getView());
            box.reorder_child_after(widget.getView(), null);
        #else
            box.add(widget.getView());
            box.reorder_child(widget.getView(), 0);
            box.show_all();
        #endif
    }

    public void addWidgetReal(Gtk.Widget widget) {
        #if GTK4
            box.append(widget);
        #else
            box.add(widget);
            box.show_all();
        #endif
    }

    public void addWidget(Widget widget) {
        #if GTK4
            box.append(widget.getView());
        #else
            box.add(widget.getView());
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
        UtilityUI.removeChildren(getView());
    }

    public void addImageRow(string[] urls, ArrayList<Image> images) {
        foreach (var index in range(urls.length)) {
            images.add(new Image.withIndex(index));
            addWidget(images.last());
        }
    }

    //  public Gtk.Box get() { return box; }

    public Gtk.Box getView() { return box; }
}
