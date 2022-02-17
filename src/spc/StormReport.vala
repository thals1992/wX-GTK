// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class StormReport {

    public string text;
    public string lat;
    public string lon;
    public string time;
    public string magnitude;
    public string address;
    public string city;
    public string state;
    public string damageReport;
    public string damageHeader;
    public LatLon latLon;

    public StormReport(string text, string lat, string lon, string time, string magnitude, string address, string city, string state, string damageReport, string damageHeader) {
        this.text = text;
        this.lat = lat;
        this.lon = lon;
        this.time = time;
        this.magnitude = magnitude;
        this.address = address;
        this.city = city;
        this.state = state;
        this.damageReport = damageReport;
        this.damageHeader = damageHeader;
        latLon = new LatLon(lat, lon);
    }
}
