// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class CardCurrentConditions : HBox {

    VBox boxText = new VBox();
    Photo photo = new Photo.icon();
    Text text1 = new Text();
    Text text2 = new Text();
    Text text3 = new Text();

    public CardCurrentConditions(CurrentConditions cc) {
        photo.setNwsIcon(cc.iconUrl);
        boxText.setSpacing(0);

        text1.setText(cc.topLine);
        text1.setBold();
        text1.setWordWrap(false);
        text2.setText(cc.middleLine);
        text3.setText(cc.bottomLine);

        boxText.addWidget(text1);
        boxText.addWidget(text2);
        boxText.addWidget(text3);

        addWidget(photo);
        addLayout(boxText);
    }

    public void update(CurrentConditions cc) {
        text1.setText(cc.topLine);
        text2.setText(cc.middleLine);
        text3.setText(cc.bottomLine);
        photo.setNwsIcon(cc.iconUrl);
    }
}
