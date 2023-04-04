// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Watch {

    public static ArrayList<double?> add(ProjectionNumbers projectionNumbers, PolygonType type) {
        var warningList = new ArrayList<double?>();
        var prefToken = PolygonWatch.byType[type].latLonList.getValue();
        if (prefToken != null && prefToken != "") {
            var polygons = prefToken.split(":");
            foreach (var polygon in polygons) {
                var latLons = LatLon.parseStringToLatLons(polygon, 1.0, false);
                warningList.add_all(LatLon.latLonListToListOfDoubles(latLons, projectionNumbers));
            }
        }
        return warningList;
    }

    // NOTE: as compared to warnings the x/y are flipped and the y needs * -1.0
    public static string show(LatLon latLon, PolygonType type) {
        string[] numberList;
        var watchLatLon = "";
        if (type == PolygonType.Watch) {
            watchLatLon = PolygonWatch.watchLatlonCombined.getValue();
            numberList = PolygonWatch.byType[PolygonType.Watch].numberList.getValue().split(":");
        } else {
            numberList = PolygonWatch.byType[type].numberList.getValue().split(":");
            watchLatLon = PolygonWatch.byType[type].latLonList.getValue();
        }
        var latLonsFromstring = watchLatLon.split(":");
        var notFound = true;
        var text = "";
        foreach (var z in range(latLonsFromstring.length)) {
            var latLons = LatLon.parseStringToLatLons(latLonsFromstring[z], 1.0, false);
            if (latLons.size > 3) {
                var contains = ExternalPolygon.polygonContainsPoint(latLon, latLons);
                if (contains && notFound) {
                    text = numberList[z];
                    notFound = false;
                }
            }
        }
        return text;
    }
}
