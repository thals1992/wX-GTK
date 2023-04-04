// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class MyApplication {

    public static void onCreate() {
        Utility.initMutex();
        Utility.prefInit();
        GlobalDictionaries.initStatic();
        UtilityHourly.initStatic();
        UtilityMetarConditions.initStatic();
        RadarSites.initStatic();
        WfoSites.initStatic();
        SoundingSites.initStatic();
        Location.refresh();
        UtilityGoes.initStatic();
        UtilityRtma.initStatic();
        UtilityNwsRadarMosaic.initStatic();
        RadarPreferences.initialize();
        UIPreferences.initialize();
        UIPreferences.initStatic();
        ColorPalettes.initialize();
        //  RadarGeometry.initialize();
        UtilityStorePreferences.setDefaultLocation();
    }
}
