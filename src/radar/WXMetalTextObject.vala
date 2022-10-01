// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class WXMetalTextObject {

    NexradState nexradState;
    FileStorage fileStorage;
    int numPanes = 0;
    public double glViewWidth = 0.0;
    public double glViewHeight = 0.0;
    int maxCitiesPerGlview = 0;
    const float cityMinZoom = 0.20f;
    const float obsMinZoom = 0.20f;
    const float countyMinZoom = 0.20f;
    const int textSize = 10;

    public WXMetalTextObject(int numPanes, NexradState nexradState, FileStorage fileStorage) {
        this.nexradState = nexradState;
        this.fileStorage = fileStorage;
        this.glViewWidth = 2000.0;
        this.glViewHeight = 1200.0;
        this.numPanes = numPanes;
        maxCitiesPerGlview = (int)(40.0 / numPanes);
        initialize();
    }

    void addTextLabelsCitiesExtended() {
        if (RadarPreferences.cities) {
            nexradState.cities.clear();
            if (nexradState.zoom > cityMinZoom) {
                var cityExtLength = UtilityCitiesExtended.cities.size;
                foreach (var index in range(cityExtLength)) {
                    if (nexradState.cities.size <= maxCitiesPerGlview) {
                        checkAndDrawText(nexradState.cities, UtilityCitiesExtended.cities[index].latitude, UtilityCitiesExtended.cities[index].longitude, UtilityCitiesExtended.cities[index].name, true);
                    }
                }
            }
        }
    }

    void checkAndDrawText(ArrayList<TextViewMetal> tvList, double lat, double lon, string text, bool checkBounds) {
        var latLon = UtilityCanvasProjection.computeMercatorNumbers(lat, -1.0 * lon, nexradState.getPn());
        var xPos = latLon[0];
        var yPos = latLon[1];
        if (checkBounds && glViewWidth / (-2.0 * nexradState.zoom) < xPos && xPos < glViewWidth / (2.0 * nexradState.zoom) && glViewHeight / (-2.0 * nexradState.zoom) < yPos && yPos < glViewHeight / (2.0 * nexradState.zoom)) {
            var tv = new TextViewMetal();
            tv.setPadding(xPos, yPos);
            tv.setText(text);
            tvList.add(tv);
        } else if (!checkBounds) {
            var tv = new TextViewMetal();
            tv.setPadding(xPos, yPos);
            tv.setText(text);
            tvList.add(tv);
        }
    }

    void initializeTextLabelsCitiesExtended() {
        if (numPanes == 1 && RadarPreferences.cities && !UtilityCitiesExtended.initialized) {
            UtilityCitiesExtended.create();
        }
    }

    void initializeTextLabelsCountyLabels() {
        if (RadarPreferences.countyLabels && !UtilityCountyLabels.initialized) {
            UtilityCountyLabels.create();
        }
    }

    void addTextLabelsCountyLabels() {
        if (RadarPreferences.countyLabels) {
            nexradState.countyLabels.clear();
            if (nexradState.zoom > countyMinZoom) {
                foreach (var index in range(UtilityCountyLabels.names.size)) {
                    checkAndDrawText(nexradState.countyLabels, UtilityCountyLabels.location[index].lat(), UtilityCountyLabels.location[index].lon(), UtilityCountyLabels.names[index], true);
                }
            }
        }
    }

    public void initialize() {
        if (numPanes == 1) {
            initializeTextLabelsCitiesExtended();
        }
        initializeTextLabelsCountyLabels();
    }

    public void add() {
        if (RadarPreferences.cities) {
            addTextLabelsCitiesExtended();
        }
        if (RadarPreferences.countyLabels) {
            addTextLabelsCountyLabels();
        }
        if (RadarPreferences.wpcFronts) {
            addWpcPressureCenters();
        }
        if (RadarPreferences.obs) {
            addTextLabelsObservations();
        }
    }

    public void addWpcPressureCenters() {
        if (RadarPreferences.wpcFronts) {
            nexradState.pressureCenterLabelsRed.clear();
            nexradState.pressureCenterLabelsBlue.clear();
            if (nexradState.zoom < nexradState.zoomToHideMiscFeatures) {
                foreach (var p in UtilityWpcFronts.pressureCenters) {
                    if (p.type == PressureCenterTypeEnum.low) {
                        checkAndDrawText(nexradState.pressureCenterLabelsRed, p.lat, p.lon, p.pressureInMb, false);
                    } else {
                        checkAndDrawText(nexradState.pressureCenterLabelsBlue, p.lat, p.lon, p.pressureInMb, false);
                    }
                }
            }
        }
    }

    public void addTextLabelsObservations() {
        if (RadarPreferences.obs || RadarPreferences.obsWindbarbs) {
            nexradState.observations.clear();
            if (nexradState.zoom > obsMinZoom) {
                foreach (var index in range(fileStorage.obsArr.size)) {
                    if (index < fileStorage.obsArr.size && index < fileStorage.obsArrExt.size) {
                        var tmpArrObs = fileStorage.obsArr[index].split(":");
                        var lat = Too.Double(tmpArrObs[0]);
                        var lon = Too.Double(tmpArrObs[1]);
                        checkAndDrawText(nexradState.observations, lat, -1.0 * lon, tmpArrObs[2], true);
                    }
                }
            }
        }
    }
}
