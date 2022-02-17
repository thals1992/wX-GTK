// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Observations : Window {

    const string prefToken = "SFC_OBS_IMG_IDX";
    Photo photo = new Photo.fullScreen();
    ComboBox comboboxProduct = new ComboBox(UtilityObservations.labels);
    VBox box = new VBox();

    public Observations() {
        setTitle("Observations");
        maximize();
        photo.setWindow(this);

        comboboxProduct.setIndexByPref(prefToken, 0);
        comboboxProduct.connect(reload);

        box.addWidget(comboboxProduct.get());
        box.addWidgetCenter(photo.get());
        box.getAndShow(this);
        reload();
    }

    void reload() {
        var url = UtilityObservations.urls[comboboxProduct.getIndex()];
        Utility.writePrefInt(prefToken, comboboxProduct.getIndex());
        new FutureBytes(url, photo.setBytes);
    }
}
