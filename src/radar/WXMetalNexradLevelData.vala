// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class WXMetalNexradLevelData {

    float binSize = 0.0f;
    int numberOfRangeBins = 916;
    int numberOfRadials = 360;
    int productCode = 0;
    double halfword3132 = 0.0;
    int seekStart = 0;
    int radarHeight = 0;
    double degree = 0.0;
    int operationalMode = 0;
    int volumeCoveragePattern = 0;
    public ObjectMetalRadarBuffers radarBuffers = new ObjectMetalRadarBuffers();
    FileStorage fileStorage;
    NexradState nexradState;
    public int totalBins = 0;
    public string radarInfo = "";
    public string radarDate = "";
    public int radarAgeMilli = 0;

    public WXMetalNexradLevelData(NexradState nexradState, FileStorage fileStorage) {
        this.fileStorage = fileStorage;
        this.nexradState = nexradState;
        productCode = GlobalDictionaries.radarProductStringToShortInt[nexradState.radarProduct];
    }

    public void decode() {
        productCode = GlobalDictionaries.radarProductStringToShortInt[nexradState.radarProduct];
        if (productCode in new int[]{30, 37, 38, 41, 56, 57, 78, 80, 181}) {
            decodeAndPlotNexradLevel3FourBit();
        } else {
            decodeAndPlotNexradLevel3();
        }
    }

    public void generateRadials() {
        if (productCode in new int[]{37, 38}) {
            totalBins = UtilityWXMetalPerfRaster.generate(radarBuffers);
        } else if (productCode in new int[]{30, 56, 78, 80, 181}) {
            totalBins = UtilityWXMetalPerf.genRadials(radarBuffers);
        } else if (productCode == 0) {
            totalBins = 0;
        } else {
            totalBins = UtilityWXMetalPerf.decode8BitAndGenRadials(radarBuffers, fileStorage);
        }
    }

    public void decodeAndPlotNexradLevel3() {
        MemoryBuffer dis;
        if (radarBuffers.animationIndex == -1) {
            dis = fileStorage.memoryBuffer;
        } else {
            dis = fileStorage.animationMemoryBuffer[radarBuffers.animationIndex];
        }
        dis.position = 0;
        if (dis.capacity > 300) {
            while (dis.getShort() != -1) {
            }
            //42700 example latOfRadar
            dis.getInt();
            // -83472 example lonOfRadar
            dis.getInt();

            radarHeight = dis.getUnsignedShort();
            productCode = dis.getUnsignedShort();
            operationalMode = dis.getUnsignedShort();
            volumeCoveragePattern = dis.getUnsignedShort();
            // sequenceNumber
            dis.getShort();
            // volumeScanNumber
            dis.getUnsignedShort();
            var volumeScanDate = dis.getUnsignedShort();
            var volumeScanTime = dis.getInt();
            writeTime(volumeScanDate, volumeScanTime);

            dis.skipBytes(10);
            // elevationNumber
            dis.getUnsignedShort();
            var elevationAngle = dis.getShort();
            degree = elevationAngle / 10.0;
            halfword3132 = dis.getFloat();
            dis.skipBytes(56);
            seekStart = dis.filePointer();
            binSize = WXGLNexrad.getBinSize(productCode);
            numberOfRangeBins = WXGLNexrad.getNumberRangeBins(productCode);
            numberOfRadials = 360;
            if (productCode == 153 || productCode == 154) {
                numberOfRadials = 720;
            }
            radarBuffers.numberOfRangeBins = numberOfRangeBins;
            radarBuffers.numberOfRadials = numberOfRadials;
            radarBuffers.binSize = binSize;
            radarBuffers.productCode = productCode;
        }
    }

    public void decodeAndPlotNexradLevel3FourBit() {
        switch (productCode) {
            case 181:
                radarBuffers.binWord = new MemoryBuffer(360 * 720);
                break;
            case 78:
                radarBuffers.binWord = new MemoryBuffer(360 * 592);
                break;
            case 80:
                radarBuffers.binWord = new MemoryBuffer(360 * 592);
                break;
            case 37:
                radarBuffers.binWord = new MemoryBuffer(464 * 464);
                break;
            case 38:
                radarBuffers.binWord = new MemoryBuffer(464 * 464);
                break;
            default:
                radarBuffers.binWord = new MemoryBuffer(360 * 230);
                break;
        }
        radarBuffers.radialStartAngle = new MemoryBuffer(4 * 360);
        MemoryBuffer dis;
        if (radarBuffers.animationIndex == -1) {
            dis = fileStorage.memoryBuffer;
        } else {
            dis = fileStorage.animationMemoryBuffer[radarBuffers.animationIndex];
        }
        if (dis.capacity > 0) {
            dis.skipBytes(58);
            radarHeight = dis.getUnsignedShort();
            productCode = (dis.getUnsignedShort());
            operationalMode = dis.getUnsignedShort();
            volumeCoveragePattern = dis.getUnsignedShort();
            // sequenceNumber
            dis.getShort();
            // volumeScanNumber
            dis.getUnsignedShort();
            var volumeScanDate = dis.getUnsignedShort();
            var volumeScanTime = dis.getInt();
            writeTime(volumeScanDate, volumeScanTime);
            dis.skipBytes(94);
            if (productCode == 37 || productCode == 38 || productCode == 41 || productCode == 57) {
                numberOfRangeBins = decodeRaster();
            } else {
                numberOfRangeBins = decodeRadial4bit();
            }
            binSize = WXGLNexrad.getBinSize(productCode);
            numberOfRadials = 360;
            radarBuffers.numberOfRangeBins = numberOfRangeBins;
            radarBuffers.numberOfRadials = numberOfRadials;
            radarBuffers.binSize = binSize;
            radarBuffers.productCode = productCode;
        }
    }

    public void writeTime(int volumeScanDate, int volumeScanTime) {
        var radarInfo = "Mode: " + Too.String(operationalMode) + ", " + "VCP: " + Too.String(volumeCoveragePattern) + ", " + "Product: " + Too.String(productCode) + ", " + "Height: " + Too.String(radarHeight);
        int64 sec = (((volumeScanDate) - 1) * 3600 * 24) + volumeScanTime;
        var dateString = ObjectDateTime.getTimeFromPointAsString(sec);
        var radarInfoFinal = dateString + " " + radarInfo;
        fileStorage.radarInfo = radarInfoFinal;
        fileStorage.radarDate = dateString;
        fileStorage.radarVcp = Too.String(volumeCoveragePattern);
        fileStorage.radarAgeMilli = (int)(ObjectDateTime.currentTimeMillis() - sec * 1000);
        fileStorage.radarProductId = productCode;
        this.radarInfo = radarInfoFinal;
        this.radarDate = dateString;
        this.radarAgeMilli = (int)(ObjectDateTime.currentTimeMillis() - sec * 1000);
    }

    int decodeRadial4bit() {
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
                radarBuffers.radialStartAngle.putFloat((450.0 - (((float)dis.getUnsignedShort() / 10.0f))));
                dis.skipBytes(2);
                range(numberOfRleHalfwords[radial] * 2).foreach((unused1) => {
                    var bin = dis.get();
                    numOfBins = (int)(bin >> 4);
                    range(numOfBins).foreach((unused2) => {
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

    int decodeRaster() {
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
            range(numberOfRows).foreach((unused0) => {
                var numberOfBytes = dis.getUnsignedShort();
                range(numberOfBytes).foreach((unused1) => {
                    var bin = dis.get();
                    numOfBins = (int)(bin >> 4);
                    range(numOfBins).foreach((unused2) => {
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
