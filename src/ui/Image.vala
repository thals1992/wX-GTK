// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Image {

    Photo image = new Photo.icon();
    Gtk.EventBox evb = new Gtk.EventBox(); //GTK4_DELETE
    Gtk.GestureMultiPress gesture; //GTK4_DELETE
    ///  public Gtk.GestureClick gesture;
    int index = 0;
    public int imageSize = UtilityUI.getImageWidth(3);
    public delegate void ConnectFn(int a);
    public delegate void ConnectFnNoInt();

    public Image() {
        gesture = new Gtk.GestureMultiPress(evb);  //GTK4_DELETE
        /// gesture = new Gtk.GestureClick();
        /// image.get().add_controller(gesture);
        gesture.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        evb.add(image.get());  //GTK4_DELETE
    }

    public Image.withIndex(int index) {
        this.index = index;
        gesture = new Gtk.GestureMultiPress(evb);  //GTK4_DELETE
        /// gesture = new Gtk.GestureClick();
        /// image.get().add_controller(gesture);
        gesture.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
        evb.add(image.get());  //GTK4_DELETE
    }

    public void setNumberAcross(int num) {
        imageSize = UtilityUI.getImageWidth(num);
    }

    public void connect(ConnectFn fn) {
        gesture.pressed.connect(() => fn(index));
    }

    public void connectNoInt(ConnectFnNoInt fn) {
        gesture.pressed.connect(() => fn());
    }

    public void setBytes(uint8[] ba) {
        image.setToWidth(ba, imageSize);
    }

    public Gtk.Widget get() {
        return evb;  //GTK4_DELETE
        /// return image.get();
    }
}
