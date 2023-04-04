// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ModelViewer : Window {

    Photo photo = new Photo.fullScreen();
    ObjectModel modelObj;
    ComboBox comboboxTime = new ComboBox.empty();
    ComboBox comboboxModel = new ComboBox.empty();
    ComboBox comboboxRun = new ComboBox.empty();
    ComboBox comboboxProduct = new ComboBox.empty();
    ComboBox comboboxSector = new ComboBox.empty();
    VBox box = new VBox();
    HBox boxH = new HBox();
    Button leftButton = new Button(Icon.Left, "Back");
    Button rightButton = new Button(Icon.Right, "Forward");

    public ModelViewer(string modelType) {
        setTitle("Model Viewer");
        maximize();

        modelObj = new ObjectModel(modelType);
        modelObj.setModelVars(modelObj.model);
        photo.setWindow(this);

        comboboxModel = new ComboBox.fromList(modelObj.models);
        comboboxModel.connect(changeModelCb);
        comboboxRun.connect(changeRunCb);
        comboboxSector.connect(changeSectorCb);
        comboboxProduct.connect(changeProductCb);
        comboboxTime.connect(changeTimeCb);

        leftButton.connect(moveLeftClicked);
        rightButton.connect(moveRightClicked);

        boxH.addWidget(comboboxModel);
        boxH.addWidget(comboboxRun);
        boxH.addWidget(comboboxSector);
        boxH.addWidget(comboboxProduct);
        boxH.addWidget(comboboxTime);
        boxH.addWidget(leftButton);
        boxH.addWidget(rightButton);
        box.addLayout(boxH);
        box.addWidgetAndCenter1(photo);
        box.getAndShow(this);
        getRun();
    }

    void changeModelCb() {
        if (comboboxModel.getIndex() != -1) {
            changeModel(comboboxModel.getIndex());
        }
    }

    void changeRunCb() {
        if (comboboxRun.getIndex() != -1) {
            changeRun(comboboxRun.getIndex());
        }
    }

    void changeSectorCb() {
        if (comboboxSector.getIndex() != -1) {
            changeSector(comboboxSector.getIndex());
        }
    }

    void changeProductCb() {
        if (comboboxProduct.getIndex() != -1) {
            changeParam(comboboxProduct.getIndex());
        }
    }

    void changeTimeCb() {
        if (comboboxTime.getIndex() != -1) {
            changeTime(comboboxTime.getIndex());
        }
    }

    void reload() {
        var url = ObjectModelGet.getImageUrl(modelObj);
        modelObj.writePrefs();
        new FutureBytes(url, photo.setBytes);

    }

    void changeModel(int index) {
        modelObj.model = modelObj.models[index];
        modelObj.setModelVars(modelObj.model);
        getRun();
    }

    void changeParam(int index) {
        modelObj.param = modelObj.paramCodes[index];
        reload();
    }

    void changeSector(int index) {
        modelObj.sector = modelObj.sectors[index];
        reload();
    }

    void changeRun(int index) {
        modelObj.run = modelObj.runs[index];
        reload();
    }

    void changeTime(int index) {
        modelObj.setTimeIdx(index);
        reload();
    }

    void moveLeftClicked() {
        modelObj.leftClick();
        comboboxTime.setIndex(modelObj.timeIdx);
    }

    void moveRightClicked() {
        modelObj.rightClick();
        comboboxTime.setIndex(modelObj.timeIdx);
    }

    void getRun() {
        new FutureVoid(getRunStatus, updateRunStatus);
    }

    void getRunStatus() {
        ObjectModelGet.getRunStatus(modelObj);
        modelObj.run = modelObj.runTimeData.mostRecentRun;
    }

    void updateRunStatus() {
        comboboxTime.block();
        comboboxRun.block();
        comboboxSector.block();
        comboboxProduct.block();
        comboboxModel.block();
        comboboxTime.setArrayList(modelObj.times);
        if (modelObj.model == "GLCFS") {
            print("");
        } else if (modelObj.model != "SREF" && modelObj.model != "HRRR" && modelObj.model != "HREF" && modelObj.model != "ESRL") {
            foreach (var index in range(modelObj.times.size)) {
                var timeStr = modelObj.times[index];
                var newValue = timeStr.split(" ")[0] + " " + UtilityModels.convertTimeRuntoTimeString(modelObj.runTimeData.timeStringConversion.replace("Z", ""), timeStr.split(" ")[0]);
                modelObj.setTimeArr(index, newValue);
            }
        } else if (modelObj.prefModel == "SPCHRRR" || modelObj.prefModel == "SPCSREF" || modelObj.prefModel == "ESRL") {
            modelObj.runs = modelObj.runTimeData.listRun;
            modelObj.times = UtilityModels.updateTime(UtilityString.getLastXChars(modelObj.run, 2), modelObj.run, modelObj.times, "");
        } else {
            modelObj.runs = modelObj.runTimeData.listRun;
            modelObj.times = UtilityModels.updateTime(UtilityString.getLastXChars(modelObj.run, 3), modelObj.run, modelObj.times, "");
        }
        comboboxModel.setIndexByValue(modelObj.model);

        comboboxSector.setArrayList(modelObj.sectors);
        comboboxSector.setIndexByValue(modelObj.sector);

        comboboxRun.setArrayList(modelObj.runs);
        comboboxRun.setIndexByValue(modelObj.run);

        comboboxProduct.setArrayList(modelObj.paramLabels);
        var paramIndex = findex(modelObj.param, modelObj.paramCodes.to_array());
        comboboxProduct.setIndex(paramIndex);

        comboboxTime.setArrayList(modelObj.times);
        comboboxTime.setIndexByValue(modelObj.getTime());

        comboboxTime.unblock();
        comboboxRun.unblock();
        comboboxSector.unblock();
        comboboxProduct.unblock();
        comboboxModel.unblock();
        reload();
    }
}
