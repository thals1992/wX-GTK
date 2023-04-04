// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradColorLegend : DrawingArea {

    string product;
    int color = 0;
    int screenHeight = 400;

    public NexradColorLegend(string product) {
        this.product = product;
        setSizeRequest(32, this.screenHeight);
        connect(drawFunc);
    }

    void drawRect(Cairo.Context painter, float x, float y, float width, float height) {
        Color.setCairoColor(painter, color);
        painter.set_line_width(1.0);
        painter.rectangle(x, y, width, height + 1.0);
        painter.fill();
        painter.stroke();
    }

    void drawText(Cairo.Context painter, string stringValue, float x, float y) {
        painter.set_font_size(12.0);
        painter.move_to(x, y);
        painter.set_source_rgb(1.0, 1.0, 1.0);
        painter.show_text(stringValue);
    }

    int setColor(int red, int green, int blue) {
        return Color.rgb(red, green, blue);
    }

    void setColorWithBuffers(int prodId, int index) {
        color = setColor(
            ColorPalette.colorMap[prodId].redValues.getByIndex(index),
            ColorPalette.colorMap[prodId].greenValues.getByIndex(index),
            ColorPalette.colorMap[prodId].blueValues.getByIndex(index));
    }

    public void update(string product) {
        this.product = product.split(":")[0];
        draw();
    }

    #if GTK4
    public void drawFunc(Gtk.DrawingArea da, Cairo.Context painter, int w, int h) {
    #else
    public bool drawFunc(Cairo.Context painter) {
    #endif
        var width = (int)width;
        var height = (int)height;
        screenHeight = height;
        var units = "";
        var startHeight = -20.0f;
        var widthStarting = 0.0f;
        var textFromLegend = 10.0f;
        var heightFudge = 0.0f;
        var scaledHeight = height / 256.0f;
        var scaleFudge = 1.45f;
        var scaledHeightText = ((screenHeight - scaleFudge * startHeight) / (95.0f + 32.0f));
        var scaledHeightVel = ((screenHeight - scaleFudge * startHeight) / (127.0f * 2.0f));
        var unitsDrawn = false;
        if (product == "N0Q" || product == "L2REF" || product == "TZL") {
            foreach (var index in range(256)) {
                setColorWithBuffers(94, 255 - index);
                drawRect(
                    painter,
                    widthStarting,                      // x
                    index * scaledHeight + startHeight, // y
                    width + widthStarting,              // width
                    scaledHeight + 1.0f);               // height
            }
            units = " dBZ";
            for (int index = 96; index > 1; index--) {
                if (index % 10 == 0) {
                    drawText(painter,
                        Too.String(index) + units,
                        widthStarting + textFromLegend,
                        (scaledHeightText * ((95) - (index))) + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "N0U" || product == "L2VEL" || product == "TV0") {
            foreach (var index in range(256)) {
                setColorWithBuffers(99, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " KT";
            for (int index = 123; index > -131; index--) {
                if (index % 10 == 0) {
                    drawText(
                        painter,
                        Too.String(index) + units,
                        widthStarting + textFromLegend,
                        (scaledHeightVel * (122.0f - (index))) + heightFudge + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "DVL") {
            foreach (var index in range(256)) {
                setColorWithBuffers(134, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " kg/m2";
            for (int index = 71; index > -1; index--) {
                if (index % 5 == 0) {
                    drawText(
                        painter,
                        Too.String(index) + units,
                        widthStarting + textFromLegend,
                        (3.64f * scaledHeightVel * (70.0f - index)) + heightFudge + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "EET") {
            scaledHeight = ((screenHeight - 1.45f * startHeight) / 70.0f);
            foreach (var index in range(71)) {
                setColorWithBuffers(135, 70 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " K FT";
            for (int index = 71; index > 1; index--) {
                if (index % 5 == 0) {
                    drawText(
                        painter,
                        Too.String(index) + units,
                        widthStarting + textFromLegend,
                        (3.64f * scaledHeightVel * (70.0f - index)) + heightFudge + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "N0X") {
            foreach (var index in range(256)) {
                setColorWithBuffers(159, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " dB";
            for (int index = 8; index >= -7; index--) {
                drawText(
                    painter,
                    Too.String(index) + units,
                    widthStarting + textFromLegend,
                    (16 * scaledHeightVel * (8.0f - index)) + heightFudge + startHeight);
                if (!unitsDrawn) {
                    unitsDrawn = true;
                    units = "";
                }
            }
        } else if (product == "N0C") {
            foreach (var index in range(256)) {
                setColorWithBuffers(161, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " CC";
            for (int index = 101; index >= 0; index--) {
                if (index % 5 == 0) {
                    string tmpStr = Too.StringD(index / 100.0);
                    drawText(
                        painter,
                        tmpStr + units,
                        widthStarting + textFromLegend,
                        (3.0f * scaledHeightVel * (100.0f - index)) + heightFudge + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "N0K") {
            foreach (var index in range(256)) {
                setColorWithBuffers(163, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " PHAS";
            for (int index = 11; index >= -1; index--) {
                drawText(
                    painter,
                    Too.String(index) + units,
                    widthStarting + textFromLegend,
                    (20.0f * scaledHeightVel * (10.0f - index)) + heightFudge + startHeight);
                if (!unitsDrawn) {
                    unitsDrawn = true;
                    units = "";
                }
            }
        } else if (product == "H0C") {
            scaledHeight = (screenHeight - 2.0f * startHeight) / 160.0f;
            const string[] labels = {"ND", "BI", "GC", "IC", "DS", "WS", "RA", "HR", "BD", "GR", "HA", "", "", "", "UK", "RF"};
            foreach (var index in range(160)) {
                setColorWithBuffers(165, 160 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = "";
            for (int index = 159; index >= 0; index--) {
                if (index % 10 == 0) {
                    drawText(
                        painter,
                        labels[(int)(index / 10)] + units,
                        widthStarting + textFromLegend,
                        (scaledHeight * (159.0f - index)) + startHeight);
                    if (!unitsDrawn) {
                        unitsDrawn = true;
                        units = "";
                    }
                }
            }
        } else if (product == "DSP") {
            foreach (var index in range(256)) {
                setColorWithBuffers(172, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " IN";
            var j = NexradUtil.wxoglDspLegendMax;
            while (j > 0) {
                var xVar = widthStarting + width + textFromLegend;
                var yVar1 = (255.0f / NexradUtil.wxoglDspLegendMax) * scaledHeightVel * (NexradUtil.wxoglDspLegendMax - j);
                var yVar = yVar1 + heightFudge + startHeight;
                drawText(painter, Too.StringF(j) + units, xVar, yVar);
                if (!unitsDrawn) {
                    unitsDrawn = true;
                    units = "";
                }
                j -= NexradUtil.wxoglDspLegendMax / 16.0f;
            }
        } else if (product == "DAA") {
            foreach (var index in range(256)) {
                setColorWithBuffers(172, 255 - index);
                drawRect(
                    painter,
                    widthStarting,
                    index * scaledHeight + startHeight,
                    width + widthStarting,
                    scaledHeight);
            }
            units = " IN";
            var j = NexradUtil.wxoglDspLegendMax;
            while (j > 0) {
                var xVar = widthStarting + width + textFromLegend;
                var yVar1 = (255.0f / NexradUtil.wxoglDspLegendMax) * scaledHeightVel * (NexradUtil.wxoglDspLegendMax - j);
                var yVar = yVar1 + heightFudge + startHeight;
                drawText(painter, Too.StringF(j) + units, xVar, yVar);
                if (!unitsDrawn) {
                    unitsDrawn = true;
                    units = "";
                }
                j -= NexradUtil.wxoglDspLegendMax / 16.0f;
            }
        }
        #if GTK4
        #else
            return false;
        #endif
    }
}
