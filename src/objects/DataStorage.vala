// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class DataStorage {

    string preference;
    string storedValue = "";

    public DataStorage(string preference) {
        this.preference = preference;
    }

    // update in memory value from what is on disk
    public void update() {
        storedValue = Utility.readPref(preference, "");
    }

    public string getValue() {
        return storedValue;
    }

    public void setValue(string value) {
        storedValue = value;
        Utility.writePref(preference, storedValue);
    }
}
