// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcFireSummary : Window {

    HBox box = new HBox();
    ArrayList<Image> images = new ArrayList<Image>();

    public SpcFireSummary() {
        setTitle("SPC Fire Weather Outlook");
        maximize();
        string[] urls = UtilitySpcFireOutlook.urls;
        box.addImageRow(urls, images);
        box.getAndShow(this);
        foreach (var i in range(urls.length)) {
            images[i].connect((index) => new SpcFireWeatherOutlook(index));
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
