// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class RainfallOutlookSummary : Window {

    HBox box = new HBox();

    public RainfallOutlookSummary() {
        setTitle("Excessive Rainfall Outlook");
        maximize();
        var urls = UtilityWpcRainfallOutlook.urls;
        ArrayList<Image> images = new ArrayList<Image>();
        box.addImageRow(urls, images);
        box.getAndShow(this);
        foreach (var i in range(urls.length)) {
            images[i].connect((index) => new RainfallOutlook(index));
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
