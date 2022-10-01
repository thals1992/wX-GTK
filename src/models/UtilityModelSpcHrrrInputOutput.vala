// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModelSpcHrrrInputOutput {

    public static RunTimeData getRunTime() {
        var runData = new RunTimeData();
        var htmlRunStatus = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/cron.log");
        runData.validTime = UtilityString.parse(htmlRunStatus, "Latest Run: ([0-9]{10})");
        runData.mostRecentRun = runData.validTime;
        runData.appendListRun(runData.mostRecentRun);
        var runTimes = UtilityString.parseColumn(htmlRunStatus, "Run: ([0-9]{8}/[0-9]{4})");
        foreach (var time in UtilityList.reversed(runTimes)) {
            var t = time.replace("/", "");
            if (t != (runData.mostRecentRun + "00")) {
                t = t.substring(0, t.length - 2);
                runData.appendListRun(t);
            }
        }
        return runData;
    }

    public static string getImageUrl(ObjectModel om) {
        var url = GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/" + getSectorCode(om.sector).ascii_down() + "/R" + om.run.replace("Z", "") + "_F" + formatTime(om.getTime()) + "_V" + getValidTime(om.run, om.getTime(), om.runTimeData.validTime) + "_" + getSectorCode(om.sector) + "_" + om.param + ".gif";
        return url;
    }

    public static string getSectorCode(string sectorName) {
        var sectorCode = "S19";
        foreach (var index in range(UtilityModelSpcHrrrInterface.sectors.length)) {
            if (sectorName == UtilityModelSpcHrrrInterface.sectors[index]) {
                sectorCode = UtilityModelSpcHrrrInterface.sectorCodes[index];
                break;
            }
        }
        return sectorCode;
    }

    //https://www.spc.noaa.gov/exper/hrrr/data/hrrr3/s14/R2020100317_F006_V2020100323_S14_ttd.gif
    public static string getValidTime(string run, string validTimeForecast, string validTime) {
        var validTimeCurrent = "";
        if (run.length == 10 && validTime.length == 10) {
            var runTimePrefix = run.substring(0, 8);
            var runTimeHr = run.substring(8, 2);
            var endTimePrefix = validTime.substring(0, 8);
            var runTimeHrInt = Too.Int(runTimeHr);
            var forecastInt = Too.Int(validTimeForecast);
            if ((runTimeHrInt + forecastInt) > 23) {
                validTimeCurrent = endTimePrefix + "%02d".printf(runTimeHrInt + forecastInt - 24);
            } else {
                validTimeCurrent = runTimePrefix + "%02d".printf(runTimeHrInt + forecastInt);
            }
        }
        return validTimeCurrent;
    }

    static string formatTime(string time) {
        return "0" + time;
    }
}
