// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Hourly : Window {

    VBox box = new VBox();
    Text text = new Text();

    public Hourly() {
        #if GTK3
            print("GTK3\n");
        #else
            print("NOT GTK3\n");
        #endif

        setTitle("Hourly forecast for " + Location.locationName());
        setSize(500, 900);
        text.setFixedWidth();
        box.addWidget(text.get());
        new ScrolledWindow(this, box);
        new FutureText("HOURLY", text.setText);
    }
}
