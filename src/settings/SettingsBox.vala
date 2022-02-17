// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SettingsBox : VBox {

    HBox hbox0 = new HBox();
    Button button = new Button(Icon.None, "Keyboard Shortcuts");
    ObjectNumberPicker np1 = new ObjectNumberPicker("Main screen image size", "MAIN_SCREEN_IMAGE_SIZE", 400, 200, 800, 50);
    ObjectSwitch[] configs = {
        new ObjectSwitch("Show Nexrad on main screen", "NEXRAD_ON_MAIN_SCREEN", false),
        new ObjectSwitch("Use new NWS API", "USE_NWS_API_SEVEN_DAY", false),
        new ObjectSwitch("Use new NWS API - Hourly", "USE_NWS_API_HOURLY", true),
        new ObjectSwitch("Show mini SevereDashboard on main screen", "MAINSCREEN_SEVERE_DASH", false),
        new ObjectSwitch("Toggle scroll wheel motion", "NEXRAD_SCROLLWHEEL", false)
    };
    ArrayList<ObjectSwitch> homeScreenObjectSwitch = new ArrayList<ObjectSwitch>();

    public SettingsBox() {
        addLayout(hbox0.get());

        button.connect(() => {
            Gtk.Builder builder = new Gtk.Builder.from_string(Shortcuts.mainWindow, Shortcuts.mainWindow.length);
            var dialog = (Gtk.ShortcutsWindow) builder.get_object("shortcuts-window");
            dialog.show_all(); //GTK4_DELETE
            /// dialog.show();
        });
        addWidget(button.get());

        foreach (var item in UIPreferences.homeScreenItemsImage) {
            homeScreenObjectSwitch.add(ObjectSwitch.fromPrefBool(item));
            addWidget(homeScreenObjectSwitch.last().get());
        }

        foreach (var item in UIPreferences.homeScreenItemsText) {
            homeScreenObjectSwitch.add(ObjectSwitch.fromPrefBool(item));
            addWidget(homeScreenObjectSwitch.last().get());
        }

        foreach (var config in configs) {
            addWidget(config.get());
        }
        addWidget(np1.get());
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
