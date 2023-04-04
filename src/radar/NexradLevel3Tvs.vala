// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NexradLevel3Tvs {

    public static void decode(ProjectionNumbers projectionNumbers, FileStorage fileStorage) {
        var data = NexradLevel3TextProduct.download("TVS", projectionNumbers.getRadarSite());
        var stormList = new ArrayList<double?>();
        var tvs = UtilityString.parseColumn(data, "P  TVS(.{20})");
        foreach (var index in range(tvs.size)) {
            var ecc = new ExternalGeodeticCalculator();
            var stringData = UtilityString.parse(tvs[index], ".{9}(.{7})");
            var items = stringData.split("/");
            var degStr = items[0].replace(" ", "");
            var nmStr = items[1].replace(" ", "");
            var degree = Too.Int(degStr);
            var nm = Too.Int(nmStr);
            var start = ExternalGlobalCoordinates.withPn(projectionNumbers, true);
            var ec = ecc.calculateEndingGlobalCoordinates(start, (double)degree, nm * 1852.0);
            stormList.add(ec.getLatitude());
            stormList.add(ec.getLongitude() * -1.0);
        }
        fileStorage.tvsData = stormList;
    }
}
