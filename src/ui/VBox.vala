// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class VBox {

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

    public void addLayout(Gtk.Widget w) {
        #if GTK4
            box.append(w);
        #else
            box.add(w);
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

    public void addWidgetCenter(Gtk.Widget w) {
        #if GTK4
            box.append(w);
        #else
            box.add(w);
            box.show_all();
        #endif
    }

    public void addWidgetAndCenter(Gtk.Widget w) {
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

    public void vExpand() {
        box.set_vexpand(true);
        box.set_valign(Gtk.Align.START);
    }

    public void hExpand() {
        box.set_hexpand(true);
        box.set_halign(Gtk.Align.FILL);
    }

    public void removeChildren() {
        UtilityUI.removeChildren(get());
    }

    public void addImageRows(ArrayList<string> urls, ArrayList<Image> images, int imagesAcross) {
        foreach (var index in range(urls.size)) {
            images.add(new Image.withIndex(index));
            if ((boxRows.size <= (int)(index / imagesAcross))) {
                boxRows.add(new HBox());
            }
            boxRows.last().addWidget(images.last().get());
        }
        foreach (var b in boxRows) {
            #if GTK4
                box.append(b.get());
            #else
                box.add(b.get());
            #endif
        }
    }

    // Qt no-op
    public void addStretch() {
    }

    public Gtk.Box get() { return box; }
}
