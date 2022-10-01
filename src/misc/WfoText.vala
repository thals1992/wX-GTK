// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WfoText : Window {

    ComboBox comboboxSector = new ComboBox(GlobalArrays.wfos);
    ComboBox comboboxProduct = new ComboBox(UtilityWfoText.wfoProdList);
    HBox boxH = new HBox();
    VBox box = new VBox();
    HBox boxText = new HBox();
    ArrayList<Text> textList = new ArrayList<Text>();
    string product = "AFD";
    string sector = "";
    int productCount = 3;
    const string[] defaultProducts = {"AFD", "HWO", "LSR"};

    public WfoText() {
        setTitle("WFO Text Products");
        maximize();
        sector = Location.office();
        boxText.setVExpand(true);

        comboboxSector.setIndexByValue(sector);
        comboboxSector.connect(changeSector);
        boxH.addWidget(comboboxSector.get());

        comboboxProduct.setIndexByValue(product);
        comboboxProduct.connect(changeProduct);
        boxH.addWidget(comboboxProduct.get());

        box.addLayout(boxH.get());
        box.addLayout(boxText.get());

        if (UtilityUI.isScreenSmall()) {
            productCount = 1;
        }

        range(productCount).foreach((unused) => {
            textList.add(new Text());
            textList.last().setFixedWidth();
            textList.last().vExpand();
            textList.last().hExpand();
            boxText.addWidget(textList.last().get());
            return true;
        });
        new ScrolledWindow(this, box);
        reload();
    }

    void reload() {
        foreach (var i in range(productCount)) {
            if (i == 0) {
                new FutureText(product + sector, textList[i].setText);
            } else {
                new FutureText(defaultProducts[i] + sector, textList[i].setText);
            }
        }
    }

    void changeProduct() {
        product = comboboxProduct.getValue().split(":")[0];
        reload();
    }

    void changeSector() {
        sector = comboboxSector.getValue().split(":")[0];
        reload();
    }
}
