// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class RadarStatusBox {

    DrawingArea drawingArea = new DrawingArea();
    bool radarIsCurrent = true;
    string text = "";
    #if GTK4
        Gtk.GestureClick controllerClick;
    #endif
    unowned FnVoid fn;

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

    public void connect(FnVoid fn) {
        this.fn = fn;
        #if GTK4
            controllerClick = new Gtk.GestureClick();
            controllerClick.pressed.connect((pressCount, delta_x, delta_y) => {
                this.fn();
            });
            drawingArea.add_controller(controllerClick);
        #else
            drawingArea.addEvents(Gdk.EventMask.BUTTON_PRESS_MASK);
            drawingArea.connectButtonPress((c) => { this.fn(); return true; });
        #endif
    }

    #if GTK4
    void draw(Gtk.DrawingArea da, Cairo.Context ctx, int w, int h) {
    #else
    bool draw(Cairo.Context ctx) {
    #endif
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
        #if GTK4
        #else
            return true; //GTK4_DELETE
        #endif
    }

    public Gtk.DrawingArea get() { return drawingArea.get(); }
}
