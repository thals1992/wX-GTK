// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelSpcHrrrInterface {

    public const string[] sectors = {
        "National",
        "Northwest US",
        "Southwest US",
        "Northern Plains",
        "Central Plains",
        "Southern Plains",
        "Northeast US",
        "Mid Atlantic",
        "Southeast US",
        "Midwest"
    };

    public const string[] sectorCodes = {
        "S19",
        "S11",
        "S12",
        "S13",
        "S14",
        "S15",
        "S16",
        "S17",
        "S18",
        "S20"
    };

    public const string[] paramCodes = {
        "refc",
        "pmsl",
        "srh3",
        "cape",
        "proxy",
        "wmax",
        "scp",
        "uh",
        "ptype",
        "ttd"
    };

    public const string[] labels = {
        "Composite Reflectivity",
        "MSL Pressure & Wind",
        "Shear Parameters",
        "Thermo Parameters",
        "Proxy Indicators",
        "Max Surface Wind",
        "SCP / STP",
        "Updraft Helicity",
        "Winter Parameters",
        "Temp/Dwpt"
    };
}
