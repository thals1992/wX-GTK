// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class RadarGeometry {

    public static HashMap<RadarGeometryTypeEnum, RadarGeomInfo> dataByType;

    public static void initStatic() {
        if (dataByType == null) {
            dataByType = new HashMap<RadarGeometryTypeEnum, RadarGeomInfo>();
            RadarGeomInfo.initStatic();
        }
        foreach (var t in new RadarGeometryTypeEnum[]{
            RadarGeometryTypeEnum.StateLines,
            RadarGeometryTypeEnum.CountyLines,
            RadarGeometryTypeEnum.HwLines,
            RadarGeometryTypeEnum.HwExtLines,
            RadarGeometryTypeEnum.LakeLines,
            RadarGeometryTypeEnum.CaLines,
            RadarGeometryTypeEnum.MxLines,
        }) {
            if (dataByType.has_key(t)) {
                dataByType[t].update();
            } else {
                dataByType[t] = new RadarGeomInfo(t);
            }
        }
    }
}
