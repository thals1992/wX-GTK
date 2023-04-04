// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Projection {

    public static double[] computeMercatorNumbersFromLatLon(LatLon latLon, ProjectionNumbers projectionNumbers) {
        return computeMercatorNumbers(latLon.lat(), latLon.lon(), projectionNumbers);
    }

    public static double[] computeMercatorNumbers(double x, double y, ProjectionNumbers pn) {
        var pnY = -1.0 * pn.y();
        var test1 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + x * (Math.PI / 180.0) / 2.0)));
        var test2 = (180.0 / Math.PI * Math.log(Math.tan(Math.PI / 4.0 + pn.x() * (Math.PI / 180.0) / 2.0)));
        var y1 = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenter;
        var x1 = -1.0 * ((y - pnY) * pn.oneDegreeScaleFactor) + pn.xCenter;
        return {x1, y1};
    }
}
