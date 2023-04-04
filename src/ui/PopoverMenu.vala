// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class PopoverMenu : Widget {

    unowned FnString fnAction;
    Gtk.Popover popover;
    VBox vbox = new VBox();
    Gtk.MenuButton button = new Gtk.MenuButton();
    ArrayList<Button> buttons = new ArrayList<Button>();

    public PopoverMenu(string buttonLabel, Gee.List<string> buttonList, FnString fnAction) {
        this.fnAction = fnAction;
        #if GTK4
            popover = new Gtk.Popover();
        #else
            popover = new Gtk.Popover(button);
        #endif
        button.set_label(buttonLabel);
        foreach (var index in range(buttonList.size)) {
            var url = buttonList[index];
            buttons.add(new Button(Icon.None, buttonList[index]));
            buttons.last().connectString(buttonClick, url);
            vbox.addWidget(buttons.last());
        }
        #if GTK4
            popover.set_child(vbox.getView());
        #else
            popover.add(vbox.getView());
        #endif
        button.set_popover(popover);
        popover.set_position(Gtk.PositionType.BOTTOM);
    }

    public void buttonClick(string s) {
        #if GTK4
        #else
            popover.set_visible(true);
        #endif
        popover.hide();
        fnAction(s);
    }

    public Gtk.Widget getView() { return button; }
}
