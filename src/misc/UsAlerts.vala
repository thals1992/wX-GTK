// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UsAlerts : Window {

    ComboBox comboBox;
    VBox box = new VBox();
    VBox boxCombo = new VBox();
    VBox boxText = new VBox();
    Photo photo = new Photo.normal();
    ArrayList<CapAlertXml> capAlerts = new ArrayList<CapAlertXml>();
    ArrayList<string> defaultFilter = UtilityList.wrap({"Tornado Warning", "Severe Thunderstorm Warning", "Flash Flood Warning"});
    ArrayList<string> eventList = new ArrayList<string>();
    HashMap<string, int> filterCount = new HashMap<string, int>();
    string url = "https://forecast.weather.gov/wwamap/png/US.png";
    string html = "";

    public UsAlerts() {
        setTitle("US Alerts");
        maximize();

        box.addLayout(boxCombo);
        box.addWidgetAndCenter1(photo);
        box.addLayout(boxText);

        new ScrolledWindow(this, box);
        new FutureBytes(url, photo.setBytes);
        new FutureVoid(() => html = UtilityDownloadNws.getCap("us"), update);
    }

    void update() {
        var alerts = UtilityString.parseColumn(html, "<entry>(.*?)</entry>");
        var rawEvents = new ArrayList<string>();
        foreach (var alert in alerts) {
            capAlerts.add(new CapAlertXml(alert));
        }
        foreach (var cap in capAlerts) {
            rawEvents.add(cap.event1);
            if (filterCount.has_key(cap.event1)) {
                filterCount[cap.event1] += 1;
            } else {
                filterCount[cap.event1] = 1;
            }
            if (defaultFilter.contains(cap.event1)) {
                boxText.addLayout(new CardAlertDetail(cap));
            }
        }
        var uniqEvents = UtilityList.removeDup(rawEvents);
        eventList.add("Tor/Ffw/Tst");
        foreach (var item in uniqEvents) {
            eventList.add(item + ": " + Too.String(UtilityList.count(rawEvents, item)));
        }
        setTitle("US Alerts: " + Too.String(capAlerts.size));
        comboBox = new ComboBox.fromList(eventList);
        comboBox.setIndex(0);
        comboBox.connect(() => filterEvents(comboBox.getIndex()));
        boxCombo.addWidget(comboBox);
    }

    void filterEvents(int index) {
        boxText.removeChildren();
        var filter = eventList[index].split(":")[0];
        if (index == 0) {
            filter = ":" + join(defaultFilter, ":");
            foreach (var cap in capAlerts) {
                if (filter.contains(":" + cap.event1 + ":")) {
                    boxText.addLayout(new CardAlertDetail(cap));
                }
            }
        } else {
            foreach (var cap in capAlerts) {
                if (cap.event1 == filter) {
                    boxText.addLayout(new CardAlertDetail(cap));
                }
            }
        }
    }
}
