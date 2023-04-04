// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradDecodeEightBit {

    const float k180DivPi = 180.0f / (float)Math.PI;

    //
    // radar binary file has values that are big endian, handle in MemoryBuffer methods via struct.pack / unpack
    //
    public static int andCreateRadials(RadarBuffers radarBuffers, FileStorage fileStorage) {
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
        var yShift = -1.0f;
        foreach (var radial in range(numberOfRadials)) {
            var numberOfRleHalfWords = dis2.getUnsignedShort();
            var angle = (450.0f - (float) dis2.getUnsignedShort() / 10.0f);
            dis2.skipBytes(2);
            if (radial < numberOfRadials - 1) {
                dis2.mark(dis2.position);
                dis2.skipBytes((int) (numberOfRleHalfWords) + 2);
                angleNext = (450.0f - (float) dis2.getUnsignedShort() / 10.0f);
                dis2.reset();
            }
            uint8 level = 0;
            var levelCount = 0;
            var binStart = radarBuffers.binSize;
            if (radial == 0) {
                angle0 = angle;
            }
            if (radial < numberOfRadials - 1) {
                angleV = angleNext;
            } else {
                angleV = angle0;
            }
            var angleVCos = Math.cosf(angleV / k180DivPi);
            var angleVSin = Math.sinf(angleV / k180DivPi);
            var angleCos = Math.cosf(angle / k180DivPi);
            var angleSin = Math.sinf(angle / k180DivPi);
            foreach (var bin1 in range(numberOfRleHalfWords)) {
                var curLevel = dis2.get();
                if (bin1 == 0) {
                    level = curLevel;
                }
                if (curLevel == level) {
                    levelCount += 1;
                } else {
                    // Since we will attempt to use the higher level QT painter we don't need a color per vertex
                    // and we can draw a polygon instead of two triangles
                    // thus we will comment out redundant point and color data
                    // 1
                    var p1x = binStart * angleVCos;
                    var p1y = yShift * binStart * angleVSin;
                    // 2
                    var p2x = (binStart + radarBuffers.binSize * levelCount) * angleVCos;
                    var p2y = yShift * (binStart + radarBuffers.binSize * levelCount) * angleVSin;
                    // 3
                    var p3x = (binStart + radarBuffers.binSize * levelCount) * angleCos;
                    var p3y = yShift * (binStart + radarBuffers.binSize * levelCount) * angleSin;
                    // 4
                    var p4x = binStart * angleCos;
                    var p4y = yShift * binStart * angleSin;

                    radarBuffers.floatGL.add(p1x);
                    radarBuffers.floatGL.add(p1y);
                    radarBuffers.floatGL.add(p2x);
                    radarBuffers.floatGL.add(p2y);
                    radarBuffers.floatGL.add(p3x);
                    radarBuffers.floatGL.add(p3y);
                    radarBuffers.floatGL.add(p4x);
                    radarBuffers.floatGL.add(p4y);
                    radarBuffers.putColorsByIndex(level);

                    totalBins += 1;
                    level = curLevel;
                    binStart = bin1 * radarBuffers.binSize;
                    levelCount = 1;
                }
            }
        }
        return totalBins;
    }

    public static int createRadials(RadarBuffers radarBuffers) {
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
        foreach (var g in range(radarBuffers.numberOfRadials)) {
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
            var angleVCos = Math.cosf(angleV / k180DivPi);
            var angleVSin = Math.sinf(angleV / k180DivPi);
            var angleCos = Math.cosf(angle / k180DivPi);
            var angleSin = Math.sinf(angle / k180DivPi);
            foreach (var bin in range(radarBuffers.numberOfRangeBins)) {
                curLevel = radarBuffers.binWord.getByIndex(bI);
                bI += 1;
                if (curLevel == level) {
                    levelCount += 1;
                } else {
                    // 1
                    var p1x = binStart * angleVCos;
                    var p1y = yShift * binStart * angleVSin;
                    // 2
                    var p2x = (binStart + radarBuffers.binSize * levelCount) * angleVCos;
                    var p2y = yShift * (binStart + radarBuffers.binSize * levelCount) * angleVSin;
                    // 3
                    var p3x = (binStart + radarBuffers.binSize * levelCount) * angleCos;
                    var p3y = yShift * (binStart + radarBuffers.binSize * levelCount) * angleSin;
                    // 4
                    var p4x = binStart * angleCos;
                    var p4y = yShift * binStart * angleSin;

                    radarBuffers.floatGL.add(p1x);
                    radarBuffers.floatGL.add(p1y);
                    radarBuffers.floatGL.add(p2x);
                    radarBuffers.floatGL.add(p2y);
                    radarBuffers.floatGL.add(p3x);
                    radarBuffers.floatGL.add(p3y);
                    radarBuffers.floatGL.add(p4x);
                    radarBuffers.floatGL.add(p4y);
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
