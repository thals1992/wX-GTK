// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class LsrByWfo : Window {

    ComboBox comboboxSector = new ComboBox(GlobalArrays.wfos);
    VBox box = new VBox();
    HBox boxH = new HBox();
    ArrayList<string> lsrList = new ArrayList<string>();
    string wfo = "";

    public LsrByWfo() {
        setTitle("Local Storm Reports by Office");
        maximize();
        wfo = Location.office();

        comboboxSector.setIndexByValue(wfo);
        comboboxSector.connect(changeSector);

        boxH.addWidget(comboboxSector.get());
        box.addLayout(boxH.get());
        new ScrolledWindow(this, box);
        reload();
    }

    void changeSector() {
        wfo = comboboxSector.getValue().split(":")[0];
        reload();
    }

    void reload() {
        new FutureVoid(getLsrFromWfo, update);
    }

    void getLsrFromWfo() {
        lsrList.clear();
        var url = "https://forecast.weather.gov/product.php?site=" + wfo + "&issuedby=" + wfo + "&product=LSR&format=txt&version=1&glossary=0";
        var html = UtilityIO.getHtml(url);
        var numberLSR = UtilityString.parseLastMatch(html, "product=LSR&format=TXT&version=(.*?)&glossary");
        if (numberLSR == "") {
            lsrList.add("None issued by this office recently.");
        } else {
            var maxVers = Too.Int(numberLSR);
            if (maxVers > 30) {
                maxVers = 30;
            }
            foreach (var version in range3(1, maxVers, 2)) {
                lsrList.add(UtilityDownload.getTextProductWithVersion("LSR" + wfo, version));
            }
        }
    }

    void update() {
        box.removeChildren();
        box.addLayout(boxH.get());
        foreach (var lsr in lsrList) {
            var text = new Text();
            text.setFixedWidth();
            text.setText(lsr);
            box.addWidget(text.get());
            box.addWidget(new ObjectDividerLine().get());
        }
    }
}
