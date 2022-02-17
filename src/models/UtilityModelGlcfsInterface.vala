// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelGlcfsInterface {

    public const string[] sectors = {
        "Lake Superior",
        "Lake Michigan",
        "Lake Huron",
        "Lake Erie",
        "Lake Ontario",
        "All Lakes"
    };

    public const string[] paramCodes = {
        "wv",
        "wn",
        "swt",
        "sfcur",
        "wl",
        "wl1d",
        "cl",
        "at"
    };

    public const string[] labels = {
        "Wave height",
        "Wind speed",
        "Surface temperature",
        "Surface currents",
        "Water level displacement",
        "Water level displacement 1D",
        "Cloud cover (5 lake view only)",
        "Air temp (5 lake view only)"
    };
}
