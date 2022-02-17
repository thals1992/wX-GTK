// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectModelGet {

    public static void getRunStatus(ObjectModel om) {
        if (om.prefModel == "NSSLWRF") {
            om.runTimeData = UtilityModelNsslWrfInputOutput.getRunTime();
        } else if (om.prefModel == "ESRL") {
            om.runTimeData = UtilityModelEsrlInputOutput.getRunTime(om);
            om.run = om.runTimeData.mostRecentRun;
            om.runs = om.runTimeData.listRun;
        } else if (om.prefModel == "GLCFS") {
            print("");
        } else if (om.prefModel == "NCEP") {
            om.runTimeData = UtilityModelNcepInputOutput.getRunTime(om);
            om.runTimeData.listRun = om.runs;
        } else if (om.prefModel == "WPCGEFS") {
            om.runTimeData = UtilityModelWpcGefsInputOutput.getRunTime();
            om.runs = om.runTimeData.listRun;
        } else if (om.prefModel == "SPCHRRR") {
            om.runTimeData = UtilityModelSpcHrrrInputOutput.getRunTime();
        } else if (om.prefModel == "SPCHREF") {
            om.runTimeData = UtilityModelSpcHrefInputOutput.getRunTime();
        } else if (om.prefModel == "SPCSREF") {
            om.runTimeData = UtilityModelSpcSrefInputOutput.getRunTime();
        }
    }

    public static string getImageUrl(ObjectModel om) {
        if (om.prefModel == "NSSLWRF") {
            return UtilityModelNsslWrfInputOutput.getImageUrl(om);
        } else if (om.prefModel == "ESRL") {
            return UtilityModelEsrlInputOutput.getImageUrl(om);
        } else if (om.prefModel == "GLCFS") {
            return UtilityModelGlcfsInputOutput.getImageUrl(om);
        } else if (om.prefModel == "NCEP") {
            if (om.model == "NAM4KM") {
                om.model = "NAM-HIRES";
            }
            if (om.model.contains("HRW") && om.model.contains("-AK")) {
                om.model = om.model.replace("-AK", "");
            }
            if (om.model.contains("HRW") && om.model.contains("-PR")) {
                om.model = om.model.replace("-PR", "");
            }
            if (om.model != "HRRR") {
                om.timeStr = UtilityString.truncate(om.timeStr, 3);
            } else {
                om.timeStr = UtilityString.truncate(om.timeStr, 3);
            }
            return UtilityModelNcepInputOutput.getImageUrl(om);
        } else if (om.prefModel == "WPCGEFS") {
            return UtilityModelWpcGefsInputOutput.getImageUrl(om);
        } else if (om.prefModel == "SPCHRRR") {
            return UtilityModelSpcHrrrInputOutput.getImageUrl(om);
        } else if (om.prefModel == "SPCHREF") {
            // return UtilityModelSpcHrefInputOutput.getImageUrl(this);
            return "";
        } else if (om.prefModel == "SPCSREF") {
            return UtilityModelSpcSrefInputOutput.getImageUrl(om);
        } else {
            return "";
        }
    }
}
