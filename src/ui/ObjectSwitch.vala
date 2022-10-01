// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectSwitch {

    string label = "";
    string pref = "";
    bool defaultValue = false;
    HBox hbox = new HBox();
    Gtk.Switch sw = new Gtk.Switch();
    Text text = new Text();

    public ObjectSwitch(string label, string pref, bool defaultValue) {
        this.label = label;
        this.pref = pref;
        this.defaultValue = defaultValue;
        text.setText(label);
        text.setWordWrap(false);
        sw.notify["active"].connect(() => {
            if (sw.get_active()) {
                Utility.writePref(pref, "true");
            } else {
                Utility.writePref(pref, "false");
            }
            UIPreferences.initialize();
            RadarPreferences.initialize();
        });
        var d = Utility.readPref(pref, defaultValue.to_string().ascii_down()).has_prefix("t");
        sw.set_active(d);
        hbox.addWidget(sw);
        hbox.addWidget(text.get());
    }

    public static ObjectSwitch fromPrefBool(PrefBool prefBool) {
        return new ObjectSwitch(prefBool.label, prefBool.prefToken, prefBool.enabledByDefault);
    }

    public void refresh() {
        var d = Utility.readPref(pref, defaultValue.to_string().ascii_down()).has_prefix("t");
        sw.set_active(d);
    }

    public Gtk.Widget get() { return hbox.get(); }
}
