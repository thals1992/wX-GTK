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
        cityEdit.connect(() => lookupSearchTerm(cityEdit.text));
        saveButton.connect(() => saveLocation(0));

        table.addRow("Enter City:", cityEdit);
        table.addRow("Name", editName);
        table.addRow("Latitude", editLat);
        table.addRow("Longitude", editLon);
        table.addRow("Nexrad", editNexrad);
        box.addWidget(table);
        box.addWidget(saveButton);

        foreach (var index in range(6)) {
            buttons.add(new Button(Icon.None, ""));
            boxResults.addWidget(buttons.last());
            buttons.last().connectInt(populateLabels, index);
        }
        addLayout(box);
        addLayout(boxResults);
        blankOutButtons();
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
            foreach (var index in range(buttons.size)) {
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
        editName.text = tokens[0];
        editLat.text = tokens[1];
        editLon.text = tokens[2];
        editNexrad.text = radar;
    }

    void blankOutButtons() {
        editName.text = "";
        editLat.text = "";
        editLon.text = "";
        editNexrad.text = "";
        foreach (var index in range(buttons.size)) {
            buttons[index].setText("");
            buttons[index].setVisible(false);
        }
    }

    void saveLocation(int i) {
        var latLon = new LatLon(editLat.text, editLon.text);
        var nameToSave = editName.text;
        Location.save(latLon, nameToSave);
        Location.setMainScreenComboBox();
        blankOutButtons();
        cityEdit.text = "";
    }
}
