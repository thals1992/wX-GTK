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
        //  if (RadarPreferences.warnings) {
        //      futures.add(new FutureVoid(PolygonWarning.polygonDataByType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        //      futures.add(new FutureVoid(PolygonWarning.polygonDataByType[PolygonType.Tor].download, () => updateWarnings(PolygonType.Tor)));
        //      futures.add(new FutureVoid(PolygonWarning.polygonDataByType[PolygonType.Ffw].download, () => updateWarnings(PolygonType.Ffw)));
        //  }

        //  foreach (var t in PolygonWarning.polygonList) {
        //      if (PolygonWarning.polygonDataByType[PolygonType.Tst].isEnabled) {
        //          futures.add(new FutureVoid(PolygonWarning.polygonDataByType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        //      }
        //  }

        if (PolygonWarning.byType[PolygonType.Tst].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        }
        if (PolygonWarning.byType[PolygonType.Tor].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Tor].download, () => updateWarnings(PolygonType.Tor)));
        }
        if (PolygonWarning.byType[PolygonType.Ffw].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Ffw].download, () => updateWarnings(PolygonType.Ffw)));
        }
        if (PolygonWarning.byType[PolygonType.Smw].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Smw].download, () => updateWarnings(PolygonType.Smw)));
        }
        if (PolygonWarning.byType[PolygonType.Sqw].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Sqw].download, () => updateWarnings(PolygonType.Sqw)));
        }
        if (PolygonWarning.byType[PolygonType.Dsw].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Dsw].download, () => updateWarnings(PolygonType.Dsw)));
        }
        if (PolygonWarning.byType[PolygonType.Sps].isEnabled) {
            futures.add(new FutureVoid(PolygonWarning.byType[PolygonType.Sps].download, () => updateWarnings(PolygonType.Sps)));
        }

        //  auto col1 = {Mcd, Watch, Mpd};
        //  var col1 = new PolygonType[]{PolygonType.Mcd, PolygonType.Watch, PolygonType.Mpd};
        //  foreach (var t in col1) {
        //      if (PolygonWatch.polygonDataByType[t].isEnabled) {
        //          PolygonType t1 = t;
        //          futures.add(new FutureVoid(PolygonWatch.polygonDataByType[t].download, () => processWatch(t1)));
        //      }
        //  }
        if (PolygonWatch.byType[PolygonType.Watch].isEnabled) {
            futures.add(new FutureVoid(PolygonWatch.byType[PolygonType.Watch].download, () => processWatch(PolygonType.Watch)));
        }
        if (PolygonWatch.byType[PolygonType.Mcd].isEnabled) {
            futures.add(new FutureVoid(PolygonWatch.byType[PolygonType.Mcd].download, () => processWatch(PolygonType.Mcd)));
        }
        if (PolygonWatch.byType[PolygonType.Mpd].isEnabled) {
            futures.add(new FutureVoid(PolygonWatch.byType[PolygonType.Mpd].download, () => processWatch(PolygonType.Mpd)));
        }

        //  if (RadarPreferences.watch) {
        //      futures.add(new FutureVoid(PolygonWatch.polygonDataByType[PolygonType.Watch].download, () => processWatch(PolygonType.Watch)));
        //  }
        //  if (RadarPreferences.mcd) {
        //      futures.add(new FutureVoid(PolygonWatch.polygonDataByType[PolygonType.Mcd].download, () => processWatch(PolygonType.Mcd)));
        //  }
        //  if (RadarPreferences.mpd) {
        //      futures.add(new FutureVoid(PolygonWatch.polygonDataByType[PolygonType.Mpd].download, () => processWatch(PolygonType.Mpd)));
        //  }
        if (RadarPreferences.swo) {
            futures.add(new FutureVoid(SwoDayOne.get, updateSwo));
        }
        if (RadarPreferences.wpcFronts) {
            futures.add(new FutureVoid(WpcFronts.get, updateWpcFronts));
        }
        foreach (var i in range(nexradList.size)) {
            if (RadarPreferences.sti) {
                futureInts.add(new FutureVoidInt((i) => NexradLevel3StormInfo.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), updateSti, i));
            }
            if (RadarPreferences.obsWindbarbs || RadarPreferences.obs) {
                futureInts.add(new FutureVoidInt((i) => Metar.getStateMetarArrayForWXOGL(nexradList[i].nexradState.getRadarSite(), nexradList[i].fileStorage), updateWBLines, i));
            }
            if (RadarPreferences.hailIndex) {
                futureInts.add(new FutureVoidInt((i) => NexradLevel3HailIndex.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), constructHi, i));
            }
            if (RadarPreferences.tvs) {
                futureInts.add(new FutureVoidInt((i) => NexradLevel3Tvs.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), constructTvs, i));
            }
        }
    }

    void updateWarnings(PolygonType polygonGenericType) {
        foreach (var nw in nexradList) {
            nw.processVtec(polygonGenericType);
            nw.draw();
        }
    }

    void processWatch(PolygonType type) {
        foreach (var nw in nexradList) {
            nw.process(type);
            if (type == PolygonType.Watch) {
                nw.process(PolygonType.WatchTornado);
            }
            nw.draw();
        }
    }

    void updateSwo() {
        foreach (var nw in nexradList) {
            nw.constructSwo();
            nw.draw();
        }
    }

    void updateWpcFronts() {
        foreach (var nw in nexradList) {
            nw.constructWpcFronts();
            nw.draw();
        }
    }

    void updateWBLines(int i) {
        nexradList[i].constructWBLines();
        nexradList[i].draw();
    }

    void updateSti(int i) {
        nexradList[i].stiList.clear();
        nexradList[i].stiList.add_all(nexradList[i].fileStorage.stiData);
        nexradList[i].draw();
    }

    void constructHi(int i) {
        nexradList[i].constructHi();
        nexradList[i].draw();
    }

    void constructTvs(int i) {
        nexradList[i].constructTvs();
        nexradList[i].draw();
    }
}
