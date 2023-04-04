// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Nhc : Window {

    ArrayList<string> urls = new ArrayList<string>();
    VBox textLayout = new VBox();
    VBox box = new VBox();
    ArrayList<Image> images = new ArrayList<Image>();
    ArrayList<CardNhcStormReportItem> stormReportCards = new ArrayList<CardNhcStormReportItem>();
    ObjectNhc objectNhc = new ObjectNhc();

    public Nhc() {
        setTitle("NHC");
        maximize();
        foreach (var region in NhcOceanEnum.all()) {
            urls.add_all(new NhcRegionSummary(region).urls);
        }
        box.addLayout(textLayout);
        box.addImageRows(urls, images, 3);
        new ScrolledWindow(this, box);

        new FutureVoid(objectNhc.getTextData, updateText);
        foreach (var i in range(urls.size)) {
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }

    void updateText() {
        objectNhc.showTextData();
        foreach (var storm in objectNhc.stormDataList) {
            stormReportCards.add(new CardNhcStormReportItem(storm));
            textLayout.addLayout(stormReportCards.last());
        }
    }
}
