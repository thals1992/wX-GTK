// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityRadarUI {

    public static Menu setupContextMenuNew(DrawingArea da, NexradState nexradState, LatLon latLon, FnString changeRadarSite, FnProduct fnProduct) {

        var longPressMenu = new LongPressMenu();

        var obsSite = UtilityMetar.findClosestObservation(latLon, 0);
        var obsString = "Show Nearest Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
        var item1 = new CMenuItem("Obs", obsString);
        longPressMenu.add(item1, () => new TextViewer(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsSite.name + ".TXT"));

        da.insertActionGroup("popup", longPressMenu.getAG());
        return longPressMenu.get();

        //  var menu = new Menu();
        //  var simpleActionGroup = new SimpleActionGroup();

        //  var obsSite = UtilityMetar.findClosestObservation(latLon, 0);
        //  var obsString = "Show Nearest Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
        //  menu.append(obsString, "popup.about" + "Obs");
        //  var actionObs = new SimpleAction("about" + "Obs", null);
        //  actionObs.activate.connect(() => new TextViewer(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsSite.name + ".TXT"));
        //  simpleActionGroup.add_action(actionObs);

        //  var saveLocationString = "Save as a location: " + latLon.printPretty();
        //  menu.append(saveLocationString, "popup.about" + "SaveLocation");
        //  var actionSaveLocation = new SimpleAction("about" + "SaveLocation", null);
        //  actionSaveLocation.activate.connect(() => {
        //      Location.save(latLon, latLon.printPretty());
        //      Location.setMainScreenComboBox();
        //  });
        //  simpleActionGroup.add_action(actionSaveLocation);

        //  var radarSites = UtilityLocation.getNearestRadarSites(latLon, 5, true);
        //  foreach (var rid in radarSites) {
        //      var radarDescription = rid.name + ": " + Utility.getRadarSiteName(rid.name) + " (" + Too.String((int)(Math.round(rid.distance))) + " mi)";
        //      menu.append(radarDescription, "popup.about" + rid.name);
        //      var action = new SimpleAction("about" + rid.name, null);
        //      action.activate.connect(() => changeRadarSite(radarDescription.split(":")[0]));
        //      simpleActionGroup.add_action(action);
        //  }
        //  menu.append("Show Warning", "popup.about" + "WARN");
        //  var actionWarnings = new SimpleAction("about" + "WARN", null);
        //  actionWarnings.activate.connect(() => UtilityRadarUI.showPolygonText(latLon));
        //  simpleActionGroup.add_action(actionWarnings);

        //  menu.append("Show Watch", "popup.about" + "Watch");
        //  var actionWatch = new SimpleAction("about" + "Watch", null);
        //  actionWatch.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Watch, latLon));
        //  simpleActionGroup.add_action(actionWatch);

        //  menu.append("Show MCD", "popup.about" + "MCD");
        //  var actionMcd = new SimpleAction("about" + "MCD", null);
        //  actionMcd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mcd, latLon));
        //  simpleActionGroup.add_action(actionMcd);

        //  menu.append("Show MPD", "popup.about" + "MPD");
        //  var actionMpd = new SimpleAction("about" + "MPD", null);
        //  actionMpd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mpd, latLon));
        //  simpleActionGroup.add_action(actionMpd);
        //  //
        //  // radar products
        //  //
        //  var productList = WXGLNexrad.radarProductList;
        //  var prodLength = 5;
        //  if (WXGLNexrad.isRadarTdwr(nexradState.radarSite)) {
        //      productList = WXGLNexrad.radarProductListTdwr;
        //      prodLength = 3;
        //  }
        //  foreach (var product in productList[0:prodLength]) {
        //      var token = product.split(":")[0];
        //      menu.append(product, "popup.about" + token);
        //      var action = new SimpleAction("about" + token, null);
        //      action.activate.connect(() => fnProduct(product, nexradState.paneNumber));
        //      simpleActionGroup.add_action(action);
        //  }
        //  //
        //  // radar status message
        //  //
        //  menu.append("Radar status message: " + radarSites[0].name, "popup.about" + "RSM");
        //  var actionRsm = new SimpleAction("about" + "RSM", null);
        //  actionRsm.activate.connect(() => getRadarStatusMessage(radarSites[0].name));
        //  simpleActionGroup.add_action(actionRsm);

        //  da.insertActionGroup("popup", simpleActionGroup);
        //  return menu;
    }

    public static Menu setupContextMenu(DrawingArea da, NexradState nexradState, LatLon latLon, FnString changeRadarSite, FnProduct fnProduct) {
        var menu = new Menu();
        var simpleActionGroup = new SimpleActionGroup();

        var obsSite = UtilityMetar.findClosestObservation(latLon, 0);
        var obsString = "Show Nearest Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
        menu.append(obsString, "popup.about" + "Obs");
        var actionObs = new SimpleAction("about" + "Obs", null);
        actionObs.activate.connect(() => new TextViewer(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsSite.name + ".TXT"));
        simpleActionGroup.add_action(actionObs);

        var saveLocationString = "Save as a location: " + latLon.printPretty();
        menu.append(saveLocationString, "popup.about" + "SaveLocation");
        var actionSaveLocation = new SimpleAction("about" + "SaveLocation", null);
        actionSaveLocation.activate.connect(() => {
            Location.save(latLon, latLon.printPretty());
            Location.setMainScreenComboBox();
        });
        simpleActionGroup.add_action(actionSaveLocation);

        var radarSites = UtilityLocation.getNearestRadarSites(latLon, 5, true);
        foreach (var rid in radarSites) {
            var radarDescription = rid.name + ": " + Utility.getRadarSiteName(rid.name) + " (" + Too.String((int)(Math.round(rid.distance))) + " mi)";
            menu.append(radarDescription, "popup.about" + rid.name);
            var action = new SimpleAction("about" + rid.name, null);
            action.activate.connect(() => changeRadarSite(radarDescription.split(":")[0]));
            simpleActionGroup.add_action(action);
        }
        menu.append("Show Warning", "popup.about" + "WARN");
        var actionWarnings = new SimpleAction("about" + "WARN", null);
        actionWarnings.activate.connect(() => UtilityRadarUI.showPolygonText(latLon));
        simpleActionGroup.add_action(actionWarnings);

        menu.append("Show Watch", "popup.about" + "Watch");
        var actionWatch = new SimpleAction("about" + "Watch", null);
        actionWatch.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Watch, latLon));
        simpleActionGroup.add_action(actionWatch);

        menu.append("Show MCD", "popup.about" + "MCD");
        var actionMcd = new SimpleAction("about" + "MCD", null);
        actionMcd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mcd, latLon));
        simpleActionGroup.add_action(actionMcd);

        menu.append("Show MPD", "popup.about" + "MPD");
        var actionMpd = new SimpleAction("about" + "MPD", null);
        actionMpd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mpd, latLon));
        simpleActionGroup.add_action(actionMpd);
        //
        // radar products
        //
        var productList = WXGLNexrad.radarProductList;
        var prodLength = 5;
        if (WXGLNexrad.isRadarTdwr(nexradState.getRadarSite())) {
            productList = WXGLNexrad.radarProductListTdwr;
            prodLength = 3;
        }
        foreach (var product in productList[0:prodLength]) {
            var token = product.split(":")[0];
            menu.append(product, "popup.about" + token);
            var action = new SimpleAction("about" + token, null);
            action.activate.connect(() => fnProduct(product, nexradState.paneNumber));
            simpleActionGroup.add_action(action);
        }
        //
        // radar status message
        //
        menu.append("Radar status message: " + radarSites[0].name, "popup.about" + "RSM");
        var actionRsm = new SimpleAction("about" + "RSM", null);
        actionRsm.activate.connect(() => getRadarStatusMessage(radarSites[0].name));
        simpleActionGroup.add_action(actionRsm);

        da.insertActionGroup("popup", simpleActionGroup);
        return menu;
    }

    public static void showPolygonText(LatLon location) {
        var url = WXGLPolygonWarnings.show(location);
        if (url != "") {
            new AlertsDetail(url);
        }
    }

    public static void showNearestProduct(PolygonType type, LatLon location) {
        var txt = UtilityWatch.show(location, type);
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

    public static string getRadarStatusMessage(string radarSite) {
        var ridSmall = radarSite;
        var message = UtilityDownload.getRadarStatusMessage(ridSmall.ascii_up());
        if (message == "") {
            return "The current radar status for " + radarSite + " is not available.";
        } else {
            return message;
        }
    }
}
