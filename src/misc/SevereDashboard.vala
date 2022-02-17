// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SevereDashboard : Window {

    public const int imagesAcross = 4;
    public ArrayList<string> urls = new ArrayList<string>();
    public ArrayList<Image> images = new ArrayList<Image>();
    public HashMap<PolygonType, SevereNotice> severeNotices = new HashMap<PolygonType, SevereNotice>();
    public HashMap<PolygonType, SevereWarning> warningsByType = new HashMap<PolygonType, SevereWarning>();
    public ArrayList<HBox> boxRows = new ArrayList<HBox>();
    public VBox boxImages = new VBox();
    public HashMap<PolygonType, VBox> boxWarnings = new HashMap<PolygonType, VBox>();
    public VBox box = new VBox();
    ScrolledWindow sw;

    public SevereDashboard() {
        setTitle("Severe Dashboard");
        maximize();

        severeNotices[PolygonType.watch] = new SevereNotice(PolygonType.watch);
        severeNotices[PolygonType.mcd] = new SevereNotice(PolygonType.mcd);
        severeNotices[PolygonType.mpd] = new SevereNotice(PolygonType.mpd);

        warningsByType[PolygonType.tor] = new SevereWarning(PolygonType.tor);
        warningsByType[PolygonType.tst] = new SevereWarning(PolygonType.tst);
        warningsByType[PolygonType.ffw] = new SevereWarning(PolygonType.ffw);

        boxWarnings[PolygonType.tor] = new VBox();
        boxWarnings[PolygonType.tst] = new VBox();
        boxWarnings[PolygonType.ffw] = new VBox();

        box.addLayout(boxImages.get());
        box.addLayout(boxWarnings[PolygonType.tor].get());
        box.addLayout(boxWarnings[PolygonType.tst].get());
        box.addLayout(boxWarnings[PolygonType.ffw].get());
        sw = new ScrolledWindow(this, box);

        new FutureVoid(() => downloadWarnings(PolygonType.tst), () => updateWarnings(PolygonType.tst));
        new FutureVoid(() => downloadWarnings(PolygonType.ffw), () => updateWarnings(PolygonType.ffw));
        new FutureVoid(() => downloadWarnings(PolygonType.tor), () => updateWarnings(PolygonType.tor));
        new FutureVoid(downloadWatch, updateWatch);
    }


    void downloadWarnings(PolygonType t) {
        warningsByType[t].download();
    }

    void updateWarnings(PolygonType t) {
        var label = new ObjectCardBlackHeaderText(warningsByType[t].getCount() + " " + warningsByType[t].getName());
        boxWarnings[t].addLayout(label.get());
        foreach (var w in warningsByType[t].warningList) {
            if (w.isCurrent) {
                var widget1 = new ObjectCardDashAlertItem(w);
                boxWarnings[t].addLayout(widget1.get());
                boxWarnings[t].addWidget(new ObjectDividerLine().get());
            }
        }
        updateStatusBar();
    }

    void downloadWatch() {
        urls.add(UtilityDownload.getImageProduct("USWARN"));
        urls.add(UtilityDownload.getImageProduct("STRPT"));

        foreach (var t in new PolygonType[]{PolygonType.mcd, PolygonType.mpd, PolygonType.watch}) {
            ObjectPolygonWatch.polygonDataByType[t].download();
            severeNotices[t].getBitmaps();
            foreach (var url in severeNotices[t].urls) {
                urls.add(url);
            }
        }
    }

    void updateWatch() {
        foreach (var index in UtilityList.range(urls.size)) {
            images.add(new Image.withIndex(index));
            images.last().setNumberAcross(imagesAcross);
        }
        foreach (var index in UtilityList.range(urls.size)) {
            images[index].connect(launch);
            if (boxRows.size <= (int)(index / imagesAcross)) {
                boxRows.add(new HBox());
            }
            boxRows.last().addWidget(images[index].get());
        }
        foreach (var b in boxRows) {
            boxImages.addLayout(b.get());
        }
        updateStatusBar();
        show();
        foreach (var index in UtilityList.range(urls.size)) {
            var url = urls[index];
            new FutureBytes(url, images[index].setBytes);
        }
    }

    void launch(int indexFinal) {
        if (indexFinal == 0) {
            new UsAlerts();
        } else if (indexFinal == 1) {
            new SpcStormReports("today");
        } else if (indexFinal > 1) {
            new SpcMcdWatchMpdViewer(urls[indexFinal]);
        }
    }

    void updateStatusBar() {
        var statusTotal = "";
        var col1 = new PolygonType[]{PolygonType.mcd, PolygonType.watch, PolygonType.mpd};
        foreach (var t in col1) {
            statusTotal += "  " + severeNotices[t].getShortName() + ": " + severeNotices[t].getCount();
        }
        foreach (var t in warningsByType.keys) {
            statusTotal += "  " + warningsByType[t].getShortName() + ": " + warningsByType[t].getCount();
        }
        setTitle(statusTotal);
    }
}
