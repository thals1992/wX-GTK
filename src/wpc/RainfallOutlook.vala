// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class RainfallOutlook : Window {

    Photo photo = new Photo.scaled();
    Text text = new Text();

    public RainfallOutlook(int day) {
        setTitle("Excessive Rainfall Outlook Day " + Too.String(day + 1));
        maximize();
        var url = UtilityWpcRainfallOutlook.urls[day];
        var product = UtilityWpcRainfallOutlook.codes[day];
        text.hExpand();
        new TwoWidgetScroll(this, photo.getView(), text.get());
        new FutureText(product, text.setText);
        new FutureBytes(url, photo.setBytes);
    }
}
