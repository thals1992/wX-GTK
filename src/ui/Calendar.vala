// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class Calendar {

    Gtk.Calendar cal = new Gtk.Calendar();

    public void connect(FnVoid fn) {
        cal.day_selected.connect(() => fn());
    }

    public int year {
        get {
            #if GTK4
                var dateTime = cal.get_date();
                int year = dateTime.get_year();
            #else
                uint year;
                uint month;
                uint day;
                cal.get_date(out year, out month, out day);
            #endif
            return (int)year;
        }
    }

    public int month {
        get {
            #if GTK4
                var dateTime = cal.get_date();
                int month = dateTime.get_month() - 1;
            #else
                uint year;
                uint month;
                uint day;
                cal.get_date(out year, out month, out day);
            #endif
            return (int)month;
        }
    }

    public int dayOfMonth {
        get  {
            #if GTK4
                var dateTime = cal.get_date();
                int day = dateTime.get_day_of_month();
            #else
                uint year;
                uint month;
                uint day;
                cal.get_date(out year, out month, out day);
            #endif
            return (int)day;
        }
    }

    public Gtk.Widget get() { return cal; }
}
