// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class TextViewer : Window {

    VBox box = new VBox();
    Text text = new Text();

    public TextViewer(string url) {
        maximize();
        text.setFixedWidth();
        box.addWidget(text.get());
        new ScrolledWindow(this, box);
        new FutureText(url, text.setText);
    }
}
