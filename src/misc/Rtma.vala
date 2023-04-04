// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Rtma : Window {

    const string prefToken = "RMTA_PROD_INDEX";
    Photo photo = new Photo.fullScreen();
    ComboBox comboboxProduct = new ComboBox(UtilityRtma.labels);
    ComboBox comboboxSector = new ComboBox(UtilityRtma.sectors);
    ComboBox comboboxTimes = new ComboBox(UtilityRtma.getTimes().to_array());
    int indexProduct = Utility.readPrefInt(prefToken, 0);
    VBox box = new VBox();
    HBox hbox = new HBox();

    public Rtma() {
        setTitle("RTMA");
        maximize();
        photo.setWindow(this);
        comboboxProduct.setIndexByValue(UtilityRtma.labels[indexProduct]);
        comboboxProduct.connect(changeProduct);
        comboboxSector.setIndexByValue(UtilityRtma.getNearest(Location.getLatLonCurrent()));
        comboboxSector.connect(changeSector);
        comboboxTimes.setIndex(0);
        comboboxTimes.connect(changeTime);
        hbox.addWidget(comboboxProduct);
        hbox.addWidget(comboboxSector);
        hbox.addWidget(comboboxTimes);
        box.addLayout(hbox);
        box.addWidgetAndCenter1(photo);
        box.getAndShow(this);
        reload();
    }

    void reload() {
        var url = UtilityRtma.getUrl(indexProduct, comboboxSector.getIndex(), comboboxTimes.getValue());
        Utility.writePrefInt(prefToken, indexProduct);
        var utcTime = comboboxTimes.getValue();
        var objectDateTime = new ObjectDateTime.fromIso8601(utcTime.replace(" UTC", "") + "0000"); // add 4 zeros for mmss "yyyyMMdd HH' UTC'"
        objectDateTime.utcToLocal();
        var timeString = objectDateTime.format("%Y%m%d %H");
        setTitle(timeString);
        new FutureBytes(url, photo.setBytes);
    }
    
    void changeProduct() {
        indexProduct = comboboxProduct.getIndex();
        reload();
    }
    
    void changeSector() {
        reload();
    }
    
    void changeTime() {
        reload();
    }
}
