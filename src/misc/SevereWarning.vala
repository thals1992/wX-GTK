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
            case PolygonType.Tor:
                return "Tornado Warning";
            case PolygonType.Tst:
                return "Severe Thunderstorm Warning";
            case PolygonType.Ffw:
                return "Flash Flood Warning";
            default:
                return "";
        }
    }

    public string getShortName() {
        switch (type) {
            case PolygonType.Tor:
                return "TOR";
            case PolygonType.Tst:
                return "TST";
            case PolygonType.Ffw:
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
        return Too.String(i);
    }
}
