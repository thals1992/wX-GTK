// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class ForecastIcon {

    const int dimensions = 60;
    const int dimensionInterim = 86;
    const int padding = 2;
    const double fontSize = 16.0;
    const double rectSize = 20.0;
    const int spaceFromEdge = 5;
    static double gray = 225.0 / 255.0;

    Cairo.ImageSurface image;
    Cairo.Context painter;

    public ForecastIcon(string weatherCondition) {
        try {
            var surf1 = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + weatherCondition + ".png");
            image = new Cairo.ImageSurface(Cairo.Format.ARGB32, dimensionInterim, dimensionInterim);
            painter = new Cairo.Context(image);
            painter.set_source_rgba(0.0, 0.0, 0.0, 1.0);
            painter.paint();
            Gdk.cairo_set_source_pixbuf(painter, surf1, 0.0, 0.0);
            painter.paint();
        } catch (Error e) {
            print(e.message + " ForecastIcon\n");
        }
    }

    public ForecastIcon.fromTwo(string leftWeatherCondition, string rightWeatherCondition) {
        try {
            var surf1 = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + leftWeatherCondition + ".png");
            var surf2 = new Gdk.Pixbuf.from_resource("/" + GlobalVariables.imageDir + rightWeatherCondition + ".png");
            surf1 = new Gdk.Pixbuf.subpixbuf(surf1, 0, 0, (int)(dimensionInterim / 2.0) - padding, dimensionInterim);
            surf2 = new Gdk.Pixbuf.subpixbuf(surf2, (int)(dimensionInterim * 0.25), 0, (int)(dimensionInterim / 2.0) - padding, dimensionInterim);
            image = new Cairo.ImageSurface(Cairo.Format.ARGB32, dimensionInterim, dimensionInterim);
            painter = new Cairo.Context(image);
            painter.set_source_rgba(1.0, 1.0, 1.0, 1.0);
            painter.paint();
            Gdk.cairo_set_source_pixbuf(painter, surf1, 0.0, 0.0);
            painter.paint();
            Gdk.cairo_set_source_pixbuf(painter, surf2, dimensionInterim / 2.0 + padding, 0.0);
            painter.paint();
        } catch (Error e) {
            print(e.message + " ForecastIcon.fromTwo\n");
        }
    }

    public void drawLeftText(string number) {
        if (number != "" && number != "0" ) {
            painter.set_source_rgb(gray, gray, gray);
            painter.rectangle(0, dimensionInterim - rectSize, (int)(dimensionInterim / 2.0) - padding, rectSize);
            painter.fill();
            painter.set_font_size(fontSize);
            painter.move_to(spaceFromEdge, dimensionInterim - spaceFromEdge);
            painter.set_source_rgb(0.15, 0.38, 0.54);
            painter.show_text(number + "%");
        }
    }

    public void drawRightText(string number) {
        if (number != "" && number != "0") {
            painter.set_source_rgb(gray, gray, gray);
            painter.rectangle((int)(dimensionInterim / 2.0) + padding, dimensionInterim - rectSize, (int)(dimensionInterim / 2.0) - padding, rectSize);
            painter.fill();
            painter.set_font_size(fontSize);
            painter.move_to((dimensionInterim) / 2.0 + padding, dimensionInterim - spaceFromEdge);
            painter.set_source_rgb(0.15, 0.38, 0.54);
            painter.show_text(number + "%");
        }
    }

    public void drawSingleText(string number) {
        painter.set_source_rgb(gray, gray, gray);
        painter.rectangle(0, dimensionInterim - rectSize, dimensionInterim, rectSize);
        painter.fill();
        if (number != "") {
            painter.set_font_size(fontSize);
            painter.move_to(spaceFromEdge, dimensionInterim - spaceFromEdge);
            painter.set_source_rgb(0.15, 0.38, 0.54);
            painter.show_text(number + "%");
        }
    }

    public Gdk.Pixbuf get() {
        var pix = Gdk.pixbuf_get_from_surface(image, 0, 0, dimensionInterim, dimensionInterim);
        return pix.scale_simple(dimensions, dimensions, Gdk.InterpType.BILINEAR);
    }

    public static Gdk.Pixbuf blankBitmap() {
        return new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, dimensions, dimensions);
    }
}
