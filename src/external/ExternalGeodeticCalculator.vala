/* Geodesy by Mike Gavaghan
*
* http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
*
* This code may be freely used and modified on any personal or professional
* project.  It comes with no warranty.
*
* BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
<p>
Implementation of Thaddeus Vincenty"s algorithms to solve the direct and
inverse geodetic problems. For more information, see Vincent"s original
publication on the NOAA website:
</p>
See http://www.ngs.noaa.gov/PUBSLIB/inverse.pdf
@author Mike Gavaghan
*/

using Gee;

class ExternalGeodeticCalculator {

    const double twoPi = 2.0 * Math.PI;

    // Calculate the destination and var bearing after traveling a specified
    // distance, and a specified starting bearing, for an initial location. This
    // is the solution to the direct geodetic problem.
    //
    // @param ellipsoid reference ellipsoid to use
    // @param start starting location
    // @param startBearing starting bearing (degrees)
    // @param distance distance to travel (meters)
    // @param endBearing bearing at destination (degrees) element at index 0 will
    //            be populated with the result
    // @return
    //
    //
    public ExternalGlobalCoordinates calculateEndingGlobalCoordinates(ExternalGlobalCoordinates start, double startBearing, double distance) {
        return calculateEndingGlobalCoordinatesOriginal(ExternalEllipsoid.wgs84(), start, startBearing, distance, {0.0, 0.0});
    }

    ExternalGlobalCoordinates calculateEndingGlobalCoordinatesOriginal(
            ExternalEllipsoid ellipsoid,
            ExternalGlobalCoordinates start,
            double startBearing,
            double distance,
            double[] endBearing
    ) {
        var a = ellipsoid.getSemiMajorAxis();
        var b = ellipsoid.getSemiMinorAxis();
        var aSquared = a * a;
        var bSquared = b * b;
        var f = ellipsoid.getFlattening();
        var phi1 = ExternalAngle.toRadians(start.getLatitude());
        var alpha1 = ExternalAngle.toRadians(startBearing);
        var cosAlpha1 = Math.cos(alpha1);
        var sinAlpha1 = Math.sin(alpha1);
        var s = distance;
        var tanU1 = (1.0 - f) * Math.tan(phi1);
        var cosU1 = 1.0 / Math.sqrt(1.0 + tanU1 * tanU1);
        var sinU1 = tanU1 * cosU1;
        // eq. 1
        var sigma1 = Math.atan2(tanU1, cosAlpha1);
        // eq. 2
        var sinAlpha = cosU1 * sinAlpha1;
        var sin2Alpha = sinAlpha * sinAlpha;
        var cos2Alpha = 1.0 - sin2Alpha;
        var uSquared = cos2Alpha * (aSquared - bSquared) / bSquared;
        // eq. 3
        var A = 1 + (uSquared / 16384) * (4096 + uSquared * (-768 + uSquared * (320 - 175 * uSquared)));
        // eq. 4
        var B = (uSquared / 1024) * (256 + uSquared * (-128 + uSquared * (74 - 47 * uSquared)));
        // iterate until there is a negligible change in sigma
        double deltaSigma;
        var sOverbA = s / (b * A);
        //  printD(sOverbA);
        var sigma = sOverbA;
        double sinSigma;
        var prevSigma = sOverbA;
        double sigmaM2;
        double cosSigmaM2;
        double cos2SigmaM2;
        while (true) {
            // eq. 5
            sigmaM2 = 2.0 * sigma1 + sigma;
            cosSigmaM2 = Math.cos(sigmaM2);
            cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;
            sinSigma = Math.sin(sigma);
            var cosSignma = Math.cos(sigma);
            // eq. 6
            deltaSigma = B *
                    sinSigma *
                    (cosSigmaM2 + (B / 4.0) * (cosSignma * (-1 + 2 * cos2SigmaM2) - (B / 6.0) * cosSigmaM2 * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM2)));
            // eq. 7
            sigma = sOverbA + deltaSigma;
            // break after converging to tolerance
            if ((sigma - prevSigma).abs() < 0.0000000000001) {
                break;
            }
            prevSigma = sigma;
        }
        sigmaM2 = 2.0 * sigma1 + sigma;
        cosSigmaM2 = Math.cos(sigmaM2);
        cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;
        var cosSigma = Math.cos(sigma);
        sinSigma = Math.sin(sigma);
        // eq. 8
        var phi2 = Math.atan2(
                sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1, (1.0 - f) * Math.sqrt(sin2Alpha + Math.pow(sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1, 2.0)));
        // eq. 9
        // This fixes the pole crossing defect spotted by Matt Feemster. When a
        // path passes a pole and essentially crosses a line of latitude twice -
        // once in each direction - the longitude calculation got messed up. Using
        // atan2 instead of atan fixes the defect. The change is in the next 3
        // lines.
        // double tanLambda = sinSigma * sinAlpha1 / (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
        // double lambda = Math.atan(tanLambda);
        var lambda = Math.atan2(sinSigma * sinAlpha1, (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1));
        // eq. 10
        var C = (f / 16.0) * cos2Alpha * (4.0 + f * (4.0 - 3.0 * cos2Alpha));
        // eq. 11
        var L = lambda - (1.0 - C) * f * sinAlpha * (sigma + C * sinSigma * (cosSigmaM2 + C * cosSigma * (-1.0 + 2.0 * cos2SigmaM2)));
        // eq. 12
        var alpha2 = Math.atan2(sinAlpha, -sinU1 * sinSigma + cosU1 * cosSigma * cosAlpha1);
        // build result
        var latitude = ExternalAngle.toDegrees(phi2);
        var longitude = start.getLongitude() + ExternalAngle.toDegrees(L);
        if ((endBearing != null) && (endBearing.length > 0)) {
            endBearing[0] = ExternalAngle.toDegrees(alpha2);
        }
        return new ExternalGlobalCoordinates(latitude, longitude);
    }
}
