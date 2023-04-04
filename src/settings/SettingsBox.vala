// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SettingsBox : VBox {

    HBox hbox0 = new HBox();
    Button button = new Button(Icon.None, "Keyboard Shortcuts");
    NumberPicker np1 = new NumberPicker("Main screen image size", "MAIN_SCREEN_IMAGE_SIZE", 400, 200, 800, 50);
    Switch[] configs = {
        new Switch("Show Nexrad on main screen", "NEXRAD_ON_MAIN_SCREEN", false),
        new Switch("Use new NWS API", "USE_NWS_API_SEVEN_DAY", false),
        new Switch("Use new NWS API - Hourly", "USE_NWS_API_HOURLY", true),
        new Switch("Show mini SevereDashboard on main screen", "MAINSCREEN_SEVERE_DASH", false),
        new Switch("Toggle scroll wheel motion", "NEXRAD_SCROLLWHEEL", false),
        new Switch("Remember last GOES image", "REMEMBER_GOES", false),
        new Switch("Remember last Radar Mosaic image", "REMEMBER_MOSAIC", false)
    };
    ArrayList<Switch> homeScreenObjectSwitch = new ArrayList<Switch>();

    public SettingsBox() {
        addLayout(hbox0);

        button.connect(() => {
            Gtk.Builder builder = new Gtk.Builder.from_string(Shortcuts.mainWindow, Shortcuts.mainWindow.length);
            var dialog = (Gtk.ShortcutsWindow) builder.get_object("shortcuts-window");
            #if GTK4
                dialog.show();
            #else
                dialog.show_all();
            #endif
        });
        addWidget(button);

        foreach (var item in UIPreferences.homeScreenItemsImage) {
            homeScreenObjectSwitch.add(Switch.fromPrefBool(item));
            addWidget(homeScreenObjectSwitch.last());
        }

        foreach (var item in UIPreferences.homeScreenItemsText) {
            homeScreenObjectSwitch.add(Switch.fromPrefBool(item));
            addWidget(homeScreenObjectSwitch.last());
        }

        foreach (var config in configs) {
            addWidget(config);
        }
        addWidget(np1);
    }

    public void refresh() {
        foreach (var s in configs) {
            s.refresh();
        }
        foreach (var s in homeScreenObjectSwitch) {
            s.refresh();
        }
    }
}
