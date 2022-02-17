// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WXGLNexrad {

    public const string[] radarProductList = {
        "N0Q: Base Reflectivity",
        "N0U: Base Velocity",
        "N0B: Base Reflectivity super-res",
        "N0G: Base Velocity super-res",
        "EET: Enhanced Echo Tops",
        "DVL: Vertically Integrated Liquid",
        "N0C: Correlation Coefficient",
        "N0X: Differential Reflectivity",
        "N0K: Specific Differential Phase",
        "H0C: Hydrometer Classification",
        "DSP: Digital Storm Total Precipitation",
        "DAA: Digital Accumulation Array",
        "N0S: Storm Relative Mean Velocity",
        "NSW: Base Spectrum Width",
        "NCR: Composite Reflectivity 124nm",
        "NCZ: Composite Reflectivity 248nm"
    };

    public const string[] radarProductListTdwr = {
        "TZL: Long Range Digital Base Reflectivity",
        "TZ0: Base Reflectivity",
        "TV0: Base Velocity"
    };

    public static float wxoglDspLegendMax = 0.0f;

    public static int findRadarProductIndex(string product) {
        foreach (var index in UtilityList.range(radarProductList.length)) {
            if (radarProductList[index].has_prefix(product + ":")) {
                return index;
            }
        }
        return 0;
    }

    public static bool isRadarTdwr(string radarSite) {
        return GlobalArrays.tdwrRadarCodes().contains(radarSite.ascii_up());
    }

    public static bool isProductTdwr(string product) {
        return product.has_prefix("TV") || product == "TZL" || product.has_prefix("TZ");
    }

    public static int getNumberRangeBins(int productCode) {
        switch (productCode) {
            case 78:
                return 592;
            case 80:
                return 592;
            case 134:
                return 460;
            case 186:
                return 1390;
            case 153:
                return 720;
            case 154:
                return 720;
            case 180:
                return 720;
            case 181:
                return 720;
            case 182:
                return 720;
            case 135:
                return 1200;
            case 99:
                return 1200;
            case 159:
                return 1200;
            case 161:
                return 1200;
            case 163:
                return 1200;
            case 170:
                return 1200;
            case 172:
                return 1200;
            default:
                return 460;
        }
    }

    public static float getBinSize(int productCode) {
        var binSize54 = 2.0f;
        var binSize13 = 0.50f;
        var binSize08 = 0.295011f;
        var binSize16 = 0.590022f;
        var binSize110 = 2.0f * binSize54;
        switch (productCode) {
            case 134:
                return binSize54;
            case 135:
                return binSize54;
            case 186:
                return binSize16;
            case 159:
                return binSize13;
            case 161:
                return binSize13;
            case 163:
                return binSize13;
            case 165:
                return binSize13;
            case 99:
                return binSize13;
            case 170:
                return binSize13;
            case 172:
                return binSize13;
            case 180:
                return binSize08;
            case 181:
                return binSize08;
            case 182:
                return binSize08;
            case 153:
                return binSize13;
            case 154:
                return binSize13;
            case 155:
                return binSize13;
            case 2161:
                return binSize13;
            case 78:
            case 80:
                return binSize110;
            default:
                return binSize54;
        }
    }
}
