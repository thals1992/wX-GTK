// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class RouteItem {

    public string iconString;
    public string toolTip;
    public unowned FnVoid fn;

    public RouteItem(string iconString, string toolTip, FnVoid fn) {
        this.iconString = iconString;
        this.toolTip = toolTip;
        this.fn = fn;
    }
}
