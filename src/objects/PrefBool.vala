// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class PrefBool {

    public string label;
    public string prefToken;
    public bool enabledByDefault;

    public PrefBool(string label, string prefToken, bool enabledByDefault) {
        this.label = label;
        this.prefToken = prefToken;
        this.enabledByDefault = enabledByDefault;
    }

    public bool isEnabled() {
        return Utility.readPref(prefToken, enabledByDefault.to_string().ascii_down()).has_prefix("t");
    }
}
