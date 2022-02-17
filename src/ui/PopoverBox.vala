// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class PopoverBox {

    public delegate void ConnectFn();
    unowned ConnectFn fnAction;
    unowned ConnectFn fnShow;
    Gtk.Popover popover;
    MenuButton button;

    public PopoverBox(string imageName, string buttonLabel, SettingsNotebook vbox, ConnectFn fnAction) {
        this.fnAction = fnAction;
        button = new MenuButton(imageName, buttonLabel);
        popover = new Gtk.Popover(button.get()); //GTK4_DELETE
        /// popover = new Gtk.Popover();
        popover.closed.connect(() => this.fnAction());
        popover.add(vbox.get()); //GTK4_DELETE
        button.setPopover(popover);
        /// popover.set_child(vbox.get());
        popover.set_position(Gtk.PositionType.BOTTOM);
    }

    public void popup() {
        popover.popup();
    }

    public void connect(ConnectFn fnShow) {
        this.fnShow = fnShow;
        popover.show.connect(() => fnShow());
    }

    public void connectClosed(ConnectFn fnShow) {
        popover.closed.connect(() => fnShow());
    }

    public Gtk.MenuButton get() {
        return button.get();
    }
}
