// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectCardLocationItem : HBox {

    Entry nameEntry = new Entry();
    Text text1 = new Text();
    Text text2 = new Text();
    int index = 0;

    public ObjectCardLocationItem(int index) {
        this.index = index;

        nameEntry.setText(Location.getName(index));
        nameEntry.connect(textChanged);

        var latLon = Location.getLatLon(index);
        text1.setText(latLon.printSpaceSeparated() + " " + Location.getWfo(index) + ", " + Location.getRadarSite(index));
        text2.setText(UtilityTimeSunMoon.getSunTimes(latLon));

        addWidget(nameEntry.get());
        addWidget(text1.get());
        addWidget(text2.get());
    }

    void textChanged() {
        Location.setName(index, nameEntry.getText());
        Location.refresh();
    }
}
