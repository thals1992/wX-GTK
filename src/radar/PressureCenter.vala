// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class PressureCenter {

    public PressureCenterTypeEnum type;
    public string pressureInMb;
    public double lat;
    public double lon;

    public PressureCenter(PressureCenterTypeEnum type, string pressureInMb, double lat, double lon) {
        this.type = type;
        this.pressureInMb = pressureInMb;
        this.lat = lat;
        this.lon = lon;
    }
}
