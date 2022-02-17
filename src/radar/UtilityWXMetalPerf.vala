// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityWXMetalPerf {

    const float k180DivPi = 180.0f / (float)Math.PI;
    const float piDiv4 = (float)Math.PI / 4.0f;
    const float piDiv360 = (float)Math.PI / 360.0f;
    const float twicePi = 2.0f * (float)Math.PI;

    //
    // radar binary file has values that are big endian, handle in MemoryBuffer methods via struct.pack / unpack
    //
    public static int decode8BitAndGenRadials(ObjectMetalRadarBuffers radarBuffers, FileStorage fileStorage) {
        var totalBins = 0;
        MemoryBuffer disFirst;
        if (radarBuffers.animationIndex == -1) {
            disFirst = fileStorage.memoryBuffer;
        } else {
            disFirst = fileStorage.animationMemoryBuffer[radarBuffers.animationIndex];
        }
        disFirst.position = 0;
        if (disFirst.capacity == 0) {
            return 0;
        }
        while (disFirst.getShort() != -1) {}
        disFirst.skipBytes(100);
        var dis2 = new MemoryBuffer.fromArray(UtilityIO.uncompress(disFirst.backingArray[disFirst.position:disFirst.capacity].to_array()));
        dis2.skipBytes(30);
        radarBuffers.setBackgroundColor();
        radarBuffers.setToPositionZero();
        var angleV = 0.0f;
        var angleNext = 0.0f;
        var angle0 = 0.0f;
        var numberOfRadials = radarBuffers.numberOfRadials;
        var xShift = 1.0f;
        var yShift = -1.0f;
        foreach (var radial in UtilityList.range(numberOfRadials)) {
            uint16 numberOfRleHalfWords = dis2.getUnsignedShort();
            float angle = (450.0f - ((float)(dis2.getUnsignedShort()) / 10.0f));
            dis2.skipBytes(2);
            if (radial < numberOfRadials - 1) {
                dis2.mark(dis2.position);
                dis2.skipBytes((int)(numberOfRleHalfWords) + 2);
                angleNext = (450.0f - ((float)(dis2.getUnsignedShort()) / 10.0f));
                dis2.reset();
            }
            uint8 level = 0;
            var levelCount = 0;
            float binStart = radarBuffers.binSize;
            if (radial == 0) {
                angle0 = angle;
            }
            if (radial < numberOfRadials - 1) {
                angleV = angleNext;
            } else {
                angleV = angle0;
            }
            foreach (var bin1 in UtilityList.range(numberOfRleHalfWords)) {
                uint8 curLevel = dis2.get();
                if (bin1 == 0) {
                    level = curLevel;
                }
                if (curLevel == level) {
                    levelCount += 1;
                } else {
                    // Since we will attempt to use the higher level QT painter we don't need a color per vertex
                    // and we can draw a polygon instead of two triangles
                    // thus we will comment out redundant point and color data
                    float angleVCos = (float)Math.cos(angleV / k180DivPi);
                    float angleVSin = (float)Math.sin(angleV / k180DivPi);
                    // 1
                    float p1x = xShift * binStart * angleVCos;
                    float p1y = yShift * binStart * angleVSin;
                    // 2
                    float p2x = xShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleVCos);
                    float p2y = yShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleVSin);
                    float angleCos = (float)Math.cos(angle / k180DivPi);
                    float angleSin = (float)Math.sin(angle / k180DivPi);
                    // 3
                    float p3x = xShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleCos);
                    float p3y = yShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleSin);
                    // 4
                    float p4x = xShift * binStart * angleCos;
                    float p4y = yShift * binStart * angleSin;

                    radarBuffers.floatBuffer.putFloat(p1x);
                    radarBuffers.floatBuffer.putFloat(p1y);
                    radarBuffers.floatBuffer.putFloat(p2x);
                    radarBuffers.floatBuffer.putFloat(p2y);
                    radarBuffers.floatBuffer.putFloat(p3x);
                    radarBuffers.floatBuffer.putFloat(p3y);
                    radarBuffers.floatBuffer.putFloat(p4x);
                    radarBuffers.floatBuffer.putFloat(p4y);
                    radarBuffers.putColorsByIndex(level);

                    totalBins += 1;
                    level = curLevel;
                    binStart = (float)bin1 * radarBuffers.binSize;
                    levelCount = 1;
                }
            }
        }
        return totalBins;
    }

    public static int genRadials(ObjectMetalRadarBuffers radarBuffers) {
        var totalBins = 0;
        var angle = 0.0f;
        var angleV = 0.0f;
        uint8 level = 0;
        var levelCount = 0;
        var binStart = 0.0f;
        var bI = 0;
        uint8 curLevel = 0;
        var radarBlackHole = 0.0f;
        var radarBlackHoleAdd = 0.0f;
        var xShift = 1.0f;
        var yShift = -1.0f;
        switch (radarBuffers.productCode) {
            case 19:
                radarBlackHole = 1.0f;
                radarBlackHoleAdd = 0.0f;
                break;
            case 30:
                radarBlackHole = 1.0f;
                radarBlackHoleAdd = 0.0f;
                break;
            case 56:
                radarBlackHole = 1.0f;
                radarBlackHoleAdd = 0.0f;
                break;
            default:
                radarBlackHole = 4.0f;
                radarBlackHoleAdd = 4.0f;
                break;
        }
        radarBuffers.setBackgroundColor();
        radarBuffers.setToPositionZero();
        foreach (var g in UtilityList.range(radarBuffers.numberOfRadials)) {
            // since radialstart is constructed natively as opposed to read in
            // from bigendian file we have to use getFloatNatve
            angle = radarBuffers.radialStartAngle.getFloatByIndex(g * 4);
            level = radarBuffers.binWord.getByIndex(bI);
            levelCount = 0;
            binStart = radarBlackHole;
            if (g < radarBuffers.numberOfRadials - 1) {
                angleV = radarBuffers.radialStartAngle.getFloatByIndex(g * 4 + 4);
            } else {
                angleV = radarBuffers.radialStartAngle.getFloatByIndex(0);
            }
            foreach (var bin in UtilityList.range(radarBuffers.numberOfRangeBins)) {
                curLevel = radarBuffers.binWord.getByIndex(bI);
                bI += 1;
                if (curLevel == level) {
                    levelCount += 1;
                } else {
                    float angleVCos = (float)Math.cos(angleV / k180DivPi);
                    float angleVSin = (float)Math.sin(angleV / k180DivPi);
                    // 1
                    float p1x = xShift * binStart * angleVCos;
                    float p1y = yShift * binStart * angleVSin;
                    // 2
                    float p2x = xShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleVCos);
                    float p2y = yShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleVSin);
                    float angleCos = (float)Math.cos(angle / k180DivPi);
                    float angleSin = (float)Math.sin(angle / k180DivPi);
                    // 3
                    float p3x = xShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleCos);
                    float p3y = yShift * ((binStart + (radarBuffers.binSize * (float)(levelCount))) * angleSin);
                    // 4
                    float p4x = xShift * binStart * angleCos;
                    float p4y = yShift * binStart * angleSin;

                    radarBuffers.floatBuffer.putFloat(p1x);
                    radarBuffers.floatBuffer.putFloat(p1y);
                    radarBuffers.floatBuffer.putFloat(p2x);
                    radarBuffers.floatBuffer.putFloat(p2y);
                    radarBuffers.floatBuffer.putFloat(p3x);
                    radarBuffers.floatBuffer.putFloat(p3y);
                    radarBuffers.floatBuffer.putFloat(p4x);
                    radarBuffers.floatBuffer.putFloat(p4y);
                    radarBuffers.putColorsByIndex(level);

                    totalBins += 1;
                    level = curLevel;
                    binStart = bin * radarBuffers.binSize + radarBlackHoleAdd;
                    levelCount = 1;
                }
            }
        }
        return totalBins;
    }
}
