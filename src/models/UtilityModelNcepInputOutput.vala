// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelNcepInputOutput {

    const string pattern = "current_cycle_white . .([0-9 ]{11} UTC)";

    public static RunTimeData getRunTime(ObjectModel om) {
        var runData = new RunTimeData();
        var url = "https://mag.ncep.noaa.gov/model-guidance-model-parameter.php?group=Model%20Guidance&model=" + om.model.ascii_up() + "&area=" + om.sector + "&ps=area";
        var html = UtilityIO.getHtml(url);
        html = UtilityString.parse(html, pattern);
        html = html.replace("UTC", "Z");
        html = html.replace(" ", "");
        var runCompletionDataStr = html.replace("Z", " UTC");
        if (runCompletionDataStr != "") {
            runCompletionDataStr = UtilityString.insert(runCompletionDataStr, 8, " ");
        }
        var runCompletionUrl = "https://mag.ncep.noaa.gov/model-guidance-model-parameter.php?group=Model%20Guidance&model=" + om.model.ascii_up();
        runCompletionUrl += "&area=" + om.sector.ascii_down();
        runCompletionUrl += "&cycle=" + runCompletionDataStr;
        runCompletionUrl += "&param=" + om.param + "&fourpan=no&imageSize=M&ps=area";
        runCompletionUrl = runCompletionUrl.replace(" ", "%20");
        var ncepPattern1 = "([0-9]{2}Z)";
        var time = UtilityString.parse(html, ncepPattern1);
        runData.mostRecentRun = time;
        runData.timeStringConversion = time;
        var timeCompleteUrl = "https://mag.ncep.noaa.gov/model-fhrs.php?group=Model%20Guidance&model=" + om.model.ascii_down() + "&fhrmode=image&loopstart=-1&loopend=-1&area=" + om.sector + "&fourpan=no&imageSize=&preselectedformattedcycledate=" + runCompletionDataStr + "&cycle=" + runCompletionDataStr + "&param=" + om.param + "&ps=area";
        var timeCompleteHTML = UtilityIO.getHtml(timeCompleteUrl.replace(" ", "%20"));
        runData.imageCompleteStr = UtilityString.parse(timeCompleteHTML, "SubmitImageForm.(.*?).\"");
        return runData;
    }

    public static string getImageUrl(ObjectModel om) {
        var imgUrl = "";
        var timeLocal = om.getTime();
        if (om.model == "HRRR") {
            timeLocal = om.getTime() + "00";
        }
        if (om.model == "GFS") {
            imgUrl = "https://mag.ncep.noaa.gov/data/" + om.model.ascii_down() + "/" + om.run.replace("Z", "") + "/" + om.sector.ascii_down() + "/" + om.param + "/" + om.model.ascii_down() + "_" + om.sector.ascii_down() + "_" + timeLocal + "_" + om.param + ".gif";
        } else {
            imgUrl = "https://mag.ncep.noaa.gov/data/" + om.model.ascii_down() + "/" + om.run.replace("Z", "") + "/" + om.model.ascii_down() + "_" + om.sector.ascii_down() + "_" + timeLocal + "_" + om.param + ".gif";
        }
        return imgUrl;
    }
}
