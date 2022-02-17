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
    //  string url = "";
    string token = "";
    Photo photo = new Photo.scaled();

    public SpcMcdWatchMpdViewer(string url) {
        //  this.url = url;
        maximize();
        var items = url.split("/");
        token = items[items.length - 1];
        token = token.replace(".gif", "");
        token = token.ascii_up();

        if (url.contains("www.wpc.ncep.noaa.gov")) {
            token = "WPCMPD" + token[token.length - 4:token.length];
        } else if (url.contains("www.spc.noaa.gov") && url.contains("mcd")) {
            token = "SPCMCD" + token[token.length - 4:token.length];
        } else {
            var items1 = url.split("/");
            token = items1[items1.length - 1];
            token = token.replace("_radar.gif", "");
            token = token.replace("ww", "");
            token = "SPCWAT" + token[token.length - 4:token.length];
        }
        setTitle(token);
        boxText.addWidget(button.get());
        boxText.addWidget(text.get());

        new ObjectTwoWidgetScroll(this, photo.get(), boxText.get());
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
}
