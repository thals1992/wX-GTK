// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************


class UtilityNhc {

    public const string[] urlEnds = {
        "_5day_cone_with_line_and_wind.png",
        "_key_messages.png",
        // "WPCQPF_sm2.gif",
        "_earliest_reasonable_toa_34_sm2.png",
        "_most_likely_toa_34_sm2.png",
        "_wind_probs_34_F120_sm2.png",
        "_wind_probs_50_F120_sm2.png",
        "_wind_probs_64_F120_sm2.png",
        "_peak_surge.png",
        "_wind_history.png"
    };

    public const string[] stormtextProducts = {
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    };

    public const string[] textProductCodes = {
        "MIATWOAT",
        "MIATWDAT",
        "MIATWSAT",
        "MIATWOEP",
        "MIATWDEP",
        "MIATWSEP",
        "HFOTWOCP"
    };

    public const string[] textProductLabels = {
        "ATL Tropical Weather Outlook",
        "ATL Tropical Weather Discussion",
        "ATL Monthly Tropical Summary",
        "EPAC Tropical Weather Outlook",
        "EPAC Tropical Weather Discussion",
        "EPAC Monthly Tropical Summary",
        "CPAC Tropical Weather Outlook"
    };

    public const string[] imageTitles = {
        "EPAC Daily Analysis",
        "ATL Daily Analysis",
        "EPAC 7-Day Analysis",
        "ATL 7-Day Analysis",
        "EPAC SST Anomaly",
        "ATL SST Anomaly"
    };

    public const string[] imageUrls = {
        "https://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/PAC/20.jpg",
        "https://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/ATL/20.jpg",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/pac_anal.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/atl_anal.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/pac_anom.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/atl_anom.gif"
    };
}
