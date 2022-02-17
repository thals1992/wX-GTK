/* Geodesy by Mike Gavaghan
*
* http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
*
* This code may be freely used and modified on any personal or professional
* project.  It comes with no warranty.
*
* BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf

<p>
Encapsulation of latitude and longitude coordinates on a globe. Negative
latitude is southern hemisphere. Negative longitude is western hemisphere.
</p>
<p>
Any angle may be specified for longtiude and latitude, but all angles will be
canonicalized such that:
</p>

<pre>
-90 &lt= latitude &lt= +90 - 180 &lt longitude &lt= +180
</pre>

@author Mike Gavaghan
*/

class ExternalGlobalCoordinates {

    // Latitude in degrees. Negative latitude is southern hemisphere. */
    double latitude;

    // Longitude in degrees. Negative longitude is western hemisphere. */
    double longitude;

    public ExternalGlobalCoordinates(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // default bool to false
    public static ExternalGlobalCoordinates withEc(ExternalGlobalCoordinates ec, bool lonNegativeOne) {
        return lonNegativeOne ? new ExternalGlobalCoordinates(ec.getLatitude(), ec.getLongitude() * -1.0) : new ExternalGlobalCoordinates(ec.getLatitude(), ec.getLongitude());
    }

    // default bool to false
    public static ExternalGlobalCoordinates withPn(ProjectionNumbers pn, bool lonNegativeOne) {
        return lonNegativeOne ? new ExternalGlobalCoordinates(pn.x(), pn.y() * -1.0) : new ExternalGlobalCoordinates(pn.x(), pn.y());
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }
}
