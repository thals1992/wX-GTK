// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class TextViewerStaticBox : VBox {

    Text text = new Text();

    public TextViewerStaticBox(string data) {
        addWidget(text.get());
        text.setText(data);
    }
}
