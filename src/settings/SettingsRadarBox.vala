// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SettingsRadarBox : VBox {

    HBox hbox = new HBox();
    HBox hbox0 = new HBox();
    HBox hbox1 = new HBox();
    HBox hbox2 = new HBox();
    HBox hboxBottom = new HBox();
    VBox vboxLeft = new VBox();
    VBox vboxCenter = new VBox();
    VBox vboxRight = new VBox();
    Text text1 = new Text();
    Text text2 = new Text();
    Button button = new Button(Icon.None, "Keyboard Shortcuts");
    NumberPicker[] numberPickers = {
        new NumberPicker("Refresh interval (minutes)", "RADAR_DATA_REFRESH_INTERVAL", 5, 1, 60, 1),
        new NumberPicker("Convective outlook line size", "RADAR_SWO_LINESIZE", 20, 1, 100, 1),
        new NumberPicker("County line size", "RADAR_COUNTY_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("Hail marker size", "RADAR_HI_SIZE", 10, 1, 100, 1),
        new NumberPicker("Highway line size", "RADAR_HW_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("Lake line size", "RADAR_LAKE_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("Location marker size", "RADAR_LOCDOT_SIZE", 20, 1, 100, 1),
        new NumberPicker("MCD/MPD/Watch line size", "RADAR_WATMCD_LINESIZE", 20, 1, 100, 1),
        new NumberPicker("Secondary road line size", "RADAR_HWEXT_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("State line size", "RADAR_STATE_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("Storm tracks line size", "RADAR_STI_LINESIZE", 10, 1, 100, 1),
        new NumberPicker("TVS marker size", "RADAR_TVS_SIZE", 10, 1, 100, 1),
        new NumberPicker("Warning line size", "RADAR_WARN_LINESIZE", 20, 1, 100, 1),
        new NumberPicker("Wind barbs line size", "RADAR_WB_LINESIZE", 10, 1, 100, 1),
    };
    ComboBox comboBoxRefPal = new ComboBox(refPalChoices);
    ComboBox comboBoxVelPal = new ComboBox(velPalChoices);
    const string[] refPalChoices = {"CODENH", "DKenh", "NSSL", "NWSD", "GREEN", "AF", "EAK", "NWS"};
    const string[] velPalChoices = {"CODENH", "EAK", "AF"};
    ArrayList<Switch> configsWarnings = new ArrayList<Switch>();
    Switch[] configs = new Switch[]{
        new Switch("Colormap Legend", "RADAR_COLOR_LEGEND", false),
        new Switch("Controls", "RADAR_SHOW_CONTROLS", false),
        new Switch("Canada Borders", "RADARCANADALINES", false),
        new Switch("County Lines", "RADAR_SHOW_COUNTY", true),
        new Switch("County Labels", "RADAR_COUNTY_LABELS", false),
        new Switch("Cities", "COD_CITIES_DEFAULT", false),
        new Switch("Hail Indicators", "RADAR_SHOW_HI", false),
        new Switch("Highways", "COD_HW_DEFAULT", false),
        new Switch("Location Markers", "COD_LOCDOT_DEFAULT", true),
        new Switch("Mexico Borders", "RADARMEXICOLINES", false),
        new Switch("Observations", "WXOGL_OBS", false),
        new Switch("Multi-pane: share position && radar site", "DUALPANE_SHARE_POSN", true),
        new Switch("Remember location, site, and product", "WXOGL_REMEMBER_LOCATION", true),
        new Switch("Rivers", "COD_LAKES_DEFAULT", false),
        new Switch("Secondary Roads", "RADAR_HW_ENH_EXT", false),
        new Switch("SPC Convective Outlooks", "RADAR_SHOW_SWO", false),
        new Switch("SPC MCD", "RADAR_SHOW_MCD", false),
        new Switch("Status Bar", "RADAR_SHOW_STATUSBAR", true),
        new Switch("Storm Tracks", "RADAR_SHOW_STI", false),
        new Switch("Tornado Vortex Signature", "RADAR_SHOW_TVS", false),
        //  new Switch("Warnings", "COD_WARNINGS_DEFAULT", false),
        new Switch("Watches", "RADAR_SHOW_WATCH", false),
        new Switch("Wind Barbs", "WXOGL_OBS_WINDBARBS", false),
        new Switch("WPC Fronts", "RADAR_SHOW_WPC_FRONTS", false),
        new Switch("WPC MPD", "RADAR_SHOW_MPD", false)
    };

    public SettingsRadarBox() {
        button.connect(() => {
            Gtk.Builder builder = new Gtk.Builder.from_string(Shortcuts.radar, Shortcuts.radar.length);
            var dialog = (Gtk.ShortcutsWindow) builder.get_object("shortcuts-window");
            #if GTK4
                dialog.show();
            #else
                dialog.show_all();
            #endif
        });
        hbox0.addWidget(button);
        hbox.addLayout(hbox0);
        addLayout(hbox);
        addLayout(hboxBottom);
        hboxBottom.addLayout(vboxLeft);
        hboxBottom.addLayout(vboxCenter);
        hboxBottom.addLayout(vboxRight);

        comboBoxRefPal.setIndex(findex(Utility.readPref("RADAR_COLOR_PALETTE_94", "CODENH"), refPalChoices));
        comboBoxRefPal.connect(changeRefPal);
        hbox1.addWidget(text1);
        hbox1.addWidget(comboBoxRefPal);
        hbox.addLayout(hbox1);

        comboBoxVelPal.setIndex(findex(Utility.readPref("RADAR_COLOR_PALETTE_99", "CODENH"), velPalChoices));
        comboBoxVelPal.connect(changeVelPal);
        hbox2.addWidget(text2);
        hbox2.addWidget(comboBoxVelPal);
        hbox.addLayout(hbox2);

        text1.setText("Reflectivity Palette:");
        text2.setText("Velocity Palette:");

        foreach (var type1 in PolygonWarning.polygonList) {
            var warning = PolygonWarning.byType[type1];
            configsWarnings.add(new Switch(warning.name(), warning.prefTokenEnabled(), false));
            vboxLeft.addWidget(configsWarnings.last());
        }

        var i = 0;
        foreach (var config in configs) {
            if (i <= configs.length / 2) {
                vboxLeft.addWidget(config);
            } else {
                vboxCenter.addWidget(config);
            }
            i += 1;
        }
        foreach (var config in numberPickers) {
            vboxRight.addWidget(config);
        }
    }

    void changeRefPal() {
        Utility.writePref("RADAR_COLOR_PALETTE_94", comboBoxRefPal.getValue());
        ColorPalette.loadColorMap(94);
    }

    void changeVelPal() {
        Utility.writePref("RADAR_COLOR_PALETTE_99", comboBoxVelPal.getValue());
        ColorPalette.loadColorMap(99);
    }

    public void refresh() {
        foreach (var s in configs) {
            s.refresh();
        }
        foreach (var s in numberPickers) {
            s.refresh();
        }
    }
}
