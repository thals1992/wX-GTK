// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilitySwoDayOne {

    public static HashMap<int, ArrayList<double?>> hashSwo;
    static DownloadTimer timer;
    static bool initialized = false;
    public static string[] threatList;
    public static ArrayList<int> swoPaints;

    public static void get() {
        if (!initialized) {
            hashSwo = new HashMap<int, ArrayList<double?>>();
            swoPaints = new ArrayList<int>();
            swoPaints.add(Color.rgb(255, 0, 255));
            swoPaints.add(Color.rgb(255, 0, 0));
            swoPaints.add(Color.rgb(255, 140, 0));
            swoPaints.add(Color.rgb(255, 255, 0));
            swoPaints.add(Color.rgb(0, 100, 0));
            timer = new DownloadTimer("SWO");
            initialized = true;
        }
        if (timer.isRefreshNeeded()) {
            threatList = {"HIGH", "MDT", "ENH", "SLGT", "MRGL"};
            var day = 1;
            var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/KWNSPTSDY" + Too.String(day) + ".txt");
            html = html.replace(GlobalVariables.newline, GlobalVariables.sep);
            var htmlBlob = UtilityString.parse(html, "... CATEGORICAL ...(.*?&)&").replace(GlobalVariables.sep, " ").replace("   ", " ").replace("  ", " ");
            foreach (var index in UtilityList.range(threatList.length)) {
                var data = "";
                var threatLevelCode = threatList[index];
                var htmlList = UtilityString.parseColumn(htmlBlob, threatLevelCode.substring(1) + "(.*?)[A-Z&]");
                var warningList = new ArrayList<double?>();
                foreach (var polygon in htmlList) {
                    var coordinates = UtilityString.parseColumn(polygon, "([0-9]{8}).*?");
                    foreach (var coordinate in coordinates) {
                        data += LatLon.fromWatchData(coordinate).printSpaceSeparated();
                    }
                    data += ":";
                    data = data.replace(" :", ":");
                }
                var polygons = data.split(":");
                if (polygons.length > 1) {
                    foreach (var polygon in polygons) {
                        if (polygon != "") {
                            var x = new ArrayList<double?>();
                            var y = new ArrayList<double?>();
                            var numbers = polygon.split(" ");
                            foreach (var index1 in UtilityList.range(numbers.length)) {
                                if (index1 % 2 == 0) {
                                    x.add(Too.Double(numbers[index1]));
                                } else {
                                    y.add(Too.Double(numbers[index1]));
                                }
                            }
                            if (!x.is_empty && !y.is_empty) {
                                warningList.add(x[0]);
                                warningList.add(y[0]);
                                foreach (var j in UtilityList.range3(1, x.size - 1, 1)) {
                                    if (x[j] < 99.0) {
                                        warningList.add(x[j]);
                                        warningList.add(y[j]);
                                        warningList.add(x[j]);
                                        warningList.add(y[j]);
                                    } else {
                                        warningList.add(x[j - 1]);
                                        warningList.add(y[j - 1]);
                                        warningList.add(x[j + 1]);
                                        warningList.add(y[j + 1]);
                                    }
                                }
                                warningList.add(x[x.size - 1]);
                                warningList.add(y[x.size - 1]);
                            }
                            hashSwo[index] = warningList;
                        }
                    }
                } else {
                    // need to prevent stale data when app is running long
                    hashSwo[index] = new ArrayList<double?>.wrap({});
                }
            }
        }
    }
}
