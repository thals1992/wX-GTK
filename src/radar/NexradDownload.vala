// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NexradDownload {

    const string pattern1 = ">(sn.[0-9]{4})</a>";
    const string pattern2 = ".*?([0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}).*?";

    public static string getRadarFileUrl(string radarSite, string product, bool isTdwr) {
        var productstring = GlobalDictionaries.nexradProductString[product] ?? "";
        return GlobalVariables.tgftpSitePrefix + "SL.us008001/DF.of/DC.radar/" + productstring + "/SI." + radarSite.ascii_down() + "/sn.last";
    }

    public static string getRadarDirectoryUrl(string radarSite, string product, bool isTdwr) {
        var productstring = GlobalDictionaries.nexradProductString[product] ?? "";
        return GlobalVariables.tgftpSitePrefix + "SL.us008001/DF.of/DC.radar/" + productstring + "/SI." + radarSite.ascii_down() + "/";
    }

    public static void getRadarFilesForAnimation(int frameCount, string product, string radarSite, FileStorage fileStorage) {
        var isTdwr = false;
        var html = UtilityIO.getHtml(getRadarDirectoryUrl(radarSite, product, isTdwr));
        var snFiles = UtilityString.parseColumn(html, pattern1);
        var snDates = UtilityString.parseColumn(html, pattern2);
        if (snDates.size == 0) {
            html = UtilityIO.getHtml(getRadarDirectoryUrl(radarSite, product, isTdwr));
            snFiles = UtilityString.parseColumn(html, pattern1);
            snDates = UtilityString.parseColumn(html, pattern2);
        }
        if (snDates.size == 0) {
            return;
        }
        var mostRecentSn = "";
        var mostRecentTime = snDates[snDates.size - 1];
        foreach (var index in range((snDates.size - 1))) {
            if (snDates[index] == mostRecentTime) {
                mostRecentSn = snFiles[index];
            }
        }
        var listOfFiles = new ArrayList<string>();
        var seq = Too.Int(mostRecentSn.replace("sn.", ""));
        var index = seq - frameCount + 1;
        range(frameCount).foreach((unused) => {
            var tmpK = index;
            if (tmpK < 0) {
                tmpK += 251;
            }
            var fn = "sn." + Too.StringPadLeftZeros(tmpK, 4);
            listOfFiles.add(fn);
            index += 1;
            return true;
        });
        var urlList = new ArrayList<string>();
        foreach (var i in range(frameCount)) {
            urlList.add(getRadarDirectoryUrl(radarSite, product, isTdwr) + listOfFiles[i]);
        }
        new DownloadParallel(fileStorage, urlList);
    }
}
