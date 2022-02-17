// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class Calendar {

    public delegate void delegate0();
    Gtk.Calendar cal = new Gtk.Calendar();

    public void connect(delegate0 fn) {
        cal.day_selected.connect(() => fn());
    }

    public int getYear() {
        uint year;  //GTK4_DELETE
        uint month;  //GTK4_DELETE
        uint day;  //GTK4_DELETE
        cal.get_date(out year, out month, out day);  //GTK4_DELETE
        /// var dateTime = cal.get_date();
        /// int year = dateTime.get_year();
        return (int)year;
    }

    public int getMonth() {
        uint year;  //GTK4_DELETE
        uint month;  //GTK4_DELETE
        uint day;  //GTK4_DELETE
        cal.get_date(out year, out month, out day);  //GTK4_DELETE
        /// var dateTime = cal.get_date();
        /// int month = dateTime.get_month() - 1;
        return (int)month;
    }

    public int getDayOfMonth() {
        uint year;  //GTK4_DELETE
        uint month;  //GTK4_DELETE
        uint day;  //GTK4_DELETE
        cal.get_date(out year, out month, out day);  //GTK4_DELETE
        /// var dateTime = cal.get_date();
        /// int day = dateTime.get_day_of_month();
        return (int)day;
    }

    public Gtk.Widget get() {
        return cal;
    }
}
