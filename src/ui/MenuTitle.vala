// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class MenuTitle {

    Gee.List<string> items;
    public string title;
    public int count;

    public MenuTitle(string title, int count) {
        this.title = title;
        this.count = count;
    }

    public void setList(string[] items, int index) {
        var tmpList = UtilityList.wrap(items);
        this.items = tmpList.slice(index, index + count);
    }

    public Gee.List<string> get() { return items; }
}
