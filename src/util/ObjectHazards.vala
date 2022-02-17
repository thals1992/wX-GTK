// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectHazards {

    public LatLon latLon;
    public string data = "";

    public ObjectHazards(LatLon latLon) {
        this.latLon = latLon;
    }

    public void process() {
        data = UtilityIO.getHtml("https://api.weather.gov/alerts?point=" + latLon.latStr() + "," + latLon.lonStr() + "&active=1");
    }
}
