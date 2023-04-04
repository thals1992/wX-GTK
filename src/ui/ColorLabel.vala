// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ColorLabel : HBox {

    Text text = new Text();
    WXColor color;
    Gtk.ColorButton colorButton;

    public ColorLabel(WXColor color) {
        this.color = color;
        colorButton = new Gtk.ColorButton.with_rgba(color.getRGBA());
        colorButton.color_set.connect(() => color.setValue(colorButton.get_rgba()));

        text.setText(color.uiLabel);
        text.setBold();
        text.setWordWrap(false);
        text.get().set_margin_start(10);

        addWidgetReal(colorButton);
        addWidget(text);
    }
}
