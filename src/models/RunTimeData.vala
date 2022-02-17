// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class RunTimeData {

    public ArrayList<string> listRun = new ArrayList<string>();
    public string mostRecentRun = "";
    public int imageCompleteInt = 0;
    public string imageCompleteStr = "";
    public string timeStringConversion = "";
    public string validTime = "";

    public void appendListRun(string value) {
        listRun.add(value);
    }

    public void appendListRunWithList(ArrayList<string> values) {
        listRun.add_all(values);
    }
}
