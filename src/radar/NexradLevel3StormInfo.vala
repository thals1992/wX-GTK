// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NexradLevel3StormInfo {

    public static void decode(ProjectionNumbers projectionNumbers, FileStorage fileStorage) {
        var data1 = NexradLevel3TextProduct.download("STI", projectionNumbers.getRadarSite());
        if (data1 != "") {
            var posn = UtilityString.parseColumn(data1, "AZ/RAN(.*?)V");
            var motion = UtilityString.parseColumn(data1, "MVT(.*?)V");
            var posnStr = join(posn, "").replace("/", " ");
            var motionStr = join(motion, "").replace("/", " ").replace("NEW", "  0  0  ");
            var reg = "(\\d+) ";
            var posnNumbers = UtilityString.parseColumn(posnStr, reg);
            var motNumbers = UtilityString.parseColumn(motionStr, reg);
            var sti15IncrLen = 0.40;
            var degreeShift = 180;
            var arrowLength = 2.0;
            var arrowBend = 20.0;
            var stormList = new ArrayList<double?>();
            if ((posnNumbers.size == motNumbers.size) && posnNumbers.size > 1) {
                foreach (var index in range3(0, posnNumbers.size - 2, 2)) {
                    var ecc = new ExternalGeodeticCalculator();
                    var degree = Too.Int(posnNumbers[index]);
                    var nm = Too.Int(posnNumbers[index + 1]);
                    var degree2 = Too.Double(motNumbers[index]);
                    var nm2 = Too.Int(motNumbers[index + 1]);
                    var start = ExternalGlobalCoordinates.withPn(projectionNumbers, true);
                    var ec = ecc.calculateEndingGlobalCoordinates(start, (double)degree, nm * 1852.0);
                    var coord = NexradLevel3Common.computeMercatorNumbersFromEc(ec, projectionNumbers);
                    stormList.add(coord[0]);
                    stormList.add(coord[1]);
                    start = ExternalGlobalCoordinates.withEc(ec, false);
                    ec = ecc.calculateEndingGlobalCoordinates(start, degree2 + degreeShift, nm2 * 1852.0);
                    var tmpCoords = NexradLevel3Common.computeMercatorNumbersFromEc(ec, projectionNumbers);
                    stormList.add(tmpCoords[0]);
                    stormList.add(tmpCoords[1]);
                    var ecArr = new ArrayList<ExternalGlobalCoordinates>();
                    var latLons = new ArrayList<LatLon>();
                    foreach (var index1 in range(4)) {
                        ecArr.add(ecc.calculateEndingGlobalCoordinates(start, degree2 + degreeShift, nm2 * 1852.0 * index1 * 0.25));
                        latLons.add(LatLon.fromList(NexradLevel3Common.computeMercatorNumbersFromEc(ecArr[index1], projectionNumbers)));
                    }
                    var endPoint = new ArrayList<double?>();
                    endPoint.add(tmpCoords[0]);
                    endPoint.add(tmpCoords[1]);
                    if (nm2 > 0) {
                        start = ExternalGlobalCoordinates.withEc(ec, false);
                        stormList.add_all(NexradLevel3Common.drawLineFromLatLon(endPoint, ecc, projectionNumbers, start, degree2 + arrowBend, arrowLength * 1852.0));
                        stormList.add_all(NexradLevel3Common.drawLineFromLatLon(endPoint, ecc, projectionNumbers, start, degree2 - arrowBend, arrowLength * 1852.0));
                        // 15,30,45 min ticks
                        var tickMarkAngleOff90 = 30.0;
                        foreach (var index2 in range3(0, 4, 1)) {
                            // first line
                            stormList.add_all(drawTickMarks(latLons[index2], ecc, projectionNumbers, ecArr[index2], degree2 - (90.0 + tickMarkAngleOff90), arrowLength * 1852.0 * sti15IncrLen));
                            stormList.add_all(drawTickMarks(latLons[index2], ecc, projectionNumbers, ecArr[index2], degree2 + (90.0 - tickMarkAngleOff90), arrowLength * 1852.0 * sti15IncrLen));
                            // 2nd line
                            stormList.add_all(drawTickMarks(latLons[index2], ecc, projectionNumbers, ecArr[index2], degree2 - (90.0 - tickMarkAngleOff90), arrowLength * 1852.0 * sti15IncrLen));
                            stormList.add_all(drawTickMarks(latLons[index2], ecc, projectionNumbers, ecArr[index2], degree2 + (90.0 + tickMarkAngleOff90), arrowLength * 1852.0 * sti15IncrLen));
                        }
                    }
                }
            }
            fileStorage.stiData = stormList;
        } else {
            fileStorage.stiData = new ArrayList<double?>();
        }
    }

    static ArrayList<double?> drawTickMarks(
            LatLon startPoint,
            ExternalGeodeticCalculator ecc,
            ProjectionNumbers pn,
            ExternalGlobalCoordinates ecArr,
            double startBearing,
            double distance
        ) {
        var start = ExternalGlobalCoordinates.withEc(ecArr, false);
        var ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance);
        var coordinates = NexradLevel3Common.computeMercatorNumbersFromEc(ec, pn);
        var returnList = new ArrayList<double?>.wrap({startPoint.lat(), startPoint.lon(), coordinates[0], coordinates[1]});
        return returnList;
    }
}
