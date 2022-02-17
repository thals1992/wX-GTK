// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class RadarPreferences {

    public static bool dualpaneshareposn = true;
    public static bool obs = false;
    public static bool obsWindbarbs = false;
    public static bool swo = false;
    public static bool cities = false;
    public static bool highways = false;
    public static bool locationDot = false;
    public static bool lakes = false;
    public static bool county = true;
    public static bool countyLabels = false;
    public static bool warnings = false;
    public static bool mcd = false;
    public static bool watch = false;
    public static bool mpd = false;
    public static bool sti = false;
    public static bool hailIndex = false;
    public static bool tvs = false;
    public static bool hwEnhExt = false;
    public static bool caBorders = false;
    public static bool mxBorders = false;
    public static int dataRefreshInterval = 1;
    public static bool wpcFronts = false;
    public static bool radarShowControls = true;
    public static bool radarShowStatusBar = true;
    public static bool colorLegend = false;
    public static int radarDataRefreshInterval = 5;
    public static bool rememberLocation = true;

    public static int radarColorHw;
    public static int radarColorHwExt;
    public static int radarColorState;
    public static int radarColorTstorm;
    public static int radarColorTstormWatch;
    public static int radarColorTor;
    public static int radarColorTorWatch;
    public static int radarColorFfw;
    public static int radarColorMcd;
    public static int radarColorMpd;
    public static int radarColorLocdot;
    public static int radarColorSpotter;
    public static int radarColorCity;
    public static int radarColorLakes;
    public static int radarColorCounty;
    public static int radarColorSti;
    public static int radarColorHi;
    public static int radarColorObs;
    public static int radarColorObsWindbarbs;
    public static int radarColorCountyLabels;
    public static int nexradRadarBackgroundColor;

    public static double warnLinesize = 0.0;
    public static double watmcdLinesize = 0.0;
    public static double stateLinesize = 0.0;
    public static double countyLinesize = 0.0;
    public static double hwLinesize = 0.0;
    public static double hwExtLinesize = 0.0;
    public static double lakeLinesize = 0.0;
    public static double gpsCircleLinesize = 0.0;
    public static double stiLinesize = 0.0;
    public static double swoLinesize = 0.0;
    public static double wbLinesize = 0.0;
    public static double lineFactor = 10.0;
    public static double locdotSize = 20.0;

    public static void initialize() {
        swo = Utility.readPref("RADAR_SHOW_SWO", "false").has_prefix("t");
        dualpaneshareposn = Utility.readPref("DUALPANE_SHARE_POSN", "true").has_prefix("t");
        obs = Utility.readPref("WXOGL_OBS", "false").has_prefix("t");
        obsWindbarbs = Utility.readPref("WXOGL_OBS_WINDBARBS", "false").has_prefix("t");
        cities = Utility.readPref("COD_CITIES_DEFAULT", "false").has_prefix("t");
        highways = Utility.readPref("COD_HW_DEFAULT", "false").has_prefix("t");
        locationDot = Utility.readPref("COD_LOCDOT_DEFAULT", "false").has_prefix("t");
        lakes = Utility.readPref("COD_LAKES_DEFAULT", "false").has_prefix("t");
        county = Utility.readPref("RADAR_SHOW_COUNTY", "true").has_prefix("t");
        warnings = Utility.readPref("COD_WARNINGS_DEFAULT", "false").has_prefix("t");
        watch = Utility.readPref("RADAR_SHOW_WATCH", "false").has_prefix("t");
        mcd = Utility.readPref("RADAR_SHOW_MCD", "false").has_prefix("t");
        mpd = Utility.readPref("RADAR_SHOW_MPD", "false").has_prefix("t");
        sti = Utility.readPref("RADAR_SHOW_STI", "false").has_prefix("t");
        radarShowControls = Utility.readPref("RADAR_SHOW_CONTROLS", "false").has_prefix("t");
        radarShowStatusBar = Utility.readPref("RADAR_SHOW_STATUSBAR", "true").has_prefix("t");
        hailIndex = Utility.readPref("RADAR_SHOW_HI", "false").has_prefix("t");
        tvs = Utility.readPref("RADAR_SHOW_TVS", "false").has_prefix("t");
        wpcFronts = Utility.readPref("RADAR_SHOW_WPC_FRONTS", "false").has_prefix("t");
        hwEnhExt = Utility.readPref("RADAR_HW_ENH_EXT", "false").has_prefix("t");
        caBorders = Utility.readPref("RADARCANADALINES", "false").has_prefix("t");
        mxBorders = Utility.readPref("RADARMEXICOLINES", "false").has_prefix("t");
        countyLabels = Utility.readPref("RADAR_COUNTY_LABELS", "false").has_prefix("t");
        dataRefreshInterval = Utility.readPrefInt("RADARDATAREFRESHINTERVAL", 3);
        colorLegend = Utility.readPref("RADAR_COLOR_LEGEND", "false").has_prefix("t");
        radarDataRefreshInterval = Utility.readPrefInt("RADAR_DATA_REFRESH_INTERVAL", 5);
        rememberLocation = Utility.readPref("WXOGL_REMEMBER_LOCATION", "true").has_prefix("t");

        radarColorHw = Utility.readPrefInt("RADAR_COLOR_HW", Color.rgb(135, 135, 135));
        radarColorHwExt = Utility.readPrefInt("RADAR_COLOR_HW_EXT", Color.rgb(91, 91, 91));
        radarColorState = Utility.readPrefInt("RADAR_COLOR_STATE", Color.rgb(255, 255, 255));
        radarColorTstorm = Utility.readPrefInt("RADAR_COLOR_TSTORM", Color.rgb(255, 255, 0));
        radarColorTstormWatch = Utility.readPrefInt("RADAR_COLOR_TSTORM_WATCH", Color.rgb(255, 187, 0));
        radarColorTor = Utility.readPrefInt("RADAR_COLOR_TOR", Color.rgb(243, 85, 243));
        radarColorTorWatch = Utility.readPrefInt("RADAR_COLOR_TOR_WATCH", Color.rgb(255, 0, 0));
        radarColorFfw = Utility.readPrefInt("RADAR_COLOR_FFW", Color.rgb(0, 255, 0));
        radarColorMcd = Utility.readPrefInt("RADAR_COLOR_MCD", Color.rgb(153, 51, 255));
        radarColorMpd = Utility.readPrefInt("RADAR_COLOR_MPD", Color.rgb(0, 255, 0));
        radarColorLocdot = Utility.readPrefInt("RADAR_COLOR_LOCDOT", Color.rgb(255, 255, 255));
        radarColorSpotter = Utility.readPrefInt("RADAR_COLOR_SPOTTER", Color.rgb(255, 0, 245));
        radarColorCity = Utility.readPrefInt("RADAR_COLOR_CITY", Color.rgb(255, 255, 255));
        radarColorLakes = Utility.readPrefInt("RADAR_COLOR_LAKES", Color.rgb(0, 0, 255));
        radarColorCounty = Utility.readPrefInt("RADAR_COLOR_COUNTY", Color.rgb(75, 75, 75));
        radarColorSti = Utility.readPrefInt("RADAR_COLOR_STI", Color.rgb(255, 255, 255));
        radarColorHi = Utility.readPrefInt("RADAR_COLOR_HI", Color.rgb(0, 255, 0));
        radarColorObs = Utility.readPrefInt("RADAR_COLOR_OBS", Color.rgb(255, 255, 255));
        radarColorObsWindbarbs = Utility.readPrefInt("RADAR_COLOR_OBS_WINDBARBS", Color.rgb(255, 255, 255));
        radarColorCountyLabels = Utility.readPrefInt("RADAR_COLOR_COUNTY_LABELS", Color.rgb(234, 214, 123));
        nexradRadarBackgroundColor = Utility.readPrefInt("NEXRAD_RADAR_BACKGROUND_COLOR", Color.rgb(0, 0, 0));

        //  radarHiSize = getInitialPreference("RADAR_HI_SIZE", 8)
        //  radarTvsSize = getInitialPreference("RADAR_TVS_SIZE", 8)

        warnLinesize = Utility.readPrefInt("RADAR_WARN_LINESIZE", 20) / lineFactor;
        watmcdLinesize = Utility.readPrefInt("RADAR_WATMCD_LINESIZE", 20) / lineFactor;
        stateLinesize = Utility.readPrefInt("RADAR_STATE_LINESIZE", 10) / lineFactor;
        countyLinesize = Utility.readPrefInt("RADAR_COUNTY_LINESIZE", 10) / lineFactor;
        hwLinesize = Utility.readPrefInt("RADAR_HW_LINESIZE", 10) / lineFactor;
        hwExtLinesize = Utility.readPrefInt("RADAR_HWEXT_LINESIZE", 10) / lineFactor;
        lakeLinesize = Utility.readPrefInt("RADAR_LAKE_LINESIZE", 10) / lineFactor;
        gpsCircleLinesize = Utility.readPrefInt("RADAR_GPSCIRCLE_LINESIZE", 4) / lineFactor;
        stiLinesize = Utility.readPrefInt("RADAR_STI_LINESIZE", 10) / lineFactor;
        swoLinesize = Utility.readPrefInt("RADAR_SWO_LINESIZE", 20) / lineFactor;
        wbLinesize = Utility.readPrefInt("RADAR_WB_LINESIZE", 10) / lineFactor;
        locdotSize = Utility.readPrefInt("RADAR_LOCDOT_SIZE", 20) / lineFactor;

        DownloadTimer.radarDataRefreshInterval = RadarPreferences.dataRefreshInterval;
        ObjectPolygonWarning.load();
        ObjectPolygonWatch.load();
    }
}
