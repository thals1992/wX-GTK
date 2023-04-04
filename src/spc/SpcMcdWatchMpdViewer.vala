// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcMcdWatchMpdViewer : Window {

    VBox boxText = new VBox();
    Button button = new Button(Icon.None, "");
    Text text = new Text();
    string token = "";
    Photo photo = new Photo.scaled();

    public SpcMcdWatchMpdViewer(string url) {
        maximize();
        token = getToken(url);
        setTitle(token);
        text.hExpand();
        boxText.addWidget(button);
        boxText.addWidget(text);

        new TwoWidgetScroll(this, photo.getView(), boxText.getView());
        new FutureText(token, updateText);
        new FutureBytes(url, photo.setBytes);
    }

    void updateText(string productText) {
        text.setText(productText);
        var textWithLatLon = productText;
        if (token.contains("SPCWAT")) {
            textWithLatLon = LatLon.getWatchLatLon(token[token.length - 4:token.length]);
        }
        var stringOfLatLon = LatLon.storeWatchMcdLatLon(textWithLatLon);
        stringOfLatLon = stringOfLatLon.replace(":", "");
        var latLonList = LatLon.parseStringToLatLons(stringOfLatLon, -1.0, false);
        var center = UtilityLocation.getCenterOfPolygon(latLonList);
        var radarSite = UtilityLocation.getNearestRadarSites(center, 1, false)[0];
        var buttonRadarText = "Show Radar - " + radarSite.name;
        button.setText(buttonRadarText);
        button.connectString((r) => new Nexrad(1, true, r), radarSite.name);
    }

    string getToken(string url) {
        var items = url.split("/");
        var s = items[items.length - 1];
        s = s.replace(".gif", "");
        s = s.replace(".png", "");
        s = s.ascii_up();
        if (url.contains("www.wpc.ncep.noaa.gov")) {
            s = "WPCMPD" + s[s.length - 4:s.length];
        } else if (url.contains("www.spc.noaa.gov") && url.contains("mcd")) {
            s = "SPCMCD" + s[s.length - 4:s.length];
        } else {
            var items1 = url.split("/");
            s = items1[items1.length - 1];
            s = s.replace("_radar.gif", "");
            s = s.replace("ww", "");
            s = "SPCWAT" + s[s.length - 4:s.length];
        }
        return s;
    }
}
