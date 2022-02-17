/* Geodesy by Mike Gavaghan
*
* http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
*
* This code may be freely used and modified on any personal or professional
* project.  It comes with no warranty.
*
* BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
*/

// Encapsulation of an ellipsoid, and declaration of common reference ellipsoids.
// @author Mike Gavaghan

class ExternalEllipsoid {

    double semiMajor;
    double semiMinor;
    double flattening;
    double inverseFlattening;

    ExternalEllipsoid(double semiMajor, double semiMinor, double flattening, double inverseFlattening) {
        this.semiMajor = semiMajor;
        this.semiMinor = semiMinor;
        this.flattening = flattening;
        this.inverseFlattening = inverseFlattening;
    }

    public double getSemiMajorAxis() {
        return semiMajor;
    }

    public double getSemiMinorAxis() {
        return semiMinor;
    }

    public double getFlattening() {
        return flattening;
    }

    public static ExternalEllipsoid wgs84() {
        return fromAAndInverseF(6378137.0, 298.257223563);
    }

    // Build an Ellipsoid from the semi major axis measurement and the inverse flattening.
    public static ExternalEllipsoid fromAAndInverseF(double semiMajor, double inverseFlattening) {
        var f = 1.0 / inverseFlattening;
        var b = (1.0 - f) * semiMajor;
        return new ExternalEllipsoid(semiMajor, b, f, inverseFlattening);
    }
}
