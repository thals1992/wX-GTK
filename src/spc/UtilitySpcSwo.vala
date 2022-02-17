// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilitySpcSwo {

    public static string getImageUrlsDays48(string day) {
        return GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + day + "prob.gif";
    }

    public static ArrayList<string> getImageUrls(string day) {
        var urls = new ArrayList<string>();
        if (day == "48") {
            foreach (var dayInt in UtilityList.range3(4, 9, 1)) {
                urls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + Too.String(dayInt) + "prob.gif");
            }
            return urls;
        }
        var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html");
        var time = UtilityString.parse(html, "show_tab\\(.otlk_([0-9]{4}).\\)");
        var dayInt = Too.Int(day);
        switch (dayInt) {
            case 1, 2:
                var day1BaseUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_";
                var day1Urls = new string[]{"_torn.gif", "_hail.gif", "_wind.gif"};
                urls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".gif");
                foreach (var url in day1Urls) {
                    urls.add(day1BaseUrl + time + url);
                }
                break;
            case 3:
                foreach (var data in new string[]{"otlk_", "prob_"}) {
                    urls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + data + time + ".gif");
                }
                break;
            default:
                break;
        }
        return urls;
    }
}
