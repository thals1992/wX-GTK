// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelNsslWrfInputOutput {

    const string baseUrl = "https://cams.nssl.noaa.gov";

    public static RunTimeData getRunTime() {
        var runData = new RunTimeData();
        var htmlRunstatus = UtilityIO.getHtml(baseUrl);
        var html = UtilityString.parse(htmlRunstatus, "\\{model: \"fv3nssl\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",)");
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

    public static string getImageUrl(ObjectModel om) {
        var sectorIndex = indexOf(UtilityModelNsslWrfInterface.sectorsLong, om.sector);
        var sector = UtilityModelNsslWrfInterface.sectors[sectorIndex];
        var baseLayerUrl = "https://cams.nssl.noaa.gov/graphics/blankmaps/spc" + sector + ".png";
        var modelPostfix = "nssl";
        var model = om.model.ascii_down();
        if (om.model == "HRRRV3") {
            modelPostfix = "";
        }
        if (om.model == "WRF3KM") {
            model = "wrfnssl3km";
            modelPostfix = "";
        }
        var year = om.run.substring(0, 4);
        var month = om.run.substring(4, 6);
        var day = om.run.substring(6, 8);
        var hour = om.run.substring(8, 10);
        var url = baseUrl + "/graphics/models/" + model + modelPostfix + "/" + year + "/" + month + "/" + day + "/" + hour + "00/f0" + om.getTime() + "00/" + om.param + ".spc" + sector.ascii_down() + ".f0" + om.getTime() + "00.png";
        return url + "," + baseLayerUrl;
    }
}
