// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class VBox : Box {

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
    ArrayList<HBox> boxRows = new ArrayList<HBox>();

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

    public void addWidgetAndCenter1(Widget widget) {
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

    public void vExpand() {
        box.set_vexpand(true);
        box.set_valign(Gtk.Align.START);
    }

    public void hExpand() {
        box.set_hexpand(true);
        box.set_halign(Gtk.Align.FILL);
    }

    public void removeChildren() {
        UtilityUI.removeChildren(getView());
    }

    public void addImageRows(ArrayList<string> urls, ArrayList<Image> images, int imagesAcross) {
        foreach (var index in range(urls.size)) {
            images.add(new Image.withIndex(index));
            if ((boxRows.size <= (int)(index / imagesAcross))) {
                boxRows.add(new HBox());
            }
            boxRows.last().addWidget(images.last());
        }
        foreach (var b in boxRows) {
            #if GTK4
                box.append(b.getView());
            #else
                box.add(b.getView());
            #endif
        }
    }

    // Qt no-op
    public void addStretch() {
    }

    public Gtk.Box getView() { return box; }
}
