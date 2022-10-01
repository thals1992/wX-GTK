// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcSwoSummary : Window {

    VBox box = new VBox();
    ArrayList<Image> images = new ArrayList<Image>();

    public SpcSwoSummary() {
        setTitle("SPC Convective Outlooks");
        maximize();
        const int numberAcross = 4;
        ArrayList<string> urls = new ArrayList<string>();
        foreach (var day in new string[]{"1", "2", "3"}) {
            urls.add(UtilitySpcSwo.getImageUrls(day)[0]);
        }
        foreach (var day in new string[]{"4", "5", "6", "7", "8"}) {
            urls.add(UtilitySpcSwo.getImageUrlsDays48(day));
        }
        images.clear();
        box.addImageRows(urls, images, numberAcross);
        new ScrolledWindow(this, box);

        foreach (var i in range(urls.size)) {
            images[i].connect((indexFinal) => new SpcSwoDay1(Too.String(indexFinal + 1)));
            images[i].setNumberAcross(numberAcross);
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
