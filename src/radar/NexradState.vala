// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradState {

    public const string[] initialRadarProducts = {"N0Q", "N0U", "EET", "DVL"};
    public int paneNumber = 0;
    public int numberOfPanes = 1;
    public string numberOfPanesStr = "1";
    bool useASpecificRadar = false;
    public double xPos = 0.0;
    public double yPos = 0.0;
    public double zoom = 1.0;
    public string radarSite = Location.radarSite();
    public string radarProduct = initialRadarProducts[0];
    public int tiltInt = 0;
    public double windowHeight = 0.0;
    public double windowWidth = 0.0;
    public ProjectionNumbers pn = new ProjectionNumbers(Location.radarSite());
    public ArrayList<TextViewMetal> cities = new ArrayList<TextViewMetal>();
    public ArrayList<TextViewMetal> countyLabels = new ArrayList<TextViewMetal>();
    public ArrayList<TextViewMetal> pressureCenterLabelsRed = new ArrayList<TextViewMetal>();
    public ArrayList<TextViewMetal> pressureCenterLabelsBlue = new ArrayList<TextViewMetal>();
    public ArrayList<TextViewMetal> observations = new ArrayList<TextViewMetal>();
    public double zoomToHideMiscFeatures = 0.2;
    public ArrayList<WXMetalNexradLevelData> levelDataList = new ArrayList<WXMetalNexradLevelData>();

    public NexradState(int paneNumber, int numberOfPanes, bool useASpecificRadar) {
        this.paneNumber = paneNumber;
        this.numberOfPanes = numberOfPanes;
        numberOfPanesStr = Too.String(numberOfPanes);
        this.useASpecificRadar = useASpecificRadar;
    }

    public void reset() {
        xPos = 0.0;
        yPos = 0.0;
        zoom = 1.0;
    }

    public void readPreferences() {
        var radarType = "WXMETAL";
        var index = Too.String(paneNumber);
        if (RadarPreferences.rememberLocation) {
            zoom = Too.Double(Utility.readPref(radarType + numberOfPanesStr + "_ZOOM" + index, "1.0"));
            xPos = Too.Double(Utility.readPref(radarType + numberOfPanesStr + "_X" + index, "0.0"));
            yPos = Too.Double(Utility.readPref(radarType + numberOfPanesStr + "_Y" + index, "0.0"));
            radarSite = Utility.readPref(radarType + numberOfPanesStr + "_RID" + index, Location.radarSite());
            radarProduct = Utility.readPref(radarType + numberOfPanesStr + "_PROD" + index, initialRadarProducts[paneNumber]);
            tiltInt = Utility.readPrefInt(radarType + numberOfPanesStr + "_TILT" + index, 0);
        }
    }

    public void writePreferences() {
        if (!useASpecificRadar) {
            var radarType = "WXMETAL";
            var index = Too.String(paneNumber);
            Utility.writePref(radarType + numberOfPanesStr + "_ZOOM" + index, Too.StringFromD(zoom));
            Utility.writePref(radarType + numberOfPanesStr + "_X" + index, Too.StringFromD(xPos));
            Utility.writePref(radarType + numberOfPanesStr + "_Y" + index, Too.StringFromD(yPos));
            Utility.writePref(radarType + numberOfPanesStr + "_RID" + index, radarSite);
            Utility.writePref(radarType + numberOfPanesStr + "_PROD" + index, radarProduct);
            Utility.writePrefInt(radarType + numberOfPanesStr + "_TILT" + index, tiltInt);
        }
    }

    public void processAnimationFiles(int frameCount, FileStorage fileStorage) {
        foreach (var index in UtilityList.range(frameCount)) {
            levelDataList.add(new WXMetalNexradLevelData(radarProduct, Too.String(paneNumber), fileStorage));
            levelDataList.last().radarBuffers.animationIndex = index;
            levelDataList.last().decode();
            levelDataList.last().radarBuffers.initialize();
            levelDataList.last().generateRadials();
            levelDataList.last().radarBuffers.setToPositionZero();
        }
    }
}
