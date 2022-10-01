// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModelEsrlInputOutput {

    const string pattern1 = "<option selected>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>";
    const string pattern2 = "<option>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>";
    const string pattern3 = "[0-9]{2} \\w{3} ([0-9]{4}) - [0-9]{2}Z";
    const string pattern4 = "([0-9]{2}) \\w{3} [0-9]{4} - [0-9]{2}Z";
    const string pattern5 = "[0-9]{2} \\w{3} [0-9]{4} - ([0-9]{2})Z";
    const string pattern6 = "[0-9]{2} (\\w{3}) [0-9]{4} - [0-9]{2}Z";

    public static RunTimeData getRunTime(ObjectModel om) {
        var runData = new RunTimeData();
        var htmlRunstatus = "";
        switch (om.model) {
            case "HRRR_AK":
                htmlRunstatus = UtilityIO.getHtml("https://rapidrefresh.noaa.gov/alaska/");
                break;
            case "RAP_NCEP":
                htmlRunstatus = UtilityIO.getHtml("https://rapidrefresh.noaa.gov/RAP/Welcome.cgi?dsKey=" + om.model.ascii_down() + "_jet&domain=full");
                break;
            case "RAP":
                htmlRunstatus = UtilityIO.getHtml("https://rapidrefresh.noaa.gov/RAP/");
                break;
            case "HRRR_NCEP":
                htmlRunstatus = UtilityIO.getHtml("https://rapidrefresh.noaa.gov/hrrr/HRRR/Welcome.cgi?dsKey=" + om.model.ascii_down() + "_jet&domain=full");
                break;
            default:
                htmlRunstatus = UtilityIO.getHtml("https://rapidrefresh.noaa.gov/" + om.model.ascii_down() + "/" + om.model + "/Welcome.cgi?dsKey=" + om.model.ascii_down() + "_jet&domain=full");
                break;
        }
        var html = UtilityString.parse(htmlRunstatus, pattern1);
        var oldRunTimes = UtilityString.parseColumn(htmlRunstatus, pattern2);
        var year1 = UtilityString.parse(html, pattern3);
        var day1 = UtilityString.parse(html, pattern4);
        var hour1 = UtilityString.parse(html, pattern5);
        var monthStr1 = monthWordToNumber(UtilityString.parse(html, pattern6));
        html = year1 + monthStr1 + day1 + hour1;
        runData.appendListRun(html);
        runData.mostRecentRun = html;
        runData.imageCompleteInt = UtilityString.parseAndCount(htmlRunstatus, ".(allfields).") - 1;
        runData.imageCompleteStr = Too.String(runData.imageCompleteInt);
        if (html != "") {
            foreach (var data in range3(0, 12, 1)) {
                var year = UtilityString.parse(oldRunTimes[data], pattern3);
                var day = UtilityString.parse(oldRunTimes[data], pattern4);
                var hour = UtilityString.parse(oldRunTimes[data], pattern5);
                var monthStr = monthWordToNumber(UtilityString.parse(oldRunTimes[data], pattern6));
                runData.appendListRun(year + monthStr + day + hour);
            }
            runData.timeStringConversion = UtilityString.parse(html, "([0-9]{2})\$");
        }
        return runData;
    }

    public static string getImageUrl(ObjectModel om) {
        var parentModel = "";
        switch (om.model) {
            case "RAP_NCEP":
                parentModel = "RAP";
                break;
            case "HRRR_NCEP":
                parentModel = "HRRR";
                break;
            default:
                break;
        }
        var imgUrl = "";
        var ondemandUrl = "";
        var sectorLocal = om.sector.replace(" ", "");
        sectorLocal = sectorLocal.replace("Full", "full");
        sectorLocal = sectorLocal.replace("CONUS", "conus");
        var param = om.param.replace("_full_", "_" + sectorLocal + "_");
        if (parentModel.contains("RAP")) {
            imgUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/for_web/" + om.model.ascii_down()
                            + "_jet/" + om.run.replace("Z", "") + "/"
                            + sectorLocal + "/" + param + "_f0"
                            + om.getTime() + ".png";
            ondemandUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/" + "displayMapUpdated"
                            + ".cgi?keys=" + om.model.ascii_down() + "_jet:&runtime="
                            + om.run.replace("Z", "") + "&plot_type=" + param
                            + "&fcst=" + om.getTime() + "&time_inc=60&num_times=16&model="
                            + om.model.ascii_down() + "&ptitle=" + om.model
                            + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain="
                            + sectorLocal + "&adtfn=1";
        } else {
            imgUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.ascii_up() + "/for_web/"
                            + om.model.ascii_down() + "_jet/" + om.run.replace("Z", "")
                            + "/" + sectorLocal + "/" + param + "_f0"
                            + om.getTime() + ".png";
            ondemandUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.ascii_up() + "/"
                            + "displayMapUpdated" + ".cgi?keys=" + om.model.ascii_down()
                            + "_jet:&runtime=" + om.run.replace("Z", "")
                            + "&plot_type=" + param + "&fcst=" + om.getTime()
                            + "&time_inc=60&num_times=16&model=" + om.model.ascii_down()
                            + "&ptitle=" + om.model + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain="
                            + sectorLocal + "&adtfn=1";
        }
        UtilityIO.getHtml(ondemandUrl);
        return imgUrl;
    }

    public static string monthWordToNumber(string month) {
        var s = month.replace("Jan", "01");
        s = s.replace("Feb", "02");
        s = s.replace("Mar", "03");
        s = s.replace("Apr", "04");
        s = s.replace("May", "05");
        s = s.replace("Jun", "06");
        s = s.replace("Jul", "07");
        s = s.replace("Aug", "08");
        s = s.replace("Sep", "09");
        s = s.replace("Oct", "10");
        s = s.replace("Nov", "11");
        s = s.replace("Dec", "12");
        return s;
    }
}
