// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SevereWarning {

    public PolygonType type;
    public ArrayList<string> listOfPolygonRaw = new ArrayList<string>();
    public ArrayList<ObjectWarning> warningList = new ArrayList<ObjectWarning>();

    public SevereWarning(PolygonType type) {
        this.type = type;
        generateString();
    }

    public void download() {
        ObjectPolygonWarning.polygonDataByType[type].download();
        generateString();

    }

    public void generateString() {
        var html = ObjectPolygonWarning.polygonDataByType[type].getData();
        warningList = ObjectWarning.parseJson(html);
        var data = html.replace("\n", "");
        data = data.replace(" ", "");
        listOfPolygonRaw = UtilityString.parseColumn(data, GlobalVariables.warningLatLonPattern);
    }

    public string getName() {
        switch (type) {
            case PolygonType.tor:
                return "Tornado Warning";
            case PolygonType.tst:
                return "Severe Thunderstorm Warning";
            case PolygonType.ffw:
                return "Flash Flood Warning";
            default:
                return "";
        }
    }

    public string getShortName() {
        switch (type) {
            case PolygonType.tor:
                return "TOR";
            case PolygonType.tst:
                return "TST";
            case PolygonType.ffw:
                return "FFW";
            default:
                return "";
        }
    }

    public string getCount() {
        var i = 0;
        foreach (var s in warningList) {
            if (s.isCurrent) {
                i += 1;
            }
        }
        var iString = Too.String(i);
        return iString;
    }
}
