// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcTstormOutlooks : Window {

    HBox box = new HBox();
    ArrayList<Image> images = new ArrayList<Image>();

    public SpcTstormOutlooks() {
        setTitle("SPC Thunderstorm Outlooks");
        maximize();
        var urls = UtilitySpc.getTstormOutlookUrls().to_array();
        box.addImageRow(urls, images);
        box.getAndShow(this);
        foreach (var i in range(urls.length)) {
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
