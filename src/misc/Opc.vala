// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Opc : Window {

    string prefToken = "OPC_IMG_FAV_URL";
    Photo photo = new Photo.fullScreen();
    VBox box = new VBox();
    ComboBox comboboxProduct = new ComboBox(UtilityOpcImages.labels);

    public Opc() {
        setTitle("OPC");
        maximize();

        photo.setWindow(this);
        comboboxProduct.setIndexByPref(prefToken, 0);
        comboboxProduct.connect(reload);

        box.addWidget(comboboxProduct);
        box.addWidget(photo);
        box.getAndShow(this);

        reload();
    }

    void reload() {
        var url = UtilityOpcImages.urls[comboboxProduct.getIndex()];
        Utility.writePrefInt(prefToken, comboboxProduct.getIndex());
        new FutureBytes(url, photo.setBytes);
    }
}
