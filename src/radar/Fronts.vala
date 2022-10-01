// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Fronts {

    public FrontTypeEnum type;
    public ArrayList<LatLon> coordinates = new ArrayList<LatLon>();
    public ArrayList<double?>[] coordinatesModified = new ArrayList<double?>[4];
    int lineCount;
    public int penColor;

    public Fronts(FrontTypeEnum type) {
        this.type = type;
        lineCount = 0;
        if (type == FrontTypeEnum.cold) {
            penColor = Color.rgb(0, 127, 255);
        } else if (type == FrontTypeEnum.warm) {
            penColor = Color.rgb(255, 0, 0);
        } else if (type == FrontTypeEnum.stnry) {
            penColor = Color.rgb(0, 127, 255);
        } else if (type == FrontTypeEnum.stnryWarm) {
            penColor = Color.rgb(255, 0, 0);
        } else if (type == FrontTypeEnum.ocfnt) {
            penColor = Color.rgb(255, 0, 255);
        } else if (type == FrontTypeEnum.trof) {
            penColor = Color.rgb(254, 216, 177);
        }
    }

    public void translate(int paneIndex, ProjectionNumbers pn) {
        coordinatesModified[paneIndex] = new ArrayList<double?>();
        if (coordinates.size > 3) {
            coordinatesModified[paneIndex].clear();
            foreach (var i in range3(0, coordinates.size, 2)) {
                if (i + 1 < coordinates.size) {
                    var coords1 = UtilityCanvasProjection.computeMercatorNumbers(coordinates[i].lat(), -1.0 * coordinates[i].lon(), pn);
                    var coords2 = UtilityCanvasProjection.computeMercatorNumbers(coordinates[i + 1].lat(), -1.0 * coordinates[i + 1].lon(), pn);
                    coordinatesModified[paneIndex].add(coords1[0]);
                    coordinatesModified[paneIndex].add(coords1[1]);
                    coordinatesModified[paneIndex].add(coords2[0]);
                    coordinatesModified[paneIndex].add(coords2[1]);
                }
            }
        }
    }
}
