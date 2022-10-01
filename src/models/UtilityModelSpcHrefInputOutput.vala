// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModelSpcHrefInputOutput {

    public static RunTimeData getRunTime() {
        var runData = new RunTimeData();
        var htmlRunstatus = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/");
        var html = UtilityString.parse(htmlRunstatus, "\\{model: \"href\",product: \"500mbmean\",sector: \"conus\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",\\})");
        var day = UtilityString.parse(html, "rd:.(.*?),.*?");
        day = day.replace("\"", "");
        var time = UtilityString.parse(html, "rt:.(.*?)00.,.*?");
        time = time.replace("\"", "");
        var mostRecentRun = day + time;
        runData.appendListRun(mostRecentRun);
        runData.appendListRunWithList(UtilityModels.generateModelRuns(mostRecentRun, 12));
        runData.mostRecentRun = mostRecentRun;
        return runData;
    }

    // public static string getImageUrl(ObjectModel om) {
    //     string year = om.run.substring(0, 4);
    //     string month = om.run.substring(4, 6);
    //     string day = om.run.substring(6, 8);
    //     string hour = om.run.substring(8, 10);
    //     string[] products = om.param.split(",");
    //     ArrayList<string> urlArr = new ArrayList<string>();
    //     urlArr.add(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/spcwhite1050px.png");
    //     urlArr.add(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/noaaoverlay1050px.png");
    //     int sectorIndex = indexOf(UtilityModelSpcHrefInterface.sectorsLong, om.sector);
    //     string sector = UtilityModelSpcHrefInterface.sectors[sectorIndex];
    //     foreach (string data in products) {
    //         string url = "";
    //         if (data.contains("crefmembers")) {
    //             string[] paramArr = data.split(" ");
    //             url = GlobalVariables.nwsSPCwebsitePrefix +
    //                     "/exper/href/graphics/models/href/" +
    //                     year +
    //                     "/" +
    //                     month +
    //                     "/" +
    //                     day +
    //                     "/" +
    //                     hour +
    //                     "00/f0" +
    //                     om.getTime() +
    //                     "00/" +
    //                     paramArr[0] +
    //                     "." +
    //                     sector +
    //                     ".f0" +
    //                     om.getTime() +
    //                     "00." +
    //                     paramArr[1] +
    //                     ".tl00.png";
    //         } else {
    //             url = GlobalVariables.nwsSPCwebsitePrefix +
    //                     "/exper/href/graphics/models/href/" +
    //                     year +
    //                     "/" +
    //                     month +
    //                     "/" +
    //                     day +
    //                     "/" +
    //                     hour +
    //                     "00/f0" +
    //                     om.getTime() +
    //                     "00/" +
    //                     data +
    //                     "." +
    //                     sector +
    //                     ".f0" +
    //                     om.getTime() +
    //                     "00.png";
    //         }
    //         urlArr.add(url);
    //     }
    //     urlArr.add(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/blankmaps/" + sector + ".png");
    //     return Utility.join(urlArr, UtilityModels.urlSeperator);
    // }
}
