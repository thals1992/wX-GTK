// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class RID {

    public string name;
    public LatLon location;
    public double distance;

    public RID(string name, LatLon location) {
        this.name = name;
        this.location = location;
        distance = 0.0;
    }
}
