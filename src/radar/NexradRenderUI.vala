// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradRenderUI {

    public static void showPolygonText(LatLon location) {
        var url = Warnings.show(location);
        if (url != "") {
            new AlertsDetail(url);
        }
    }

    public static void showNearestProduct(PolygonType type, LatLon location) {
        var txt = Watch.show(location, type);
        // https://www.spc.noaa.gov/products/md/mcd0922.gif
        // https://www.wpc.ncep.noaa.gov/metwatch/images/mcd0339.gif
        // https://www.spc.noaa.gov/products/watch/ww0283_radar.gif
        var url = "";
        if (type == PolygonType.Mcd) {
            url = "https://www.spc.noaa.gov/products/md/mcd" + txt + ".gif";
        } else if (type == PolygonType.Mpd) {
            url = "https://www.wpc.ncep.noaa.gov/metwatch/images/mcd" + txt + ".gif";
        } else if (type == PolygonType.Watch) {
            url = "https://www.spc.noaa.gov/products/watch/ww" + txt + "_radar.gif";
        }
        if (txt != "") {
            new SpcMcdWatchMpdViewer(url);
        }
    }

    //  public static LatLon getLatLonFromScreenPositionOLD(NexradState nexradState, int numberOfPanes, double x, double y) {
    //      //  var ortInt = 950.0;
    //      var width = nexradState.windowWidth;
    //      var height = nexradState.windowHeight;
    //      var yModified = y;
    //      var xModified = x;
    //      //  var density = (ortInt * 2.0) / ((width * 1920.0 / width) * nexradState.zoom);
    //      var density = 1.0 / nexradState.zoom;
    //      var xMiddle = width / 2.0;
    //      var yMiddle = 0.0;
    //      // TODO FIXME - don't need if else
    //      if (numberOfPanes != 4) {
    //          yMiddle = height / 2.0;
    //      } else {
    //          yMiddle = height / 2.0;
    //          xMiddle = width / 2.0;
    //      }
    //      var diffX = density * (xMiddle - xModified);
    //      var diffY = density * (yMiddle - yModified);
    //      var radarX = Too.Double(Utility.getRadarSiteX(nexradState.getRadarSite()));
    //      var radarY = Too.Double(Utility.getRadarSiteY(nexradState.getRadarSite()));
    //      var radarLocation = new LatLon.fromDouble(radarX, radarY);
    //      var ppd = nexradState.getPn().oneDegreeScaleFactor;
    //      var newX = radarLocation.lon() + (nexradState.xPos / nexradState.zoom + diffX) / ppd;
    //      var test2 = 180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + radarLocation.lat() * (Math.PI / 180) / 2.0));
    //      var newY = test2 + (nexradState.yPos / nexradState.zoom + diffY) / ppd;
    //      newY = (180.0 / Math.PI * (2.0 * Math.atan(Math.exp(newY * Math.PI / 180.0)) - Math.PI / 2.0));
    //      return new LatLon.fromDouble(newY, -1.0 * newX);
    //  }

    public static LatLon getLatLonFromScreenPosition(NexradState nexradState, double x, double y) {
        var width = nexradState.windowWidth;
        var height = nexradState.windowHeight;
        var density = 1.0 / nexradState.zoom;
        var yMiddle = height / 2.0;
        var xMiddle = width / 2.0;
        var diffX = density * (xMiddle - x);
        var diffY = density * (yMiddle - y);
        var ppd = nexradState.getPn().oneDegreeScaleFactor;
        var newX = nexradState.getPn().y() + (nexradState.xPos / nexradState.zoom + diffX) / ppd;
        var test2 = 180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4 + nexradState.getPn().x() * (Math.PI / 180) / 2.0));
        var newY = test2 + (nexradState.yPos / nexradState.zoom + diffY) / ppd;
        newY = (180.0 / Math.PI * (2 * Math.atan(Math.exp(newY * Math.PI / 180.0)) - Math.PI / 2.0));
        return new LatLon.fromDouble(newY, -1.0 * newX);
    }

    public static void showRadarStatusMessage(string radarSite) {
        var ridSmall = radarSite;
        var message = DownloadText.getRadarStatusMessage(ridSmall.ascii_up());
        if (message == "") {
            message = "The current radar status for " + radarSite + " is not available.";
        }
        new TextViewerStatic(message);
    }
}
