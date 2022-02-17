// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class TextViewMetal {

    public string text = "";
    public int xPos = 0;
    public int yPos = 0;
    public const float fontSize = 14.0f;

    public void setText(string text) {
        this.text = text;
    }

    public void setPadding(double xPos, double yPos) {
        this.xPos = (int)xPos;
        this.yPos = (int)yPos;
    }
}
