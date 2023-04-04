// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NhcStorm : Window {

    Text text = new Text();
    ComboBox comboboxProduct = new ComboBox(UtilityNhc.stormtextProducts);
    NhcStormDetails stormData;
    VBox boxText = new VBox();
    VBox boxImages = new VBox();
    ArrayList<Photo> images = new ArrayList<Photo>();
    Button goesButton = new Button(Icon.None, "GOES");
    TwoWidgetScroll sw;

    public NhcStorm(NhcStormDetails stormData) {
        this.stormData = stormData;
        setTitle("NHC Storm " + stormData.forTopHeader());
        maximize();
        ArrayList<string> urls = new ArrayList<string>();

        goesButton.connect(() => new GoesViewer(this.stormData.goesUrl));
        foreach (var url in UtilityNhc.urlEnds) {
            urls.add(stormData.baseUrl + url);
        }
        comboboxProduct.setIndex(0);
        comboboxProduct.connect(reload);

        text.hExpand();
        boxText.addWidget(goesButton);
        boxText.addWidget(comboboxProduct);
        boxText.addWidget(text);

        urls.foreach((unused) => {
            images.add(new Photo(this, PhotoSizeEnum.Scaled));
            boxImages.addWidget(images.last());
            return true;
        });

        sw = new TwoWidgetScroll(this, boxImages.getView(), boxText.getView());

        foreach (var index in range(urls.size)) {
            new FutureBytes(urls[index], images[index].setBytes);
        }
        reload();
    }

    void reload() {
        var product = comboboxProduct.getValue().split(":")[0] + stormData.binNumber;
        new FutureText(product, text.setText);
    }
}
