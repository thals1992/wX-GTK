// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModelSpcSrefInputOutput {

    const string pattern1 = "([0-9]{10}z</a>&nbsp in through <b>f[0-9]{3})";
    const string pattern2 = "<tr><td class=.previous.><a href=sref.php\\?run=[0-9]{10}&id=SREF_H5__>([0-9]{10}z)</a></td></tr>";

    public static RunTimeData getRunTime() {
        var runData = new RunTimeData();
        var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/exper/sref/");
        var tmpTxt = UtilityString.parse(html, pattern1);
        var result = UtilityString.parseColumn(html, pattern2);
        var latestRun = tmpTxt.split("</a>")[0];
        runData.appendListRun(latestRun.replace("z", ""));
        if (!result.is_empty) {
            foreach (var data in result) {
                runData.appendListRun(data.replace("z", ""));
            }
        }
        tmpTxt = UtilityString.parse(tmpTxt, pattern1);
        tmpTxt = UtilityString.parse(tmpTxt, "(f[0-9]{3})");
        runData.imageCompleteStr = tmpTxt;
        if (!runData.listRun.is_empty) {
            runData.mostRecentRun = runData.listRun[0];
        }
        return runData;
    }

    public static string getImageUrl(ObjectModel om) {
        return GlobalVariables.nwsSPCwebsitePrefix + "/exper/sref/gifs/" + om.run.replace("z", "") + "/" + om.param + "f" + om.getTime() + ".gif";
    }
}
