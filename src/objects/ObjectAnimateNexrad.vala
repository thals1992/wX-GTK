// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class ObjectAnimateNexrad {

    public delegate void FnDownloadData();
    int frameCount;
    int animationSpeed;
    ArrayList<NexradWidget> nexradList;
    ButtonToggle animateButton;
    unowned FnDownloadData downloadFn;
    Timer timeLine;
    ComboBox comboboxAnimCount;
    ComboBox comboboxAnimSpeed;

    public ObjectAnimateNexrad(ArrayList<NexradWidget> nexradList, ButtonToggle animateButton, ComboBox comboboxAnimCount, ComboBox comboboxAnimSpeed, FnDownloadData downloadFn) {
        this.animationSpeed = 1500;
        this.frameCount = 10;
        this.nexradList = nexradList;
        this.animateButton = animateButton;
        this.comboboxAnimCount = comboboxAnimCount;
        this.comboboxAnimSpeed = comboboxAnimSpeed;
        this.downloadFn = downloadFn;
        this.timeLine = new Timer(this.animationSpeed, this.frameCount, loadAnimationFrame);
    }

    public void animateClicked() {
        if (!timeLine.isRunning()) {
            frameCount = Too.Int(comboboxAnimCount.getValue());
            animationSpeed = Too.Int(comboboxAnimSpeed.getValue());
            downloadFrames();
            timeLine.setCount(frameCount);
            timeLine.setSpeed(animationSpeed);
            timeLine.start();
        } else {
            stopAnimate();
        }
    }

    public bool isAnimating() {
        return timeLine.isRunning();
    }

    public void stopAnimateNoDownload() {
        foreach (var nw in nexradList) {
            nw.nexradState.levelDataList.clear();
        }
        if (timeLine.isRunning()) {
            timeLine.stop();
        }
    }

    public void stopAnimate() {
        foreach (var nw in nexradList) {
            nw.nexradState.levelDataList.clear();
        }
        if (timeLine.isRunning()) {
            downloadFn();
            timeLine.stop();
        }
    }

    void downloadFrames() {
        foreach (var nw in nexradList) {
            WXGLDownload.getRadarFilesForAnimation(frameCount, nw.nexradState.radarProduct, nw.nexradState.radarSite, nw.fileStorage);
            nw.nexradState.levelDataList.clear();
            nw.nexradState.processAnimationFiles(frameCount, nw.fileStorage);
        }
    }

    void loadAnimationFrame(int index) {
        print(Too.String(index) + "\n");
        foreach (var nw in nexradList) {
            nw.downloadDataForAnimation(index);
        }
        foreach (var nw in nexradList) {
            nw.update();
        }
    }

    public void setAnimationCount() {
        Utility.writePrefInt("NEXRAD_ANIM_FRAME_COUNT", comboboxAnimCount.getIndex());
    }

    public void setAnimationSpeed() {
        Utility.writePrefInt("NEXRAD_ANIM_SPEED", comboboxAnimSpeed.getIndex());
    }
}
