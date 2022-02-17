// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class DrawingArea {

    public delegate bool delegate0(Cairo.Context ctx); //GTK4_DELETE
    /// public delegate void delegate0(Gtk.DrawingArea da, Cairo.Context ctx, int a, int b);
    public delegate bool delegate1(Gdk.EventButton v0); //GTK4_DELETE
    public delegate bool delegate2(Gdk.EventMotion v0); //GTK4_DELETE
    public delegate bool delegate3(Gdk.EventScroll v0); //GTK4_DELETE
    Gtk.DrawingArea drawingArea = new Gtk.DrawingArea();

    public DrawingArea() {
        drawingArea.set_size_request(50, 50);
    }

    public void setSizeRequest(int w, int h) {
        drawingArea.set_size_request(w, h);
    }

    public void connect(delegate0 fn) {
        drawingArea.draw.connect((ctx) => { return fn(ctx); }); //GTK4_DELETE
        /// drawingArea.set_draw_func((da1, ctx, w, h) => { fn(da1, ctx, w, h); });
    }

    // void draw_callback(Gtk.Widget da, Cairo.Context ctx, int w, int h) {

    public void connectScroll(delegate3 fn) { //GTK4_DELETE
        drawingArea.scroll_event.connect((e) => { return fn(e); }); //GTK4_DELETE
    } //GTK4_DELETE

    public void connectButtonPress(delegate1 fn) { //GTK4_DELETE
        drawingArea.button_press_event.connect((e) => { return fn(e); }); //GTK4_DELETE
    } //GTK4_DELETE

    public void connectButtonRelease(delegate1 fn) { //GTK4_DELETE
        drawingArea.button_release_event.connect((e) => { return fn(e); }); //GTK4_DELETE
    } //GTK4_DELETE

    public void connectMotionNotify(delegate2 fn) { //GTK4_DELETE
        drawingArea.motion_notify_event.connect((e) => { return fn(e); }); //GTK4_DELETE
    } //GTK4_DELETE

    public void draw() {
        drawingArea.queue_draw();
    }

    public void add_controller(Gtk.EventController controller) {
        /// drawingArea.add_controller(controller);
    }

    public void addEvents(int e) { //GTK4_DELETE
        drawingArea.add_events(e); //GTK4_DELETE
    } //GTK4_DELETE

    public void setHExpand(bool e) {
        drawingArea.set_hexpand(e);
    }

    public void setVExpand(bool e) {
        drawingArea.set_vexpand(e);
    }

    public void insertActionGroup(string type1, SimpleActionGroup ag) {
        drawingArea.insert_action_group(type1, ag);
    }

    public float getWidth() {
        return drawingArea.get_allocated_width();
    }

    public float getHeight() {
        return drawingArea.get_allocated_height();
    }

    public Gtk.DrawingArea get() {
        return drawingArea;
    }
}
