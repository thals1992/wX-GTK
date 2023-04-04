// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class MainWindow : Gtk.ApplicationWindow {

    ComboBox comboBox = new ComboBox(Location.listOfNames());
    SevenDay sevenDay = new SevenDay();
    CurrentConditions currentConditions = new CurrentConditions();
    Hazards hazards = new Hazards();
    SevenDayCollection sevenDayCollection;
    CardCurrentConditions cardCurrentConditions;
    CardHazards cardHazards;
    VBox box = new VBox();
    VBox boxCc = new VBox();
    VBox boxSevenDay = new VBox();
    VBox boxHazards = new VBox();
    Toolbar toolbar;
    bool initializedCc = false;
    bool initialized7Day = false;
    HBox layout = new HBox();
    VBox imageLayout = new VBox();
    VBox forecastLayout = new VBox();
    VBox rightMostLayout = new VBox();
    #if GTK4
        Gtk.EventControllerKey controller = new Gtk.EventControllerKey();
    #endif
    HashMap<string, Image> imageWidgets = new HashMap<string, Image>();
    HashMap<string, Text> textWidgets = new HashMap<string, Text>();
    string tokenString = "";
    int imageSize = UIPreferences.mainScreenImageSize;
    ArrayList<NexradWidget> nexradList = new ArrayList<NexradWidget>();
    //
    // Mini SevereDashboard
    //
    HBox boxSevereDashboard = new HBox();
    ArrayList<string> urls = new ArrayList<string>();
    ArrayList<Image> images = new ArrayList<Image>();
    HashMap<PolygonType, SevereNotice> watchesByType = new HashMap<PolygonType, SevereNotice>();
    ArrayList<WByteArray> bytesList = new ArrayList<WByteArray>();
    Mutex mutex = Mutex();

    public MainWindow(Gtk.Application application) {
        GLib.Object(application: application);
        UtilityUI.maximize(this);

        #if GTK4
            ((Gtk.Widget)this).add_controller(controller);
            controller.key_pressed.connect(window_key_pressed);
        #else
            try {
                this.icon = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + "wx_launcher.png");
            } catch (Error e) {
                print("Error " + e.message + "\n");
            }
        #endif

        toolbar = new Toolbar(reload);
        comboBox.setIndex(Location.getCurrentLocation());
        comboBox.connect(comboBoxChanged);
        Location.comboBox = comboBox;

        watchesByType[PolygonType.Watch] = new SevereNotice(PolygonType.Watch);
        watchesByType[PolygonType.Mcd] = new SevereNotice(PolygonType.Mcd);
        watchesByType[PolygonType.Mpd] = new SevereNotice(PolygonType.Mpd);

        addWidgets();

        layout.addLayout(toolbar);
        box.addLayout(boxSevereDashboard);
        forecastLayout.hExpand();

        box.addLayout(layout);
        layout.addLayout(imageLayout);
        layout.addLayout(forecastLayout);
        layout.addLayout(rightMostLayout);

        forecastLayout.addWidget(comboBox);
        forecastLayout.addLayout(boxCc);
        forecastLayout.addLayout(boxHazards);
        forecastLayout.addLayout(boxSevenDay);
        new ScrolledWindow(this, box);

        reload();
    }

    void comboBoxChanged() {
        if (comboBox.getIndex() != -1) {
            this.locationChanged();
        }
    }

    void locationChanged() {
        Location.setCurrentLocation(comboBox.getIndex());
        reload();
    }

    void reload() {
        mutex.lock();
        configChangeCheck();
        new FutureVoid(getCC, updateCc);
        new FutureVoid(getHazards, updateHazards);
        new FutureVoid(get7Day, update7Day);
        if (!UtilityUI.isScreenSmall()) {
            foreach (var item in UIPreferences.homeScreenItemsText) {
                if (item.isEnabled()) {
                    new FutureText(item.prefToken, textWidgets[item.prefToken].setText);
                }
            }
            foreach (var item in UIPreferences.homeScreenItemsImage) {
                if (item.isEnabled()) {
                    new FutureBytes(DownloadImage.byProduct(item.prefToken), imageWidgets[item.prefToken].setBytes);
                }
            }
            if (UIPreferences.nexradMainScreen) {
                var pane = 0;
                nexradList[pane].nexradState.setRadar(Location.radarSite());
                nexradList[pane].nexradState.reset();
                nexradList[pane].nexradState.zoom = 0.6;
                nexradList[pane].nexradDraw.initGeom();

                foreach (var nw in nexradList) {
                    new FutureVoid(nw.downloadData, nw.update);
                }
            }
            if (UIPreferences.mainScreenSevereDashboard) {
                new FutureVoid(downloadWatch, updateWatch);
            } else {
                boxSevereDashboard.removeChildren();
            }
        }
        mutex.unlock();
    }

    void downloadWatch() {
        urls.clear();
        foreach (var t in new PolygonType[]{PolygonType.Mcd, PolygonType.Mpd, PolygonType.Watch}) {
            PolygonWatch.byType[t].download();
        }
        urls.add(DownloadImage.byProduct("USWARN"));
        urls.add(DownloadImage.byProduct("STRPT"));
        foreach (var t in new PolygonType[]{PolygonType.Watch, PolygonType.Mcd, PolygonType.Mpd}) {
            PolygonWatch.byType[t].download();
            watchesByType[t].getBitmaps();
            urls.add_all(watchesByType[t].urls);
        }
        foreach (var index in range(urls.size)) {
            bytesList.add(new WByteArray.fromArray(UtilityIO.downloadAsByteArray(urls[index])));
        }
    }

    void updateWatch() {
        boxSevereDashboard.removeChildren();
        images.clear();
        foreach (var index in range(urls.size)) {
            images.add(new Image.withIndex(index));
            images[index].imageSize = 150;
            images[index].setBytes(bytesList[index].data);
            images[index].connect(launch);
            boxSevereDashboard.addWidget(images[index]);
        }
    }

    void launch(int indexFinal) {
        if (indexFinal == 0) {
            new UsAlerts();
        } else if (indexFinal == 1) {
            new SpcStormReports("today");
        } else if (indexFinal > 1) {
            new SpcMcdWatchMpdViewer(urls[indexFinal]);
        }
    }

    void configChangeCheck() {
        if (tokenString != computeTokenString() || UIPreferences.mainScreenImageSize != imageSize) {
            addWidgets();
        }
    }

    void get7Day() {
        sevenDay.process(Location.getLatLonCurrent());
    }

    void getCC() {
        currentConditions.process(Location.getLatLonCurrent(), 0);
        currentConditions.timeCheck();
    }

    void getHazards() {
        hazards.process(Location.getLatLonCurrent());
    }

    void updateCc() {
        if (!initializedCc) {
            cardCurrentConditions = new CardCurrentConditions(currentConditions);
            boxCc.addLayout(cardCurrentConditions);
            initializedCc = true;
        } else {
            cardCurrentConditions.update(currentConditions);
        }
    }

    void update7Day() {
        if (!initialized7Day || sevenDayCollection.cards.size == 0) {
            sevenDayCollection = new SevenDayCollection(boxSevenDay, sevenDay);
            initialized7Day = true;
        } else {
            sevenDayCollection.update();
        }
    }

    void updateHazards() {
        boxHazards.removeChildren();
        cardHazards = new CardHazards(hazards);
        boxHazards.addLayout(cardHazards);
    }

    void addWidgets() {
        if (UIPreferences.nexradMainScreen) {
            var sb = new StatusBar( );
            var rsb = new RadarStatusBox();
            nexradList.add(
                new NexradWidget(
                    0,
                    1,
                    true,
                    Location.radarSite(),
                    sb,
                    rsb,
                    () => {},
                    () => {},
                    () => {},
                    () => {},
                    () => {}
                )
            );
        }
        imageLayout.removeChildren();
        rightMostLayout.removeChildren();
        imageWidgets.clear();
        textWidgets.clear();
        tokenString = "";
        if (UIPreferences.mainScreenSevereDashboard) {
            boxSevereDashboard.removeChildren();
        }
        //
        // nexrad
        //
        if (UIPreferences.nexradMainScreen) {
            nexradList[0].da.setSizeRequest(UIPreferences.mainScreenImageSize, UIPreferences.mainScreenImageSize);
            imageLayout.addWidget(nexradList[0].da);
            foreach (var nw in nexradList) {
                nw.nexradDraw.initGeom();
            }
            tokenString += "NEXRAD_MAIN";
        }
        //
        // image setup
        //
        var imageIndex = 0;
        foreach (var item in UIPreferences.homeScreenItemsImage) {
            if (item.isEnabled()) {
                imageWidgets[item.prefToken] = new Image.withIndex(imageIndex);
                imageWidgets[item.prefToken].connect(launchImageScreen);
                imageWidgets[item.prefToken].imageSize = UIPreferences.mainScreenImageSize;
                imageLayout.addWidget(imageWidgets[item.prefToken]);
                tokenString += item.prefToken;
            }
            imageSize = UIPreferences.mainScreenImageSize;
            imageIndex += 1;
        }
        //
        // Textual right side bar (hourly)
        //
        foreach (var item in UIPreferences.homeScreenItemsText) {
            if (item.isEnabled()) {
                textWidgets[item.prefToken] = new Text();
                textWidgets[item.prefToken].setFixedWidth();
                rightMostLayout.addWidget(textWidgets[item.prefToken]);
                tokenString += item.prefToken;
            }
        }
    }

    string computeTokenString() {
        var tokenString = "";
        if (UIPreferences.nexradMainScreen) {
            tokenString += "NEXRAD_MAIN";
        }
        foreach (var item in UIPreferences.homeScreenItemsImage) {
            if (item.isEnabled()) {
                tokenString += item.prefToken;
            }
        }
        foreach (var item in UIPreferences.homeScreenItemsText) {
            if (item.isEnabled()) {
                tokenString += item.prefToken;
            }
        }
        return tokenString;
    }

    #if GTK4
        bool window_key_pressed(Gtk.EventControllerKey controller, uint keyval, uint keycode, Gdk.ModifierType state) {
            return windowKeyPressedCommon(keyval, state);
        }
    #else
        // GTK3
        protected override bool key_press_event(Gdk.EventKey event) {
            return windowKeyPressedCommon(event.keyval, event.state);
        }
    #endif

    bool windowKeyPressedCommon(uint keyval, Gdk.ModifierType state) {
        if (keyval == Gdk.Key.Escape) {
            close();
            return true;
        }
        var default_modifiers = Gtk.accelerator_get_default_mod_mask();
        if ((state & default_modifiers) == Gdk.ModifierType.CONTROL_MASK) {
            switch (keyval) {
                case Gdk.Key.q:
                    close();
                    break;
                case Gdk.Key.h:
                    new Hourly();
                    break;
                case Gdk.Key.a:
                    new WfoText();
                    break;
                case Gdk.Key.b:
                    new Rtma();
                    break;
                case Gdk.Key.l:
                    Route.lightning();
                    break;
                case Gdk.Key.c:
                    new GoesViewer("");
                    break;
                case Gdk.Key.f:
                    new SpcFireSummary();
                    break;
                case Gdk.Key.s:
                    new SpcSwoSummary();
                    break;
                case Gdk.Key.z:
                    new SpcMeso();
                    break;
                case Gdk.Key.i:
                    new NationalImages();
                    break;
                case Gdk.Key.d:
                    new SevereDashboard();
                    break;
                case Gdk.Key.o:
                    new Nhc();
                    break;
                case Gdk.Key.u:
                    reload();
                    break;
                case Gdk.Key.m:
                    new RadarMosaicNws();
                    break;
                case Gdk.Key.n:
                    new ModelViewer("NCEP");
                    break;
                case Gdk.Key.t:
                    new NationalText("");
                    break;
                case Gdk.Key.r:
                    new Nexrad(1, false, "");
                    break;
                case Gdk.Key.@1:
                    new Nexrad(1, false, "");
                    break;
                case Gdk.Key.@2:
                    new Nexrad(2, false, "");
                    break;
                case Gdk.Key.@4:
                    new Nexrad(4, false, "");
                    break;
                case Gdk.Key.p:
                    toolbar.settingsPopoverBox.popup();
                    break;
                case Gdk.Key.v:
                    new ObservationSites();
                    break;
                default:
                    break;
            }
        }
        return true;
    }

    void launchImageScreen(int index) {
        var token = UIPreferences.homeScreenItemsImage[index].prefToken;
        if (token == "VISIBLE_SATELLITE") {
            new GoesViewer("");
        } else if (token == "RADAR_MOSAIC") {
            new RadarMosaicNws();
        } else if (token == "ANALYSIS_RADAR_AND_WARNINGS") {
            new NationalImages();
        } else if (token == "USWARN") {
            new UsAlerts();
        } else if (token == "RTMA_TEMP") {
            new Rtma();
        }
    }
}
