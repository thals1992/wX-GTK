// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectModel {

    string modelName = "";
    public ArrayList<string> paramCodes = new ArrayList<string>();
    public ArrayList<string> paramLabels = new ArrayList<string>();
    public ArrayList<string> sectors = new ArrayList<string>();
    public ArrayList<string> times = new ArrayList<string>();
    public ArrayList<string> runs = new ArrayList<string>();
    public ArrayList<string> models = new ArrayList<string>();
    public RunTimeData runTimeData = new RunTimeData();
    string modelToken = "";
    public string prefModel;
    string prefSector = "";
    string prefParam = "";
    string prefRunPosn = "";
    string prefRunPosnIdx = "";
    public string model = "";
    public string run = "";
    public string timeStr = "";
    public int timeIdx = 0;
    public string param = "";
    public string sector = "";
    int sectorInt = 0;
    int prodIdx = 0;

    public string getTime() {
        if (timeStr.contains(" ")) {
            return timeStr.split(" ")[0];
        } else {
            return timeStr;
        }
    }

    public ObjectModel(string prefModel) {
        this.prefModel = prefModel;
        prefSector = "MODEL" + prefModel + "SECTORLASTUSED";
        prefParam = "MODEL" + prefModel + "PARAMLASTUSED";
        prefRunPosn = prefModel + "RUNPOSN";
        prefRunPosnIdx = prefModel + "RUNPOSN" + "IDX";
        if (prefModel == "NCARENSEMBLE") {
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "t2mean";
            sector = "CONUS";
            model = "NCARENSEMBLE";
            models = UtilityList.wrap({"NCARENSEMBLE"});
        } else if (prefModel == "NSSLWRF") {
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "sfct";
            sector = "CONUS";
            model = "WRF";
            models = UtilityList.wrap(UtilityModelNsslWrfInterface.models);
        } else if (prefModel == "ESRL") {
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "1ref_sfc";
            model = "HRRR_NCEP";
            sector = "US";
            sectorInt = 0;
            models = UtilityList.wrap(UtilityModelEsrlInterface.models);
        } else if (prefModel == "GLCFS") {
            run = "00Z";
            timeStr = "01";
            timeIdx = 0;
            param = "wv";
            model = "GLCFS";
            models = UtilityList.wrap({"GLCFS"});
            sector = "All Lakes";
        } else if (prefModel == "NCEP") {
            run = "00Z";
            timeStr = "003";
            timeIdx = 1;
            param = "500_vort_ht";
            model = "GFS";
            sector = "NAMER";
            models = UtilityList.wrap(UtilityModelNcepInterface.models);
        } else if (prefModel == "WPCGEFS") {
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "capegt500";
            sector = "US";
            sectorInt = 0;
            model = "WPCGEFS";
            models = UtilityList.wrap({"WPCGEFS"});
        } else if (prefModel == "SPCHRRR") {
            prodIdx = 0;
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "sfcprec";
            model = "HRRR";
            models = UtilityList.wrap({"HRRR"});
            sector = "US";
        } else if (prefModel == "SPCHREF") {
            prodIdx = 0;
            run = "00Z";
            timeStr = "01";
            timeIdx = 1;
            param = "500wmean,500hmean";
            model = "HREF";
            models = UtilityList.wrap({"HREF"});
            sector = "CONUS";
        } else if (prefModel == "SPCSREF") {
            run = "00Z";
            timeStr = "03";
            timeIdx = 1;
            param = "SREFH5";
            model = "SREF";
            models = UtilityList.wrap({"SREF"});
            sector = "US";
        }
        getPrefs();
    }

    public void getPrefs() {
        model = Utility.readPref(prefModel, model);
        param = Utility.readPref(prefParam, param);
        sector = Utility.readPref(prefSector, sector);
        timeStr = Utility.readPref(prefRunPosn, timeStr);
        timeIdx = Utility.readPrefInt(prefRunPosnIdx, timeIdx);
    }

    public void writePrefs() {
        Utility.writePref(prefModel, model);
        Utility.writePref(prefParam, param);
        Utility.writePref(prefSector, sector);
        Utility.writePref(prefRunPosn, timeStr);
        Utility.writePrefInt(prefRunPosnIdx, timeIdx);
    }

    public void loadTimeList(int from, int to, int by) {
        foreach (var value in range3(from, to, by)) {
            times.add(Too.StringPadLeftZeros(value, 2));
        }
    }

    public void loadTimeList3(int from, int to, int by) {
        foreach (var value in range3(from, to, by)) {
            times.add(Too.StringPadLeftZeros(value, 3));
        }
    }

    public void loadRunList(int from, int to, int by) {
        foreach (var value in range3(from, to, by)) {
            runs.add(Too.StringPadLeftZeros(value, 2) + "Z");
        }
    }

    public void setModelVars(string modelName) {
        this.modelName = modelName;
        modelToken = prefModel + ":" + modelName;
        if (modelToken == "NSSLWRF:WRF") {
            paramCodes = UtilityList.wrap(UtilityModelNsslWrfInterface.paramsNsslWrf);
            paramLabels = UtilityList.wrap(UtilityModelNsslWrfInterface.labelsNsslWrf);
            sectors = UtilityList.wrap(UtilityModelNsslWrfInterface.sectorsLong);
            times.clear();
            loadTimeList(1, 36, 1);
        } else if (modelToken == "NSSLWRF:WRF_3KM") {
            paramCodes = UtilityList.wrap(UtilityModelNsslWrfInterface.paramsNsslWrf);
            paramLabels = UtilityList.wrap(UtilityModelNsslWrfInterface.labelsNsslWrf);
            sectors = UtilityList.wrap(UtilityModelNsslWrfInterface.sectorsLong);
            times.clear();
            loadTimeList(1, 36, 1);
        } else if (modelToken == "NSSLWRF:FV3") {
            paramCodes = UtilityList.wrap(UtilityModelNsslWrfInterface.paramsNsslFv3);
            paramLabels = UtilityList.wrap(UtilityModelNsslWrfInterface.labelsNsslFv3);
            sectors = UtilityList.wrap(UtilityModelNsslWrfInterface.sectorsLong);
            times.clear();
            loadTimeList(1, 60, 1);
        } else if (modelToken == "NSSLWRF:HRRRV3") {
            paramCodes = UtilityList.wrap(UtilityModelNsslWrfInterface.paramsNsslHrrrv3);
            paramLabels = UtilityList.wrap(UtilityModelNsslWrfInterface.labelsNsslHrrrv3);
            sectors = UtilityList.wrap(UtilityModelNsslWrfInterface.sectorsLong);
            times.clear();
            loadTimeList(1, 36, 1);
        } else if (modelToken == "ESRL:HRRR") {
            paramCodes = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrParams);
            paramLabels = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrLabels);
            sectors = UtilityList.wrap(UtilityModelEsrlInterface.sectorsHrrr);
            times.clear();
            loadTimeList(0, 36, 1);
        } else if (modelToken == "ESRL:HRRR_AK") {
            paramCodes = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrParams);
            paramLabels = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrLabels);
            sectors = UtilityList.wrap(UtilityModelEsrlInterface.sectorsHrrrAk);
            times.clear();
            loadTimeList(0, 36, 1);
        } else if (modelToken == "ESRL:HRRR_NCEP") {
            paramCodes = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrParams);
            paramLabels = UtilityList.wrap(UtilityModelEsrlInterface.modelHrrrLabels);
            sectors = UtilityList.wrap(UtilityModelEsrlInterface.sectorsHrrr);
            times.clear();
            loadTimeList(0, 36, 1);
        } else if (modelToken == "ESRL:RAP") {
            paramCodes = UtilityList.wrap(UtilityModelEsrlInterface.modelRapParams);
            paramLabels = UtilityList.wrap(UtilityModelEsrlInterface.modelRapLabels);
            sectors = UtilityList.wrap(UtilityModelEsrlInterface.sectorsRap);
            times.clear();
            loadTimeList(0, 21, 1);
        } else if (modelToken == "ESRL:RAP_NCEP") {
            paramCodes = UtilityList.wrap(UtilityModelEsrlInterface.modelRapParams);
            paramLabels = UtilityList.wrap(UtilityModelEsrlInterface.modelRapLabels);
            sectors = UtilityList.wrap(UtilityModelEsrlInterface.sectorsRap);
            times.clear();
            loadTimeList(0, 21, 1);
        } else if (modelToken == "GLCFS:GLCFS") {
            paramCodes = UtilityList.wrap(UtilityModelGlcfsInterface.paramCodes);
            paramLabels = UtilityList.wrap(UtilityModelGlcfsInterface.labels);
            sectors = UtilityList.wrap(UtilityModelGlcfsInterface.sectors);
            times.clear();
            loadTimeList(1, 13, 1);
            loadTimeList(15, 120, 3);
        } else if (modelToken == "NCEP:GFS") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsGfs);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsGfs);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsGfs);
            times.clear();
            loadTimeList3(0, 243, 3);
            loadTimeList3(252, 396, 12);
            setupListRunZ();
        } else if (modelToken == "NCEP:HRRR") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsHrrr);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsHrrr);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsHrrr);
            times.clear();
            loadTimeList3(0, 18, 1);
            runs.clear();
            loadRunList(0, 22, 1);
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:RAP") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsRap);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsRap);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsRap);
            times.clear();
            loadTimeList3(0, 21, 1);
            runs.clear();
            loadRunList(0, 22, 1);
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:NAM-HIRES") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsNamHires);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsNamHires);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsNamHires);
            times.clear();
            loadTimeList3(1, 61, 1);
            setupListRunZ();
        } else if (modelToken == "NCEP:NAM") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsNam);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsNam);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsNam);
            times.clear();
            loadTimeList3(0, 85, 3);
            setupListRunZ();
        } else if (modelToken == "NCEP:HRW-FV3") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.modelHrwFv3Params);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.modelHrwFv3Labels);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsHrwNmm);
            times.clear();
            loadTimeList3(1, 49, 1);
            loadTimeList3(51, 61, 3);
            runs.clear();
            runs.add("00Z");
            runs.add("12Z");
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:HRW-ARW") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsHrwNmm);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsHrwNmm);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsHrwNmm);
            times.clear();
            loadTimeList3(1, 48, 1);
            runs.clear();
            runs.add("00Z");
            runs.add("12Z");
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:HRW-ARW2") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsHrwArw2);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsHrwArw2);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsHrwArw2);
            times.clear();
            loadTimeList3(1, 48, 1);
            runs.clear();
            runs.add("00Z");
            runs.add("12Z");
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:NBM") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsNbm);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsNbm);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsNbm);
            times.clear();
            loadTimeList3(0, 264, 3);
            runs.clear();
            runs.add("00Z");
            runs.add("06Z");
            runs.add("12Z");
            runs.add("18Z");
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:GEFS-SPAG") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsGefsSpag);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsGefsSpag);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsGefsSpag);
            times.clear();
            loadTimeList3(0, 180, 6);
            loadTimeList3(192, 384, 12);
            setupListRunZ();
        } else if (modelToken == "NCEP:GEFS-MEAN-SPRD") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsGefsMnsprd);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsGefsMnsprd);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsGefsMnsprd);
            times.clear();
            loadTimeList3(0, 180, 6);
            loadTimeList3(192, 384, 12);
            setupListRunZ();
        } else if (modelToken == "NCEP:SREF") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsSref);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsSref);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsSref);
            times.clear();
            loadTimeList3(0, 87, 3);
            setupListRunZWithStart("03Z");
        } else if (modelToken == "NCEP:NAEFS") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsNaefs);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsNaefs);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsNaefs);
            times.clear();
            loadTimeList3(0, 384, 6);
            setupListRunZ();
        } else if (modelToken == "NCEP:POLAR") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsPolar);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsPolar);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsPolar);
            times.clear();
            loadTimeList3(0, 384, 24);
            runs.clear();
            runs.add("00Z");
            runTimeData.listRun = runs;
        } else if (modelToken == "NCEP:WW3") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsWw3);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsWw3);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsWw3);
            times.clear();
            loadTimeList3(0, 126, 6);
            setupListRunZ();
        } else if (modelToken == "NCEP:ESTOFS") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsEstofs);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsEstofs);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsEstofs);
            times.clear();
            loadTimeList3(0, 180, 1);
            setupListRunZ();
        } else if (modelToken == "NCEP:FIREWX") {
            paramCodes = UtilityList.wrap(UtilityModelNcepInterface.paramsFirefx);
            paramLabels = UtilityList.wrap(UtilityModelNcepInterface.labelsFirefx);
            sectors = UtilityList.wrap(UtilityModelNcepInterface.sectorsFirewx);
            times.clear();
            loadTimeList3(0, 37, 1);
            setupListRunZ();
        } else if (modelToken == "WPCGEFS:WPCGEFS") {
            paramCodes = UtilityList.wrap(UtilityModelWpcGefsInterface.paramCodes);
            paramLabels = UtilityList.wrap(UtilityModelWpcGefsInterface.labels);
            sectors = UtilityList.wrap(UtilityModelWpcGefsInterface.sectors);
            times.clear();
            loadTimeList3(0, 240, 6);
            runs = runTimeData.listRun;
        } else if (modelToken == "SPCHRRR:HRRR") {
            paramCodes = UtilityList.wrap(UtilityModelSpcHrrrInterface.paramCodes);
            paramLabels = UtilityList.wrap(UtilityModelSpcHrrrInterface.labels);
            sectors = UtilityList.wrap(UtilityModelSpcHrrrInterface.sectors);
            times.clear();
            loadTimeList(2, 15, 1);
            runs = runTimeData.listRun;
        } else if (modelToken == "SPCHREF:HREF") {
            paramCodes = UtilityList.wrap(UtilityModelSpcHrefInterface.paramCodes);
            paramLabels = UtilityList.wrap(UtilityModelSpcHrefInterface.labels);
            sectors = UtilityList.wrap(UtilityModelSpcHrefInterface.sectorsLong);
            times.clear();
            loadTimeList(1, 49, 1);
            runs = runTimeData.listRun;
        } else if (modelToken == "SPCSREF:SREF") {
            paramCodes = UtilityList.wrap(UtilityModelSpcSrefInterface.paramCodes);
            paramLabels = UtilityList.wrap(UtilityModelSpcSrefInterface.labels);
            sectors.clear();
            times.clear();
            loadTimeList3(0, 90, 3);
            runs = runTimeData.listRun;
        }
        if (!sectors.is_empty) {
            if (!sectors.contains(sector)) {
                sector = sectors[0];
            }
        }
        if (!paramCodes.contains(param)) {
            if (!paramCodes.is_empty) {
                param = paramCodes[0];
            }
        }
        if (timeIdx > times.size) {
            setTimeIdx(2);
        }
    }

    public void setupListRunZ() {
        runs.clear();
        runs.add("00Z");
        runs.add("06Z");
        runs.add("12Z");
        runs.add("18Z");
        runTimeData.listRun = runs;
    }

    public void setupListRunZWithStart(string start) {
        runs.clear();
        runs.add("03Z");
        runs.add("09Z");
        runs.add("15Z");
        runs.add("21Z");
        runTimeData.listRun = runs;
    }

    public void setTimeIdx(int timeIdxF) {
        if (timeIdxF > -2 && timeIdxF < times.size) {
            timeIdx = timeIdxF;
            timeStr = times[timeIdx];
        }
    }

    void timeIdxIncr() {
        timeIdx += 1;
        timeStr = Utility.safeGet(times, timeIdx);
    }

    void timeIdxDecr() {
        timeIdx -= 1;
        timeStr = Utility.safeGet(times, timeIdx);
    }

    public void leftClick() {
        if (timeIdx == 0) {
            setTimeIdx(times.size - 1);
        } else {
            timeIdxDecr();
        }
    }

    public void rightClick() {
        if (timeIdx == times.size - 1) {
            setTimeIdx(0);
        } else {
            timeIdxIncr();
        }
    }

    public void setTimeArr(int idx, string time) {
        times[idx] = time;
    }
}
