// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcStormReports : Window {

    HBox boxImage = new HBox();
    VBox box = new VBox();
    string url = "";
    string stormReportsUrl = "";
    string spcStormReportsDay = "";
    ArrayList<string> states = new ArrayList<string>();
    ArrayList<StormReport> stormReports = new ArrayList<StormReport>();
    ArrayList<VBox> cardWidgets = new ArrayList<VBox>();
    Photo photo = new Photo.normal();
    ComboBox comboBox = new ComboBox.empty();
    Calendar calendar = new Calendar();
    VBox boxText = new VBox();
    VBox boxCombo = new VBox();
    Button button = new Button(Icon.None, "LSR by WFO");

    public SpcStormReports(string day) {
        setTitle("SPC Storm Reports");
        maximize();
        spcStormReportsDay = day;
        url = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".gif";
        stormReportsUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".csv";
        calendar.connect(getData);
        boxImage.addWidget(photo.get());
        boxImage.addWidget(calendar.get());
        button.connect(() => new LsrByWfo());
        box.addLayout(boxImage.get());
        box.addLayout(boxCombo.get());
        box.addWidget(button.get());
        box.addLayout(boxText.get());
        new ScrolledWindow(this, box);
        reload();
    }

    void getData() {
        var year = calendar.year;
        var month = calendar.month + 1;
        var day = calendar.dayOfMonth;
        var dayStr = Too.StringPadLeftZeros(day, 2);
        var monthStr = Too.StringPadLeftZeros(month, 2);
        var yearStr = Too.String(year).substring(2, 2);
        spcStormReportsDay = yearStr + monthStr + dayStr;
        url = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + "_rpts.gif";
        stormReportsUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".csv";
        states.clear();
        stormReports.clear();
        reload();
    }

    void reload() {
        new FutureBytes(url, photo.setNoScale);
        new FutureText(stormReportsUrl, updateReports);
    }

    void updateReports(string html) {
        stormReports = UtilitySpcStormReports.process(html.split(GlobalVariables.newline));
        var rawStates = new ArrayList<string>();
        foreach (var stormReport in stormReports) {
            if (stormReport.damageHeader == "" && stormReport.state != "") {
                rawStates.add(stormReport.state);
            }
        }
        var uniqStates = UtilityList.removeDup(rawStates);
        var uniqStatesWithCount = new ArrayList<string>();
        foreach (var item in uniqStates) {
            uniqStatesWithCount.add(item + ": " + Too.String(UtilityList.count(rawStates, item)));
        }
        boxCombo.removeChildren();
        states.add("All");
        states.add_all(uniqStatesWithCount);
        comboBox = new ComboBox.fromList(states);
        comboBox.connect(filterReports);
        comboBox.setIndex(0);
        #if GTK4
            filterReports();
        #endif
        boxCombo.addWidget(comboBox.get());
    }

    void filterReports() {
        var index = comboBox.getIndex();
        if (index >= states.size || index == -1) {
            return;
        }
        var filter = states[index].split(":")[0];
        boxText.removeChildren();
        cardWidgets.clear();
        foreach (var stormReport in stormReports) {
            if (stormReport.damageHeader == "" && filter == "All") {
                boxText.addLayout(new ObjectCardStormReportItem(stormReport).get());
                boxText.addWidget(new ObjectDividerLine().get());
            } else if (stormReport.damageHeader == "" && stormReport.state == filter) {
                boxText.addLayout(new ObjectCardStormReportItem(stormReport).get());
                boxText.addWidget(new ObjectDividerLine().get());
            } else if (stormReport.damageHeader != "") {
                boxText.addLayout(new ObjectCardBlackHeaderText(stormReport.damageHeader).get());
                boxText.addWidget(new ObjectDividerLine().get());
            }
        }
        boxText.addStretch();
    }
}
