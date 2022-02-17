// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class GlobalVariables {

    public const string aboutString = """
    wxgtk is an efficient and configurable method to access weather content from the NWS, NSSL WRF, and blitzortung.org.
    Software is provided \"as is\". Use at your own risk. Use for educational purposes and non-commercial purposes only.
    Do not use for operational purposes.  Copyright 2020, 2021, 2022 joshua.tee@gmail.com .
    Privacy Policy: this app does not collect any data from the user or the user’s device.
    Please report bugs or suggestions via email.
    wxgtk is licensed under the GNU GPLv3 license. For more information on the license please go here:
    http://www.gnu.org/licenses/gpl-3.0.en.html
    """;

    public const string mainScreenShortcuts = """

    Ctrl-a - WFO Viewer
    Ctrl-c - GOES
    Ctrl-d - Severe Dashboard
    Ctrl-h - Hourly
    Ctrl-l - Lightning
    Ctrl-m - Radad Mosaic
    Ctrl-n - NCEP Model Viewer
    Ctrl-o - NHC
    Ctrl-q - Quit program
    Ctrl-r - Nexrad
    Ctrl-s - SPC Convective Outlook Summary
    Ctrl-u - update, reload data
    Ctrl-1 - single pane nexrad
    Ctrl-2 - dual pane nexrad
    Ctrl-4 - quad pane nexrad

    """;

    public const string nexradShortcuts = """
    Ctrl-downArrow - down
    Ctrl-upArrow - up
    Ctrl-leftArrow - left
    Ctrl-rightArrow - right
    Ctrl-- zoom out
    Ctrl-+ zoom in
    """;

    public const string nexradHelp = """
    Right click on the radar to bring up a contextual menu.
    """;

    public const string sep = "ABC123";
    public const string appName = "wxgtk";
    public const string appCreatorEmail = "joshua.tee@gmail.com";
    public const string nwsSPCwebsitePrefix = "https://www.spc.noaa.gov";
    public const string nwsWPCwebsitePrefix = "https://www.wpc.ncep.noaa.gov";
    public const string nwsAWCwebsitePrefix = "https://www.aviationweather.gov";
    public const string nwsGraphicalWebsitePrefix = "http://graphical.weather.gov";
    public const string nwsCPCNcepWebsitePrefix = "https://www.cpc.ncep.noaa.gov";
    public const string nwsGoesWebsitePrefix = "https://www.goes.noaa.gov";
    public const string nwsOpcWebsitePrefix = "https://ocean.weather.gov";
    public const string nwsNhcWebsitePrefix = "https://www.nhc.noaa.gov";
    public const string nwsRadarWebsitePrefix = "https://radar.weather.gov";
    public const string nwsMagNcepWebsitePrefix = "https://mag.ncep.noaa.gov";
    public const string sunMoonDataUrl = "https://api.usno.navy.mil";
    public const string goes16Url = "https://cdn.star.nesdis.noaa.gov";
    public const string nwsApiUrl = "https://api.weather.gov";
    public const string tgftpSitePrefix = "https://tgftp.nws.noaa.gov/";
    public const string degreeSymbol = "\u00B0";
    public const string newline = "\n";
    public const string resDir = "res/";
    public const string imageDir = "images/";
    public const string prePattern = "<pre.*?>(.*?)</pre>";
    public const string pre2Pattern = "<pre>(.*?)</pre>";
    public const string vtecPattern = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)";
    public const string warningLatLonPattern = "\"coordinates\":\\[\\[(.*?)\\]\\]\\}";
    public const string utilUsWeatherSummaryPattern = ".*?weather-summary=(.*?)/>.*?";
    public const string utilUsPeriodNamePattern = ".*?period-name=(.*?)>.*?";
    public const string xmlValuePattern = "<value>";
}
