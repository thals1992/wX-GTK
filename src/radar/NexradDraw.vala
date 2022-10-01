// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradDraw {

    static double xShift = -1.0;
    static double yShift = 1.0;

    NexradState nexradState;
    FileStorage fileStorage;
    WXMetalTextObject textObject;

    public NexradDraw(NexradState nexradState, FileStorage fileStorage, WXMetalTextObject textObject) {
        this.nexradState = nexradState;
        this.fileStorage = fileStorage;
        this.textObject = textObject;
    }

    public void initGeom() {
        if (RadarPreferences.locationDot) {
            fileStorage.locationDotsTransformed.clear();
            fileStorage.locationDotsColor.clear();
            foreach (var latLon in Location.getListLatLons()) {
                var coord = latLon.getProjection(nexradState.getPn());
                fileStorage.locationDotsTransformed.add(new WbData(coord));
                fileStorage.locationDotsColor.add(RadarPreferences.colorLocdot);
            }
        }
        foreach (var t in new RadarGeometryTypeEnum[]{
            RadarGeometryTypeEnum.StateLines,
            RadarGeometryTypeEnum.CountyLines,
            RadarGeometryTypeEnum.HwLines,
            RadarGeometryTypeEnum.HwExtLines,
            RadarGeometryTypeEnum.LakeLines,
            RadarGeometryTypeEnum.CaLines,
            RadarGeometryTypeEnum.MxLines
        }) {
            convertGeomData(t);
        }
        textObject.add();
    }

    public void convertGeomData(RadarGeometryTypeEnum type) {
        if (!RadarGeometry.dataByType[type].isEnabled) {
            if (RadarGeometry.dataByType[type] != null) {
                fileStorage.relativeBuffers[type].clear();
            }
            return;
        }
        if (!fileStorage.relativeBuffers.keys.contains(type) || fileStorage.relativeBuffers[type].is_empty) {
            fileStorage.relativeBuffers[type] = new ArrayList<float?>.wrap(new float?[RadarGeometry.dataByType[type].lineData.length]);
        }
        var pnX = nexradState.getPn().x();
        var pnY = nexradState.getPn().y();
        var xCenter = nexradState.getPn().xCenter;
        var yCenter = nexradState.getPn().yCenter;
        var oneDegreeScaleFactor = nexradState.getPn().oneDegreeScaleFactor;
        foreach (var indexRelative in range3(0, RadarGeometry.dataByType[type].lineData.length, 4)) {
            double lat = RadarGeometry.dataByType[type].lineData[indexRelative];
            double lon = RadarGeometry.dataByType[type].lineData[indexRelative + 1];
            var test1 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + lat * (Math.PI / 180.0) / 2.0)));
            var test2 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + pnX * (Math.PI / 180.0) / 2.0)));
            var y1 = (-1.0 * ((test1 - test2) * oneDegreeScaleFactor) + yCenter);
            var x1 = (-1.0 * ((lon - pnY) * oneDegreeScaleFactor) + xCenter);
            lat = RadarGeometry.dataByType[type].lineData[indexRelative + 2];
            lon = RadarGeometry.dataByType[type].lineData[indexRelative + 3];
            test1 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + lat * (Math.PI / 180.0) / 2.0)));
            test2 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + pnX * (Math.PI / 180.0) / 2.0)));
            var y2 = (-1.0 * ((test1 - test2) * oneDegreeScaleFactor) + yCenter);
            var x2 = (-1.0 * ((lon - pnY) * oneDegreeScaleFactor) + xCenter);
            fileStorage.relativeBuffers[type][indexRelative] = (float)x1;
            fileStorage.relativeBuffers[type][indexRelative + 1] = (float)y1;
            fileStorage.relativeBuffers[type][indexRelative + 2] = (float)x2;
            fileStorage.relativeBuffers[type][indexRelative + 3] = (float)y2;
        }
    }

    public void initSurface(Cairo.Context ctx) {
        ctx.set_antialias(Cairo.Antialias.NONE);
        ctx.save();
        Color.setCairoColor(ctx, RadarPreferences.nexradRadarBackgroundColor);
        ctx.paint();
        ctx.restore();
        ctx.translate((nexradState.windowWidth / 2) + nexradState.xPos, (nexradState.windowHeight / 2) + nexradState.yPos);
        ctx.scale(nexradState.zoom, nexradState.zoom);
        ctx.set_line_width(1.0 / nexradState.zoom);
    }

    // TODO FIXME use width1 instead of 2.0
    public void drawGenericCircles(Cairo.Context ctx, double width1, ArrayList<int> colors, ArrayList<WbData> centers) {
        foreach (var index in range(centers.size)) {
            var coord = centers[index].data;
            var width = 2.0 / nexradState.zoom;
            var color = colors[index];
            ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
            ctx.arc(xShift * coord[0], yShift * coord[1], width, 0.0, 2.0 * Math.PI);
            ctx.stroke_preserve();
            ctx.fill();
        }
    }

    // used for hw/state lines, note no shift and array instead of list
    //  public void drawGeomLine(Cairo.Context ctx, float[] linePoints, int color, double size) {
    //      Color.setCairoColor(ctx, color);
    //      ctx.set_line_width(size / nexradState.zoom);
    //      foreach (var index in range3(0, linePoints.length, 4)) {
    //          ctx.move_to(linePoints[index], linePoints[index + 1]);
    //          ctx.line_to(linePoints[index + 2], linePoints[index + 3]);
    //          ctx.move_to(linePoints[index + 2], linePoints[index + 3]);
    //      }
    //      ctx.stroke();
    //  }

    public void drawGeomLine(Cairo.Context ctx, RadarGeometryTypeEnum type) {
        if (!RadarGeometry.dataByType[type].isEnabled) {
            return;
        }
        Color.setCairoColor(ctx, RadarGeometry.dataByType[type].colorInt);
        ctx.set_line_width(RadarGeometry.dataByType[type].lineSize / nexradState.zoom);
        foreach (var index in range3(0, fileStorage.relativeBuffers[type].size, 4)) {
            ctx.move_to(fileStorage.relativeBuffers[type][index], fileStorage.relativeBuffers[type][index + 1]);
            ctx.line_to(fileStorage.relativeBuffers[type][index + 2], fileStorage.relativeBuffers[type][index + 3]);
            // ctx->move_to(fileStorage->relativeBuffers[type][index + 2], fileStorage->relativeBuffers[type][index + 3]);
        }
        ctx.stroke();
    }

    // used for things like watches and warnings
    public void drawGenericLine(Cairo.Context ctx, double size, int color, ArrayList<double?> linePoints) {
        if (linePoints == null || linePoints.size == 0) {
            return;
        }
        Color.setCairoColor(ctx, color);
        ctx.set_line_width(size / nexradState.zoom);
        foreach (var index in range3(0, linePoints.size, 4)) {
            ctx.move_to(xShift * linePoints[index], yShift * linePoints[index + 1]);
            ctx.line_to(xShift * linePoints[index + 2], yShift * linePoints[index + 3]);
            ctx.move_to(xShift * linePoints[index + 2], yShift * linePoints[index + 3]);
        }
        ctx.stroke();
    }

    // used for things like watches and warnings
    public void drawGenericLine2(Cairo.Context ctx, double size, int color, double[] linePoints) {
        Color.setCairoColor(ctx, color);
        ctx.set_line_width(size / nexradState.zoom);
        foreach (var index in range3(0, linePoints.length, 4)) {
            ctx.move_to(xShift * linePoints[index], yShift * linePoints[index + 1]);
            ctx.line_to(xShift * linePoints[index + 2], yShift * linePoints[index + 3]);
            ctx.move_to(xShift * linePoints[index + 2], yShift * linePoints[index + 3]);
        }
        ctx.stroke();
    }

    public void drawTriangle(Cairo.Context ctx, ArrayList<ArrayList<double?>> polygons, int color) {
        var lineWidth = 1.0;
        ctx.set_source_rgb((double)Color.red(color) / 255.0, (double)Color.green(color) / 255.0, (double)Color.blue(color) / 255.0);
        ctx.set_line_width(lineWidth / nexradState.zoom);
        foreach (var index in range(polygons.size)) {
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

    public void drawText(Cairo.Context ctx, int color, ArrayList<TextViewMetal> textPoints) {
        ctx.set_font_size(TextViewMetal.fontSize / nexradState.zoom);
        Color.setCairoColor(ctx, color);
        foreach (var tv in textPoints) {
            ctx.move_to(xShift * tv.xPos, yShift * tv.yPos);
            ctx.show_text(tv.text);
        }
    }
}
