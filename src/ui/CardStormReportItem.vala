// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class CardStormReportItem : HBox {

    Text text0 = new Text();
    Text text1 = new Text();
    Text text2 = new Text();
    VBox box = new VBox();
    ButtonLink button = new ButtonLink("", "");

    public CardStormReportItem(StormReport stormReport) {
        text0.setText(stormReport.state + ", " + stormReport.city + " " + stormReport.time);
        text0.setBold();
        text1.setText(stormReport.address);
        text2.setText(stormReport.magnitude + " - " + stormReport.damageReport);
        text2.setGray();

        var url1 = "https://www.openstreetmap.org/?mlat=" + stormReport.lat + "&mlon=" + stormReport.lon + "&zoom=12#map=12/" + stormReport.lat + "/" + stormReport.lon;
        var title = stormReport.lat + ", " + stormReport.lon;
        button = new ButtonLink(url1, title);
        addWidget(button);

        box.addWidget(text0);
        box.addWidget(text1);
        box.addWidget(text2);
        addLayout(box);
    }
}
