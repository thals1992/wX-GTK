// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradWidget {

    int totalBins = 0;
    NexradLevelData levelData;
    public FileStorage fileStorage = new FileStorage();
    public ArrayList<double?> stiList = new ArrayList<double?>();
    ArrayList<double?> wbLines = new ArrayList<double?>();
    ArrayList<double?> wbGustLines = new ArrayList<double?>();
    ArrayList<WbData> windBarbCirclesTransformed = new ArrayList<WbData>();
    ArrayList<int> windBarbCircleColors = new ArrayList<int>();
    ArrayList<double?> hiRawData = new ArrayList<double?>();
    ArrayList<ArrayList<double?>> hiPolygons = new ArrayList<ArrayList<double?>>();
    ArrayList<double?> tvsRawData = new ArrayList<double?>();
    ArrayList<ArrayList<double?>> tvsPolygons = new ArrayList<ArrayList<double?>>();
    HashMap<int, WarnData> swoLinesMap = new HashMap<int, WarnData>();
    HashMap<PolygonType, WarnData> polygons = new HashMap<PolygonType, WarnData>();
    //  HashMap<PolygonType, int> polygonBufferSize = new HashMap<PolygonType, int>();
    public DrawingArea da = new DrawingArea();
    bool dragInProgress = false;
    double dragLastX = 0.0;
    double dragLastY = 0.0;
    public NexradRenderTextObject textObject;
    public NexradState nexradState;
    public NexradDraw nexradDraw;
    #if GTK4
        Gtk.EventControllerScroll controllerScroll;
        Gtk.GestureDrag controllerDrag;
        Gtk.GestureClick controllerClick;
        Gtk.GestureLongPress controllerLongPress;
        bool clickHappened;
    #endif
    unowned FnProduct fnProduct;
    unowned FnZoom fnZoom;
    unowned FnPosition fnPosition;
    unowned FnMasterDownload fnMasterDownload;
    unowned FnSyncRadarSite fnSyncRadarSite;
    StatusBar statusBar;
    RadarStatusBox radarStatusBox;
    bool lastFrameWasAnimation = false;
    int toggleIndex = 0;
    bool hideRadar = false;
    bool hideRoads = false;

    public NexradWidget(
        int paneNumber,
        int numberOfPanes,
        bool useASpecificRadar,
        string radarToUse,
        StatusBar statusBar,
        RadarStatusBox radarStatusBox,
        FnProduct fnProduct,
        FnZoom fnZoom,
        FnPosition fnPosition,
        FnMasterDownload fnMasterDownload,
        FnSyncRadarSite fnSyncRadarSite
    ) {
        this.statusBar = statusBar;
        this.radarStatusBox = radarStatusBox;
        this.fnProduct = fnProduct;
        this.fnZoom = fnZoom;
        this.fnPosition = fnPosition;
        this.fnMasterDownload = fnMasterDownload;
        this.fnSyncRadarSite = fnSyncRadarSite;

        nexradState = new NexradState(paneNumber, numberOfPanes, useASpecificRadar, radarToUse);
        levelData = new NexradLevelData(nexradState, fileStorage);
        textObject = new NexradRenderTextObject(numberOfPanes, nexradState, fileStorage);
        nexradDraw = new NexradDraw(nexradState, fileStorage, textObject);

        radarStatusBox.connect(toggleRadar);
        nexradDraw.initGeom();
        da.connect(drawRadar);

        // pinch zoom?
        // controllerZoom = new Gtk.GestureZoom();
        //  controllerZoom = new Gtk.GestureZoom(da.get()); // GTK4_DELETE
        //  controllerZoom.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        //  controllerZoom.scale_changed.connect((delta_x) => {
        //      print(delta_x.to_string() + "\n");
        //  });
        // da.add_controller(controllerZoom);

        #if GTK4
            controllerScroll = new Gtk.EventControllerScroll(Gtk.EventControllerScrollFlags.VERTICAL);
            controllerScroll.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
            controllerScroll.scroll.connect((delta_x, delta_y) => {
                var up = 1.33;
                var down = 0.77;
                if (UIPreferences.nexradScrollWheelMotion) {
                    up = 0.77;
                    down = 1.33;
                }
                if (delta_y > 0.0) {
                    fnZoom(up, nexradState.paneNumber);;
                } else {
                    fnZoom(down, nexradState.paneNumber);;
                }
                return false;
            });
            da.add_controller(controllerScroll);

            controllerClick = new Gtk.GestureClick();
            controllerClick.pressed.connect((pressCount, delta_x, delta_y) => {
                onClickPressed(pressCount, delta_x, delta_y);
            });
            controllerClick.released.connect((pressCount, delta_x, delta_y) => {
                onClickReleased(pressCount, delta_x, delta_y);
            });
            controllerClick.stopped.connect(() => {
                onClickStopped();
            });
            da.add_controller(controllerClick);

            controllerDrag = new Gtk.GestureDrag();
            controllerDrag.drag_begin.connect((pressCount, delta_x, delta_y) => {
                onDragBegin(delta_x, delta_y);
            });
            controllerDrag.drag_end.connect((delta_x, delta_y) => {
                onDragEnd(delta_x, delta_y);
            });
            controllerDrag.drag_update.connect((delta_x, delta_y) => {
                onDragUpdate(delta_x, delta_y);
            });
            da.add_controller(controllerDrag);

            controllerLongPress = new Gtk.GestureLongPress();
            controllerLongPress.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
            controllerLongPress.pressed.connect((delta_x, delta_y) => {
                gestureLongPress(delta_x, delta_y);
            });
            da.add_controller(controllerLongPress);
        #else
            da.addEvents(Gdk.EventMask.BUTTON_PRESS_MASK);
            da.connectButtonPress(mousePressEvent);

            da.addEvents(Gdk.EventMask.BUTTON_RELEASE_MASK);
            da.connectButtonRelease(mouseReleaseEvent);

            da.addEvents(Gdk.EventMask.POINTER_MOTION_MASK);
            da.connectMotionNotify(mouseMoveEvent);

            da.addEvents(Gdk.EventMask.BUTTON3_MOTION_MASK);

            da.addEvents(Gdk.EventMask.SCROLL_MASK);
            da.connectScroll(wheelEvent);
        #endif

    }

    #if GTK4
        void onClickPressed(int numClicks, double x, double y) {
            clickHappened = true;
        }

        void onClickReleased(int numClicks, double x, double y) {
            if (clickHappened) {
                fnZoom(0.77, nexradState.paneNumber);;
            }
            clickHappened = false;
        }

        void onClickStopped() {
            clickHappened = false;
        }

        void onDragBegin(double x, double y) {
            dragInProgress = true;
            dragLastX = x;
            dragLastY = y;
        }

        void onDragUpdate(double x, double y) {
            if (dragInProgress) {
                fnPosition(x * 0.25, y * 0.25, nexradState.paneNumber);
            }
        }

        void onDragEnd(double x, double y) {
            dragInProgress = false;
            nexradState.writePreferences();
        }

        void gestureLongPress(double xPoint, double yPoint) {
            dragInProgress = false;
            var latLon = NexradRenderUI.getLatLonFromScreenPosition(nexradState, xPoint, yPoint);
            var menu = NexradLongPressMenu.setupContextMenu(da, nexradState, latLon, changeRadarSite, fnProduct);
            var popover = new Gtk.PopoverMenu.from_model(menu);
            popover.set_parent(da.getView());
            popover.set_position(Gtk.PositionType.BOTTOM);
            var rectangle = Gdk.Rectangle();
            rectangle.x = (int)xPoint;
            rectangle.y = (int)yPoint;
            rectangle.width = 1;
            rectangle.height = 1;
            popover.set_pointing_to(rectangle);
            popover.popup();
        }
    #endif

    #if GTK4
    void drawRadar(Gtk.DrawingArea da1, Cairo.Context ctx, int w, int h) {
    #else
    bool drawRadar(Cairo.Context ctx) {
    #endif
        nexradState.windowWidth = da.width;
        nexradState.windowHeight = da.height;
        textObject.glViewWidth = nexradState.windowWidth;
        textObject.glViewHeight = nexradState.windowHeight;
        nexradDraw.initSurface(ctx);
        if (!hideRadar) {
            var j = 0;
            var c = 0;
            if (levelData != null && levelData.radarBuffers != null && levelData.radarBuffers.initialized) {
                for (int i = 0; i < totalBins; i++) {
                    if (levelData.radarBuffers.initialized) {
                        var red = levelData.radarBuffers.colorGL[c] / 255.0f;
                        var green = levelData.radarBuffers.colorGL[c + 1] / 255.0f;
                        var blue = levelData.radarBuffers.colorGL[c + 2] / 255.0f;
                        ctx.set_source_rgb(red, green, blue);
                        ctx.set_line_width(0.0);
                        var x1 = levelData.radarBuffers.floatGL[j];
                        var y1 = levelData.radarBuffers.floatGL[j + 1];
                        var x2 = levelData.radarBuffers.floatGL[j + 2];
                        var y2 = levelData.radarBuffers.floatGL[j + 3];
                        var x3 = levelData.radarBuffers.floatGL[j + 4];
                        var y3 = levelData.radarBuffers.floatGL[j + 5];
                        var x4 = levelData.radarBuffers.floatGL[j + 6];
                        var y4 = levelData.radarBuffers.floatGL[j + 7];
                        ctx.move_to(x1, y1);
                        ctx.line_to(x2, y2);
                        ctx.line_to(x3, y3);
                        ctx.line_to(x4, y4);
                        ctx.close_path();
                        ctx.fill();
                        j += 8;
                        c += 3;
                    }
                }
            }
        }
        if (nexradState.zoom > 0.9) {
            if (RadarPreferences.county) {
                nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.CountyLines);
            }
            if (!hideRoads) {
                if (RadarPreferences.highways) {
                    nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.HwLines);
                }
                if (RadarPreferences.hwEnhExt) {
                    nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.HwExtLines);
                }
            }
            if (RadarPreferences.lakes) {
                nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.LakeLines);
            }
        }
        nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.StateLines);
        if (RadarPreferences.caBorders) {
            nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.CaLines);
        }
        if (RadarPreferences.mxBorders) {
            nexradDraw.drawGeomLine(ctx, RadarGeometryTypeEnum.MxLines);
        }
        if (RadarPreferences.locationDot) {
            nexradDraw.drawGenericCircles(ctx, RadarPreferences.locdotSize, fileStorage.locationDotsColor, fileStorage.locationDotsTransformed);
        }
        if (RadarPreferences.sti) {
            drawSti(ctx);
        }
        if (RadarPreferences.obsWindbarbs) {
            drawWindBarbs(ctx);
        }
        drawWatch(ctx);
        drawWarnings(ctx);
        if (RadarPreferences.swo) {
            drawSwo(ctx);
        }
        if (RadarPreferences.wpcFronts) {
            drawWpcFronts(ctx);
        }
        if (RadarPreferences.hailIndex) {
            nexradDraw.drawTriangle(ctx, hiPolygons, Color.greenInt);
        }
        if (RadarPreferences.tvs) {
            nexradDraw.drawTriangle(ctx, tvsPolygons, Color.redInt);
        }
        if (RadarPreferences.cities && nexradState.zoom > 0.5) {
            nexradDraw.drawText(ctx, RadarPreferences.colorCity, nexradState.cities);
        }
        if (RadarPreferences.wpcFronts && nexradState.zoom < nexradState.zoomToHideMiscFeatures) {
            nexradDraw.drawText(ctx, Color.redInt, nexradState.pressureCenterLabelsRed);
            nexradDraw.drawText(ctx, Color.rgb(0, 0, 255), nexradState.pressureCenterLabelsBlue);
        }
        if (RadarPreferences.countyLabels && nexradState.zoom > 0.9) {
            nexradDraw.drawText(ctx, RadarPreferences.colorCountyLabels, nexradState.countyLabels);
        }
        if (RadarPreferences.obs && nexradState.zoom > 0.5) {
            nexradDraw.drawText(ctx, RadarPreferences.colorObs, nexradState.observations);
        }
        #if GTK4
        #else
            return true;
        #endif
    }

    void drawSwo(Cairo.Context ctx) {
        foreach (var riskLevelIndex in range(SwoDayOne.threatList.length)) {
            if (SwoDayOne.hashSwo.has_key(riskLevelIndex) && SwoDayOne.hashSwo[riskLevelIndex].size > 0 && swoLinesMap.has_key(riskLevelIndex)) {
                var color = SwoDayOne.swoPaints[riskLevelIndex];
                nexradDraw.drawGenericLine(ctx, RadarPreferences.watmcdLinesize, color, swoLinesMap[riskLevelIndex].data);
            }
        }
    }

    void drawWpcFronts(Cairo.Context ctx) {
        if (nexradState.zoom < 0.5 && WpcFronts.fronts != null) {
            foreach (var it in WpcFronts.fronts) {
                if (it.coordinatesModified[nexradState.paneNumber] != null) {
                    nexradDraw.drawGenericLine(ctx,
                        RadarPreferences.watmcdLinesize,
                        it.penColor,
                        it.coordinatesModified[nexradState.paneNumber]
                    );
                }
            }
        }
    }

    void drawWarnings(Cairo.Context ctx) {
        foreach (var it in PolygonWarning.polygonList) {
            if (PolygonWarning.byType[it] != null && PolygonWarning.byType[it].isEnabled && polygons.keys.contains(it)) {
                nexradDraw.drawGenericLine(ctx,
                    RadarPreferences.warnLinesize,
                    PolygonWarning.byType[it].colorInt,
                    polygons[it].data
                );
            }
        }
    }

    void drawWatch(Cairo.Context ctx) {
        foreach (var type1 in PolygonWatch.polygonList) {
            if (PolygonWatch.byType[type1].isEnabled && polygons.keys.contains(type1)) {
                nexradDraw.drawGenericLine(ctx,
                    RadarPreferences.watmcdLinesize,
                    PolygonWatch.byType[type1].colorInt,
                    polygons[type1].data
                );
            }
        }
    }

    void drawSti(Cairo.Context ctx) {
        nexradDraw.drawGenericLine(ctx, RadarPreferences.stiLinesize, Color.rgb(255, 255, 255), stiList);
    }

    void drawWindBarbs(Cairo.Context ctx) {
        nexradDraw.drawGenericLine(ctx, RadarPreferences.wbLinesize, Color.rgb(255, 0, 0), wbGustLines);
        nexradDraw.drawGenericLine(ctx, RadarPreferences.wbLinesize, Color.rgb(255, 255, 255), wbLines);
        nexradDraw.drawGenericCircles(ctx, 6.0, windBarbCircleColors, windBarbCirclesTransformed);
    }

    #if GTK4
    #else
        bool mousePressEvent(Gdk.EventButton event) {
            if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3) {
                var latLon = NexradRenderUI.getLatLonFromScreenPosition(nexradState, event.x, event.y);
                var menu = NexradLongPressMenu.setupContextMenu(da, nexradState, latLon, changeRadarSite, fnProduct);
                var popover = new Gtk.Popover.from_model(da.getView(), menu);
                popover.set_position(Gtk.PositionType.BOTTOM);
                var rectangle = Gdk.Rectangle();
                rectangle.x = (int)event.x;
                rectangle.y = (int)event.y;
                rectangle.width = 1;
                rectangle.height = 1;
                popover.set_pointing_to(rectangle);
                popover.popup();
            } else if (event.type == Gdk.EventType.BUTTON_PRESS) {
                dragInProgress = true;
                dragLastX = event.x;
                dragLastY = event.y;
            } else if (event.type == Gdk.EventType.DOUBLE_BUTTON_PRESS) {
                fnZoom(1.33, nexradState.paneNumber);
            }
            return true;
        }

        bool mouseReleaseEvent(Gdk.EventButton event) {
            dragInProgress = false;
            nexradState.writePreferences();
            return false;
        }

        bool mouseMoveEvent(Gdk.EventMotion event) {
            if (dragInProgress) {
                fnPosition((event.x - dragLastX) * 0.25, (event.y - dragLastY) * 0.25, nexradState.paneNumber);
            }
            return false;
        }

        bool wheelEvent(Gdk.EventScroll event) {
            Gdk.ScrollDirection dir;
            event.get_scroll_direction(out dir);
            var up = 1.33;
            var down = 0.77;
            if (UIPreferences.nexradScrollWheelMotion) {
                up = 0.77;
                down = 1.33;
            }
            if (dir == Gdk.ScrollDirection.UP) {
                fnZoom(up, nexradState.paneNumber);
            } else if (dir == Gdk.ScrollDirection.DOWN) {
                fnZoom(down, nexradState.paneNumber);
            }
            return false;
        }
    #endif

    public void downloadData() {
        nexradState.writePreferences();
        if (GlobalArrays.tdwrRadarCodes().contains(nexradState.getRadarSite()) && !NexradUtil.isProductTdwr(nexradState.radarProduct)) {
            nexradState.radarProduct = "TZL";
        } else if (GlobalArrays.nexradRadarCodes().contains(nexradState.getRadarSite()) && NexradUtil.isProductTdwr(nexradState.radarProduct)) {
            nexradState.radarProduct = "N0Q";
        }
        var tmpRadarProduct = nexradState.radarProduct;
        if (UtilityString.match(nexradState.radarProduct, "[A-Z][0-9][A-Z]")) {
            tmpRadarProduct = UtilityString.replaceRegex(nexradState.radarProduct, "([0-3])", Too.String(nexradState.tiltInt));
        }
        var url = NexradDownload.getRadarFileUrl(nexradState.getRadarSite(), tmpRadarProduct, false);
        totalBins = 0;
        fileStorage.memoryBuffer = new MemoryBuffer.fromArray(UtilityIO.downloadAsByteArray(url));
        levelData.radarBuffers.animationIndex = -1;
        levelData.decode();
        levelData.radarBuffers.initialize();
        levelData.generateRadials();
        totalBins = levelData.totalBins;
        levelData.radarBuffers.setToPositionZero();
        lastFrameWasAnimation = false;
    }

    public void update() {
        draw();
        if (!lastFrameWasAnimation) {
            updateStatusBar();
        }
    }

    public void constructWBLines() {
        if (RadarPreferences.obs) {
            textObject.addTextLabelsObservations();
        }
        wbLines.clear();
        wbGustLines.clear();
        wbLines.add_all(NexradLevel3WindBarbs.decodeAndPlot(nexradState.getPn(), false, fileStorage));
        wbGustLines.add_all(NexradLevel3WindBarbs.decodeAndPlot(nexradState.getPn(), true, fileStorage));
        windBarbCirclesTransformed.clear();
        windBarbCircleColors.clear();
        foreach (var index in range(fileStorage.obsArrX.size)) {
            var lat = fileStorage.obsArrX[index];
            var lon = fileStorage.obsArrY[index];
            var coords = Projection.computeMercatorNumbers(lat, lon * -1.0, nexradState.getPn());
            var rawColor = fileStorage.obsArrAviationColor[index];
            windBarbCirclesTransformed.add(new WbData(coords));
            windBarbCircleColors.add(rawColor);
        }
    }

    public void process(PolygonType polygonType) {
        var numbers = Watch.add(nexradState.getPn(), polygonType);
        //  polygonBufferSize[polygonType] = numbers.size / 4;
        polygons[polygonType] = new WarnData(numbers);
    }

    public void constructSwo() {
        foreach (var riskLevelIndex in range(SwoDayOne.threatList.length)) {
            if (!swoLinesMap.has_key(riskLevelIndex)) {
                swoLinesMap[riskLevelIndex] = new WarnData.zero();
            }
            if (SwoDayOne.hashSwo.has_key(riskLevelIndex) && SwoDayOne.hashSwo[riskLevelIndex].size > 0) {
                swoLinesMap[riskLevelIndex].data.clear();
                var x = 0;
                range(SwoDayOne.hashSwo[riskLevelIndex].size / 4).foreach((unused) => {
                    var floatList = SwoDayOne.hashSwo[riskLevelIndex];
                    var coords1 = Projection.computeMercatorNumbers(floatList[x], -1.0 * floatList[x + 1], nexradState.getPn());
                    var coords2 = Projection.computeMercatorNumbers(floatList[x + 2], -1.0 * floatList[x + 3], nexradState.getPn());
                    swoLinesMap[riskLevelIndex].data.add(coords1[0]);
                    swoLinesMap[riskLevelIndex].data.add(coords1[1]);
                    swoLinesMap[riskLevelIndex].data.add(coords2[0]);
                    swoLinesMap[riskLevelIndex].data.add(coords2[1]);
                    x += 4;
                    return true;
                });
            } else {
                if (swoLinesMap.has_key(riskLevelIndex)) {
                    swoLinesMap.unset(riskLevelIndex);
                }
            }
        }
    }

    public void constructWpcFronts() {
        foreach (var front in WpcFronts.fronts) {
            front.translate(nexradState.paneNumber, nexradState.getPn());
        }
        textObject.addWpcPressureCenters();
        draw();
    }

    public void constructHi() {
        // incoming data looks like this (CBW Maine)
        // [45.89576296739614, 68.26380691924794, 45.91076296739614, 68.26380691924794, 45.92576296739614, 68.26380691924794, 45.08396212654225, 69.63299893457703]
        hiRawData.clear();
        hiRawData.add_all(fileStorage.hiData);
        generateHi();
    }

    void generateHi() {
        var lengthOrig = 10.0;
        var length = lengthOrig / nexradState.zoom;
        hiPolygons.clear();
        foreach (var index in range3(0, hiRawData.size, 2)) {
            var point0 = Projection.computeMercatorNumbers(hiRawData[index], -1.0 * hiRawData[index + 1], nexradState.getPn());
            var point1 = new ArrayList<double?>.wrap({point0[0], point0[1]});
            var point2 = new ArrayList<double?>.wrap({point0[0] - length, point0[1] - length});
            var point3 = new ArrayList<double?>.wrap({point0[0] + length, point0[1] - length});
            var sumList = new ArrayList<double?>();
            sumList.add_all(point1);
            sumList.add_all(point2);
            sumList.add_all(point3);
            hiPolygons.add(sumList);
        }
    }

    //  void resizePolygons() {
    //      generateHi();
    //      generateTvs();
    //  }

    public void constructTvs() {
        tvsRawData.clear();
        tvsRawData.add_all(fileStorage.tvsData);
        generateTvs();
    }

    void generateTvs() {
        var lengthOrig = 10.0;
        var length = lengthOrig / nexradState.zoom;
        tvsPolygons.clear();
        foreach (var index in range3(0, tvsRawData.size, 2)) {
            var point0 = Projection.computeMercatorNumbers(tvsRawData[index], -1.0 * tvsRawData[index + 1], nexradState.getPn());
            var point1 = new ArrayList<double?>.wrap({point0[0], point0[1]});
            var point2 = new ArrayList<double?>.wrap({point0[0] - length, point0[1] - length});
            var point3 = new ArrayList<double?>.wrap({point0[0] + length, point0[1] - length});
            var sumList = new ArrayList<double?>();
            sumList.add_all(point1);
            sumList.add_all(point2);
            sumList.add_all(point3);
            tvsPolygons.add(sumList);
        }
    }

    public void processVtec(PolygonType polygonGenericType) {
        var numbers = Warnings.add(nexradState.getPn(), polygonGenericType);
        polygons[polygonGenericType] = new WarnData(numbers);
    }

    public void downloadDataForAnimation(int index) {
        levelData = nexradState.levelDataList[index];
        totalBins = levelData.totalBins;
        levelData.radarBuffers.setToPositionZero();
        lastFrameWasAnimation = true;
        updateStatusBarForAnimation(index);
    }

    void updateStatusBarForAnimation(int index) {
        var statusTotal = "";
        var sep = "";
        if (nexradState.numberOfPanes > 1) {
            sep = " | ";
        }
        if (nexradState.paneNumber == 0) {
            statusTotal += nexradState.levelDataList[index].radarInfo + sep;
            foreach (var polygonGenericType in PolygonWarning.polygonList) {
                if (PolygonWarning.byType[polygonGenericType].isEnabled) {
                    statusTotal += " " + polygonGenericType.to_string().replace("POLYGON_TYPE_", "").ascii_up() + ": " + Too.String(Warnings.getCount(polygonGenericType));
                }
            }
            statusBar.text = statusTotal;
        }
        updateRadarStatusIconForAnimation(index);
    }

    void updateRadarStatusIconForAnimation(int index) {
        var radarAgeString = "age: " + Too.String((int) (nexradState.levelDataList[index].radarAgeMilli / 60000.0)) + " min";
        var status = " / " + nexradState.levelDataList[index].radarInfo.split(" ")[0];
        if (NexradUtil.isRadarTimeOld(nexradState.levelDataList[index].radarAgeMilli)) {
            radarStatusBox.setOld(radarAgeString + status);
        } else {
            radarStatusBox.setCurrent(radarAgeString + status);
        }
    }

    public void updateStatusBar() {
        var statusTotal = "";
        var sep = "";
        if (nexradState.numberOfPanes > 1) {
            sep = " | ";
        }
        // TODO FIXME
        //foreach (var pane in range(nexradState.numberOfPanes)) {
        if (nexradState.paneNumber == 0) {
            statusTotal += fileStorage.radarInfo + sep;
            foreach (var polygonGenericType in PolygonWarning.polygonList) {
                if (PolygonWarning.byType[polygonGenericType].isEnabled) {
                    statusTotal += " " + polygonGenericType.to_string().replace("POLYGON_TYPE_", "").ascii_up() + ": " + Too.String(Warnings.getCount(polygonGenericType));
                }
            }
            statusBar.text = statusTotal;
        }
        updateRadarStatusIcon();
    }

    void updateRadarStatusIcon() {
        var radarAgeString = "age: " + Too.String((int) (fileStorage.radarAgeMilli / 60000.0)) + " min";
        var status = " / " + fileStorage.radarInfo.split(" ")[0];
        if (NexradUtil.isRadarTimeOld(fileStorage.radarAgeMilli)) {
            radarStatusBox.setOld(radarAgeString + status);
        } else {
            radarStatusBox.setCurrent(radarAgeString + status);
        }
    }

    void changeRadarSite(string site) {
        fnSyncRadarSite(site.split(":")[0], nexradState.paneNumber, true);
        fnMasterDownload();
    }

    public void changeProduct(string prod) {
        nexradState.radarProduct = prod.split(":")[0];
        downloadData();
        nexradState.writePreferences();
        da.draw();
    }

    void toggleRadar() {
        toggleIndex += 1;
        if (toggleIndex == 0) {
            hideRadar = false;
            hideRoads = false;
        } else if (toggleIndex == 1) {
            hideRadar = true;
            hideRoads = false;
        } else if (toggleIndex == 2) {
            hideRadar = false;
            hideRoads = true;
        } else {
            toggleIndex = 0;
            hideRadar = false;
            hideRoads = false;
        }
        draw();
    }

    public void draw() {
        da.draw();
    }
}
