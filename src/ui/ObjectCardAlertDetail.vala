// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectCardAlertDetail : HBox {

    VBox boxText = new VBox();
    Text text1 = new Text();
    Text text2 = new Text();
    Text text3 = new Text();
    Text text4 = new Text();
    Button leftButton = new Button(Icon.None, "Details");
    Button radarButton = new Button(Icon.Radar, "");

    public ObjectCardAlertDetail(CapAlertXml cap) {
        var radarSite = cap.getClosestRadar();
        if (radarSite != "") {
            radarButton.connectString((r) => new Nexrad(1, true, r), radarSite);
            addWidget(radarButton.get());
        }
        var startTime = "Start: " + cap.effective;
        startTime = startTime.replace("T", " ");
        startTime = UtilityString.replaceRegex(startTime, ":00-0[0-9]:00", "");

        var endTime = "End: " + cap.expires;
        endTime = endTime.replace("T", " ");
        endTime = UtilityString.replaceRegex(endTime, ":00-0[0-9]:00", "");

        text1.setText(cap.title);
        text1.setBlue();
        text1.setLarge();
        text2.setText(cap.area);
        text3.setText(startTime);
        text4.setText(endTime);

        boxText.addWidget(text1.get());
        boxText.addWidget(text2.get());
        boxText.addWidget(text3.get());
        boxText.addWidget(text4.get());

        leftButton.connectString((u) => new AlertsDetail(u), cap.url);
        addWidget(leftButton.get());
        addLayout(boxText.get());
    }
}
