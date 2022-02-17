// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradWidget {

    int totalBins = 0;
    WXMetalNexradLevelData levelData;
    string radarIndex = "0";
    public FileStorage fileStorage = new FileStorage();
    double xShift = -1.0;
    double yShift = 1.0;
    float[] stateLineRelativeBuffer;
    float[] countyLineRelativeBuffer;
    float[] hwExtLineRelativeBuffer;
    float[] lakeLineRelativeBuffer;
    float[] caLineRelativeBuffer;
    float[] mxLineRelativeBuffer;
    float[] hwLineRelativeBuffer;
    public ArrayList<double?> stiList = new ArrayList<double?>();
    ArrayList<double?> wbLines = new ArrayList<double?>();
    ArrayList<double?> wbGustLines = new ArrayList<double?>();
    ArrayList<WbData> windBarbCirclesTransformed = new ArrayList<WbData>();
    ArrayList<int> windBarbCircleColors = new ArrayList<int>();
    ArrayList<double?> hiRawData = new ArrayList<double?>();
    ArrayList<ArrayList<double?>> hiPolygons = new ArrayList<ArrayList<double?>>();
    ArrayList<double?> tvsRawData = new ArrayList<double?>();
    ArrayList<ArrayList<double?>> tvsPolygons = new ArrayList<ArrayList<double?>>();
    HashMap<int, WbData> swoLinesMap = new HashMap<int, WbData>();
    HashMap<PolygonType, WarnData> polygonToBufferMap = new HashMap<PolygonType, WarnData>();
    HashMap<PolygonType, int> polygonToColorMap = new HashMap<PolygonType, int>();
    HashMap<PolygonType, WarnData> polygonGenericToBufferMap = new HashMap<PolygonType, WarnData>();
    HashMap<PolygonType, int> polygonGenericToQColorMap = new HashMap<PolygonType, int>();
    HashMap<PolygonType, int> polygonBufferSize = new HashMap<PolygonType, int>();
    HashMap<PolygonType, int> polygonGenericBufferSize = new HashMap<PolygonType, int>();
    public DrawingArea da = new DrawingArea();
    bool dragInProgress = false;
    double dragLastX = 0.0;
    double dragLastY = 0.0;
    public WXMetalTextObject textObject;
    public NexradState nexradState;
    //  Gtk.GestureZoom controllerZoom;
    ///  Gtk.EventControllerScroll controllerScroll;
    ///  Gtk.GestureDrag controllerDrag;
    ///  Gtk.GestureClick controllerClick;
    ///  Gtk.GestureLongPress controllerLongPress;
    ///  bool clickHappened;
    public delegate void FnProduct(string s, int i);
    public delegate void FnZoom(double d, int i);
    public delegate void FnPosition(double d, double d1, int i);
    public delegate void FnMasterDownload();
    public delegate void FnSyncRadarSite(string s, int i, bool b);
    unowned FnProduct fnProduct;
    unowned FnZoom fnZoom;
    unowned FnPosition fnPosition;
    unowned FnMasterDownload fnMasterDownload;
    unowned FnSyncRadarSite fnSyncRadarSite;
    StatusBar statusBar;
    RadarStatusBox radarStatusBox;
    bool lastFrameWasAnimation = false;

    public NexradWidget(
        int paneNumber,
        int numberOfPanes,
        bool useASpecificRadar,
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

        nexradState = new NexradState(paneNumber, numberOfPanes, useASpecificRadar);
        radarIndex = Too.String(paneNumber);

        polygonToColorMap[PolygonType.ffw] = RadarPreferences.radarColorFfw;
        polygonToColorMap[PolygonType.tst] = RadarPreferences.radarColorTstorm;
        polygonToColorMap[PolygonType.tor] = RadarPreferences.radarColorTor;
        polygonToColorMap[PolygonType.mpd] = RadarPreferences.radarColorMpd;
        polygonToColorMap[PolygonType.mcd] = RadarPreferences.radarColorMcd;
        polygonToColorMap[PolygonType.watch] = RadarPreferences.radarColorTstormWatch;
        polygonToColorMap[PolygonType.watchTornado] = RadarPreferences.radarColorTorWatch;
        polygonGenericToQColorMap[PolygonType.ffw] = RadarPreferences.radarColorFfw;
        polygonGenericToQColorMap[PolygonType.tst] = RadarPreferences.radarColorTstorm;
        polygonGenericToQColorMap[PolygonType.tor] = RadarPreferences.radarColorTor;

        stateLineRelativeBuffer = new float[RadarGeometry.stateLines.length];
        countyLineRelativeBuffer = new float[RadarGeometry.countyLines.length];
        hwLineRelativeBuffer = new float[RadarGeometry.hwLines.length];
        hwExtLineRelativeBuffer = new float[RadarGeometry.hwExtLines.length];
        lakeLineRelativeBuffer = new float[RadarGeometry.lakeLines.length];
        caLineRelativeBuffer = new float[RadarGeometry.caLines.length];
        mxLineRelativeBuffer = new float[RadarGeometry.mxLines.length];

        textObject = new WXMetalTextObject(numberOfPanes, nexradState, fileStorage);

        da.connect(drawRadar);

        da.addEvents(Gdk.EventMask.BUTTON_PRESS_MASK);  //GTK4_DELETE
        da.connectButtonPress(mousePressEvent);  //GTK4_DELETE

        da.addEvents(Gdk.EventMask.BUTTON_RELEASE_MASK);  //GTK4_DELETE
        da.connectButtonRelease(mouseReleaseEvent);  //GTK4_DELETE

        da.addEvents(Gdk.EventMask.POINTER_MOTION_MASK);  //GTK4_DELETE
        da.connectMotionNotify(mouseMoveEvent);  //GTK4_DELETE

        da.addEvents(Gdk.EventMask.BUTTON3_MOTION_MASK);  //GTK4_DELETE

        da.addEvents(Gdk.EventMask.SCROLL_MASK);  //GTK4_DELETE
        da.connectScroll(wheelEvent);  //GTK4_DELETE

        // controllerZoom = new Gtk.GestureZoom();
        //  controllerZoom = new Gtk.GestureZoom(da.get()); //GTK4_DELETE
        //  controllerZoom.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        //  controllerZoom.scale_changed.connect((delta_x) => {
        //      print(delta_x.to_string() + "\n");
        //  });
        // da.add_controller(controllerZoom);

        ///  controllerScroll = new Gtk.EventControllerScroll(Gtk.EventControllerScrollFlags.VERTICAL);
        ///  controllerScroll.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        ///  controllerScroll.scroll.connect((delta_x, delta_y) => {
        ///      if (delta_y > 0.0) {
        ///          fnZoom(1.33, nexradState.paneNumber);;
        ///      } else {
        ///          fnZoom(0.77, nexradState.paneNumber);;
        ///      }
        ///      return false;
        ///  });
        ///  da.add_controller(controllerScroll);

        ///  controllerClick = new Gtk.GestureClick();
        ///  controllerClick.pressed.connect((pressCount, delta_x, delta_y) => {
        ///      onClickPressed(pressCount, delta_x, delta_y);
        ///  });
        ///  controllerClick.released.connect((pressCount, delta_x, delta_y) => {
        ///      onClickReleased(pressCount, delta_x, delta_y);
        ///  });
        ///  controllerClick.stopped.connect(() => {
        ///      onClickStopped();
        ///  });
        ///  da.add_controller(controllerClick);

        ///  controllerDrag = new Gtk.GestureDrag();
        ///  controllerDrag.drag_begin.connect((pressCount, delta_x, delta_y) => {
        ///      onDragBegin(delta_x, delta_y);
        ///  });
        ///  controllerDrag.drag_end.connect((delta_x, delta_y) => {
        ///      onDragEnd(delta_x, delta_y);
        ///  });
        ///  controllerDrag.drag_update.connect((delta_x, delta_y) => {
        ///      onDragUpdate(delta_x, delta_y);
        ///  });
        ///  da.add_controller(controllerDrag);

        ///  controllerLongPress = new Gtk.GestureLongPress();
        ///  controllerLongPress.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        ///  controllerLongPress.pressed.connect((delta_x, delta_y) => {
        ///      gestureLongPress(delta_x, delta_y);
        ///  });
        ///  da.add_controller(controllerLongPress);

    }

    ///  void onClickPressed(int numClicks, double x, double y) {
    ///      clickHappened = true;
    ///  }

    ///  void onClickReleased(int numClicks, double x, double y) {
    ///      if (clickHappened) {
    ///          fnZoom(0.77, nexradState.paneNumber);;
    ///      }
    ///      clickHappened = false;
    ///  }

    ///  void onClickStopped() {
    ///      clickHappened = false;
    ///  }

    ///  void onDragBegin(double x, double y) {
    ///      dragInProgress = true;
    ///      dragLastX = x;
    ///      dragLastY = y;
    ///  }

    ///  void onDragUpdate(double x, double y) {
    ///      if (dragInProgress) {
    ///          fnPosition(x * 0.25, y * 0.25, nexradState.paneNumber);
    ///      }
    ///  }

    ///  void onDragEnd(double x, double y) {
    ///      dragInProgress = false;
    ///      nexradState.writePreferences();
    ///  }

    ///  void gestureLongPress(double xPoint, double yPoint) {
    ///      dragInProgress = false;
    ///      var latLon = UtilityRadarUI.getLatLonFromScreenPosition(nexradState, nexradState.numberOfPanes, xPoint, yPoint);
    ///      var menu  = getContextMenu(latLon);
    ///      var popover  = new Gtk.PopoverMenu.from_model(menu);
    ///      popover.set_parent(da.get());
    ///      popover.set_position(Gtk.PositionType.BOTTOM);
    ///      var rectangle = Gdk.Rectangle();
    ///      rectangle.x = (int)xPoint;
    ///      rectangle.y = (int)yPoint;
    ///      rectangle.width = 1;
    ///      rectangle.height = 1;
    ///      popover.set_pointing_to(rectangle);
    ///      popover.popup();
    ///  }

    //  void gestureClickEnter(int pressCount, double xPoint, double yPoint) {
    //      if (pressCount == 1) {
    //          dragInProgress = true;
    //          dragLastX = xPoint;
    //          dragLastY = yPoint;
    //      } else if (pressCount == 2) {
    //          fnZoom(1.33, nexradState.paneNumber);;
    //      }
    //  }

    /// void drawRadar(Gtk.DrawingArea da1, Cairo.Context ctx, int w, int h) {
    bool drawRadar(Cairo.Context ctx) {  //GTK4_DELETE used to have 1st arg Gtk.Widget da,
        nexradState.windowWidth = da.getWidth();
        nexradState.windowHeight = da.getHeight();
        textObject.glViewWidth = nexradState.windowWidth;
        textObject.glViewHeight = nexradState.windowHeight;

        ctx.set_antialias(Cairo.Antialias.NONE);
        ctx.save();
        Color.setCairoColor(ctx, RadarPreferences.nexradRadarBackgroundColor);
        ctx.paint();
        ctx.restore();

        ctx.translate((nexradState.windowWidth / 2) + nexradState.xPos, (nexradState.windowHeight / 2) + nexradState.yPos);
        ctx.scale(nexradState.zoom, nexradState.zoom);

        ctx.set_line_width(1.0 / nexradState.zoom);

        var j = 0;
        var c = 0;
        if (levelData != null && levelData.radarBuffers != null && levelData.radarBuffers.initialized) {
            for (int i = 0; i < totalBins; i++) {
                if (levelData.radarBuffers.initialized) {
                    var red = levelData.radarBuffers.colorBuffer.getByIndex(c) / 255.0f;
                    var green = levelData.radarBuffers.colorBuffer.getByIndex(c + 1) / 255.0f;
                    var blue = levelData.radarBuffers.colorBuffer.getByIndex(c + 2) / 255.0f;
                    ctx.set_source_rgb(red, green, blue);
                    ctx.set_line_width(0.0);
                    var x1 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j);
                    var y1 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 4);
                    var x2 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 8);
                    var y2 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 12);
                    var x3 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 16);
                    var y3 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 20);
                    var x4 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 24);
                    var y4 = levelData.radarBuffers.floatBuffer.getFloatByIndex(j + 28);
                    ctx.move_to(x1, y1);
                    ctx.line_to(x2, y2);
                    ctx.line_to(x3, y3);
                    ctx.line_to(x4, y4);
                    ctx.close_path();
                    ctx.fill();
                    j += 32;
                    c += 3;
                }
            }
        }
        if (nexradState.zoom > 0.9) {
            if(RadarPreferences.county) {
                drawGenericLines(ctx, countyLineRelativeBuffer, RadarPreferences.radarColorCounty, RadarPreferences.countyLinesize);
            }
            if(RadarPreferences.highways) {
                drawGenericLines(ctx, hwLineRelativeBuffer, RadarPreferences.radarColorHw, RadarPreferences.hwLinesize);
            }
            if(RadarPreferences.hwEnhExt) {
                Color.setCairoColor(ctx, RadarPreferences.radarColorHwExt);
                ctx.set_line_width(RadarPreferences.hwExtLinesize / nexradState.zoom);
                for (int index = 0; index < hwExtLineRelativeBuffer.length; index += 4) {
                    ctx.move_to(hwExtLineRelativeBuffer[index], hwExtLineRelativeBuffer[index + 1]);
                    ctx.line_to(hwExtLineRelativeBuffer[index + 2], hwExtLineRelativeBuffer[index + 3]);
                    ctx.move_to(hwExtLineRelativeBuffer[index + 2], hwExtLineRelativeBuffer[index + 3]);
                }
                ctx.stroke();
            }
            if(RadarPreferences.lakes) {
                drawGenericLines(ctx, lakeLineRelativeBuffer, RadarPreferences.radarColorLakes, RadarPreferences.lakeLinesize);
            }
        }
        drawGenericLines(ctx, stateLineRelativeBuffer, RadarPreferences.radarColorState, RadarPreferences.stateLinesize);
        if(RadarPreferences.caBorders) {
            drawGenericLines(ctx, caLineRelativeBuffer, RadarPreferences.radarColorState, RadarPreferences.stateLinesize);
        }
        if(RadarPreferences.mxBorders) {
            drawGenericLines(ctx, mxLineRelativeBuffer, RadarPreferences.radarColorState, RadarPreferences.stateLinesize);
        }
        if (RadarPreferences.locationDot) {
            drawLocationDot(ctx);
        }
        if (RadarPreferences.sti) {
            drawSti(ctx);
        }
        if (RadarPreferences.obsWindbarbs) {
            drawWindBarbs(ctx);
        }
        if (RadarPreferences.mcd) {
            drawWatch(ctx, PolygonType.mcd);
        }
        if (RadarPreferences.mpd) {
            drawWatch(ctx, PolygonType.mpd);
        }
        if (RadarPreferences.watch) {
            drawWatch(ctx, PolygonType.watch);
            drawWatch(ctx, PolygonType.watchTornado);
        }
        if (RadarPreferences.warnings) {
            drawWarnings(ctx);
        }
        if (RadarPreferences.swo) {
            drawSwo(ctx);
        }
        if (RadarPreferences.wpcFronts) {
            drawWpcFronts(ctx);
        }
        if (RadarPreferences.hailIndex) {
            drawTriangle(ctx, hiPolygons, Color.greenInt);
        }
        if (RadarPreferences.tvs) {
            drawTriangle(ctx, tvsPolygons, Color.redInt);
        }
        //
        // Text labels - cities
        //
        if (RadarPreferences.cities && nexradState.zoom > 0.5) {
            ctx.set_font_size(TextViewMetal.fontSize / nexradState.zoom);
            Color.setCairoColor(ctx, RadarPreferences.radarColorCity);
            foreach (var city in nexradState.cities) {
                ctx.move_to(xShift * city.xPos, yShift * city.yPos);
                ctx.show_text(city.text);
            }
        }
        //
        // WPC Fronts
        //
        if (RadarPreferences.wpcFronts && nexradState.zoom < nexradState.zoomToHideMiscFeatures) {
            ctx.set_font_size(TextViewMetal.fontSize / nexradState.zoom);
            foreach (var tv in nexradState.pressureCenterLabelsRed) {
                ctx.set_source_rgb(1.0, 0.0, 0.0);
                ctx.move_to(xShift * tv.xPos, yShift * tv.yPos);
                ctx.show_text(tv.text);
            }
            foreach (var tv in nexradState.pressureCenterLabelsBlue) {
                ctx.set_source_rgb(0.0, 0.0, 1.0);
                ctx.move_to(xShift * tv.xPos, yShift * tv.yPos);
                ctx.show_text(tv.text);
            }
        }
        //
        // Text labels - counties
        //
        if (RadarPreferences.countyLabels && nexradState.zoom > 0.5) {
            ctx.set_font_size(TextViewMetal.fontSize / nexradState.zoom);
            Color.setCairoColor(ctx, RadarPreferences.radarColorCountyLabels);
            foreach (var tv in nexradState.countyLabels) {
                ctx.move_to(xShift * tv.xPos, yShift * tv.yPos);
                ctx.show_text(tv.text);
            }
        }
        //
        //
        // Text labels - observations
        //
        if (RadarPreferences.obs && nexradState.zoom > 0.5) {
            ctx.set_font_size(TextViewMetal.fontSize / nexradState.zoom);
            Color.setCairoColor(ctx, RadarPreferences.radarColorObs);
            foreach (var tv in nexradState.observations) {
                ctx.move_to(xShift * tv.xPos, yShift * tv.yPos);
                ctx.show_text(tv.text);
            }
        }
        return true; //GTK4_DELETE
    }

    void drawGenericLines(Cairo.Context ctx, float[] linePoints, int color, double size) {
        Color.setCairoColor(ctx, color);
        ctx.set_line_width(size / nexradState.zoom);
        foreach (var index in UtilityList.range3(0, linePoints.length, 4)) {
            ctx.move_to(linePoints[index], linePoints[index + 1]);
            ctx.line_to(linePoints[index + 2], linePoints[index + 3]);
            ctx.move_to(linePoints[index + 2], linePoints[index + 3]);
        }
        ctx.stroke();
    }

    void drawSwo(Cairo.Context ctx) {
        var xShift = -1.0f;
        var yShift = 1.0f;
        ctx.set_line_width(RadarPreferences.swoLinesize / nexradState.zoom);
        foreach (var riskLevelIndex in UtilityList.range(UtilitySwoDayOne.threatList.length)) {
            if (UtilitySwoDayOne.hashSwo.has_key(riskLevelIndex) && UtilitySwoDayOne.hashSwo[riskLevelIndex].size > 0 && swoLinesMap.has_key(riskLevelIndex)) {
                var color = UtilitySwoDayOne.swoPaints[riskLevelIndex];
                ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
                foreach (var index in UtilityList.range3(0, swoLinesMap[riskLevelIndex].data.length, 4)) {
                    ctx.move_to(xShift * swoLinesMap[riskLevelIndex].data[index], yShift * swoLinesMap[riskLevelIndex].data[index + 1]);
                    ctx.line_to(xShift * swoLinesMap[riskLevelIndex].data[index + 2], yShift * swoLinesMap[riskLevelIndex].data[index + 3]);
                    ctx.move_to(xShift * swoLinesMap[riskLevelIndex].data[index + 2], yShift * swoLinesMap[riskLevelIndex].data[index + 3]);
                }
                ctx.stroke();
            }
        }
    }

    void drawWpcFronts(Cairo.Context ctx) {
        if (nexradState.zoom < 0.5 && UtilityWpcFronts.fronts != null) {
            ctx.set_line_width(2.0 / nexradState.zoom);
            foreach (var front in UtilityWpcFronts.fronts) {
                var color = front.penColor;
                ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
                if (front.coordinatesModified[nexradState.paneNumber] != null) {
                    foreach (var index in UtilityList.range3(0, front.coordinatesModified[nexradState.paneNumber].size, 4)) {
                        ctx.move_to(xShift * front.coordinatesModified[nexradState.paneNumber][index], yShift * front.coordinatesModified[nexradState.paneNumber][index + 1]);
                        ctx.line_to(xShift * front.coordinatesModified[nexradState.paneNumber][index + 2], yShift * front.coordinatesModified[nexradState.paneNumber][index + 3]);
                        ctx.move_to(xShift * front.coordinatesModified[nexradState.paneNumber][index + 2], yShift * front.coordinatesModified[nexradState.paneNumber][index + 3]);
                    }
                }
                ctx.stroke();
            }
        }
    }

    void drawWarnings(Cairo.Context ctx) {
        var xShift = -1.0f;
        var yShift = 1.0f;
        foreach (var type1 in ObjectPolygonWarning.polygonList) {
            if (polygonGenericToBufferMap.has_key(type1)) {
                var color = polygonGenericToQColorMap[type1];
                ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
                ctx.set_line_width(RadarPreferences.warnLinesize / nexradState.zoom);
                foreach (var index in UtilityList.range3(0, polygonGenericToBufferMap[type1].data.size, 4)) {
                    ctx.move_to(xShift * polygonGenericToBufferMap[type1].data[index], yShift * polygonGenericToBufferMap[type1].data[index + 1]);
                    ctx.line_to(xShift * polygonGenericToBufferMap[type1].data[index + 2], yShift * polygonGenericToBufferMap[type1].data[index + 3]);
                    ctx.move_to(xShift * polygonGenericToBufferMap[type1].data[index + 2], yShift * polygonGenericToBufferMap[type1].data[index + 3]);
                }
                ctx.stroke();
            }
        }
    }

    void drawWatch(Cairo.Context ctx, PolygonType type1) {
        var xShift = -1.0f;
        var yShift = 1.0f;
        var color = polygonToColorMap[type1];
        ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
        ctx.set_line_width(RadarPreferences.watmcdLinesize / nexradState.zoom);
        if (polygonToBufferMap.keys.contains(type1)) {
            foreach (var index in UtilityList.range3(0, polygonToBufferMap[type1].data.size, 4)) {
                ctx.move_to(xShift * polygonToBufferMap[type1].data[index], yShift * polygonToBufferMap[type1].data[index + 1]);
                ctx.line_to(xShift * polygonToBufferMap[type1].data[index + 2], yShift * polygonToBufferMap[type1].data[index + 3]);
                ctx.move_to(xShift * polygonToBufferMap[type1].data[index + 2], yShift * polygonToBufferMap[type1].data[index + 3]);
            }
        }
        ctx.stroke();
    }

    void drawLocationDot(Cairo.Context ctx) {
        var latLons = Location.getListLatLons();
        Color.setCairoColor(ctx, RadarPreferences.radarColorLocdot);
        foreach (var latLon in latLons) {
            var coord = latLon.getProjection(nexradState.pn);
            var width = RadarPreferences.locdotSize / nexradState.zoom;
            ctx.arc(xShift * coord[0], yShift * coord[1], width, 0.0, 2.0 * Math.PI);
            ctx.stroke_preserve();
            ctx.fill();
        }
    }

    void drawSti(Cairo.Context ctx) {
        var xShift = -1.0f;
        var yShift = 1.0f;
        ctx.set_source_rgb(1.0, 1.0, 1.0);
        ctx.set_line_width(RadarPreferences.stiLinesize / nexradState.zoom);
        foreach (var index in UtilityList.range3(0, stiList.size, 4)) {
            ctx.move_to(xShift * stiList[index], yShift * stiList[index + 1]);
            ctx.line_to(xShift * stiList[index + 2], yShift * stiList[index + 3]);
            ctx.move_to(xShift * stiList[index + 2], yShift * stiList[index + 3]);
        }
        ctx.stroke();
    }

    void drawTriangle(Cairo.Context ctx, ArrayList<ArrayList<double?>> polygons, int color) {
        var lineWidth = 1.0;
        ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
        ctx.set_line_width(lineWidth / nexradState.zoom);
        foreach (var index in UtilityList.range(polygons.size)) {
            var points = polygons[index];
            if (points.size == 6) {
                ctx.new_path();
                ctx.move_to(xShift * points[0], yShift * points[1]);
                ctx.line_to(xShift * points[2], yShift * points[3]);
                ctx.move_to(xShift * points[2], yShift * points[3]);
                ctx.line_to(xShift * points[4], yShift * points[5]);
                ctx.move_to(xShift * points[4], yShift * points[5]);
                ctx.line_to(xShift * points[0], yShift * points[1]);
                ctx.move_to(xShift * points[0], yShift * points[1]);
                ctx.close_path();
                ctx.stroke_preserve();
                ctx.fill_preserve();
            }
        }
    }

    void drawWindBarbs(Cairo.Context ctx) {
        var xShift = -1.0f;
        var yShift = 1.0f;
        ctx.set_source_rgb(1.0, 0.0, 0.0);
        ctx.set_line_width(RadarPreferences.wbLinesize / nexradState.zoom);
        foreach (var index in UtilityList.range3(0, wbGustLines.size, 4)) {
            ctx.move_to(xShift * wbGustLines[index], yShift * wbGustLines[index + 1]);
            ctx.line_to(xShift * wbGustLines[index + 2], yShift * wbGustLines[index + 3]);
            ctx.move_to(xShift * wbGustLines[index + 2], yShift * wbGustLines[index + 3]);
        }
        ctx.stroke();
        ctx.set_source_rgb(1.0, 1.0, 1.0);
        ctx.set_line_width(RadarPreferences.wbLinesize / nexradState.zoom);
        foreach (var index in UtilityList.range3(0, wbLines.size, 4)) {
            ctx.move_to(xShift * wbLines[index], yShift * wbLines[index + 1]);
            ctx.line_to(xShift * wbLines[index + 2], yShift * wbLines[index + 3]);
            ctx.move_to(xShift * wbLines[index + 2], yShift * wbLines[index + 3]);
        }
        ctx.stroke();
        foreach (var index in UtilityList.range(windBarbCirclesTransformed.size)) {
            var coord = windBarbCirclesTransformed[index].data;
            var width = 2.0 / nexradState.zoom;
            var color = windBarbCircleColors[index];
            ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
            ctx.arc(xShift * coord[0], yShift * coord[1], width, 0.0, 2.0 * Math.PI);
            ctx.stroke_preserve();
            ctx.fill();
        }
    }

    Menu getContextMenu(LatLon latLon) {
        var menu = new Menu();
        var simpleActionGroup = new SimpleActionGroup();

        var obsSite = UtilityMetar.findClosestObservation(latLon);
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
        actionWatch.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.watch, latLon));
        simpleActionGroup.add_action(actionWatch);

        menu.append("Show MCD", "popup.about" + "MCD");
        var actionMcd = new SimpleAction("about" + "MCD", null);
        actionMcd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.mcd, latLon));
        simpleActionGroup.add_action(actionMcd);

        menu.append("Show MPD", "popup.about" + "MPD");
        var actionMpd = new SimpleAction("about" + "MPD", null);
        actionMpd.activate.connect(() => UtilityRadarUI.showNearestProduct(PolygonType.mpd, latLon));
        simpleActionGroup.add_action(actionMpd);
        //
        // radar products
        //
        var productList = WXGLNexrad.radarProductList;
        var prodLength = 5;
        if (WXGLNexrad.isRadarTdwr(nexradState.radarSite)) {
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

    bool mousePressEvent(Gdk.EventButton event) {  //GTK4_DELETE
        if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3) {  //GTK4_DELETE
            var latLon = UtilityRadarUI.getLatLonFromScreenPosition(nexradState, nexradState.numberOfPanes, event.x, event.y);  //GTK4_DELETE
            var menu = getContextMenu(latLon);  //GTK4_DELETE
            var popover = new Gtk.Popover.from_model(da.get(), menu);  //GTK4_DELETE
            popover.set_position(Gtk.PositionType.BOTTOM);  //GTK4_DELETE
            var rectangle = Gdk.Rectangle();  //GTK4_DELETE
            rectangle.x = (int)event.x;  //GTK4_DELETE
            rectangle.y = (int)event.y;  //GTK4_DELETE
            rectangle.width = 1;  //GTK4_DELETE
            rectangle.height = 1;  //GTK4_DELETE
            popover.set_pointing_to(rectangle);  //GTK4_DELETE
            popover.popup();  //GTK4_DELETE
        } else if (event.type == Gdk.EventType.BUTTON_PRESS) {  //GTK4_DELETE
            dragInProgress = true;  //GTK4_DELETE
            dragLastX = event.x;  //GTK4_DELETE
            dragLastY = event.y;  //GTK4_DELETE
        } else if (event.type == Gdk.EventType.DOUBLE_BUTTON_PRESS) {  //GTK4_DELETE
            fnZoom(1.33, nexradState.paneNumber);  //GTK4_DELETE
        }  //GTK4_DELETE
        return true;  //GTK4_DELETE
    }  //GTK4_DELETE

    bool mouseReleaseEvent(Gdk.EventButton event) {  //GTK4_DELETE
        dragInProgress = false;  //GTK4_DELETE
        nexradState.writePreferences();  //GTK4_DELETE
        return false;  //GTK4_DELETE
    }  //GTK4_DELETE

    bool mouseMoveEvent(Gdk.EventMotion event) {  //GTK4_DELETE
        if (dragInProgress) {  //GTK4_DELETE
            fnPosition((event.x - dragLastX) * 0.25, (event.y - dragLastY) * 0.25, nexradState.paneNumber);  //GTK4_DELETE
        }  //GTK4_DELETE
        return false;  //GTK4_DELETE
    }  //GTK4_DELETE

    bool wheelEvent(Gdk.EventScroll event) {  //GTK4_DELETE
        Gdk.ScrollDirection dir;  //GTK4_DELETE
        event.get_scroll_direction(out dir);  //GTK4_DELETE
        var up = 1.33;  //GTK4_DELETE
        var down = 0.77;  //GTK4_DELETE
        if (UIPreferences.nexradScrollWheelMotion) {  //GTK4_DELETE
            up = 0.77;  //GTK4_DELETE
            down = 1.33;  //GTK4_DELETE
        }  //GTK4_DELETE
        if (dir == Gdk.ScrollDirection.UP) {  //GTK4_DELETE
            fnZoom(up, nexradState.paneNumber);  //GTK4_DELETE
        } else if (dir == Gdk.ScrollDirection.DOWN) {  //GTK4_DELETE
            fnZoom(down, nexradState.paneNumber);  //GTK4_DELETE
        }  //GTK4_DELETE
        return false;  //GTK4_DELETE
    }  //GTK4_DELETE

    public void initGeom() {
        nexradState.pn = new ProjectionNumbers(nexradState.radarSite);
        convertGeomData(RadarGeometry.stateLines, stateLineRelativeBuffer);
        if (RadarPreferences.county) {
            convertGeomData(RadarGeometry.countyLines, countyLineRelativeBuffer);
        }
        if (RadarPreferences.highways) {
            convertGeomData(RadarGeometry.hwLines, hwLineRelativeBuffer);
        }
        if (RadarPreferences.hwEnhExt) {
            convertGeomData(RadarGeometry.hwExtLines, hwExtLineRelativeBuffer);
        }
        if (RadarPreferences.lakes) {
            convertGeomData(RadarGeometry.lakeLines, lakeLineRelativeBuffer);
        }
        if (RadarPreferences.caBorders) {
            convertGeomData(RadarGeometry.caLines, caLineRelativeBuffer);
        }
        if (RadarPreferences.mxBorders) {
            convertGeomData(RadarGeometry.mxLines, mxLineRelativeBuffer);
        }
        textObject.add();
    }

    void convertGeomData(float[] srcVec, float[] destVec) {
        var pnX = nexradState.pn.xDbl();
        var pnY = nexradState.pn.yDbl();
        foreach (var indexRelative in UtilityList.range3(0, srcVec.length, 4)) {
            var lat = srcVec[indexRelative];
            var lon = srcVec[indexRelative + 1];
            var test1 = (float)(180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + lat * (Math.PI / 180.0) / 2.0)));
            var test2 = (float)(180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + pnX * (Math.PI / 180.0) / 2.0)));
            var y1 = (float)(-1.0 * ((test1 - test2) * nexradState.pn.oneDegreeScaleFactor) + nexradState.pn.yCenter);
            var x1 = (float)(-1.0 * ((lon - pnY) * nexradState.pn.oneDegreeScaleFactor) + nexradState.pn.xCenter);
            lat = srcVec[indexRelative + 2];
            lon = srcVec[indexRelative + 3];
            test1 = (float)(180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + lat * (Math.PI / 180.0) / 2.0)));
            test2 = (float)(180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + pnX * (Math.PI / 180.0) / 2.0)));
            var y2 = (float)(-1.0 * ((test1 - test2) * nexradState.pn.oneDegreeScaleFactor) + nexradState.pn.yCenter);
            var x2 = (float)(-1.0 * ((lon - pnY) * nexradState.pn.oneDegreeScaleFactor) + nexradState.pn.xCenter);
            destVec[indexRelative] = x1;
            destVec[indexRelative + 1] = y1;
            destVec[indexRelative + 2] = x2;
            destVec[indexRelative + 3] = y2;
        }
    }

    public void downloadData() {
        nexradState.writePreferences();
        if (GlobalArrays.tdwrRadarCodes().contains(nexradState.radarSite) && !WXGLNexrad.isProductTdwr(nexradState.radarProduct)) {
            nexradState.radarProduct = "TZL";
        } else if (GlobalArrays.nexradRadarCodes().contains(nexradState.radarSite) && WXGLNexrad.isProductTdwr(nexradState.radarProduct)) {
            nexradState.radarProduct = "N0Q";
        }
        var tmpRadarProduct = nexradState.radarProduct;
        if (UtilityString.match(nexradState.radarProduct, "[A-Z][0-9][A-Z]")) {
            tmpRadarProduct = UtilityString.replaceRegex(nexradState.radarProduct, "([0-3])", Too.String(nexradState.tiltInt));
        }
        var url = WXGLDownload.getRadarFileUrl(nexradState.radarSite, tmpRadarProduct, false);
        totalBins = 0;
        fileStorage.memoryBuffer = new MemoryBuffer.fromArray(UtilityIO.downloadAsByteArray(url));
        //  totalBins = 0;
        levelData = new WXMetalNexradLevelData(nexradState.radarProduct, radarIndex, fileStorage);
        levelData.radarBuffers.animationIndex = -1;
        levelData.decode();
        levelData.radarBuffers.initialize();
        levelData.generateRadials();
        totalBins = levelData.totalBins;
        levelData.radarBuffers.setToPositionZero();
        lastFrameWasAnimation = false;
    }

    public void update() {
        da.draw();
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
        wbLines.add_all(WXGLNexradLevel3WindBarbs.decodeAndPlot(nexradState.pn, false, fileStorage));
        wbGustLines.add_all(WXGLNexradLevel3WindBarbs.decodeAndPlot(nexradState.pn, true, fileStorage));
        windBarbCirclesTransformed.clear();
        windBarbCircleColors.clear();
        foreach (var index in UtilityList.range(fileStorage.obsArrX.size)) {
            var lat = fileStorage.obsArrX[index];
            var lon = fileStorage.obsArrY[index];
            var coords = UtilityCanvasProjection.computeMercatorNumbers(lat, lon * -1.0, nexradState.pn);
            var rawColor = fileStorage.obsArrAviationColor[index];
            windBarbCirclesTransformed.add(new WbData(coords));
            windBarbCircleColors.add(rawColor);
        }
    }

    public void process(PolygonType polygonType) {
        var numbers = UtilityWatch.add(nexradState.pn, polygonType);
        polygonBufferSize[polygonType] = numbers.size / 4;
        polygonToBufferMap[polygonType] = new WarnData(numbers);
    }

    public void processMcd() {
        process(PolygonType.mcd);
    }

    public void processMpd() {
        process(PolygonType.mpd);
    }

    public void processWatch() {
        process(PolygonType.watch);
        process(PolygonType.watchTornado);
    }

    public void constructSwo() {
        foreach (var riskLevelIndex in UtilityList.range(UtilitySwoDayOne.threatList.length)) {
            if (UtilitySwoDayOne.hashSwo.has_key(riskLevelIndex) && UtilitySwoDayOne.hashSwo[riskLevelIndex].size > 0) {
                swoLinesMap[riskLevelIndex] = new WbData(new double[] {});
                var x = 0;
                UtilityList.range(UtilitySwoDayOne.hashSwo[riskLevelIndex].size / 4).foreach((unused) => {
                    var floatList = UtilitySwoDayOne.hashSwo[riskLevelIndex];
                    var coords1 = UtilityCanvasProjection.computeMercatorNumbers(floatList[x], -1.0 * floatList[x + 1], nexradState.pn);
                    var coords2 = UtilityCanvasProjection.computeMercatorNumbers(floatList[x + 2], -1.0 * floatList[x + 3], nexradState.pn);
                    swoLinesMap[riskLevelIndex].data += coords1[0];
                    swoLinesMap[riskLevelIndex].data += coords1[1];
                    swoLinesMap[riskLevelIndex].data += coords2[0];
                    swoLinesMap[riskLevelIndex].data += coords2[1];
                    x += 4;
                    return true;
                });
            }
        }
    }

    public void constructWpcFronts() {
        foreach (var front in UtilityWpcFronts.fronts) {
            front.translate(nexradState.paneNumber, nexradState.pn);
        }
        textObject.addWpcPressureCenters();
        da.draw();
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
        foreach (var index in UtilityList.range3(0, hiRawData.size, 2)) {
            var point0 = UtilityCanvasProjection.computeMercatorNumbers(hiRawData[index], -1.0 * hiRawData[index + 1], nexradState.pn);
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
        foreach (var index in UtilityList.range3(0, tvsRawData.size, 2)) {
            var point0 = UtilityCanvasProjection.computeMercatorNumbers(tvsRawData[index], -1.0 * tvsRawData[index + 1], nexradState.pn);
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
        var numbers = WXGLPolygonWarnings.add(nexradState.pn, polygonGenericType);
        polygonGenericBufferSize[polygonGenericType] = numbers.size / 4;
        polygonGenericToBufferMap[polygonGenericType] = new WarnData(numbers);
    }

    public void downloadDataForAnimation(int index) {
        //  levelData = new WXMetalNexradLevelData(nexradState.radarProduct, radarIndex, fileStorage);
        //  levelData.radarBuffers.animationIndex = index;
        //  levelData.decode();
        //  levelData.radarBuffers.initialize();
        //  totalBins = levelData.generateRadials();
        //  levelData.radarBuffers.setToPositionZero();
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
            if (RadarPreferences.warnings) {
                foreach (var polygonGenericType in ObjectPolygonWarning.polygonList) {
                    statusTotal += " " + polygonGenericType.to_string().replace("POLYGON_TYPE_", "").ascii_up() + ": " + Too.String(WXGLPolygonWarnings.getCount(polygonGenericType));
                }
            }
            statusBar.setText(statusTotal);
        }
        updateRadarStatusIconForAnimation(index);
    }

    void updateRadarStatusIconForAnimation(int index) {
        var radarAgeString = "age: " + Too.String((int) (nexradState.levelDataList[index].radarAgeMilli / 60000.0d)) + " min";
        var status = " / " + nexradState.levelDataList[index].radarInfo.split(" ")[0];
        if (UtilityTime.isRadarTimeOld(nexradState.levelDataList[index].radarAgeMilli)) {
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
        //foreach (var pane in UtilityList.range(nexradState.numberOfPanes)) {
        if (nexradState.paneNumber == 0) {
            statusTotal += fileStorage.radarInfo + sep;
            if (RadarPreferences.warnings) {
                foreach (var polygonGenericType in ObjectPolygonWarning.polygonList) {
                    statusTotal += " " + polygonGenericType.to_string().replace("POLYGON_TYPE_", "").ascii_up() + ": " + Too.String(WXGLPolygonWarnings.getCount(polygonGenericType));
                }
            }
            statusBar.setText(statusTotal);
        }
        updateRadarStatusIcon();
    }

    void updateRadarStatusIcon() {
        var radarAgeString = "age: " + Too.String((int) (fileStorage.radarAgeMilli / 60000.0d)) + " min";
        var status = " / " + fileStorage.radarInfo.split(" ")[0];
        if (UtilityTime.isRadarTimeOld(fileStorage.radarAgeMilli)) {
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

    void getRadarStatusMessage(string closeRadar) {
        var radarStatus = UtilityRadarUI.getRadarStatusMessage(closeRadar);
        new TextViewerStatic(radarStatus);
    }
}
