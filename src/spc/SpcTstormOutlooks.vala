// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcTstormOutlooks : Window {

    HBox box = new HBox();
    ArrayList<string> urls = UtilitySpc.getTstormOutlookUrls();
    ArrayList<Image> images = new ArrayList<Image>();

    public SpcTstormOutlooks() {
        setTitle("SPC Thunderstorm Outlooks");
        maximize();
        box.addImageRow(urls.to_array(), images);
        box.getAndShow(this);
        foreach (var i in UtilityList.range(urls.size)) {
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
