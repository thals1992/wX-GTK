// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class AlertsDetail : Window {

    Text text = new Text();
    VBox box = new VBox();
    CapAlert capAlert = new CapAlert.zero();
    string url = "";

    public AlertsDetail(string url) {
        this.url = url;
        setSize(700, 900);
        box.addWidget(text.get());
        new ScrolledWindow(this, box);
        new FutureVoid(() => capAlert = new CapAlert(this.url), updateText);
    }

    void updateText() {
        text.setText(capAlert.text);
        setTitle(capAlert.title);
    }
}
