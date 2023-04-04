// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NhcRegionSummary {

    public ArrayList<string> urls = new ArrayList<string>();
    public ArrayList<string> titles = new ArrayList<string>();
    public string replacestring = "";
    public string baseUrl = "";

    public NhcRegionSummary(NhcOceanEnum region) {
        switch (region) {
            case NhcOceanEnum.atlantic:
                titles = UtilityList.wrap({
                    "Atlantic Tropical Cyclones and Disturbances ",
                    "ATL: Two-Day Graphical Tropical Weather Outlook",
                    "ATL: Five-Day Graphical Tropical Weather Outlook"
                });
                urls = UtilityList.wrap({
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_0d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_2d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_5d0.png"
                });
                replacestring = "NHC Atlantic Wallet";
                baseUrl = "${GlobalVariables.nwsNhcWebsitePrefix}/nhcat";
                break;
            case NhcOceanEnum.epac:
                titles = UtilityList.wrap({
                    "EPAC Tropical Cyclones and Disturbances ",
                    "EPAC: Two-Day Graphical Tropical Weather Outlook",
                    "EPAC: Five-Day Graphical Tropical Weather Outlook"
                });
                urls = UtilityList.wrap({
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_0d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_2d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_5d0.png"
                });
                replacestring = "NHC Eastern Pacific Wallet";
                baseUrl = "${GlobalVariables.nwsNhcWebsitePrefix}/nhcep";
                break;
            case NhcOceanEnum.cpac:
                titles = UtilityList.wrap({
                    "CPAC Tropical Cyclones and Disturbances ",
                    "CPAC: Two-Day Graphical Tropical Weather Outlook",
                    "CPAC: Five-Day Graphical Tropical Weather Outlook"
                });
                urls = UtilityList.wrap({
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_0d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_2d0.png",
                    GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_5d0.png"
                });
                replacestring = "";
                baseUrl = "";
                break;
        }
    }
}
