// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class RouteItem {

    public delegate void ConnectFn();
    public string iconString;
    public string toolTip;
    public unowned ConnectFn fn;

    public RouteItem(string iconString, string toolTip, ConnectFn fn) {
        this.iconString = iconString;
        this.toolTip = toolTip;
        this.fn = fn;
    }
}
