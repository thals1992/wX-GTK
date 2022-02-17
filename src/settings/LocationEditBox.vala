// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class LocationEditBox : HBox {

    Table table = new Table();
    Button saveButton = new Button(Icon.None, "Save");
    SearchEntry cityEdit = new SearchEntry();
    Entry editName = new Entry();
    Entry editLat = new Entry();
    Entry editLon = new Entry();
    Entry editNexrad = new Entry();
    VBox boxResults = new VBox();
    VBox box = new VBox();
    ArrayList<Button> buttons = new ArrayList<Button>();
    ArrayList<string> cities = new ArrayList<string>();

    public LocationEditBox() {
        Utility.recordAllSettings();

        cities = UtilityIO.rawFileToStringArrayFromResource(GlobalVariables.resDir + "cityall.txt");
        cityEdit.connect(textChanged);
        saveButton.connect(() => saveLocation(0));

        table.addRow("Enter City:", cityEdit.get());
        table.addRow("Name", editName.get());
        table.addRow("Latitude", editLat.get());
        table.addRow("Longitude", editLon.get());
        table.addRow("Nexrad", editNexrad.get());
        box.addLayout(table.get());
        box.addWidget(saveButton.get());

        foreach (var index in UtilityList.range(6)) {
            buttons.add(new Button(Icon.None, ""));
            boxResults.addWidget(buttons.last().get());
            buttons.last().connectInt(populateLabels, index);
        }
        addLayout(box.get());
        addLayout(boxResults.get());
        blankOutButtons();
    }

    void textChanged() {
        var text = cityEdit.getText();
        lookupSearchTerm(text);
    }

    void lookupSearchTerm(string text) {
        if (text.length > 3) {
            var citiesSelected = new ArrayList<string>();
            foreach (var city in cities) {
                if (city.ascii_down().has_prefix(text)) {
                    var tokens = city.split(",");
                    var latLon = new LatLon(tokens[1], tokens[2]);
                    var radar = UtilityLocation.getNearestRadarSites(latLon, 1, false)[0].name;
                    citiesSelected.add(city + " Radar: " + radar);
                }
            }
            foreach (var index in UtilityList.range(buttons.size)) {
                if (index < citiesSelected.size) {
                    buttons[index].setText(citiesSelected[index]);
                    buttons[index].setVisible(true);
                }
                if (index == 0) {
                    populateLabels(index);
                }
            }
        } else {
            blankOutButtons();
        }
    }

    void populateLabels(int index) {
        var city = buttons[index].getText();
        var tokens = city.split(",");
        var latLon = new LatLon(tokens[1], tokens[2]);
        var radar = UtilityLocation.getNearestRadarSites(latLon, 1, false)[0].name;
        editName.setText(tokens[0]);
        editLat.setText(tokens[1]);
        editLon.setText(tokens[2]);
        editNexrad.setText(radar);
    }

    void blankOutButtons() {
        editName.setText("");
        editLat.setText("");
        editLon.setText("");
        editNexrad.setText("");
        foreach (var index in UtilityList.range(buttons.size)) {
            buttons[index].setText("");
            buttons[index].setVisible(false);
        }
    }

    void saveLocation(int i) {
        var latLon = new LatLon(editLat.getText(), editLon.getText());
        var nameToSave = editName.getText();
        Location.save(latLon, nameToSave);
        Location.setMainScreenComboBox();
        blankOutButtons();
        cityEdit.setText("");
    }
}
