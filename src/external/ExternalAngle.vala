/* Geodesy by Mike Gavaghan
*
* http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
*
* This code may be freely used and modified on any personal or professional
* project.  It comes with no warranty.
*
* BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
*/
// Utility methods for dealing with angles.
// @author Mike Gavaghan

class ExternalAngle {

    // Convert degrees to radians.
    public static double toRadians(double degrees) {
        return degrees * (Math.PI / 180.0);
    }

    // Convert radians to degrees.
    public static double toDegrees(double radians) {
        return radians / (Math.PI / 180.0);
    }
}
