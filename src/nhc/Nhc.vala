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
    ArrayList<ObjectCardNhcStormReportItem> stormReportCards = new ArrayList<ObjectCardNhcStormReportItem>();
    ObjectNhc objectNhc = new ObjectNhc();

    public Nhc() {
        setTitle("NHC");
        maximize();
        foreach (var region in NhcOceanEnum.all()) {
            urls.add_all(new ObjectNhcRegionSummary(region).urls);
        }
        box.addLayout(textLayout.get());
        box.addImageRows(urls, images, 3);
        new ScrolledWindow(this, box);

        new FutureVoid(objectNhc.getTextData, updateText);
        foreach (var i in UtilityList.range(urls.size)) {
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }

    void updateText() {
        objectNhc.showTextData();
        foreach (var storm in objectNhc.stormDataList) {
            stormReportCards.add(new ObjectCardNhcStormReportItem(storm));
            textLayout.addLayout(stormReportCards.last().get());
        }
    }
}