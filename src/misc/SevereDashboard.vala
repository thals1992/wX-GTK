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

        severeNotices[PolygonType.Watch] = new SevereNotice(PolygonType.Watch);
        severeNotices[PolygonType.Mcd] = new SevereNotice(PolygonType.Mcd);
        severeNotices[PolygonType.Mpd] = new SevereNotice(PolygonType.Mpd);

        warningsByType[PolygonType.Tor] = new SevereWarning(PolygonType.Tor);
        warningsByType[PolygonType.Tst] = new SevereWarning(PolygonType.Tst);
        warningsByType[PolygonType.Ffw] = new SevereWarning(PolygonType.Ffw);

        boxWarnings[PolygonType.Tor] = new VBox();
        boxWarnings[PolygonType.Tst] = new VBox();
        boxWarnings[PolygonType.Ffw] = new VBox();

        box.addLayout(boxImages);
        box.addLayout(boxWarnings[PolygonType.Tor]);
        box.addLayout(boxWarnings[PolygonType.Tst]);
        box.addLayout(boxWarnings[PolygonType.Ffw]);
        sw = new ScrolledWindow(this, box);

        new FutureVoid(() => downloadWarnings(PolygonType.Tst), () => updateWarnings(PolygonType.Tst));
        new FutureVoid(() => downloadWarnings(PolygonType.Ffw), () => updateWarnings(PolygonType.Ffw));
        new FutureVoid(() => downloadWarnings(PolygonType.Tor), () => updateWarnings(PolygonType.Tor));
        new FutureVoid(downloadWatch, updateWatch);
    }


    void downloadWarnings(PolygonType t) {
        warningsByType[t].download();
    }

    void updateWarnings(PolygonType t) {
        if (warningsByType[t].getCountInt() > 0) {
            var label = new CardBlackHeaderText(warningsByType[t].getCount() + " " + warningsByType[t].getName());
            boxWarnings[t].addLayout(label);
            foreach (var w in warningsByType[t].warningList) {
                if (w.isCurrent) {
                    var widget1 = new CardDashAlertItem(w);
                    boxWarnings[t].addLayout(widget1);
                    boxWarnings[t].addWidget(new DividerLine());
                }
            }
            updateStatusBar();
        }
    }

    void downloadWatch() {
        urls.add(DownloadImage.byProduct("USWARN"));
        urls.add(DownloadImage.byProduct("STRPT"));

        foreach (var t in new PolygonType[]{PolygonType.Mcd, PolygonType.Mpd, PolygonType.Watch}) {
            PolygonWatch.byType[t].download();
            severeNotices[t].getBitmaps();
            // TODO FIXME
            foreach (var url in severeNotices[t].urls) {
                urls.add(url);
            }
        }
    }

    void updateWatch() {
        foreach (var index in range(urls.size)) {
            images.add(new Image.withIndex(index));
            images.last().setNumberAcross(imagesAcross);
        }
        foreach (var index in range(urls.size)) {
            images[index].connect(launch);
            if (boxRows.size <= (int)(index / imagesAcross)) {
                boxRows.add(new HBox());
            }
            boxRows.last().addWidget(images[index]);
        }
        foreach (var b in boxRows) {
            boxImages.addLayout(b);
        }
        updateStatusBar();
        show();
        foreach (var index in range(urls.size)) {
            new FutureBytes(urls[index], images[index].setBytes);
        }
    }

    void launch(int indexFinal) {
        if (indexFinal == 0) {
            new UsAlerts();
        } else if (indexFinal == 1) {
            new SpcStormReports("today");
        } else {
            new SpcMcdWatchMpdViewer(urls[indexFinal]);
        }
    }

    void updateStatusBar() {
        var statusTotal = "";
        var col1 = new PolygonType[]{PolygonType.Mcd, PolygonType.Watch, PolygonType.Mpd};
        foreach (var t in col1) {
            if (severeNotices[t].getCountInt() > 0) {
                statusTotal += "  " + severeNotices[t].getShortName() + ": " + severeNotices[t].getCount();
            }
        }
        foreach (var t in warningsByType.keys) {
            if (warningsByType[t].getCountInt() > 0) {
                statusTotal += "  " + warningsByType[t].getShortName() + ": " + warningsByType[t].getCount();
            }
        }
        setTitle(statusTotal);
    }
}
