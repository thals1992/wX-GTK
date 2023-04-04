// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradDecodeFourBit {

    public static int radial(RadarBuffers radarBuffers, FileStorage fileStorage) {
        MemoryBuffer dis;
        if (radarBuffers.animationIndex == -1) {
            dis = fileStorage.memoryBuffer;
        } else {
            dis = fileStorage.animationMemoryBuffer[radarBuffers.animationIndex];
        }
        dis.position = 0;
        if (dis.capacity == 0) {
            return 0;
        }
        if (dis.capacity > 0) {
            dis.skipBytes(170);
            var numberOfRangeBins = dis.getUnsignedShort();
            dis.skipBytes(6);
            dis.getUnsignedShort();
            var numberOfRleHalfwords = new int[360];
            radarBuffers.radialStartAngle.position = 0;
            radarBuffers.binWord.position = 0;
            var numOfBins = 0;
            foreach (var radial in range(360)) {
                numberOfRleHalfwords[radial] = dis.getUnsignedShort();
                radarBuffers.radialStartAngle.putFloat(450.0 - (float) dis.getUnsignedShort() / 10.0f);
                dis.skipBytes(2);
                range(numberOfRleHalfwords[radial] * 2).foreach(unused1 => {
                    var bin = dis.get();
                    numOfBins = (int)(bin >> 4);
                    range(numOfBins).foreach(unused2 => {
                        radarBuffers.binWord.put(bin % 16);
                        return true;
                    });
                    return true;
                });
            }
            return numberOfRangeBins;
        } else {
            return 230;
        }
    }

    public static int raster(RadarBuffers radarBuffers, FileStorage fileStorage) {
        MemoryBuffer dis;
        if (radarBuffers.animationIndex == -1) {
            dis = fileStorage.memoryBuffer;
        } else {
            dis = fileStorage.animationMemoryBuffer[radarBuffers.animationIndex];
        }
        dis.position = 0;
        if (dis.capacity == 0) {
            return 0;
        }
        var numberOfRangeBins = 0;
        if (dis.capacity > 0) {
            dis.skipBytes(172);
            //var iCoordinateStart = dis.getUnsignedShort();
            //var jCoordinateStart = dis.getUnsignedShort();
            //var xScaleInt = dis.getUnsignedShort();
            //var xScaleFractional = dis.getUnsignedShort();
            //var yScaleInt = dis.getUnsignedShort();
            //var yScaleFractional = dis.getUnsignedShort();
            dis.skipBytes(12);
            uint16 numberOfRows = dis.getUnsignedShort();
            //var packingDescriptor = dis.getUnsignedShort();
            dis.skipBytes(2);
            // 464 rows in NCR
            // 232 rows in NCZ
            var numOfBins = 0;
            range(numberOfRows).foreach(unused0 => {
                var numberOfBytes = dis.getUnsignedShort();
                range(numberOfBytes).foreach(unused1 => {
                    var bin = dis.get();
                    numOfBins = (int)(bin >> 4);
                    range(numOfBins).foreach(unused2 => {
                        radarBuffers.binWord.put(bin % 16);
                        return true;
                    });
                    return true;
                });
                return true;
            });
        } else {
            numberOfRangeBins = 230;
        }
        return numberOfRangeBins;
    }
}
