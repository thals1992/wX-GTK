// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SettingsLocationsBox : VBox {

    ArrayList<Button> buttons = new ArrayList<Button>();
    ArrayList<ObjectCardLocationItem> cards = new ArrayList<ObjectCardLocationItem>();
    ArrayList<HBox> boxes = new ArrayList<HBox>();

    public SettingsLocationsBox() {
        addLocations();
    }

    void addLocations() {
        foreach (var index in range(Location.getNumLocations())) {
            cards.add(new ObjectCardLocationItem(index));
            boxes.add(new HBox());

            buttons.add(new Button(Icon.Down, ""));
            buttons.last().connectInt(moveDownClicked, index);
            boxes.last().addWidget(buttons.last().get());

            buttons.add(new Button(Icon.Up, ""));
            buttons.last().connectInt(moveUpClicked, index);
            boxes.last().addWidget(buttons.last().get());

            buttons.add(new Button(Icon.Delete, "Delete"));
            buttons.last().connectInt(deleteLocation, index);
            boxes.last().addWidget(buttons.last().get());

            boxes.last().addWidget(cards.last().get());
            addLayout(boxes.last().get());
        }
    }

    public void refresh() {
        Location.setMainScreenComboBox();
        removeChildren();
        addLocations();
    }

    void deleteLocation(int locationIndex) {
        if (Location.getNumLocations() > 1) {
            Location.deleteLocation(Too.String(locationIndex + 1));
            refresh();
        }
    }

    void moveDownClicked(int position) {
        if (position < Location.getNumLocations() - 1) {
            var locA = new ObjectLocation(position);
            var locB = new ObjectLocation(position + 1);
            locA.saveToNewSlot(position + 1);
            locB.saveToNewSlot(position);
        } else {
            var locA = new ObjectLocation(position);
            var locB = new ObjectLocation(0);
            locA.saveToNewSlot(0);
            locB.saveToNewSlot(position);
        }
        refresh();
    }

    void moveUpClicked(int position) {
        if (position > 0) {
            var locA = new ObjectLocation(position - 1);
            var locB = new ObjectLocation(position);
            locA.saveToNewSlot(position);
            locB.saveToNewSlot(position - 1);
        } else {
            var locA = new ObjectLocation(Location.getNumLocations() - 1);
            var locB = new ObjectLocation(0);
            locA.saveToNewSlot(0);
            locB.saveToNewSlot(Location.getNumLocations() - 1);
        }
        refresh();
    }
}
