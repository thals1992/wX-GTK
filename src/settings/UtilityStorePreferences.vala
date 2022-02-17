// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityStorePreferences {

    public static void setDefaultLocation() {
        var value = Utility.readPref("LOC1LABEL", "");
        if (value == "") {
            var stateDefault = "Oklahoma";
            var locNumIntDefault = 1;
            var loc1LabelDefault = "Home";
            var zipcodeDefault = "73069";
            var county1Default = "Cleveland";
            var zone1Default = "OKC027";
            var stateCodeDefault = "OK";
            var loc1XDefault = "35.231";
            var loc1YDefault = "-97.451";
            var loc1NwsDefault = "OUN";
            var nws1Default = "OUN";
            var rid1Default = "TLX";
            var nws1DefaultDtate = "OK";
            Utility.writePrefInt("LOCNUMINT", locNumIntDefault);
            Utility.writePref("LOC1X", loc1XDefault);
            Utility.writePref("LOC1Y", loc1YDefault);
            Utility.writePref("LOC1NWS", loc1NwsDefault);
            Utility.writePref("LOC1LABEL", loc1LabelDefault);
            Utility.writePref("COUNTY1", county1Default);
            Utility.writePref("ZONE1", zone1Default);
            Utility.writePref("STATE", stateDefault);
            Utility.writePref("STATECODE", stateCodeDefault);
            Utility.writePref("ZIPCODE1", zipcodeDefault);
            Utility.writePref("NWS1", nws1Default);
            Utility.writePref("RID1", rid1Default);
            Utility.writePref("NWS1STATE", nws1DefaultDtate);
            Utility.writePref("CURRENTLOCFRAGMENT", "1");
        }
    }
}
