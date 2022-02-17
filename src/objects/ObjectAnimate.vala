// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectAnimate {

    public delegate string[] DelegateType(string a, string b, int c);
    public delegate void DelegateType2();
    public string product = "";
    public string sector = "";
    public int frameCount;
    ArrayList<WByteArray> animationFrames = new ArrayList<WByteArray>();
    int animationSpeed;
    Photo photo;
    ButtonToggle button;
    public unowned DelegateType getFunction;
    unowned DelegateType2 downloadFunction;
    Timer timeLine;

    public ObjectAnimate(Photo photo, DelegateType getFunction, DelegateType2 downloadFunction, ButtonToggle button) {
        this.animationSpeed = 500;
        this.frameCount = 12;
        this.photo = photo;
        this.getFunction = getFunction;
        this.downloadFunction = downloadFunction;
        this.button = button;
        this.timeLine = new Timer(this.animationSpeed, this.frameCount, updateImage);
    }

    void updateImage(int index) {
        print(Too.String(index) + " ");
        photo.setBytes(animationFrames[index].data);
    }

    public void animateClicked() {
        if (!timeLine.isRunning()) {
            var urls = getFunction(product, sector, frameCount);
            downloadFrames(urls);
            timeLine.setCount(urls.length);
            timeLine.start();
        } else {
            stopAnimate();
        }
    }

    void downloadFrames(string[] urls) {
        var dpb = new DownloadParallelBytes(urls);
        animationFrames = dpb.byteList;
    }

    public void stopAnimate() {
        if (timeLine.isRunning()) {
            timeLine.stop();
            downloadFunction();
        }
    }
}
