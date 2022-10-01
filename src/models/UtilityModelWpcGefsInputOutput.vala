// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModelWpcGefsInputOutput {

    public static RunTimeData getRunTime() {
        var runData = new RunTimeData();
        var currentHour = ObjectDateTime.getCurrentHourInUTC();
        runData.mostRecentRun = "00";
        if (currentHour >= 12 && currentHour < 18) {
            runData.mostRecentRun = "06";
        }
        if (currentHour >= 18) {
            runData.mostRecentRun = "12";
        }
        if (currentHour < 6) {
            runData.mostRecentRun = "18";
        }
        runData.listRun = UtilityList.wrap({"00", "06", "12", "18"});
        runData.timeStringConversion = runData.mostRecentRun;
        return runData;
    }

    public static string getImageUrl(ObjectModel om) {
        var sectorAdd = "";
        if (om.sector == "AK") {
            sectorAdd = "ak";
        }
        var url = GlobalVariables.nwsWPCwebsitePrefix + "/exper/gefs/" + om.run + "/GEFS_" + om.param + "_" + om.run + "Z_f" + om.getTime().split(" ")[0] + sectorAdd + ".gif";
        return url;
    }
}
