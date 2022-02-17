// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectNhcStormDetails {

    public string center;
    public string classification;
    public string name;
    public string binNumber;
    public string stormId;
    public string dateTime;
    public string movement;
    public string movementDir;
    public string movementSpeed;
    public string pressure;
    public string intensity;
    public string status;
    public string baseUrl = "";
    public string goesUrl = "";
    public string lastUpdate;
    public string lastUpdatePretty;
    public string lat;
    public string lon;
    public uint8[] coneBytes;

    public ObjectNhcStormDetails(string name, string movementDir, string movementSpeed, string pressure, string binNumber, string stormId, string lastUpdate, string classification, string lat, string lon, string intensity, string status) {
        this.name = name;
        this.movementDir = movementDir;
        this.movementSpeed = movementSpeed;
        this.pressure = pressure;
        this.binNumber = binNumber;
        this.stormId = stormId;
        this.lastUpdate = lastUpdate;
        lastUpdatePretty = lastUpdate.replace("T", " ").replace(":00.000Z", "");
        this.classification = classification;
        this.lat = lat;
        this.lon = lon;
        this.intensity = intensity;
        this.status = status;
        center = lat + " " + lon;
        dateTime = lastUpdate;
        if (stormId.length > 4) {
            var modBinNumber = stormId[0:4].ascii_up();
            baseUrl = "https://www.nhc.noaa.gov/storm_graphics/" + modBinNumber.replace("AL", "AT") + "/" + stormId.ascii_up();
            goesUrl = "https://cdn.star.nesdis.noaa.gov/FLOATER/data/" + stormId.ascii_up() + "/GEOCOLOR/latest.jpg";
        }
        movement = movementDir + " at " + movementSpeed + " mph";
        coneBytes = UtilityIO.downloadAsByteArray(baseUrl + UtilityNhc.urlEnds[0]);
    }

    public string forTopHeader() {
        return movement + ", " + pressure + " mb, " + intensity + " mph";
    }
}
