// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SevereNotice {

    string[] numberList = new string[]{};
    public ArrayList<string> urls = new ArrayList<string>();
    public PolygonType type1;

    public SevereNotice(PolygonType type1) {
        this.type1 = type1;
        //  numberList = new string[]{};
        getBitmaps();
    }

    public void getBitmaps() {
        var comp = "";
        var html = "";
        urls.clear();
        switch (type1) {
            case PolygonType.mcd:
                comp = "<center>No Mesoscale Discussions are currently in effect.";
                html = ObjectPolygonWatch.polygonDataByType[PolygonType.mcd].numberList.getValue();
                break;
            case PolygonType.watch:
                comp = "<center><strong>No watches are currently valid";
                html = ObjectPolygonWatch.polygonDataByType[PolygonType.watch].numberList.getValue();
                break;
            case PolygonType.mpd:
                comp = "No MPDs are currently in effect.";
                html = ObjectPolygonWatch.polygonDataByType[PolygonType.mpd].numberList.getValue();
                break;
            default:
                comp = "";
                break;
        }
        var text = (!html.contains(comp)) ? html : "";
        numberList = text.split(":");
        var tmpList = new ArrayList<string>();
        foreach (var n in numberList) {
            if (!tmpList.contains(n) && n != "") {
                tmpList.add(n);
            }
        }
        // TODO FIXME reduce usage of old school arrays
        numberList = new string[]{};
        foreach (var n in tmpList) {
            numberList += n;
        }
        if (text != "") {
            foreach (var number in numberList) {
                var url = "";
                switch (type1) {
                    case PolygonType.mcd:
                        url = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/mcd" + number + ".gif";
                        break;
                    case PolygonType.watch:
                        url = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + number + "_radar.gif";
                        break;
                    case PolygonType.mpd:
                        url = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + number + ".gif";
                        break;
                    default:
                        url = "";
                        break;
                }
                urls.add(url);
            }
        }
    }

    public string getShortName() {
        switch (type1) {
            case PolygonType.mcd:
                return "MCD";
            case PolygonType.mpd:
                return "MPD";
            case PolygonType.watch:
                return "WATCH";
            default:
                return "";
        }
    }

    public string getCount() {
        return Too.String(urls.size);
    }
}
