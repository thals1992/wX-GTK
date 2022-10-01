// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class ObjectMetalRadarBuffers {

    public int animationIndex = -1;
    //  public MemoryBuffer floatBuffer = new MemoryBuffer(0);
    //  public MemoryBuffer colorBuffer = new MemoryBuffer(0);
    public ArrayList<float?> floatGL = new ArrayList<float?>();
    public ArrayList<uint8> colorGL = new ArrayList<uint8>();
    public MemoryBuffer radialStartAngle = new MemoryBuffer(0);
    public MemoryBuffer binWord = new MemoryBuffer(0);
    public int numberOfRadials = 0;
    public int numberOfRangeBins = 0;
    public float binSize = 0.0f;
    public int productCode = 0;
    public bool initialized = false;

    public void initialize() {
        floatGL.clear();
        colorGL.clear();
        //  if (productCode == 37 || productCode == 38 || productCode == 41 || productCode == 57) {
        //      if (floatBuffer.capacity < (48 * 464 * 464)) {
        //          floatBuffer = new MemoryBuffer(48 * 464 * 464);
        //      }
        //      if (colorBuffer.capacity < (12 * 464 * 464)) {
        //          colorBuffer = new MemoryBuffer(12 * 464 * 464);
        //      }
        //  } else {
        //      if (floatBuffer.capacity < (32 * numberOfRadials * numberOfRangeBins)) {
        //          floatBuffer = new MemoryBuffer(32 * numberOfRadials * numberOfRangeBins);
        //      }
        //      if (colorBuffer.capacity < 12 * numberOfRadials * numberOfRangeBins) {
        //          colorBuffer = new MemoryBuffer(12 * numberOfRadials * numberOfRangeBins);
        //      }
        //  }
        //  setToPositionZero();
        initialized = true;
    }

    public void setToPositionZero() {
        //  floatBuffer.position = 0;
        //  colorBuffer.position = 0;
    }

    //  public void putFloat(float newValue) {
    //      floatBuffer.putFloat(newValue);
    //  }

    public void putColor(uint8 b) {
        //  colorBuffer.put(b);
        colorGL.add(b);
    }

    public void setBackgroundColor() {
        ObjectColorPalette.colorMap[productCode].redValues.putByIndex(0, Color.red(RadarPreferences.nexradRadarBackgroundColor));
        ObjectColorPalette.colorMap[productCode].greenValues.putByIndex(0, Color.green(RadarPreferences.nexradRadarBackgroundColor));
        ObjectColorPalette.colorMap[productCode].blueValues.putByIndex(0, Color.blue(RadarPreferences.nexradRadarBackgroundColor));
    }

    public void putColorsByIndex(uint8 level) {
        putColor(ObjectColorPalette.colorMap[productCode].redValues.getByIndex(level));
        putColor(ObjectColorPalette.colorMap[productCode].greenValues.getByIndex(level));
        putColor(ObjectColorPalette.colorMap[productCode].blueValues.getByIndex(level));
    }
}
