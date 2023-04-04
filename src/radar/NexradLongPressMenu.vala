// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradLongPressMenu {

    //  public static Menu setupContextMenuNew(DrawingArea da, NexradState nexradState, LatLon latLon, FnString changeRadarSite, FnProduct fnProduct) {

    //      var longPressMenu = new LongPressMenu();

    //      var obsSite = UtilityMetar.findClosestObservation(latLon, 0);
    //      var obsString = "Show Nearest Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
    //      var item1 = new CMenuItem("Obs", obsString);
    //      longPressMenu.add(item1, () => new TextViewer(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsSite.name + ".TXT"));

    //      da.insertActionGroup("popup", longPressMenu.getAG());
    //      return longPressMenu.get();

    //      //  var menu = new Menu();
    //      //  var simpleActionGroup = new SimpleActionGroup();

    //      //  var obsSite = UtilityMetar.findClosestObservation(latLon, 0);
    //      //  var obsString = "Show Nearest Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
    //      //  menu.append(obsString, "popup.about" + "Obs");
    //      //  var actionObs = new SimpleAction("about" + "Obs", null);
    //      //  actionObs.activate.connect(() => new TextViewer(GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsSite.name + ".TXT"));
    //      //  simpleActionGroup.add_action(actionObs);

    //      //  var saveLocationString = "Save as a location: " + latLon.printPretty();
    //      //  menu.append(saveLocationString, "popup.about" + "SaveLocation");
    //      //  var actionSaveLocation = new SimpleAction("about" + "SaveLocation", null);
    //      //  actionSaveLocation.activate.connect(() => {
    //      //      Location.save(latLon, latLon.printPretty());
    //      //      Location.setMainScreenComboBox();
    //      //  });
    //      //  simpleActionGroup.add_action(actionSaveLocation);

    //      //  var radarSites = UtilityLocation.getNearestRadarSites(latLon, 5, true);
    //      //  foreach (var rid in radarSites) {
    //      //      var radarDescription = rid.name + ": " + Utility.getRadarSiteName(rid.name) + " (" + Too.String((int)(Math.round(rid.distance))) + " mi)";
    //      //      menu.append(radarDescription, "popup.about" + rid.name);
    //      //      var action = new SimpleAction("about" + rid.name, null);
    //      //      action.activate.connect(() => changeRadarSite(radarDescription.split(":")[0]));
    //      //      simpleActionGroup.add_action(action);
    //      //  }
    //      //  menu.append("Show Warning", "popup.about" + "WARN");
    //      //  var actionWarnings = new SimpleAction("about" + "WARN", null);
    //      //  actionWarnings.activate.connect(() => UtilityRadarUI.showPolygonText(latLon));
    //      //  simpleActionGroup.add_action(actionWarnings);

    //      //  menu.append("Show Watch", "popup.about" + "Watch");
    //      //  var actionWatch = new SimpleAction("about" + "Watch", null);
    //      //  actionWatch.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Watch, latLon));
    //      //  simpleActionGroup.add_action(actionWatch);

    //      //  menu.append("Show MCD", "popup.about" + "MCD");
    //      //  var actionMcd = new SimpleAction("about" + "MCD", null);
    //      //  actionMcd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mcd, latLon));
    //      //  simpleActionGroup.add_action(actionMcd);

    //      //  menu.append("Show MPD", "popup.about" + "MPD");
    //      //  var actionMpd = new SimpleAction("about" + "MPD", null);
    //      //  actionMpd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.Mpd, latLon));
    //      //  simpleActionGroup.add_action(actionMpd);
    //      //  //
    //      //  // radar products
    //      //  //
    //      //  var productList = WXGLNexrad.radarProductList;
    //      //  var prodLength = 5;
    //      //  if (WXGLNexrad.isRadarTdwr(nexradState.radarSite)) {
    //      //      productList = WXGLNexrad.radarProductListTdwr;
    //      //      prodLength = 3;
    //      //  }
    //      //  foreach (var product in productList[0:prodLength]) {
    //      //      var token = product.split(":")[0];
    //      //      menu.append(product, "popup.about" + token);
    //      //      var action = new SimpleAction("about" + token, null);
    //      //      action.activate.connect(() => fnProduct(product, nexradState.paneNumber));
    //      //      simpleActionGroup.add_action(action);
    //      //  }
    //      //  //
    //      //  // radar status message
    //      //  //
    //      //  menu.append("Radar status message: " + radarSites[0].name, "popup.about" + "RSM");
    //      //  var actionRsm = new SimpleAction("about" + "RSM", null);
    //      //  actionRsm.activate.connect(() => getRadarStatusMessage(radarSites[0].name));
    //      //  simpleActionGroup.add_action(actionRsm);

    //      //  da.insertActionGroup("popup", simpleActionGroup);
    //      //  return menu;
    //  }

    public static Menu setupContextMenu(DrawingArea da, NexradState nexradState, LatLon latLon, FnString changeRadarSite, FnProduct fnProduct) {
        var menu = new Menu();
        var simpleActionGroup = new SimpleActionGroup();

        var obsSite = Metar.findClosestObservation(latLon, 0);
        var obsString = "Observation: " + obsSite.name + " (" + Too.String((int)(Math.round(obsSite.distance))) + " mi)";
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
            var radarDescription = rid.name + " " + UtilityLocation.getRadarSiteName(rid.name) + " " + Too.String((int)(Math.round(rid.distance))) + " mi";
            menu.append(radarDescription, "popup.about" + rid.name);
            var action = new SimpleAction("about" + rid.name, null);
            action.activate.connect(() => changeRadarSite(radarDescription.split(" ")[0]));
            simpleActionGroup.add_action(action);
        }

        if (PolygonWarning.areAnyEnabled() && PolygonWarning.isCountNonZero()) {
            menu.append("Show Warning", "popup.about" + "WARN");
            var actionWarnings = new SimpleAction("about" + "WARN", null);
            actionWarnings.activate.connect(() => NexradRenderUI.showPolygonText(latLon));
            simpleActionGroup.add_action(actionWarnings);
        }

        if (PolygonWatch.byType[PolygonType.Watch].isEnabled && (PolygonWatch.byType[PolygonType.Watch].latLonList.getValue() != "" || PolygonWatch.watchLatlonCombined.getValue() != "" )) {
            menu.append("Show Watch", "popup.about" + "Watch");
            var actionWatch = new SimpleAction("about" + "Watch", null);
            actionWatch.activate.connect(() => NexradRenderUI.showNearestProduct(PolygonType.Watch, latLon));
            simpleActionGroup.add_action(actionWatch);
        }

        if (PolygonWatch.byType[PolygonType.Mcd].isEnabled && PolygonWatch.byType[PolygonType.Mcd].latLonList.getValue() != "") {
            menu.append("Show MCD", "popup.about" + "MCD");
            var actionMcd = new SimpleAction("about" + "MCD", null);
            actionMcd.activate.connect(() => NexradRenderUI.showNearestProduct(PolygonType.Mcd, latLon));
            simpleActionGroup.add_action(actionMcd);
        }

        if (PolygonWatch.byType[PolygonType.Mpd].isEnabled && PolygonWatch.byType[PolygonType.Mpd].latLonList.getValue() != "") {
            menu.append("Show MPD", "popup.about" + "MPD");
            var actionMpd = new SimpleAction("about" + "MPD", null);
            actionMpd.activate.connect(() => NexradRenderUI.showNearestProduct(PolygonType.Mpd, latLon));
            simpleActionGroup.add_action(actionMpd);
        }

        //
        // radar products
        //
        var productList = NexradUtil.radarProductList;
        var prodLength = 5;
        if (NexradUtil.isRadarTdwr(nexradState.getRadarSite())) {
            productList = NexradUtil.radarProductListTdwr;
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
        actionRsm.activate.connect(() => NexradRenderUI.showRadarStatusMessage(radarSites[0].name));
        simpleActionGroup.add_action(actionRsm);

        da.insertActionGroup("popup", simpleActionGroup);
        return menu;
    }
}
