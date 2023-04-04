// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class Toolbar : VBox {

    ButtonFlat button = new ButtonFlat("reload.png", "Reload, Ctrl-u");
    public PopoverBox settingsPopoverBox;
    string day1 = "1";
    string day2 = "2";
    string day3 = "3";
    string day48 = "48";
    SettingsNotebook settingsNotebook = new SettingsNotebook();
    ArrayList<RouteItem> routeItems = new ArrayList<RouteItem>();
    ArrayList<ButtonFlat> buttons = new ArrayList<ButtonFlat>();
    unowned FnVoid fn;

    public Toolbar(FnVoid fn) {
        this.fn = fn;
        button.connect(fn);
        addWidget(button);
        settingsPopoverBox = new PopoverBox(
            "baseline_settings_black_48dp.png",
            "Settings",
            settingsNotebook,
            reloadIfPrefChange
        );
        settingsPopoverBox.connect(refreshSettings);
        settingsPopoverBox.connectClosed(refreshComboBox);

        addWidget(settingsPopoverBox);
        routeItems.add(new RouteItem("baseline_warning_black_48dp.png", "Severe Dasboard, Ctrl-d", () => new SevereDashboard()));
        routeItems.add(new RouteItem("baseline_cloud_black_48dp.png", "GOES Viewer, Ctrl-c", () => new GoesViewer("")));
        routeItems.add(new RouteItem("baseline_date_range_black_48dp.png", "Hourly, Ctrl-h", () => new Hourly()));
        routeItems.add(new RouteItem("baseline_info_black_48dp.png", "Wfo Text, Cltr-a", () => new WfoText()));
        routeItems.add(new RouteItem("baseline_flash_on_black_48dp.png", "Nexrad, Ctrl-r", () => new Nexrad(1, false, "")));
        routeItems.add(new RouteItem("wxogldualpane.png", "Nexrad Dual Pane, Cltrl-2", () => new Nexrad(2, false, "")));
        routeItems.add(new RouteItem("wxoglquadpane.png", "Nexrad Quad Pane, Cltrl-4", () => new Nexrad(4, false, "")));
        routeItems.add(new RouteItem("spc_sum.png", "SPC Convective Outlooks, Cltrl-s", () => new SpcSwoSummary()));
        routeItems.add(new RouteItem("day" + day1 + ".png", "SPC Convective Outlook Day " + day1, () => new SpcSwoDay1(day1)));
        routeItems.add(new RouteItem("day" + day2 + ".png", "SPC Convective Outlook Day " + day2, () => new SpcSwoDay1(day2)));
        routeItems.add(new RouteItem("day" + day3 + ".png", "SPC Convective Outlook Day " + day3, () => new SpcSwoDay1(day3)));
        routeItems.add(new RouteItem("day" + day48 + ".png", "SPC Convective Outlook Day " + day48, () => new SpcSwoDay1(day48)));
        routeItems.add(new RouteItem("fmap.png", "National Images, Cltr-i", () => new NationalImages()));
        routeItems.add(new RouteItem("meso.png", "Spc Mesoanalysis, Cltr-z", () => new SpcMeso()));
        routeItems.add(new RouteItem("nwsobssites.png", "Observation Sites", () => new ObservationSites()));
        routeItems.add(new RouteItem("nwsobs.png", "Observations", () => new Observations()));
        routeItems.add(new RouteItem("rtma.png", "RTMA", () => new Rtma()));
        routeItems.add(new RouteItem("radarmosaicnws.png", "NWS Radar Mosaic, Cltr-m", () => new RadarMosaicNws()));
        routeItems.add(new RouteItem("srfd.png", "National Text", () => new NationalText("")));
        routeItems.add(new RouteItem("uswarn.png", "National Alerts", () => new UsAlerts()));
        routeItems.add(new RouteItem("wpc_rainfall.png", "Excessive Rainfall Outlook", () => new RainfallOutlookSummary()));
        routeItems.add(new RouteItem("spccompmap.png", "SPC Compmap", () => new SpcCompMap()));
        routeItems.add(new RouteItem("tstorm.png", "SPC Thunderstorm Outlooks", () => new SpcTstormOutlooks()));
        routeItems.add(new RouteItem("lightning.png", "Lightning, Cltr-l", () => Route.lightning()));
        routeItems.add(new RouteItem("fire_outlook.png", "SPC Fire Weather Outlook", () => new SpcFireSummary()));
        routeItems.add(new RouteItem("report_today.png", "SPC Storm Reports - Today", () => new SpcStormReports("today")));
        routeItems.add(new RouteItem("report_yesterday.png", "SPC Storm Reports - Yesterday", () => new SpcStormReports("yesterday")));
        routeItems.add(new RouteItem("nhc.png", "NHC, Cltr-o", () => new Nhc()));
        routeItems.add(new RouteItem("ncep.png", "NCEP Models, Ctrl-m", () => new ModelViewer("NCEP")));
        routeItems.add(new RouteItem("spchrrr.png", "SPC HRRR", () => new ModelViewer("SPCHRRR")));
        routeItems.add(new RouteItem("spcsref.png", "SPC SREF", () => new ModelViewer("SPCSREF")));
        routeItems.add(new RouteItem("hrrrviewer.png", "ESRL HRRR/RAP", () => new ModelViewer("ESRL")));
        routeItems.add(new RouteItem("glcfs.png", "GLCFS", () => new ModelViewer("GLCFS")));
        routeItems.add(new RouteItem("opc.png", "Ocean Prediction Center", () => new Opc()));

        foreach (var item in routeItems) {
            buttons.add(new ButtonFlat(item.iconString, item.toolTip));
            buttons.last().connect(item.fn);
            addWidget(buttons.last());
        }
    }

    void reloadIfPrefChange() {
        var newSettings = Utility.getSettings();
        if (newSettings != Utility.allSettings) {
            fn();
            Utility.recordAllSettings();
        }
    }

    void refreshSettings() {
        settingsNotebook.refresh();
    }

    void refreshComboBox() {
        Location.setMainScreenComboBox();
    }
}
