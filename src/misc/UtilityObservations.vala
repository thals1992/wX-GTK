// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityObservations {

    public const string[] labels = {
        "CONUS Surface Obs",
        "SW Surface Analysis",
        "SC Surface Analysis",
        "SE Surface Analysis",
        "CW Surface Analysis",
        "C Surface Analysis",
        "CE Surface Analysis",
        "NW Surface Analysis",
        "NC Surface Analysis",
        "NE Surface Analysis",
        "AK Surface Analysis",
        "Gulf of AK Surface Analysis"
    };

    public const string[] urls = {
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/sfcobs/large_latestsfc.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namswsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namscsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namsesfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namcwsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namccsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namcesfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namnwsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namncsfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namnesfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namaksfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namak2sfcwbg.gif"
    };
}
