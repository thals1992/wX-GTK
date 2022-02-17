// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SettingsColorsBox : VBox {

    VBox vbox1 = new VBox();
    VBox vbox2 = new VBox();
    HBox hbox = new HBox();
    ArrayList<WXColor> colors = new ArrayList<WXColor>();
    ArrayList<ObjectColorLabel> colorLabels = new ArrayList<ObjectColorLabel>();

    public SettingsColorsBox() {
        loadColors();
        hbox.addLayout(vbox1.get());
        hbox.addLayout(vbox2.get());
        addLayout(hbox.get());
        int i = 0;
        foreach (var color in colors) {
            colorLabels.add(new ObjectColorLabel(color));
            if (i >= colors.size / 2) {
                vbox2.addLayout(colorLabels.last().get());
            } else {
                vbox1.addLayout(colorLabels.last().get());
            }
            i += 1;
        }
    }

    void loadColors() {
        colors.add(new WXColor("Cities", "RADAR_COLOR_CITY", 255, 255, 255));
        colors.add(new WXColor("Counties", "RADAR_COLOR_COUNTY", 75, 75, 75));
        colors.add(new WXColor("County Labels", "RADAR_COLOR_COUNTY_LABELS", 234, 214, 123));
        colors.add(new WXColor("Flash Flood Warning", "RADAR_COLOR_FFW", 0, 255, 0));
        colors.add(new WXColor("Hail Indicators", "RADAR_COLOR_HI", 0, 255, 0));
        colors.add(new WXColor("Highways", "RADAR_COLOR_HW", 135, 135, 135));
        colors.add(new WXColor("Lakes and Rivers", "RADAR_COLOR_LAKES", 0, 0, 255));
        colors.add(new WXColor("Location Dot", "RADAR_COLOR_LOCDOT", 255, 255, 255));
        colors.add(new WXColor("MCD", "RADAR_COLOR_MCD", 153, 51, 255));
        colors.add(new WXColor("MPD", "RADAR_COLOR_MPD", 0, 255, 0));
        colors.add(new WXColor("Nexrad Radar Background Color", "NEXRAD_RADAR_BACKGROUND_COLOR", 0, 0, 0 ));
        colors.add(new WXColor("NWS Forecast Icon Bottom Color", "NWS_ICON_BOTTOM_COLOR", 255, 255, 255));
        colors.add(new WXColor("NWS Forecast Icon Text Color", "NWS_ICON_TEXT_COLOR", 38, 97, 139));
        colors.add(new WXColor("Observations", "RADAR_COLOR_OBS", 255, 255, 255));
        colors.add(new WXColor("Secondary Roads", "RADAR_COLOR_HW_EXT", 91, 91, 91));
        colors.add(new WXColor("Spotters", "RADAR_COLOR_SPOTTER", 255, 0, 245));
        colors.add(new WXColor("State Lines", "RADAR_COLOR_STATE", 142, 142, 142));
        colors.add(new WXColor("Storm Tracks", "RADAR_COLOR_STI", 255, 255, 255));
        colors.add(new WXColor("Thunderstorm Warning", "RADAR_COLOR_TSTORM", 255, 255, 0));
        colors.add(new WXColor("Thunderstorm Watch", "RADAR_COLOR_TSTORM_WATCH", 255, 187, 0));
        colors.add(new WXColor("Tornado Warning", "RADAR_COLOR_TOR", 243, 85, 243));
        colors.add(new WXColor("Tornado Watch", "RADAR_COLOR_TOR_WATCH", 255, 0, 0));
        colors.add(new WXColor("Wind Barbs", "RADAR_COLOR_OBS_WINDBARBS", 255, 255, 255));
    }
}
