// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class ProjectionNumbers {

    double scale = 190.0;
    public double oneDegreeScaleFactor = 0.0;
    string latstring = "";
    string lonstring = "";
    public double xCenter = 0.0;
    public double yCenter = 0.0;
    public string radarSite = "";

    public ProjectionNumbers(string radarSite) {
        if (radarSite.length == 3) {
            string radarPrefix = WXGLDownload.getRidPrefix(radarSite, false);
            this.radarSite = radarPrefix.ascii_up() + radarSite;
        } else {
            this.radarSite = radarSite;
        }
        latstring = Utility.getRadarSiteX(this.radarSite);
        lonstring = Utility.getRadarSiteY(this.radarSite);
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl(), scale);
    }

    public double xDbl() {
        return Too.Double(latstring);
    }

    public double yDbl() {
        return Too.Double(lonstring);
    }

    // TODO FIXME remove in favor of above
    public double x() {
        return Too.Double(latstring);
    }

    public double y() {
        return Too.Double(lonstring);
    }
}
