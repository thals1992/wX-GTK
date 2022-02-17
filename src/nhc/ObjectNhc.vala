// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectNhc {

    public ArrayList<string> ids = new ArrayList<string>();
    public ArrayList<string> binNumbers = new ArrayList<string>();
    public ArrayList<string> names = new ArrayList<string>();
    public ArrayList<string> classifications = new ArrayList<string>();
    public ArrayList<string> intensities = new ArrayList<string>();
    public ArrayList<string> pressures = new ArrayList<string>();
    public ArrayList<string> latitudes = new ArrayList<string>();
    public ArrayList<string> longitudes = new ArrayList<string>();
    public ArrayList<string> movementDirs = new ArrayList<string>();
    public ArrayList<string> movementSpeeds = new ArrayList<string>();
    public ArrayList<string> lastUpdates = new ArrayList<string>();
    public ArrayList<string> statusList = new ArrayList<string>();
    public ArrayList<ObjectNhcStormDetails> stormDataList = new ArrayList<ObjectNhcStormDetails>();

    public void getTextData() {
        var url = GlobalVariables.nwsNhcWebsitePrefix + "/CurrentStorms.json";
        //  string url = "https://www.nhc.noaa.gov/productexamples/NHC_JSON_Sample.json";

        var html = UtilityIO.getHtml(url);
        ids = UtilityString.parseColumn(html, "\"id\": \"(.*?)\"");
        binNumbers = UtilityString.parseColumn(html, "\"binNumber\": \"(.*?)\"");
        names = UtilityString.parseColumn(html, "\"name\": \"(.*?)\"");
        classifications = UtilityString.parseColumn(html, "\"classification\": \"(.*?)\"");

        intensities = UtilityString.parseColumn(html, "\"intensity\": \"(.*?)\"");
        pressures = UtilityString.parseColumn(html, "\"pressure\": \"(.*?)\"");
        // sample data not quoted for these two
        //  intensities = UtilityString.parseColumn(html, "\"intensity\": (.*?),");
        //  pressures = UtilityString.parseColumn(html, "\"pressure\": (.*?),");

        latitudes = UtilityString.parseColumn(html, "\"latitude\": \"(.*?)\"");
        longitudes = UtilityString.parseColumn(html, "\"longitude\": \"(.*?)\"");
        movementDirs = UtilityString.parseColumn(html, "\"movementDir\": (.*?),");
        movementSpeeds = UtilityString.parseColumn(html, "\"movementSpeed\": (.*?),");
        lastUpdates = UtilityString.parseColumn(html, "\"lastUpdate\": \"(.*?)\"");
        foreach (var index in UtilityList.range(binNumbers.size)) {
            var text = UtilityDownload.getTextProduct("MIATCP" + binNumbers[index]);
            var textNoNewLines = text.replace(GlobalVariables.newline, " ");
            var status = UtilityString.parse(textNoNewLines, "(\\.\\.\\..*?\\.\\.\\.)");
            statusList.add(status);
        }
    }

    public void showTextData() {
        if (ids.size > 0) {
            foreach (var index in UtilityList.range(ids.size)) {
                stormDataList.add(new ObjectNhcStormDetails(names[index], movementDirs[index], movementSpeeds[index], pressures[index], binNumbers[index], ids[index], lastUpdates[index], classifications[index], latitudes[index], longitudes[index], intensities[index], statusList[index]));
            }
        }
    }
}
