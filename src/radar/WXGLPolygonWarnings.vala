// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WXGLPolygonWarnings {

    public static ArrayList<double?> add(ProjectionNumbers projectionNumbers, PolygonType type) {
        var html = ObjectPolygonWarning.polygonDataByType[type].getData();
        var warnings = ObjectWarning.parseJson(html);
        //  print(warnings.size.to_string() + "\n");
        var warningList = new ArrayList<double?>();
        foreach (var w in warnings) {
            //  print(" is warning current?\n");
            if (w.isCurrent) {
                //  print("current\n");
                var latLons = w.getPolygonAsLatLons();
                warningList.add_all(LatLon.latLonListToListOfDoubles(latLons, projectionNumbers));
            }
        }
        return warningList;
    }

    public static int getCount(PolygonType type) {
        var html = ObjectPolygonWarning.polygonDataByType[type].getData();
        var warningList = ObjectWarning.parseJson(html);
        var i = 0;
        foreach (var s in warningList) {
            if (s.isCurrent) {
                i += 1;
            }
        }
        return i;
    }

    public static string show(LatLon latLon) {
        var warningChunk = "";
        foreach (var type1 in ObjectPolygonWarning.polygonList) {
            warningChunk += ObjectPolygonWarning.polygonDataByType[type1].getData();
        }
        var warnings = ObjectWarning.parseJson(warningChunk);
        var urlToOpen = "";
        var notFound = true;
        foreach (var w in warnings) {
            var latLons = w.getPolygonAsLatLons();
            if (latLons.size > 0) {
                var contains = ExternalPolygon.polygonContainsPoint(latLon, latLons);
                if (contains && notFound) {
                    urlToOpen = w.getUrl();
                    notFound = false;
                }
            }
        }
        return urlToOpen;
    }
}
