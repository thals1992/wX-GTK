// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class TextViewerStatic : Window {

    VBox box = new VBox();
    Text text = new Text();

    public TextViewerStatic(string data) {
        maximize();
        box.addWidget(text);
        new ScrolledWindow(this, box);
        text.setText(data);
    }
}
