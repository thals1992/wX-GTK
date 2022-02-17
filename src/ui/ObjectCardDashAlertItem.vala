// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectCardDashAlertItem : HBox {

    VBox boxText = new VBox();
    Text text0 = new Text();
    Text text1 = new Text();
    Text text2 = new Text();
    Text text3 = new Text();
    Text text4 = new Text();
    Button rightButton = new Button(Icon.Radar, "");
    Button leftButton = new Button(Icon.None, "Details");

    public ObjectCardDashAlertItem(ObjectWarning warning) {
        text0.setText(warning.event1 + " (" + warning.sender + ")");
        text0.setBlue();
        text0.setLarge();
        text1.setText(warning.sender + " " + warning.title.replace("\\n", " "));
        text2.setText(warning.effective);
        text3.setText(warning.expires);
        text4.setText(warning.area);

        boxText.addWidget(text0.get());
        boxText.addWidget(text1.get());
        boxText.addWidget(text2.get());
        boxText.addWidget(text3.get());
        boxText.addWidget(text4.get());

        leftButton.connectString((u) => new AlertsDetail(u), warning.getUrl());
        rightButton.connectString((r) => new Nexrad(1, true, r), warning.getClosestRadar());

        addWidget(leftButton.get());
        addWidget(rightButton.get());
        addLayout(boxText.get());
    }
}
