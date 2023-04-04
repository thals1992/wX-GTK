// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class SpcCompMap : Window {

    string product = Utility.readPref(prefToken, "0");
    const string prefToken = "SPCCOMPMAP_LAYERSTRIOS";
    Photo photo = new Photo.fullScreen();
    ComboBox comboboxProduct = new ComboBox(UtilitySpcCompmap.labels);
    VBox box = new VBox();
    HBox buttonBox = new HBox();
    Button buttonBack = new Button(Icon.Left, "");
    Button buttonForward = new Button(Icon.Right, "");
    int index = 0;

    public SpcCompMap() {
        setTitle("SPC Compmap");
        maximize();
        photo.setWindow(this);

        buttonBack.connect(() => {
            index -= 1;
            index = int.max(index, 0);
            comboboxProduct.setIndex(index);
            reload();
        });
        buttonForward.connect(() => {
            index += 1;
            index = int.min(index, UtilitySpcCompmap.urlIndices.length - 1);
            comboboxProduct.setIndex(index);
            reload();
        });

        index = indexOf(UtilitySpcCompmap.urlIndices, product);
        comboboxProduct.setIndex(index);
        comboboxProduct.connect(changeProduct);

        buttonBox.addWidget(buttonBack);
        buttonBox.addWidget(buttonForward);
        buttonBox.addWidget(comboboxProduct);
        box.addLayout(buttonBox);
        box.addWidgetAndCenter1(this.photo);
        box.getAndShow(this);

        reload();
    }

    void reload() {
        Utility.writePref(prefToken, product);
        var url = UtilitySpcCompmap.getImage(product);
        setTitle("SPC Compmap - " + comboboxProduct.getValue());
        new FutureBytes(url, photo.setBytes);
    }

    void changeProduct() {
        index = comboboxProduct.getIndex();
        product = UtilitySpcCompmap.urlIndices[index];
        reload();
    }
}
