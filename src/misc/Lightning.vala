// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Lightning : Window {

    string url = "";
    Photo photo = new Photo.fullScreen();
    ComboBox comboboxSector = new ComboBox(UtilityLightning.sectors);
    ComboBox comboboxTime = new ComboBox(UtilityLightning.timeList);
    VBox box = new VBox();
    HBox boxH = new HBox();
    int index = 0;
    string time = "";
    string sector = "";
    const string prefTokenSector = "LIGHTNING_SECTOR";
    const string prefTokenPeriod = "LIGHTNING_PERIOD";

    public Lightning() {
        setTitle("Lightning");
        maximize();
        sector = Utility.readPref(prefTokenSector, "usa_big");
        time = Utility.readPref(prefTokenPeriod, "0.25");
        photo.setWindow(this);

        index = UtilityList.findex(UtilityLightning.getSectorPretty(sector), UtilityLightning.sectors);
        comboboxSector.setIndex(index);
        comboboxSector.connect(sectorChanged);

        var indexTime = UtilityList.findex(UtilityLightning.getTimePretty(time), UtilityLightning.timeList);
        comboboxTime.setIndex(indexTime);
        comboboxTime.connect(timeChanged);

        boxH.addWidget(comboboxSector.get());
        boxH.addWidget(comboboxTime.get());
        box.addLayout(boxH.get());
        box.addWidget(photo.get());
        box.getAndShow(this);
        reload();
    }

    void sectorChanged() {
        var label = comboboxSector.getValue();
        var index = UtilityList.findex(label, UtilityLightning.sectors);
        sector = UtilityLightning.getSector(UtilityLightning.sectors[index]);
        reload();
    }

    void timeChanged() {
        var label = comboboxTime.getValue();
        var index = UtilityList.findex(label, UtilityLightning.timeList);
        time = UtilityLightning.getTime(UtilityLightning.timeList[index]);
        reload();
    }

    void reload() {
        url = UtilityLightning.getImageUrl(sector, time);
        Utility.writePref(prefTokenSector, sector);
        Utility.writePref(prefTokenPeriod, time);
        new FutureBytes(url, photo.setBytes);
    }
}
