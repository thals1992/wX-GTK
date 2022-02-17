// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Table {

    Gtk.Grid grid = new Gtk.Grid();
    int rowNum = 0;

    public Table() {
        grid.set_column_spacing(5);
        grid.set_row_spacing(5);
    }

    public void addRow(string label, Gtk.Widget w) {
        var text = new Text();
        text.setText(label);
        grid.attach(text.get(), 0, rowNum, 1, 1);
        grid.attach(w, 1, rowNum, 1, 1);
        rowNum += 1;
    }

    public Gtk.Grid get() {
        return grid;
    }
}
