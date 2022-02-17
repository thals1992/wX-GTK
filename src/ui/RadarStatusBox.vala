// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class RadarStatusBox {

    DrawingArea drawingArea = new DrawingArea();
    bool radarIsCurrent = true;
    string text = "";

    public RadarStatusBox() {
        drawingArea.setSizeRequest(140, 30);
        drawingArea.connect(draw);
    }

    public void setCurrent(string text) {
        radarIsCurrent = true;
        this.text = text;
        drawingArea.draw();
    }

    public void setOld(string text) {
        radarIsCurrent = false;
        this.text = text;
        drawingArea.draw();
    }

    /// void draw(Gtk.DrawingArea da, Cairo.Context ctx, int w, int h) {
    bool draw(Cairo.Context ctx) {  //GTK4_DELETE
        if (radarIsCurrent) {
            ctx.set_source_rgb(0.0, 1.0, 0.0);
        } else {
            ctx.set_source_rgb(1.0, 0.0, 0.0);
        }
        ctx.fill();
        ctx.paint();

        //  double xScale;
        //  double yScale;
        //  // https://valadoc.org/cairo/Cairo.Surface.html
        //  var surface = ctx.get_target();
        //  surface.get_device_scale(out xScale, out yScale);
        //  print(xScale.to_string() + " " + yScale.to_string() + "\n");

        ctx.set_font_size(13.0);
        Color.setCairoColor(ctx, Color.rgb(0, 0, 0));
        ctx.move_to(5.0, 30.0);
        ctx.show_text(text);
        return true; //GTK4_DELETE
    }

    public Gtk.DrawingArea get() {
        return drawingArea.get();
    }
}
