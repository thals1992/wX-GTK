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
        UtilityRadar.initStatic();
        Location.refresh();
        UtilityGoes.initStatic();
        UtilityNwsRadarMosaic.initStatic();
        RadarPreferences.initialize();
        UIPreferences.initialize();
        UIPreferences.initializeData();
        ColorPalettes.initialize();
        RadarGeometry.initialize();
        UtilityStorePreferences.setDefaultLocation();
    }
}
