// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectNumberPicker {

    string label;
    string pref;
    int defaultValue;
    HBox hbox = new HBox();
    Gtk.SpinButton spinbutton;
    Gtk.Adjustment adjustment;
    Text text1 = new Text();

    public ObjectNumberPicker(string label, string pref, int defaultValue, int low, int up, int step) {
        this.label = label;
        this.pref = pref;
        this.defaultValue = defaultValue;

        adjustment = new Gtk.Adjustment(Utility.readPrefInt(pref, defaultValue), low, up, step, 10, 1);
        spinbutton = new Gtk.SpinButton(adjustment, 1.0, 0);
        spinbutton.value_changed.connect(onValueChanged);
        hbox.addWidget(spinbutton);

        text1.setText(label);
        text1.setWordWrap(false);
        hbox.addWidget(text1.get());
    }

    void onValueChanged(Gtk.SpinButton sb) {
        Utility.writePrefInt(pref, sb.get_value_as_int());
        RadarPreferences.initialize();
        UIPreferences.initialize();
    }

    public void refresh() {
        spinbutton.set_value(Utility.readPrefInt(pref, defaultValue));
    }

    public Gtk.Widget get() { return hbox.get(); }
}
