// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class PopoverMenu {

    public delegate void ConnectFn(string s);
    unowned ConnectFn fnAction;
    Gtk.Popover popover;
    VBox vbox = new VBox();
    Gtk.MenuButton button = new Gtk.MenuButton();
    ArrayList<Button> buttons = new ArrayList<Button>();

    public PopoverMenu(string buttonLabel, Gee.List<string> buttonList, ConnectFn fnAction) {
        this.fnAction = fnAction;
        popover = new Gtk.Popover(button); //GTK4_DELETE
        /// popover = new Gtk.Popover();
        button.set_label(buttonLabel);
        foreach (var index in UtilityList.range(buttonList.size)) {
            var url = buttonList[index];
            buttons.add(new Button(Icon.None, buttonList[index]));
            buttons.last().connectString(buttonClick, url);
            vbox.addWidget(buttons.last().get());
        }
        popover.add(vbox.get()); //GTK4_DELETE
        button.set_popover(popover);
        /// popover.set_child(vbox.get());
        popover.set_position(Gtk.PositionType.BOTTOM);
    }

    public void buttonClick(string s) {
        popover.set_visible(true); //GTK4_DELETE
        popover.hide();
        fnAction(s);
    }

    public Gtk.MenuButton get() {
        return button;
    }
}
