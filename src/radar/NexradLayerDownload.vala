// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradLayerDownload {

    weak ArrayList<NexradWidget> nexradList;
    ArrayList<FutureVoid> futures = new ArrayList<FutureVoid>();
    ArrayList<FutureVoidInt> futureInts = new ArrayList<FutureVoidInt>();

    public NexradLayerDownload(ArrayList<NexradWidget> nexradList) {
        this.nexradList = nexradList;
    }

    public void downloadLayers() {
        var allDone = true;
        foreach (var f in futures) {
            if (!f.isFinished()) {
                allDone = false;
            }
        }
        foreach (var f in futureInts) {
            if (!f.isFinished()) {
                allDone = false;
            }
        }
        if (allDone) {
            futures.clear();
            futureInts.clear();
        }
        if (RadarPreferences.warnings) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.tst].download, () => updateWarnings(PolygonType.tst)));
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.tor].download, () => updateWarnings(PolygonType.tor)));
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.ffw].download, () => updateWarnings(PolygonType.ffw)));
        }
        if (RadarPreferences.watch) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.watch].download, updateWatch));
        }
        if (RadarPreferences.mcd) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.mcd].download, updateMcd));
        }
        if (RadarPreferences.mpd) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.mpd].download, updateMpd));
        }
        if (RadarPreferences.swo) {
            futures.add(new FutureVoid(UtilitySwoDayOne.get, updateSwo));
        }
        if (RadarPreferences.wpcFronts) {
            futures.add(new FutureVoid(UtilityWpcFronts.get, updateWpcFronts));
        }
        foreach (var i in UtilityList.range(nexradList.size)) {
            if (RadarPreferences.sti) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3StormInfo.decode(nexradList[i].nexradState.pn, nexradList[i].fileStorage), updateSti, i));
            }
            if (RadarPreferences.obsWindbarbs || RadarPreferences.obs) {
                futureInts.add(new FutureVoidInt((i) => UtilityMetar.getStateMetarArrayForWXOGL(nexradList[i].nexradState.radarSite, nexradList[i].fileStorage), updateWBLines, i));
            }
            if (RadarPreferences.hailIndex) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3HailIndex.decode(nexradList[i].nexradState.pn, nexradList[i].fileStorage), constructHi, i));
            }
            if (RadarPreferences.tvs) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3Tvs.decode(nexradList[i].nexradState.pn, nexradList[i].fileStorage), constructTvs, i));
            }
        }
    }

    void updateWarnings(PolygonType polygonGenericType) {
        foreach (var nw in nexradList) {
            nw.processVtec(polygonGenericType);
            nw.da.draw();
        }
    }

    void updateWatch() {
        foreach (var nw in nexradList) {
            nw.processWatch();
            nw.da.draw();
        }
    }

    void updateMcd() {
        foreach (var nw in nexradList) {
            nw.processMcd();
            nw.da.draw();
        }
    }

    void updateMpd() {
        foreach (var nw in nexradList) {
            nw.processMpd();
            nw.da.draw();
        }
    }

    void updateSwo() {
        foreach (var nw in nexradList) {
            nw.constructSwo();
            nw.da.draw();
        }
    }

    void updateWpcFronts() {
        foreach (var nw in nexradList) {
            nw.constructWpcFronts();
            nw.da.draw();
        }
    }

    void updateWBLines(int i) {
        nexradList[i].constructWBLines();
        nexradList[i].da.draw();
    }

    void updateSti(int i) {
        nexradList[i].stiList.clear();
        nexradList[i].stiList.add_all(nexradList[i].fileStorage.stiData);
        nexradList[i].da.draw();
    }

    void constructHi(int i) {
        nexradList[i].constructHi();
        nexradList[i].da.draw();
    }

    void constructTvs(int i) {
        nexradList[i].constructTvs();
        nexradList[i].da.draw();
    }
}
