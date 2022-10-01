// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WXGLNexradLevel3HailIndex {

    const string pattern = "(\\d+) ";

    public static void decode(ProjectionNumbers projectionNumbers, FileStorage fileStorage) {
        var productCode = "HI";
        WXGLDownload.getNidsTab(productCode, projectionNumbers.getRadarSite(), fileStorage);
        var hailData = fileStorage.level3TextProductMap[productCode];
        var posn = UtilityString.parseColumn(hailData, "AZ/RAN(.*?)V");
        var hailPercent = UtilityString.parseColumn(hailData, "POSH/POH(.*?)V");
        var hailSize = UtilityString.parseColumn(hailData, "MAX HAIL SIZE(.*?)V");
        var posnStr = "";
        foreach (var data in posn) {
            posnStr += data.replace("/", " ");
        }
        var hailPercentStr = "";
        foreach (var data in hailPercent) {
            hailPercentStr += data.replace("/", " ");
        }
        hailPercentStr = hailPercentStr.replace("UNKNOWN", " 0 0 ");
        var hailSizeStr = "";
        foreach (var data in hailSize) {
            hailSizeStr += data.replace("/", " ");
        }
        hailSizeStr = hailSizeStr.replace("UNKNOWN", " 0.00 ");
        hailSizeStr = hailSizeStr.replace("<0.50", " 0.49 ");
        posnStr = posnStr.replace("\\s+", " ");
        hailPercentStr = hailPercentStr.replace("\\s+", " ");
        var posnNumbers = UtilityString.parseColumn(posnStr, pattern);
        var hailPercentNumbers = UtilityString.parseColumn(hailPercentStr, pattern);
        var hailSizeNumbers = UtilityString.parseColumn(hailSizeStr, " ([0-9]{1}\\.[0-9]{2}) ");
        var stormList = new ArrayList<double?>();
        if ((posnNumbers.size == hailPercentNumbers.size) && posnNumbers.size > 1) {
            var index = 0;
            foreach (var data in range3(0, posnNumbers.size - 2, 2)) {
                var hailSizeDbl = Too.Double(hailSizeNumbers[index]);
                if (hailSizeDbl > 0.49 && (Too.Int(hailPercentNumbers[data]) > 60 || Too.Int(hailPercentNumbers[data + 1]) > 60)) {
                    var ecc = new ExternalGeodeticCalculator();
                    var degree = Too.Int(posnNumbers[data]);
                    var nm = Too.Int(posnNumbers[data + 1]);
                    var start = ExternalGlobalCoordinates.withPn(projectionNumbers, true);
                    var ec = ecc.calculateEndingGlobalCoordinates(start, (double)degree, nm * 1852.0);
                    stormList.add(ec.getLatitude());
                    stormList.add(ec.getLongitude() * -1.0);
                    var baseSize = 0.015;
                    var indexForSizeLoop = 0;
                    foreach (var size in new double[]{0.99, 1.99, 2.99}) {
                        indexForSizeLoop += 1;
                        if (hailSizeDbl > size) {
                            stormList.add(ec.getLatitude() + 0.015 + indexForSizeLoop * baseSize);
                            stormList.add(ec.getLongitude() * -1.0);
                        }
                    }
                }
                index += 1;
            }
        }
        fileStorage.hiData = stormList;
    }
}
