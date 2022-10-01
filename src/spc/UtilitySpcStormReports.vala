// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilitySpcStormReports {

    public static ArrayList<StormReport> process(string[] lines) {
        var stormReports = new ArrayList<StormReport>();
        foreach (var line in lines) {
            var lat = "";
            var lon = "";
            var state = "";
            var time = "";
            var address = "";
            var damageReport = "";
            var magnitude = "";
            var city = "";
            var output = "";
            var damageHeader = "";
            if (line.contains(",F_Scale,")) {
                damageHeader = "Tornado Reports";
            } else if (line.contains(",Speed,")) {
                damageHeader = "Wind Reports";
            } else if (line.contains(",Size,")) {
                damageHeader = "Hail Reports";
            } else {
                var lineChunks = line.split(",");
                if (lineChunks.length > 7) {
                    output += lineChunks[0];
                    output += " ";
                    output += lineChunks[1];
                    output += " ";
                    output += lineChunks[2];
                    output += " ";
                    output += lineChunks[3];
                    output += " ";
                    output += lineChunks[4];
                    output += " ";
                    output += lineChunks[5];
                    output += " ";
                    output += lineChunks[6];
                    output += GlobalVariables.newline;
                    output += lineChunks[7];
                    time = lineChunks[0];
                    magnitude = lineChunks[1];
                    address = lineChunks[2];
                    city = lineChunks[3];
                    state = lineChunks[4];
                    lat = lineChunks[5];
                    lon = lineChunks[6];
                    damageReport = lineChunks[7];
                    stormReports.add(new StormReport(output, lat, lon, time, magnitude, address, city, state, damageReport, damageHeader));
                }
            }
        }
        return stormReports;
    }
}
