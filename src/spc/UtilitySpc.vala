// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilitySpc {

    public static ArrayList<string> getTstormOutlookUrls() {
        var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/enhtstm/");
        var urls = UtilityString.parseColumn(html, "OnClick.\"show_tab\\(.([0-9]{4}).\\)\".*?");
        var returnList = new ArrayList<string>();
        foreach (var data in urls) {
            returnList.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/enhtstm/imgs/enh_" + data + ".gif");
        }
        return returnList;
    }
}
