// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectColorPalette {

    public static HashMap<int, string> radarColorPalette;
    public static HashMap<int, ObjectColorPalette> colorMap;

    public MemoryBuffer redValues = new MemoryBuffer(0);
    public MemoryBuffer greenValues = new MemoryBuffer(0);
    public MemoryBuffer blueValues = new MemoryBuffer(0);
    int colormapCode = 0;

    public ObjectColorPalette(int colormapCode) {
        this.colormapCode = colormapCode;
    }

    public void setupBuffers(int size) {
        redValues = new MemoryBuffer(size);
        greenValues = new MemoryBuffer(size);
        blueValues = new MemoryBuffer(size);
    }

    public void position(int index) {
        redValues.position = index;
        blueValues.position = index;
        greenValues.position = index;
    }

    public void putBytesFromLine(ObjectColorPaletteLine objectColorPaletteLine) {
        redValues.put((uint8)(objectColorPaletteLine.red));
        greenValues.put((uint8)(objectColorPaletteLine.green));
        blueValues.put((uint8)(objectColorPaletteLine.blue));
    }

    public void putInt(int colorAsInt) {
        redValues.put(Color.red(colorAsInt));
        greenValues.put(Color.green(colorAsInt));
        blueValues.put(Color.blue(colorAsInt));
    }

    public void initialize() {
        switch (colormapCode) {
            case 19, 30, 56:
                setupBuffers(4 * 16);
                generate4bitGeneric(colormapCode);
                break;
            case 165:
                setupBuffers(4 * 256);
                loadColorMap165();
                break;
            default:
                // previously this held 256 bytes as each color was represented via byte. Now holds int so 4 times that
                setupBuffers(4 * 256);
                loadColorMap(colormapCode);
                break;
        }
    }

    static void generate(int productCode, string code) {
        ObjectColorPalette objectColorPalette = ObjectColorPalette.colorMap[productCode];
        objectColorPalette.position(0);
        var objectColorPaletteLines = new ArrayList<ObjectColorPaletteLine>();
        var scale = 2;
        var lowerEnd = -32;
        var prodOffset = 0.0;
        var prodScale = 1.0;
        switch (productCode) {
            case 94:
                scale = 2;
                lowerEnd = -32;
                break;
            case 99:
                scale = 1;
                lowerEnd = -127;
                break;
            case 134:
                scale = 1;
                lowerEnd = 0;
                prodOffset = 0.0;
                prodScale = 3.64;
                break;
            case 135:
                scale = 1;
                lowerEnd = 0;
                break;
            case 159:
                scale = 1;
                lowerEnd = 0;
                prodOffset = 128.0;
                prodScale = 16.0;
                break;
            case 161:
                scale = 1;
                lowerEnd = 0;
                prodOffset = -60.5;
                prodScale = 300.0;
                break;
            case 163:
                scale = 1;
                lowerEnd = 0;
                prodOffset = 43.0;
                prodScale = 20.0;
                break;
            case 172:
                scale = 1;
                lowerEnd = 0;
                break;
            default:
                break;
        }
        var text = UtilityColorPalette.getColorMapStringFromDisk(productCode, code);
        var red = "0";
        var green = "0";
        var blue = "0";
        var priorLineHas6 = false;
        foreach (var line in text.split("\n")) {
            if (line.contains("olor") && !line.contains("#")) {
                var items = line.contains(",") ? line.split(",") : line.split(" ");
                if (items.length > 4) {
                    red = items[2];
                    green = items[3];
                    blue = items[4];
                    if (priorLineHas6) {
                        objectColorPaletteLines.add(new ObjectColorPaletteLine.withDbzNoList((Too.Double(items[1]) * prodScale + prodOffset - 1), red, green, blue));
                        objectColorPaletteLines.add(new ObjectColorPaletteLine.withDbzNoList((Too.Double(items[1]) * prodScale + prodOffset - 1), red, green, blue));
                        priorLineHas6 = false;
                    } else {
                        objectColorPaletteLines.add(new ObjectColorPaletteLine.withDbzNoList((Too.Double(items[1]) * prodScale + prodOffset - 1), red, green, blue));
                    }
                    if (items.length > 7) {
                        priorLineHas6 = true;
                        red = items[5];
                        green = items[6];
                        blue = items[7];
                    }
                }
            }
        }
        if (productCode == 161) {
            UtilityList.range(10).foreach((unused) => {
                objectColorPalette.putBytesFromLine(objectColorPaletteLines[0]);
                return true;
            });
        }
        if (productCode == 99 || productCode == 13) {
            objectColorPalette.putBytesFromLine(objectColorPaletteLines[0]);
            objectColorPalette.putBytesFromLine(objectColorPaletteLines[0]);
        }
        UtilityList.range3(lowerEnd, objectColorPaletteLines[0].dbz, 1).foreach((unused) => {
            objectColorPalette.putBytesFromLine(objectColorPaletteLines[0]);
            if (scale == 2) {
                objectColorPalette.putBytesFromLine(objectColorPaletteLines[0]);
            }
            return true;
        });
        foreach (var index in UtilityList.range(objectColorPaletteLines.size)) {
            if (index < (objectColorPaletteLines.size - 1)) {
                int low = objectColorPaletteLines[index].dbz;
                var lowColor = objectColorPaletteLines[index].asInt();
                int high = objectColorPaletteLines[index + 1].dbz;
                var highColor = objectColorPaletteLines[index + 1].asInt();
                int diff = high - low;
                objectColorPalette.putBytesFromLine(objectColorPaletteLines[index]);
                if (scale == 2) {
                    objectColorPalette.putBytesFromLine(objectColorPaletteLines[index]);
                }
                if (diff == 0) {
                    diff = 1;
                }
                foreach (var j in UtilityList.range3(1, diff, 1)) {
                    if (scale == 1) {
                        var amt0 = (double)j / (double)(diff * scale);
                        var colorInt = UtilityNexradColors.interpolateColor(lowColor, highColor, amt0);
                        objectColorPalette.putInt(colorInt);
                    } else if (scale == 2) {
                        var amt1 = ((j * 2.0) - 1.0) / (diff * 2.0);
                        var amt2 = (j * 2.0) / (diff * 2.0);
                        var colorInt = UtilityNexradColors.interpolateColor(lowColor, highColor, amt1);
                        var colorInt2 = UtilityNexradColors.interpolateColor(lowColor, highColor, amt2);
                        objectColorPalette.putInt(colorInt);
                        objectColorPalette.putInt(colorInt2);
                    }
                }
            } else {
                objectColorPalette.putBytesFromLine(objectColorPaletteLines[index]);
                if (scale == 2) {
                    objectColorPalette.putBytesFromLine(objectColorPaletteLines[index]);
                }
            }
        }
    }

    public static void loadColorMap(int productCode) {
        ColorPalettes.refreshPref();
        var map = ObjectColorPalette.radarColorPalette[productCode];
        generate(productCode, map);
    }

    static void generate4bitGeneric(int radarColorPaletteCode) {
        var text = UtilityColorPalette.getColorMapStringFromDisk(radarColorPaletteCode, "CODENH");
        foreach (var line in text.split("\n")) {
            if (line.contains(",")) {
                var objectColorPaletteLines = new ObjectColorPaletteLine.fourBit(line.split(","));
                ObjectColorPalette.colorMap[radarColorPaletteCode].putBytesFromLine(objectColorPaletteLines);
            }
        }
    }

    static void loadColorMap165() {
        int radarColorPaletteCode = 165;
        var objectColorPaletteLines = new ArrayList<ObjectColorPaletteLine>();
        var text = UtilityColorPalette.getColorMapStringFromDisk(radarColorPaletteCode, "CODENH");
        foreach (var data in text.split("\n")) {
            if (data.contains("olor") && !data.contains("#")) {
                var items = (data.contains(",")) ? data.split(",") : data.split(" ");
                if (items.length > 4) {
                    objectColorPaletteLines.add(new ObjectColorPaletteLine(UtilityList.wrap(items)));
                }
            }
        }
        const int diff = 10;
        foreach (var i in UtilityList.range(objectColorPaletteLines.size)) {
            UtilityList.range(diff).foreach((unused) => {
                ObjectColorPalette.colorMap[radarColorPaletteCode].putBytesFromLine(objectColorPaletteLines[i]);
                return true;
            });
        }
    }
}
