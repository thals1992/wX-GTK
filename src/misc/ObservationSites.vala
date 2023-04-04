// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObservationSites : Window {

    ButtonLink button1 = new ButtonLink("https://www.wrh.noaa.gov/map/?obs=true&wfo=" + Location.wfo().ascii_down(), Location.wfo() + ": nearby current observations");
    ButtonLink button2 = new ButtonLink("https://www.weather.gov/wrh/timeseries?site=" + Location.getObs(), Location.getObs() + ": recent observations");
    VBox box = new VBox();

    public ObservationSites() {
        setSize (600, 600);
        setTitle("Observation web sites - " + Location.name());
        box.addWidget(button1);
        box.addWidget(button2);
        new ScrolledWindow(this, box);
    }
}
