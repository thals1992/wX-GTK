// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class ObjectCardBlackHeaderText : HBox {

    Text text = new Text();

    public ObjectCardBlackHeaderText(string header) {
        text.setText(header);
        text.setBlue();
        text.setBold();
        text.setLarge();
        addWidget(text.get());
    }
}
