// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelGlcfsInputOutput {

    public static string getImageUrl(ObjectModel om) {
        var sectorLocal = om.sector;
        if (om.sector.split(" ").length > 1) {
            var tmp = om.sector.split(" ")[1];
            tmp = tmp.substring(0, 1);
            tmp = tmp.ascii_down();
            sectorLocal = tmp;
        }
        return "https://www.glerl.noaa.gov/res/glcfs/fcast/" + sectorLocal + om.param + "+" + om.getTime() + ".gif";
    }
}
