// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectCardNhcStormReportItem : HBox {

    ObjectNhcStormDetails stormData;
    VBox textLayout = new VBox();
    Image image = new Image.withIndex(0);
    Button button = new Button(Icon.None, "Details");
    Text textView1 = new Text();
    Text textView2 = new Text();
    Text textView3 = new Text();
    Text textView4 = new Text();
    Text textView5 = new Text();
    Text textView6 = new Text();

    public ObjectCardNhcStormReportItem(ObjectNhcStormDetails stormData) {
        this.stormData = stormData;
        button.connect(() => new NhcStorm(this.stormData));
        image.imageSize = 250;
        image.connectNoInt(() => new ImageViewer(this.stormData.coneBytes));
        image.setBytes(stormData.coneBytes);

        textView1.setText(stormData.name + " (" + stormData.classification + ") " + stormData.center);
        textView1.setBold();
        textView1.setLarge();
        textView1.setBlue();
        textView2.setText("Moving " + UtilityMath.convertWindDir(stormData.movementDir) + " at " + stormData.movementSpeed + " mph");
        textView3.setText("Min pressure: " + stormData.pressure + " mb");
        textView4.setText("Max sustained: " + stormData.intensity + " mph");
        textView5.setText(stormData.status + " " + stormData.binNumber + " " + stormData.stormId.ascii_up());
        textView6.setText(stormData.lastUpdatePretty);

        addWidget(image.get());
        textLayout.addWidget(button.get());
        textLayout.addWidget(textView1.get());
        textLayout.addWidget(textView2.get());
        textLayout.addWidget(textView3.get());
        textLayout.addWidget(textView4.get());
        textLayout.addWidget(textView6.get());
        addLayout(textLayout.get());
    }
}
