// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UIPreferences {

    public const int textPadding = 3;
    public const int imageMargin = 5;
    public const int boxMargin = 5;
    public const int swinMargin = 5;
    public const int textMargin = 5;
    public static bool unitsM = true;
    public static bool unitsF = true;
    public static int mainScreenImageSize = 400;
    public static bool useNwsApi = false;
    public static bool useNwsApiForHourly = true;
    public static bool lightningUseGoes = true;
    public static bool nexradMainScreen = false;
    public static bool mainScreenSevereDashboard = false;
    public static bool nexradScrollWheelMotion = false;
    public static ArrayList<PrefBool> homeScreenItemsImage;
    public static ArrayList<PrefBool> homeScreenItemsText;

    public static void initialize() {
        mainScreenImageSize = Utility.readPrefInt("MAIN_SCREEN_IMAGE_SIZE", mainScreenImageSize);
        useNwsApi = Utility.readPref("USE_NWS_API_SEVEN_DAY", "false").has_prefix("t");
        useNwsApiForHourly = Utility.readPref("USE_NWS_API_HOURLY", "true").has_prefix("t");
        lightningUseGoes = Utility.readPref("LIGHTNING_USE_GOES", "true").has_prefix("t");
        nexradMainScreen = Utility.readPref("NEXRAD_ON_MAIN_SCREEN", "false").has_prefix("t");
        mainScreenSevereDashboard = Utility.readPref("MAINSCREEN_SEVERE_DASH", "false").has_prefix("t");
        nexradScrollWheelMotion = Utility.readPref("NEXRAD_SCROLLWHEEL", "false").has_prefix("t");
    }

    public static void initializeData() {
        homeScreenItemsImage = new ArrayList<PrefBool>.wrap({
            new PrefBool("Visible Satellite", "VISIBLE_SATELLITE", true),
            new PrefBool("Radar Mosaic", "RADAR_MOSAIC", true),
            new PrefBool("Alerts", "USWARN", false),
            new PrefBool("Analysis", "ANALYSIS_RADAR_AND_WARNINGS", false),
        });
        homeScreenItemsText = new ArrayList<PrefBool>.wrap({
            new PrefBool("Hourly", "HOURLY", true),
            new PrefBool("Wfo Text", "WFO_TEXT", false)
        });
    }
}
