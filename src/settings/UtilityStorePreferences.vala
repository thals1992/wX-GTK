// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityStorePreferences {

    public static void setDefaultLocation() {
        var value = Utility.readPref("LOC1LABEL", "");
        if (value == "") {
            // TODO FIXME no need for COUNTY/ZONE/ZIP/STATE?
            Utility.writePrefInt("LOCNUMINT", 1);
            Utility.writePref("LOC1X", "35.231");
            Utility.writePref("LOC1Y", "-97.451");
            Utility.writePref("LOC1NWS", "OUN");
            Utility.writePref("LOC1LABEL", "Home");
            Utility.writePref("COUNTY1", "Cleveland");
            Utility.writePref("ZONE1", "OKC027");
            Utility.writePref("STATE", "Oklahoma");
            Utility.writePref("STATECODE", "OK");
            Utility.writePref("ZIPCODE1", "73069");
            Utility.writePref("NWS1", "OUN");
            Utility.writePref("RID1", "KTLX");
            Utility.writePref("NWS1STATE", "OK");
            Utility.writePref("CURRENTLOCFRAGMENT", "1");
        }
    }
}
