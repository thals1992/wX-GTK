// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Photo {

    PhotoSizeEnum size = PhotoSizeEnum.full;
    Gtk.Window win;
    int width;
    Gtk.Image image = new Gtk.Image(); //GTK4_DELETE
    /// Gtk.Picture image = new Gtk.Picture();

    public Photo(Gtk.Window win, PhotoSizeEnum size) {
        this.win = win;
        this.size = size;
        width = UtilityUI.getImageWidth(3);
    }

    public Photo.fullScreen() {
        this.size = PhotoSizeEnum.full;
        width = UtilityUI.getImageWidth(3);
    }

    public Photo.scaled() {
        this.size = PhotoSizeEnum.scaled;
        width = UtilityUI.getImageWidth(3);
    }

    public Photo.normal() {
        this.size = PhotoSizeEnum.normal;
        width = UtilityUI.getImageWidth(3);
    }

    public Photo.icon() {
        width = UtilityUI.getImageWidth(3);
    }

    public void setWindow(Gtk.Window win) {
        this.win = win;
    }

    public void setPix(Gdk.Pixbuf p) {
        /// image.set_keep_aspect_ratio(true);
        /// image.can_shrink = false;
        /// image.halign = Gtk.Align.CENTER;
        /// image.valign = Gtk.Align.CENTER;
        /// image.set_pixbuf(p);
        image.set_from_pixbuf(p); //GTK4_DELETE
    }

    public Gtk.Widget get() {
        return image;
    }

    public void setFullScreen(Gtk.Window win, uint8[] ba) {
        var dim = UtilityUI.getScreenBounds();
        dim[1] -= 100; // was 150
        try {
            var loader = new Gdk.PixbufLoader();
            loader.write(ba);
            loader.close();
            var width = loader.get_pixbuf().width;
            var height = loader.get_pixbuf().height;
            var pix = loader.get_pixbuf().scale_simple((int)((double)dim[1] * ((double)width / height)), dim[1], Gdk.InterpType.BILINEAR);
            setPix(pix);
        } catch (Error e) {
            print(e.message + "\n");
        }
    }

    public void setNoScale(uint8[] ba) {
        try {
            var loader = new Gdk.PixbufLoader();
            loader.write(ba);
            loader.close();
            setPix(loader.get_pixbuf());
        } catch(Error e) {
            print(e.message + "\n");
        }
    }

    public void setToWidth(uint8[] ba, int imageSize) {
        try {
            var loader = new Gdk.PixbufLoader();
            loader.write(ba);
            loader.close();
            var width = loader.get_pixbuf().width;
            var height = loader.get_pixbuf().height;
            var pix = loader.get_pixbuf().scale_simple(imageSize, (int)(imageSize * ((double)height / width)), Gdk.InterpType.BILINEAR);
            setPix(pix);
        } catch (Error e) {
            print(e.message + "\n");
        }
    }

    public void setBytes(uint8[] ba) {
        if (size == PhotoSizeEnum.full) {
            setFullScreen(win, ba);
        } else if (size == PhotoSizeEnum.scaled) {
            setToWidth(ba, width);
        } else {
            setNoScale(ba);
        }
    }

    public void setNwsIcon(string url) {
        setPix(UtilityNws.getIcon(url));
    }
}
