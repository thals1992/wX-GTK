// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilitySpcMesoInputOutput {

    public static string[] getAnimation(string product, string sector, int frameCount) {
        var urls = new ArrayList<string>();
        var html = UtilityIO.getHtml(GlobalVariables.nwsSPCwebsitePrefix + "/exper/mesoanalysis/new/archiveviewer.php?sector=19&parm=pmsl");
        html = html.replace("\n", " ");
        var timeList = UtilityString.parseColumn(html, "dattim\\[[0-9]{1,2}\\].*?=.*?([0-9]{8})");
        if (timeList.size > frameCount) {
            for (var index = frameCount - 1; index >= 0; index -= 1) {
                var imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/exper/mesoanalysis/s" + sector + "/" + product + "/" + product + "_" + timeList[index] + ".gif";
                urls.add(imgUrl);
            }
        }
        return urls.to_array();
    }
}
