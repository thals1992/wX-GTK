// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CardNhcStormReportItem : HBox {

    NhcStormDetails stormData;
    VBox textLayout = new VBox();
    Image image = new Image.withIndex(0);
    Button button = new Button(Icon.None, "Details");
    Text text1 = new Text();
    Text text2 = new Text();
    Text text3 = new Text();
    Text text4 = new Text();
    Text text5 = new Text();
    Text text6 = new Text();

    public CardNhcStormReportItem(NhcStormDetails stormData) {
        this.stormData = stormData;
        button.connect(() => new NhcStorm(this.stormData));
        image.imageSize = 250;
        image.connectNoInt(() => new ImageViewer(this.stormData.coneBytes));
        image.setBytes(stormData.coneBytes);

        text1.setText(stormData.name + " (" + stormData.classification + ") " + stormData.center);
        text1.setBold();
        text1.setLarge();
        text1.setBlue();
        text1.hExpand ();
        text2.setText("Moving " + UtilityMath.convertWindDir(stormData.movementDir) + " at " + stormData.movementSpeed + " mph");
        text3.setText("Min pressure: " + stormData.pressure + " mb");
        text4.setText("Max sustained: " + stormData.intensity + " mph");
        text5.setText(stormData.status + " " + stormData.binNumber + " " + stormData.stormId.ascii_up());
        text6.setText(stormData.lastUpdatePretty);

        addWidget(image);
        textLayout.addWidget(button);
        textLayout.addWidget(text1);
        textLayout.addWidget(text2);
        textLayout.addWidget(text3);
        textLayout.addWidget(text4);
        textLayout.addWidget(text6);
        addLayout(textLayout);
    }
}
