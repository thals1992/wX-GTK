// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class SevenDayCard : HBox {

    VBox boxText = new VBox();
    Text text1 = new Text();
    Text text2 = new Text();
    Photo photo = new Photo.icon();

    public SevenDayCard(string row1, string row2, string icon) {
        boxText.setSpacing(0);
        photo.setNwsIcon(icon);

        text1.setText(row1.replace("\"", "") + tempAndWind(row2));
        text1.setBold();
        text2.setText(row2);
        text2.hExpand();

        boxText.addWidget(text1.get());
        boxText.addWidget(text2.get());

        addWidget(photo.get());
        addLayout(boxText.get());
    }

    public void update(string row1, string row2, string icon) {
        photo.setNwsIcon(icon);
        text1.setText(row1.replace("\"", "") + tempAndWind(row2));
        text2.setText(row2);
    }

    static string tempAndWind(string row2) {
        var temperature = UtilityLocationFragment.extractTemp(row2) + GlobalVariables.degreeSymbol;
        var windDirection = UtilityLocationFragment.extractWindDirection(row2);
        var windSpeed = UtilityLocationFragment.extract7DayMetrics(row2);
        var tempAndWind = temperature + " " + windDirection + " " + windSpeed;
        return " (" + tempAndWind.strip() + ")";
    }
}
