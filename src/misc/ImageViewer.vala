// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ImageViewer : Window {

    VBox box = new VBox();
    Photo photo = new Photo.fullScreen();

    public ImageViewer(uint8[] data) {
        photo.setWindow(this);
        photo.setNoScale(data);
        box.addWidget(photo);
        box.getAndShow(this);
    }
}
