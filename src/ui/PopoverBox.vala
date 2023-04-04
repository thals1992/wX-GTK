// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class PopoverBox : Widget {

    unowned FnVoid fnAction;
    unowned FnVoid fnShow;
    Gtk.Popover popover;
    MenuButton button;

    public PopoverBox(string imageName, string buttonLabel, SettingsNotebook vbox, FnVoid fnAction) {
        this.fnAction = fnAction;
        button = new MenuButton(imageName, buttonLabel);
        #if GTK4
            popover = new Gtk.Popover();
        #else
            popover = new Gtk.Popover(button.get());
        #endif
        popover.closed.connect(() => this.fnAction());
        #if GTK4
            popover.set_child(vbox.getView());
        #else
            popover.add(vbox.getView());
        #endif
        button.setPopover(popover);
        popover.set_position(Gtk.PositionType.BOTTOM);
    }

    public void popup() {
        popover.popup();
    }

    public void connect(FnVoid fnShow) {
        this.fnShow = fnShow;
        popover.show.connect(() => fnShow());
    }

    public void connectClosed(FnVoid fnShow) {
        popover.closed.connect(() => fnShow());
    }

    public Gtk.Widget getView() { return button.get(); }
}
