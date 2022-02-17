// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class SettingsNotebook : VBox {

    TabWidget tabWidget = new TabWidget();
    SettingsBox settingsMain = new SettingsBox();
    SettingsRadarBox settingsRadar = new SettingsRadarBox();
    SettingsColorsBox settingsColors = new SettingsColorsBox();
    SettingsLocationsBox settingsLocation = new SettingsLocationsBox();
    LocationEditBox locationEditBox = new LocationEditBox();

    public SettingsNotebook() {
        addWidget(tabWidget.get());
        tabWidget.addTab(settingsMain.get(), "General");
        tabWidget.addTab(settingsRadar.get(), "Radar");
        tabWidget.addTab(settingsColors.get(), "Colors");
        tabWidget.addTab(settingsLocation.get(), "Locations");
        tabWidget.addTab(locationEditBox.get(), "Add Location");
        tabWidget.addTab(new TextViewerStaticBox(GlobalVariables.aboutString).get(), "About");
        tabWidget.connect((w, i) => {
            if (i == 3) {
                settingsLocation.refresh();
            }
        });
    }

    public void switchIndex(int index) {
        tabWidget.switchIndex(index);
    }

    public void refresh() {
        // TODO FIXME call refresh in children
        settingsMain.refresh();
        settingsRadar.refresh();
    }
}
