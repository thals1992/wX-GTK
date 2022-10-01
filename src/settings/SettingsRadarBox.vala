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
    ObjectNumberPicker[] numberPickers = {
        new ObjectNumberPicker("Refresh interval (minutes)", "RADAR_DATA_REFRESH_INTERVAL", 5, 1, 60, 1),
        new ObjectNumberPicker("Convective outlook line size", "RADAR_SWO_LINESIZE", 20, 1, 100, 1),
        new ObjectNumberPicker("County line size", "RADAR_COUNTY_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Hail marker size", "RADAR_HI_SIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Highway line size", "RADAR_HW_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Lake line size", "RADAR_LAKE_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Location marker size", "RADAR_LOCDOT_SIZE", 20, 1, 100, 1),
        new ObjectNumberPicker("MCD/MPD/Watch line size", "RADAR_WATMCD_LINESIZE", 20, 1, 100, 1),
        new ObjectNumberPicker("Secondary road line size", "RADAR_HWEXT_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("State line size", "RADAR_STATE_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Storm tracks line size", "RADAR_STI_LINESIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("TVS marker size", "RADAR_TVS_SIZE", 10, 1, 100, 1),
        new ObjectNumberPicker("Warning line size", "RADAR_WARN_LINESIZE", 20, 1, 100, 1),
        new ObjectNumberPicker("Wind barbs line size", "RADAR_WB_LINESIZE", 10, 1, 100, 1),
    };
    ComboBox comboBoxRefPal = new ComboBox(refPalChoices);
    ComboBox comboBoxVelPal = new ComboBox(velPalChoices);
    const string[] refPalChoices = {"CODENH", "DKenh", "NSSL", "NWSD", "GREEN", "AF", "EAK", "NWS"};
    const string[] velPalChoices = {"CODENH", "EAK", "AF"};
    ArrayList<ObjectSwitch> configsWarnings = new ArrayList<ObjectSwitch>();
    ObjectSwitch[] configs = new ObjectSwitch[]{
        new ObjectSwitch("Colormap Legend", "RADAR_COLOR_LEGEND", false),
        new ObjectSwitch("Controls", "RADAR_SHOW_CONTROLS", false),
        new ObjectSwitch("Canada Borders", "RADARCANADALINES", false),
        new ObjectSwitch("County Lines", "RADAR_SHOW_COUNTY", true),
        new ObjectSwitch("County Labels", "RADAR_COUNTY_LABELS", false),
        new ObjectSwitch("Cities", "COD_CITIES_DEFAULT", false),
        new ObjectSwitch("Hail Indicators", "RADAR_SHOW_HI", false),
        new ObjectSwitch("Highways", "COD_HW_DEFAULT", false),
        new ObjectSwitch("Location Markers", "COD_LOCDOT_DEFAULT", true),
        new ObjectSwitch("Mexico Borders", "RADARMEXICOLINES", false),
        new ObjectSwitch("Observations", "WXOGL_OBS", false),
        new ObjectSwitch("Multi-pane: share position && radar site", "DUALPANE_SHARE_POSN", true),
        new ObjectSwitch("Remember location, site, and product", "WXOGL_REMEMBER_LOCATION", true),
        new ObjectSwitch("Rivers", "COD_LAKES_DEFAULT", false),
        new ObjectSwitch("Secondary Roads", "RADAR_HW_ENH_EXT", false),
        new ObjectSwitch("SPC Convective Outlooks", "RADAR_SHOW_SWO", false),
        new ObjectSwitch("SPC MCD", "RADAR_SHOW_MCD", false),
        new ObjectSwitch("Status Bar", "RADAR_SHOW_STATUSBAR", true),
        new ObjectSwitch("Storm Tracks", "RADAR_SHOW_STI", false),
        new ObjectSwitch("Tornado Vortex Signature", "RADAR_SHOW_TVS", false),
        //  new ObjectSwitch("Warnings", "COD_WARNINGS_DEFAULT", false),
        new ObjectSwitch("Watches", "RADAR_SHOW_WATCH", false),
        new ObjectSwitch("Wind Barbs", "WXOGL_OBS_WINDBARBS", false),
        new ObjectSwitch("WPC Fronts", "RADAR_SHOW_WPC_FRONTS", false),
        new ObjectSwitch("WPC MPD", "RADAR_SHOW_MPD", false)
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
        hbox0.addWidget(button.get());
        hbox.addLayout(hbox0.get());
        addLayout(hbox.get());
        addLayout(hboxBottom.get());
        hboxBottom.addLayout(vboxLeft.get());
        hboxBottom.addLayout(vboxCenter.get());
        hboxBottom.addLayout(vboxRight.get());

        comboBoxRefPal.setIndex(findex(Utility.readPref("RADAR_COLOR_PALETTE_94", "CODENH"), refPalChoices));
        comboBoxRefPal.connect(changeRefPal);
        hbox1.addWidget(text1.get());
        hbox1.addWidget(comboBoxRefPal.get());
        hbox.addLayout(hbox1.get());

        comboBoxVelPal.setIndex(findex(Utility.readPref("RADAR_COLOR_PALETTE_99", "CODENH"), velPalChoices));
        comboBoxVelPal.connect(changeVelPal);
        hbox2.addWidget(text2.get());
        hbox2.addWidget(comboBoxVelPal.get());
        hbox.addLayout(hbox2.get());

        text1.setText("Reflectivity Palette:");
        text2.setText("Velocity Palette:");

        foreach (var type1 in ObjectPolygonWarning.polygonList) {
            var warning = ObjectPolygonWarning.polygonDataByType[type1];
            configsWarnings.add(new ObjectSwitch(warning.name(), warning.prefTokenEnabled(), false));
            vboxLeft.addWidget(configsWarnings.last().get());
        }

        var i = 0;
        foreach (var config in configs) {
            if (i <= configs.length / 2) {
                vboxLeft.addWidget(config.get());
            } else {
                vboxCenter.addWidget(config.get());
            }
            i += 1;
        }
        foreach (var config in numberPickers) {
            vboxRight.addWidget(config.get());
        }
    }

    void changeRefPal() {
        Utility.writePref("RADAR_COLOR_PALETTE_94", comboBoxRefPal.getValue());
        ObjectColorPalette.loadColorMap(94);
    }

    void changeVelPal() {
        Utility.writePref("RADAR_COLOR_PALETTE_99", comboBoxVelPal.getValue());
        ObjectColorPalette.loadColorMap(99);
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
