// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WXGLNexradLevel3WindBarbs {

    public static ArrayList<double?> decodeAndPlot(ProjectionNumbers projectionNumbers, bool isGust, FileStorage fileStorage) {
        var stormList = new ArrayList<double?>();
        var arrWb = (!isGust) ? fileStorage.obsArrWb : fileStorage.obsArrWbGust;
        var degreeShift = 180.00;
        var arrowLength = 2.5;
        var arrowSpacing = 3.0;
        var barbLengthScaleFactor = 0.4;
        var arrowBend = 60.0;
        var nmScaleFactor = -1852.0;
        var barbLength = 15.0;
        var barbOffset = 0.0;
        var above50 = false;
        foreach (var windBarb in arrWb) {
            var ecc = new ExternalGeodeticCalculator();
            var metarArr = windBarb.split(":");
            var angle = 0;
            var length = 0;
            var locXDbl = 0.0;
            var locYDbl = 0.0;
            if (metarArr.length > 3) {
                locXDbl = Too.Double(metarArr[0]);
                locYDbl = Too.Double(metarArr[1]);
                angle = Too.Int(metarArr[2]);
                length = Too.Int(metarArr[3]);
            }
            if (length > 4) {
                var degree = 0.0;
                var nm = 0.0;
                var degree2 = (double)angle;
                var startLength = nm * nmScaleFactor;
                var start = new ExternalGlobalCoordinates(locXDbl, locYDbl);
                var ec = ecc.calculateEndingGlobalCoordinates(start, degree, nm * nmScaleFactor * barbLengthScaleFactor);
                var tmpCoords = WXGLNexradLevel3Common.computeMercatorNumbersFromEc(ec, projectionNumbers);
                stormList.add(tmpCoords[0]);
                stormList.add(tmpCoords[1]);
                start = ExternalGlobalCoordinates.withEc(ec, false);
                ec = ecc.calculateEndingGlobalCoordinates(start, degree2 + degreeShift, barbLength * nmScaleFactor * barbLengthScaleFactor);
                var end = ExternalGlobalCoordinates.withEc(ec, false);
                tmpCoords = WXGLNexradLevel3Common.computeMercatorNumbersFromEc(ec, projectionNumbers);
                stormList.add(tmpCoords[0]);
                stormList.add(tmpCoords[1]);
                int barbCount = length / 10;
                var halfBarb = false;
                var oneHalfBarb = false;
                if (((length - barbCount * 10) > 4 && length > 10) || (length > 4 && length < 10)) {
                    halfBarb = true;
                }
                if (length > 4 && length < 10) {
                    oneHalfBarb = true;
                }
                if (length > 49) {
                    above50 = true;
                    barbCount -= 4;
                } else {
                    above50 = false;
                }
                var index = 0;
                if (above50) {
                    // initial angled line
                    ec = ecc.calculateEndingGlobalCoordinates(end, degree2, barbOffset + startLength + index * arrowSpacing * nmScaleFactor * barbLengthScaleFactor);
                    stormList.add_all(WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength * nmScaleFactor));
                    // perpendicular line from main barb
                    ec = ecc.calculateEndingGlobalCoordinates(end, degree2, barbOffset + startLength + -1.0 * arrowSpacing * nmScaleFactor * barbLengthScaleFactor);
                    stormList.add_all(WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - 90.0, startLength + 0.80 * arrowLength * nmScaleFactor));
                    // connecting line parallel to main barb
                    ec = ecc.calculateEndingGlobalCoordinates(end, degree2, barbOffset + startLength + index * arrowSpacing * nmScaleFactor * barbLengthScaleFactor);
                    stormList.add_all(WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - 180.0, startLength + 0.5 * arrowLength * nmScaleFactor));
                    index += 1;
                }
                UtilityList.range3(index, barbCount, 1).foreach((unused) => {
                    ec = ecc.calculateEndingGlobalCoordinates(end, degree2, barbOffset + startLength + index * arrowSpacing * nmScaleFactor * barbLengthScaleFactor);
                    stormList.add_all(WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength * nmScaleFactor));
                    index += 1;
                    return true;
                });
                var halfBarbOffsetFudge = 0.0;
                if (oneHalfBarb) {
                    halfBarbOffsetFudge = nmScaleFactor * 1.0;
                }
                if (halfBarb) {
                    ec = ecc.calculateEndingGlobalCoordinates(end, degree2, barbOffset + halfBarbOffsetFudge + startLength + index * arrowSpacing * nmScaleFactor * barbLengthScaleFactor);
                    stormList.add_all(WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength / 2.0 * nmScaleFactor));
                }
            }
        }
        return stormList;
    }
}
