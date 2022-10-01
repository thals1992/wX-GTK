// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class Nexrad : Window {

    HBox nexradBox = new HBox();
    HBox nexradBox2 = new HBox();
    HBox boxH = new HBox();
    VBox box = new VBox();
    HBox boxHBottom = new HBox();
    ComboBox comboboxSector = new ComboBox(GlobalArrays.getRadars());
    ComboBox comboboxProduct = new ComboBox(WXGLNexrad.radarProductList);
    ComboBox comboboxAnimCount = new ComboBox({"5", "10", "15", "20", "25", "30"});
    ComboBox comboboxAnimSpeed = new ComboBox({"10", "25", "50", "100", "200", "300", "400", "500", "600", "700", "800", "900"});
    ComboBox comboboxTilt = new ComboBox({"0", "1", "2", "3"});
    Text textFrameCount = new Text();
    Text textTilt = new Text();
    Text textAnimSpeed = new Text();
    ArrayList<UIColorLegend> colorLegends = new ArrayList<UIColorLegend>();
    const int windowSize = 800;
    //  int numberOfPanes = 1;
    int currentIndex = 0;
    StatusBar statusBar = new StatusBar();
    bool useASpecificRadar = false;
    ButtonToggle animateButton = new ButtonToggle(Icon.Play, "Animate ctrl-a");
    ButtonToggle reloadButton = new ButtonToggle(Icon.Update, "Auto Update ctrl-u");
    Button zoomOutButton = new Button(Icon.Minus, "Zoom out ctrl- -");
    Button zoomInButton = new Button(Icon.Plus, "Zoom in ctrl- +");
    Button moveLeftButton = new Button(Icon.Left, "Move left ctrl- <-");
    Button moveRightButton = new Button(Icon.Right, "Move left ctrl- ->");
    Button moveUpButton = new Button(Icon.Up, "Move up ctrl- upArrow");
    Button moveDownButton = new Button(Icon.Down, "Move down ctrl- downArrow");
    ArrayList<RadarStatusBox> radarStatusBoxList = new ArrayList<RadarStatusBox>();
    ArrayList<NexradWidget> nexradList = new ArrayList<NexradWidget>();
    Timer timer;
    ObjectAnimateNexrad objectAnimateNexrad;
    NexradLayerDownload nexradLayerDownload;
    PopoverBox popoverBox;
    SettingsNotebook settingsRadarBox = new SettingsNotebook();
    ArrayList<FutureVoid> futures = new ArrayList<FutureVoid>();

    public Nexrad(int numberOfPanes, bool useASpecificRadar, string radarToUse) {
        //  this.numberOfPanes = numberOfPanes;
        this.useASpecificRadar = useASpecificRadar;
        setTitle("Nexrad Radar");
        maximize();

        foreach (var index in range(numberOfPanes)) {
            radarStatusBoxList.add(new RadarStatusBox());
            nexradList.add(
                new NexradWidget(
                    index,
                    numberOfPanes,
                    useASpecificRadar,
                    radarToUse,
                    statusBar,
                    radarStatusBoxList.last(),
                    changeProductFromChild,
                    changeZoom,
                    changePosition,
                    downloadData,
                    syncRadarSite
                )
            );
            if (RadarPreferences.colorLegend) {
                colorLegends.add(new UIColorLegend(nexradList.last().nexradState.radarProduct));
            }
        }
        nexradLayerDownload = new NexradLayerDownload(nexradList);

        #if GTK4
            close_request.connect(() => { timer.stop(); objectAnimateNexrad.stopAnimateNoDownload(); return false; });
        #else
            destroy.connect(() => {
                timer.stop();
                objectAnimateNexrad.stopAnimateNoDownload();
            });
        #endif
        timer = new Timer(RadarPreferences.radarDataRefreshInterval * 60 * 1000, 1, autoUpdate);
        popoverBox = new PopoverBox(
            "baseline_settings_black_48dp.png",
            "Settings ctrl-p", settingsRadarBox,
            () => {
                syncRadarSite(nexradList[0].nexradState.getRadarSite(), 0, false);
                foreach (var nw in nexradList) {
                    nw.textObject.initialize();
                }

                if (RadarPreferences.colorLegend && colorLegends.size == 0) {
                    foreach (var nw in nexradList) {
                        colorLegends.add(new UIColorLegend(nw.nexradState.radarProduct));
                    }
                    nexradBox.addWidgetFirst(colorLegends.last().get());
                }
                if (!RadarPreferences.colorLegend && colorLegends.size > 0) {
                    foreach (var cl in colorLegends) {
                        cl.get().set_visible(false);
                    }
                }
                //  downloadData();
                // if auto update is on, toggle it in case of refresh interval changes
                // this will force an update as well
                if (reloadButton.getActive()) {
                    reloadButton.setActive(false);
                    reloadButton.setActive(true);
                } else {
                    downloadData();
                }
            }
        );
        settingsRadarBox.switchIndex(1);

        textFrameCount.setText("Frame Count:");
        textTilt.setText("Tilt:");
        textAnimSpeed.setText("Anim Speed:");
        //
        // Combobox  setup
        //
        comboboxSector.setIndex(GlobalArrays.findRadarIndex(nexradList[0].nexradState.getRadarSite()));
        comboboxSector.connect(changeRadarSite);

        comboboxProduct.setIndex(WXGLNexrad.findRadarProductIndex(nexradList[0].nexradState.radarProduct));
        comboboxProduct.connect(changeProduct);

        comboboxAnimCount.setIndex(Utility.readPrefInt("NEXRAD_ANIM_FRAME_COUNT", 1));
        comboboxAnimSpeed.setIndex(Utility.readPrefInt("NEXRAD_ANIM_SPEED", 4));
        comboboxTilt.setIndex(nexradList[0].nexradState.tiltInt);
        comboboxTilt.connect(changeTilt);

        reloadButton.connect(reloadClicked);
        objectAnimateNexrad = new ObjectAnimateNexrad(nexradList, comboboxAnimCount, comboboxAnimSpeed, downloadData);
        animateButton.connect(objectAnimateNexrad.animateClicked);
        comboboxAnimCount.connect(objectAnimateNexrad.setAnimationCount);
        comboboxAnimSpeed.connect(objectAnimateNexrad.setAnimationSpeed);

        zoomOutButton.connect(() => zoomOut(0));
        zoomInButton.connect(() => zoomIn(0));
        moveLeftButton.connect(moveLeft);
        moveRightButton.connect(moveRight);
        moveUpButton.connect(moveUp);
        moveDownButton.connect(moveDown);

        boxH.addWidget(popoverBox.get());
        boxH.addWidget(comboboxSector.get());
        boxH.addWidget(comboboxProduct.get());

        boxH.addWidget(moveLeftButton.get());
        boxH.addWidget(moveRightButton.get());
        boxH.addWidget(moveUpButton.get());
        boxH.addWidget(moveDownButton.get());
        boxH.addWidget(zoomOutButton.get());
        boxH.addWidget(zoomInButton.get());

        boxH.addWidget(reloadButton.get());
        boxH.addWidget(animateButton.get());
        boxH.addWidget(textFrameCount.get());
        boxH.addWidget(comboboxAnimCount.get());
        boxH.addWidget(textTilt.get());
        boxH.addWidget(comboboxTilt.get());
        boxH.addWidget(textAnimSpeed.get());
        boxH.addWidget(comboboxAnimSpeed.get());
        foreach (var statusBox in radarStatusBoxList) {
            boxH.addWidget(statusBox.get());
        }
        boxH.setHExpand(false);
        boxH.setVExpand(false);
        box.addLayout(boxH.get());
        nexradBox.setSpacing(0);
        nexradBox2.setSpacing(0);
        box.setSpacing(0);

        box.addLayout(nexradBox.get());
        nexradBox.setHExpand(true);
        nexradBox.setVExpand(true);
        if (numberOfPanes == 4) {
            box.addLayout(nexradBox2.get());
            nexradBox2.setHExpand(true);
            nexradBox2.setVExpand(true);
        }
        if (RadarPreferences.colorLegend) {
            nexradBox.addWidget(colorLegends[0].get());
        }
        nexradBox.addWidget(nexradList[0].da.get());
        nexradList[0].da.setHExpand(true);
        nexradList[0].da.setVExpand(true);
        if (numberOfPanes > 1) {
            if (RadarPreferences.colorLegend) {
                nexradBox.addWidget(colorLegends[1].get());
            }
            nexradBox.addWidget(nexradList[1].da.get());
            nexradList[1].da.setHExpand(true);
            nexradList[1].da.setVExpand(true);
        }
        if (numberOfPanes == 4) {
            if (RadarPreferences.colorLegend) {
                nexradBox2.addWidget(colorLegends[2].get());
            }
            nexradBox2.addWidget(nexradList[2].da.get());
            if (RadarPreferences.colorLegend) {
                nexradBox2.addWidget(colorLegends[3].get());
            }
            nexradBox2.addWidget(nexradList[3].da.get());
            nexradList[2].da.setHExpand(true);
            nexradList[2].da.setVExpand(true);
            nexradList[3].da.setHExpand(true);
            nexradList[3].da.setVExpand(true);
        }
        if (RadarPreferences.radarShowStatusBar) {
            box.addLayout(boxHBottom.get());
            boxHBottom.addWidget(statusBar.get());
        }
        box.getAndShow(this);
        if (!RadarPreferences.radarShowControls) {
            moveLeftButton.setVisible(false);
            moveRightButton.setVisible(false);
            moveUpButton.setVisible(false);
            moveDownButton.setVisible(false);
            zoomOutButton.setVisible(false);
            zoomInButton.setVisible(false);
        }
        downloadData();
    }

    void syncRadarSite(string radarSite, int pane, bool resetZoom) {
        moveLeftButton.setVisible(RadarPreferences.radarShowControls);
        moveRightButton.setVisible(RadarPreferences.radarShowControls);
        moveUpButton.setVisible(RadarPreferences.radarShowControls);
        moveDownButton.setVisible(RadarPreferences.radarShowControls);
        zoomOutButton.setVisible(RadarPreferences.radarShowControls);
        zoomInButton.setVisible(RadarPreferences.radarShowControls);

        statusBar.visible = RadarPreferences.radarShowStatusBar;

        if (RadarPreferences.dualpaneshareposn) {
            foreach (var nw in nexradList) {
                nw.nexradState.setRadar(radarSite);
                if (resetZoom) {
                    nw.nexradState.reset();
                }
                nw.nexradDraw.initGeom();

            }
        } else {
            nexradList[pane].nexradState.setRadar(radarSite);
            if (resetZoom) {
                nexradList[pane].nexradState.reset();
            }
            nexradList[pane].nexradDraw.initGeom();
        }
    }

    void downloadData() {
        var allDone = true;
        foreach (var f in futures) {
            if (!f.isFinished()) {
                allDone = false;
            }
        }
        if (allDone) {
            print("Nexrad: clear futures\n");
            futures.clear();
        }
        foreach (var nw in nexradList) {
            futures.add(new FutureVoid(nw.downloadData, nw.update));
        }
        comboboxSector.block();
        comboboxSector.setIndex(GlobalArrays.findRadarIndex(nexradList[0].nexradState.getRadarSite()));
        comboboxSector.unblock();
        nexradLayerDownload.downloadLayers();
    }

    void changeRadarSite() {
        objectAnimateNexrad.stopAnimateNoDownload();
        var site = comboboxSector.getValue();
        var radarSite = site.split(":")[0];
        syncRadarSite(radarSite, currentIndex, true);
        downloadData();
    }

    void changeProduct() {
        objectAnimateNexrad.stopAnimateNoDownload();
        var prod = comboboxProduct.getValue();
        if (RadarPreferences.colorLegend) {
            colorLegends[0].update(prod);
        }
        nexradList[0].changeProduct(prod);
        nexradList[0].updateStatusBar();
    }

    void changeProductFromChild(string productF, int currentIndex) {
        objectAnimateNexrad.stopAnimateNoDownload();
        var product = productF.split(":")[0];
        if (currentIndex == 0 && !WXGLNexrad.isProductTdwr(product)) {
            comboboxProduct.setIndex(WXGLNexrad.findRadarProductIndex(product));
        } else {
            if (RadarPreferences.colorLegend) {
                colorLegends[currentIndex].update(product);
            }
            nexradList[currentIndex].changeProduct(product);
        }
    }

    void changeTilt() {
        var tilt = comboboxTilt.getIndex();
        if (tilt != nexradList[0].nexradState.tiltInt ) {
            foreach (var nw in nexradList) {
                nw.nexradState.tiltInt = tilt;
            }
            downloadData();
        }
    }

    void zoomOut(int pane) {
        changeZoom(0.77, pane);
    }

    void zoomIn(int pane) {
        changeZoom(1.33, pane);
    }

    void changeZoom(double changeAmount, int paneIndex) {
        var factor = changeAmount;
        if (RadarPreferences.dualpaneshareposn) {
            foreach (var nw in nexradList) {
                var oldZoom = nw.nexradState.zoom;
                nw.nexradState.zoom *= factor;
                var newZoom = nw.nexradState.zoom;
                var zoomDifference = newZoom / oldZoom;
                nw.nexradState.xPos *= zoomDifference;
                nw.nexradState.yPos *= zoomDifference;
            }
        } else {
            var oldZoom = nexradList[paneIndex].nexradState.zoom;
            nexradList[paneIndex].nexradState.zoom *= factor;
            var newZoom = nexradList[paneIndex].nexradState.zoom;
            var zoomDifference = newZoom / oldZoom;
            nexradList[paneIndex].nexradState.xPos *= zoomDifference;
            nexradList[paneIndex].nexradState.yPos *= zoomDifference;
        }
        drawAndSave();
    }

    void changePosition(double x, double y, int paneIndex) {
        if (RadarPreferences.dualpaneshareposn) {
            foreach (var nw in nexradList) {
                nw.nexradState.xPos += x;
                nw.nexradState.yPos += y;
            }
        } else {
            nexradList[paneIndex].nexradState.xPos += x;
            nexradList[paneIndex].nexradState.yPos += y;
        }
        drawAndSave();
    }

    void reloadClicked() {
        objectAnimateNexrad.stopAnimateNoDownload();
        if (reloadButton.getActive()) {
            UtilityLog.d("reloadClicked: auto update start");
            timer.setSpeed(RadarPreferences.radarDataRefreshInterval * 60 * 1000);
            timer.start();
            setTitle("Auto update [on], interval " + Too.String(RadarPreferences.radarDataRefreshInterval) + ", last update: " + ObjectDateTime.getLocalTimeAsStringForNexradTitle());
            downloadData();
        } else {
            UtilityLog.d("reloadClicked: auto update stop\n");
            timer.stop();
            setTitle("Nexrad Radar");
        }
    }

    void autoUpdate() {
        setTitle("Auto update [on], interval " + Too.String(RadarPreferences.radarDataRefreshInterval) + ", last update: " + ObjectDateTime.getLocalTimeAsStringForNexradTitle());
        downloadData();
    }

    void moveLeft() {
        changePosition(20.0, 0.0, 0);
    }

    void moveRight() {
        changePosition(-20.0, 0.0, 0);
    }

    void moveUp() {
        changePosition(0.0, 20.0, 0);
    }

    void moveDown() {
        changePosition(0.0, -20.0, 0);
    }

    void drawAndSave() {
        foreach (var nw in nexradList) {
            nw.draw();
            nw.textObject.add();
            nw.nexradState.writePreferences();
        }
    }

    protected override void processEscape() {
        timer.stop();
        objectAnimateNexrad.stopAnimateNoDownload();
    }

    protected override void processKey(uint keyval) {
        switch (keyval) {
            case Gdk.Key.j, Gdk.Key.Left:
                moveLeft();
                break;
            case Gdk.Key.Up:
                moveUp();
                break;
            case Gdk.Key.k, Gdk.Key.Right:
                moveRight();
                break;
            case Gdk.Key.n, Gdk.Key.Down:
                moveDown();
                break;
            case Gdk.Key.equal:
                zoomIn(0);
                break;
            case Gdk.Key.minus:
                zoomOut(0);
                break;
            case Gdk.Key.w:
                timer.stop();
                objectAnimateNexrad.stopAnimateNoDownload();
                close();
                break;
            case Gdk.Key.p:
                popoverBox.popup();
                break;
            case Gdk.Key.u:
                if (reloadButton.getActive()) {
                    reloadButton.setActive(false);
                } else {
                    reloadButton.setActive(true);
                }
                break;
            case Gdk.Key.a:
                if (animateButton.getActive()) {
                    animateButton.setActive(false);
                } else {
                    animateButton.setActive(true);
                }
                #if GTK4
                    objectAnimateNexrad.animateClicked();
                #endif
                break;
            case Gdk.Key.r:
                changeProductFromChild("N0Q", 0);
                break;
            case Gdk.Key.v:
                changeProductFromChild("N0U", 0);
                break;
            case Gdk.Key.t:
                changeProductFromChild("EET", 0);
                break;
            case Gdk.Key.l:
                changeProductFromChild("DVL", 0);
                break;
            case Gdk.Key.c:
                changeProductFromChild("N0C", 0);
                break;
            default:
                break;
        }
    }
}
