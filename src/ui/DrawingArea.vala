// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class DrawingArea : Widget {

    #if GTK4
        public delegate void delegate0(Gtk.DrawingArea da, Cairo.Context ctx, int a, int b);
    #else
        public delegate bool delegate0(Cairo.Context ctx);
        public delegate bool delegate1(Gdk.EventButton v0);
        public delegate bool delegate2(Gdk.EventMotion v0);
        public delegate bool delegate3(Gdk.EventScroll v0);
    #endif
    Gtk.DrawingArea drawingArea = new Gtk.DrawingArea();

    public DrawingArea() {
        drawingArea.set_size_request(50, 50);
    }

    public void setSizeRequest(int w, int h) {
        drawingArea.set_size_request(w, h);
    }

    public void connect(delegate0 fn) {
        #if GTK4
            drawingArea.set_draw_func((da1, ctx, w, h) => { fn(da1, ctx, w, h); });
        #else
            drawingArea.draw.connect((ctx) => { return fn(ctx); });
        #endif
    }

    #if GTK4
    #else
        public void connectScroll(delegate3 fn) {
            drawingArea.scroll_event.connect((e) => { return fn(e); });
        }

        public void connectButtonPress(delegate1 fn) {
            drawingArea.button_press_event.connect((e) => { return fn(e); });
        }

        public void connectButtonRelease(delegate1 fn) {
            drawingArea.button_release_event.connect((e) => { return fn(e); });
        }

        public void connectMotionNotify(delegate2 fn) {
            drawingArea.motion_notify_event.connect((e) => { return fn(e); });
        }
    #endif

    public void draw() {
        drawingArea.queue_draw();
    }

    #if GTK4
        public void add_controller(Gtk.EventController controller) {
            drawingArea.add_controller(controller);
        }
    #else
        public void addEvents(int e) {
            drawingArea.add_events(e);
        }
    #endif

    public void setHExpand(bool e) {
        drawingArea.set_hexpand(e);
    }

    public void setVExpand(bool e) {
        drawingArea.set_vexpand(e);
    }

    public void setVisible(bool e) {
        drawingArea.set_visible(e);
    }

    public void insertActionGroup(string type1, SimpleActionGroup ag) {
        drawingArea.insert_action_group(type1, ag);
    }

    public int width {
        get { return drawingArea.get_allocated_width(); }
    }

    public int height {
        get { return drawingArea.get_allocated_height(); }
    }

    public Gtk.Widget getView() { return drawingArea; }
}
