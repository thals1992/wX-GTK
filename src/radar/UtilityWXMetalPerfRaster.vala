// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityWXMetalPerfRaster {

    public static int generate(ObjectMetalRadarBuffers radarBuffers) {
        var xShift = 1.0f;
        var yShift = -1.0f;
        var totalBins = 0;
        uint8 curLevel = 0;
        var numberOfRows = 0;
        var binsPerRow = 0;
        var scaleFactor = 0.0f;
        switch (radarBuffers.productCode) {
            case 38:
                numberOfRows = 232;
                binsPerRow = 232;
                scaleFactor = 8.0f;
                break;
            case 41:
                numberOfRows = 116;
                binsPerRow = 116;
                scaleFactor = 8.0f;
                break;
            case 57:
                numberOfRows = 116;
                binsPerRow = 116;
                scaleFactor = 8.0f;
                break;
            default:
                numberOfRows = 464;
                binsPerRow = 464;
                scaleFactor = 2.0f;
                break;
        }
        radarBuffers.setBackgroundColor();
        radarBuffers.setToPositionZero();
        var halfPoint = numberOfRows / 2.0f;
        foreach (var g in range(numberOfRows)) {
            foreach (var bin in range(binsPerRow)) {
                curLevel = radarBuffers.binWord.getByIndex(g * binsPerRow + bin);
                // 1
                radarBuffers.floatGL.add(xShift * (bin - halfPoint) * scaleFactor);
                radarBuffers.floatGL.add(yShift * (g - halfPoint) * scaleFactor * -1.0f);
                // 2
                radarBuffers.floatGL.add(xShift * (bin - halfPoint) * scaleFactor);
                radarBuffers.floatGL.add(yShift * (g + 1.0f - halfPoint) * scaleFactor * -1.0f);
                // 3
                radarBuffers.floatGL.add(xShift * (bin + 1.0f - halfPoint) * scaleFactor);
                radarBuffers.floatGL.add(yShift * (g + 1.0f - halfPoint) * scaleFactor * -1.0f);
                // 4
                radarBuffers.floatGL.add(xShift * (bin + 1.0f - halfPoint) * scaleFactor);
                radarBuffers.floatGL.add(yShift * (g - halfPoint) * scaleFactor * -1.0f);

                radarBuffers.putColorsByIndex(curLevel);
                totalBins += 1;
            }
        }
        return totalBins;
    }
}
