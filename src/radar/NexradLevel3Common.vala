// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NexradLevel3Common {

    public static ArrayList<double?> drawLine(
        ExternalGlobalCoordinates startEc,
        ExternalGeodeticCalculator ecc,
        ProjectionNumbers pn,
        double startBearing,
        double distance
    ) {
        var start = ExternalGlobalCoordinates.withEc(startEc, false);
        var startCoords = computeMercatorNumbersFromEc(startEc, pn);
        var ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance);
        var coordinates = computeMercatorNumbersFromEc(ec, pn);
        var listToReturn = new ArrayList<double?>();
        listToReturn.add(startCoords[0]);
        listToReturn.add(startCoords[1]);
        listToReturn.add(coordinates[0]);
        listToReturn.add(coordinates[1]);
        return listToReturn;
    }

    public static ArrayList<double?> drawLineFromLatLon(
        ArrayList<double?> startPoint,
        ExternalGeodeticCalculator ecc,
        ProjectionNumbers pn,
        ExternalGlobalCoordinates start,
        double startBearing,
        double distance
    ) {
        var ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance);
        var coordinates = computeMercatorNumbersFromEc(ec, pn);
        var listToReturn = new ArrayList<double?>();
        listToReturn.add_all(startPoint);
        listToReturn.add(coordinates[0]);
        listToReturn.add(coordinates[1]);
        return listToReturn;
    }

    public static double[] computeMercatorNumbersFromEc(ExternalGlobalCoordinates ec, ProjectionNumbers pn) {
        return Projection.computeMercatorNumbers(ec.getLatitude(), ec.getLongitude() , pn);
    }
}
