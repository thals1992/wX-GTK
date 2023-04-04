// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcSwoDay1 : Window {

    VBox imageVBox = new VBox();
    Text text = new Text();
    ArrayList<Image> images = new ArrayList<Image>();

    public SpcSwoDay1(string day) {
        setTitle("SPC Convective Outlook Day " + day);
        maximize();
        ArrayList<string> urls = new ArrayList<string>();
        if (Too.Int(day) > 3) {
            urls = UtilitySpcSwo.getImageUrls("48");
        } else {
            urls = UtilitySpcSwo.getImageUrls(day);
        }
        foreach (var index in range(urls.size)) {
            images.add(new Image.withIndex(index));
            imageVBox.addWidget(images[index]);
        }
        var product = "SWODY" + day;
        if (day == "4" || day == "5" || day == "6" || day == "7" || day == "8" || day == "48") {
            product = "SWOD48";
        }
        text.hExpand();
        new TwoWidgetScroll(this, imageVBox.getView(), text.get());
        new FutureText(product, text.setText);
        foreach (var i in range(urls.size)) {
            new FutureBytes(urls[i], images[i].setBytes);
        }
    }
}
