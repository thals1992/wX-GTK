// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilitySpcCompmap {

    public const string[] labels = {
        "IR satellite",
        "MAPS sea-level pressure (mb)",
        "2-meter temperature  (F)",
        "2-meter dewpoint temperature  (F)",
        "10m Wind Barbs",
        "CAPE/CINH",
        "HLCY/SHEAR",
        "3-hr surface pressure change",
        "Boundary layer mositure (mixing ratio) convergence",
        "K-Index and Precipitable Water (inches)",
        "12-hr Total Precipitation",
        "SFC OBS MAP",
        "Lapse rates 500-850mb",
        "850 WAA/WIND",
        "700 INFO",
        "700-500 mb layer average relative humidity",
        "500 mb height and absolute vorticity (dashed) field",
        "700-500 mb Upward Vertical Velocity",
        "300mb winds",
        "DAY 1 Outlook (94O)",
        "HPC Fronts (90F)",
        "HPC 6-hr QPF (92E)"
    };

    public const string[] urlIndices = {
        "16",
        "7",
        "1",
        "0",
        "8",
        "2",
        "21",
        "3",
        "4",
        "5",
        "6",
        "9",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "17",
        "18",
        "19",
        "20"
    };

    public static string getImage(string product) {
        return GlobalVariables.nwsSPCwebsitePrefix + "/exper/compmap/" + product + ".gif";
    }
}
