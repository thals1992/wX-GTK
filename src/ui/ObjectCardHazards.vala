// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectCardHazards : HBox {

    VBox box = new VBox();
    ArrayList<Button> buttons = new ArrayList<Button>();

    public ObjectCardHazards(ObjectHazards objectHazards) {
        var ids = UtilityString.parseColumn(objectHazards.data, "\"id\": \"(http.*?)\"");
        var hazards = UtilityString.parseColumn(objectHazards.data, "\"event\": \"(.*?)\"");
        var index = 0;
        foreach (var hazard in hazards) {
            buttons.add(new Button(Icon.None, hazard));
            buttons.last().connectString((u) => new AlertsDetail(u), ids[index]);
            box.addWidget(buttons.last().get());
            index += 1;
        }
        addLayout(box.get());
    }
}
