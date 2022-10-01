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
            print("NexradLayerDownload: clear futures\n");
            futures.clear();
            futureInts.clear();
        }
        //  if (RadarPreferences.warnings) {
        //      futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        //      futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Tor].download, () => updateWarnings(PolygonType.Tor)));
        //      futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Ffw].download, () => updateWarnings(PolygonType.Ffw)));
        //  }

        //  foreach (var t in ObjectPolygonWarning.polygonList) {
        //      if (ObjectPolygonWarning.polygonDataByType[PolygonType.Tst].isEnabled) {
        //          futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        //      }
        //  }

        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Tst].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Tst].download, () => updateWarnings(PolygonType.Tst)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Tor].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Tor].download, () => updateWarnings(PolygonType.Tor)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Ffw].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Ffw].download, () => updateWarnings(PolygonType.Ffw)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Smw].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Smw].download, () => updateWarnings(PolygonType.Smw)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Sqw].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Sqw].download, () => updateWarnings(PolygonType.Sqw)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Dsw].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Dsw].download, () => updateWarnings(PolygonType.Dsw)));
        }
        if (ObjectPolygonWarning.polygonDataByType[PolygonType.Sps].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWarning.polygonDataByType[PolygonType.Sps].download, () => updateWarnings(PolygonType.Sps)));
        }

        //  auto col1 = {Mcd, Watch, Mpd};
        //  var col1 = new PolygonType[]{PolygonType.Mcd, PolygonType.Watch, PolygonType.Mpd};
        //  foreach (var t in col1) {
        //      if (ObjectPolygonWatch.polygonDataByType[t].isEnabled) {
        //          print(t.to_string() + " enabled \n");
        //          PolygonType t1 = t;
        //          futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[t].download, () => processWatch(t1)));
        //      }
        //  }
        if (ObjectPolygonWatch.polygonDataByType[PolygonType.Watch].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Watch].download, () => processWatch(PolygonType.Watch)));
        }
        if (ObjectPolygonWatch.polygonDataByType[PolygonType.Mcd].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Mcd].download, () => processWatch(PolygonType.Mcd)));
        }
        if (ObjectPolygonWatch.polygonDataByType[PolygonType.Mpd].isEnabled) {
            futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Mpd].download, () => processWatch(PolygonType.Mpd)));
        }


        //  if (RadarPreferences.watch) {
        //      futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Watch].download, () => processWatch(PolygonType.Watch)));
        //  }
        //  if (RadarPreferences.mcd) {
        //      futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Mcd].download, () => processWatch(PolygonType.Mcd)));
        //  }
        //  if (RadarPreferences.mpd) {
        //      futures.add(new FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonType.Mpd].download, () => processWatch(PolygonType.Mpd)));
        //  }
        if (RadarPreferences.swo) {
            futures.add(new FutureVoid(UtilitySwoDayOne.get, updateSwo));
        }
        if (RadarPreferences.wpcFronts) {
            futures.add(new FutureVoid(UtilityWpcFronts.get, updateWpcFronts));
        }
        foreach (var i in range(nexradList.size)) {
            if (RadarPreferences.sti) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3StormInfo.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), updateSti, i));
            }
            if (RadarPreferences.obsWindbarbs || RadarPreferences.obs) {
                futureInts.add(new FutureVoidInt((i) => UtilityMetar.getStateMetarArrayForWXOGL(nexradList[i].nexradState.getRadarSite(), nexradList[i].fileStorage), updateWBLines, i));
            }
            if (RadarPreferences.hailIndex) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3HailIndex.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), constructHi, i));
            }
            if (RadarPreferences.tvs) {
                futureInts.add(new FutureVoidInt((i) => WXGLNexradLevel3Tvs.decode(nexradList[i].nexradState.getPn(), nexradList[i].fileStorage), constructTvs, i));
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
        //  print("processWatch " + type.to_string() + "\n");
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
