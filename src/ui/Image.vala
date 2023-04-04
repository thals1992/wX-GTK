// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Image : Widget {

    Photo image = new Photo.icon();
    #if GTK4
        public Gtk.GestureClick gesture;
    #else
        Gtk.EventBox evb = new Gtk.EventBox();
        Gtk.GestureMultiPress gesture;
    #endif
    int index = 0;
    public int imageSize = UtilityUI.getImageWidth(3);

    public Image() {
        #if GTK4
            gesture = new Gtk.GestureClick();
            image.getView().add_controller(gesture);
        #else
            evb.add(image.getView());
            gesture = new Gtk.GestureMultiPress(evb);
        #endif
        gesture.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
    }

    public Image.withIndex(int index) {
        this.index = index;
        #if GTK4
            gesture = new Gtk.GestureClick();
            image.getView().add_controller(gesture);
        #else
            evb.add(image.getView());
            gesture = new Gtk.GestureMultiPress(evb);
        #endif
        gesture.set_propagation_phase(Gtk.PropagationPhase.CAPTURE);
    }

    public void setNumberAcross(int num) {
        imageSize = UtilityUI.getImageWidth(num);
    }

    public void connect(FnInt fn) {
        gesture.pressed.connect(() => fn(index));
    }

    public void connectNoInt(FnVoid fn) {
        gesture.pressed.connect(() => fn());
    }

    public void setBytes(uint8[] ba) {
        image.setToWidth(ba, imageSize);
    }

    //  public Gtk.Widget get() {
    //      #if GTK4
    //          return image.getView();
    //      #else
    //          return evb;
    //      #endif
    //  }

    public Gtk.Widget getView() {
        #if GTK4
            return image.getView();
        #else
            return evb;
        #endif
    }
}
