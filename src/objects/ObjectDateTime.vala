// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class ObjectDateTime {

    DateTime dateTime = new DateTime.now_utc();

    public ObjectDateTime(DateTime dateTime) {
        this.dateTime = dateTime;
    }

    public ObjectDateTime.utc(string time) {
    }

    public ObjectDateTime.local() {
        dateTime = new DateTime.now();
    }

    public ObjectDateTime.fromIso8601(string time) {
        print(time + "\n");
        dateTime = new DateTime.from_iso8601(time, new TimeZone.utc());
    }

    public void addDays(int i) {
        dateTime = dateTime.add_days(i);
    }

    //  public void addHours(int i) {
    //      dateTime = dateTime.add_hours(i);
    //  }

    //  public void addMinutes(int i) {
    //      dateTime = dateTime.add_minutes(i);
    //  }

    //  public string to_string() { return dateTime.to_string(); }

    public bool isAfter(ObjectDateTime dt) { return dateTime.difference(dt.get()) >= 0; }

    public bool isBefore(ObjectDateTime dt) { return dateTime.difference(dt.get()) < 0; }

    public void utcToLocal() {
        dateTime = dateTime.to_local();
    }

    public DateTime get() { return dateTime; }

    public ObjectDateTime.fromObs(string time) {
        // time comes in as follows 2018.02.11 2353 UTC
        // https://valadoc.org/glib-2.0/GLib.DateTime.DateTime.from_iso8601.html
        // https://en.wikipedia.org/wiki/ISO_8601
        var returnTime = time.strip()
                                    .replace(" UTC", "")
                                    .replace(".", "")
                                    .replace(" ", "T") + "00.000Z";
        // time should now be as "20220225T095300.000Z"
        // text has a timezone "Z" so 2nd arg is null
        dateTime = new DateTime.from_iso8601(returnTime, new TimeZone.utc());
        if (dateTime == null) {
            dateTime = ObjectDateTime.getCurrentTimeInUTC();
        }
    }

    public ObjectDateTime.decodeVtecTime(string timeRange) {
        // Y2K issue
        var year = Too.Int("20" + UtilityString.parse(timeRange, "([0-9]{2})[0-9]{4}T[0-9]{4}"));
        var month = Too.Int(UtilityString.parse(timeRange, "[0-9]{2}([0-9]{2})[0-9]{2}T[0-9]{4}"));
        var day = Too.Int(UtilityString.parse(timeRange, "[0-9]{4}([0-9]{2})T[0-9]{4}"));
        var hour = Too.Int(UtilityString.parse(timeRange, "[0-9]{6}T([0-9]{2})[0-9]{2}"));
        var minute = Too.Int(UtilityString.parse(timeRange, "[0-9]{6}T[0-9]{2}([0-9]{2})"));
        dateTime = new DateTime(new TimeZone.utc(), year, month, day, hour, minute, 0);
        // if the vtec can't be parsed, return a valid date 1hr in future so it will show
        if (dateTime == null) {
            dateTime = getCurrentTimeInUTC();
            dateTime.add_hours(1);
        }
    }

    public string format(string s) { return dateTime.format(s); }

    //
    // start of core static methods
    //
    public static DateTime getCurrentTimeInUTC() { return new DateTime.now_utc(); }

    // is t1 greater then t2 by m minutes
    // if t2 is greater then difference will return negative number
    // TODO FIXME only take ObjectDateTime
    public static bool timeDifference(DateTime t1, DateTime t2, int m) {
        return (t1.difference(t2) / 60000000.0) < m;
    }

    public static string getTimeFromPointAsString(int64 sec) {
        var date = new DateTime.from_unix_local(sec);
        return date.format("%H:%M:%S");
    }

    public static string getGmtTimeForVtec() {
        var now = new DateTime.now_utc();
        return now.format("%y%m%dT%H%M");
    }

    public static int offsetFromUtcInSeconds() {
        var dt = new DateTime.now();
        TimeSpan ts = dt.get_utc_offset();
        return (int)(ts / 1000000.0);
    }

    // TODO FIXME consolidate this and below
    public static string getLocalTimeAsStringForLogging() {
        var now = new DateTime.now();
        return now.format("%H:%M:%S").replace("T", "");
    }

    //https://wiki.gnome.org/Projects/Vala/TimeSample
    public static string getLocalTimeAsStringForNexradTitle() {
        var now = new DateTime.now();
        return now.format("%H:%M:%S").replace("T", "");
    }

    public static int64 currentTimeMillis() { return GLib.get_real_time() / 1000; }

    public static string dayOfWeekAbbreviation(int year, int month, int day, int hour = 0) {
        var localTime = new DateTime(new TimeZone.local(), year, month, day, hour, 0, 0);
        return localTime.format("%a");
    }

    // Local
    public static int getYear() { return new DateTime.now_local().get_year(); }

    public static int getHour() { return new DateTime.now_local().get_hour(); }

    public static int getDayOfWeek() { return new DateTime.now_local().get_day_of_week(); }

    // UTC
    public static int getCurrentHourInUTC() { return new DateTime.now_utc().get_hour(); }

    //  ISO 8601 strings of the form <date><sep><time><tz> are supported, with some extensions from RFC 3339 as mentioned below.
    //  Note that as DateTime "is oblivious to leap seconds", leap seconds information in an ISO-8601 string will be ignored, so a `23:59:60` time would be parsed as `23:59:59`.
    //  <sep> is the separator and can be either 'T', 't' or ' '. The latter two separators are an extension from [RFC 3339 ](https://tools.ietf.org/html/rfc3339section-5.6).
    //  <date> is in the form:
    //  `YYYY-MM-DD` - Year/month/day, e.g. 2016-08-24.
    //  `YYYYMMDD` - Same as above without dividers.
    //  `YYYY-DDD` - Ordinal day where DDD is from 001 to 366, e.g. 2016-237.
    //  `YYYYDDD` - Same as above without dividers.
    //  `YYYY-Www-D` - Week day where ww is from 01 to 52 and D from 1-7, e.g. 2016-W34-3.
    //  `YYYYWwwD` - Same as above without dividers.
    //  <time> is in the form:
    //  `hh:mm:ss(.sss)` - Hours, minutes, seconds (subseconds), e.g. 22:10:42.123.
    //  `hhmmss(.sss)` - Same as above without dividers.
    //  <tz> is an optional timezone suffix of the form:
    //  `Z` - UTC.
    //  `+hh:mm` or `-hh:mm` - Offset from UTC in hours and minutes, e.g. +12:00.
    //  `+hh` or `-hh` - Offset from UTC in hours, e.g. +12.
    public static string convertFromUTCForMetar(string time) {
        // time comes in as follows 2018.02.11 2353 UTC
        var returnTime = time.strip()
                                    .replace(" UTC", "00")
                                    .replace(".", "")
                                    .replace(" ", "T") + "00Z";
        // time should now be as "20120227T132700"
        var radarDate = new DateTime.from_iso8601(returnTime, new TimeZone.local());
        radarDate = radarDate.to_local();
        var timeString = radarDate.to_string()
                                            .replace(":00.000", "")
                                            .replace("T", " ");
        timeString = UtilityString.replaceRegex(timeString, "-0[0-9]00", "");
        return timeString;
    }

    public static bool isDaytime(RID obs) {
        var sunTimes = UtilityTimeSunMoon.getSunriseSunsetFromObs(obs);
        var currentTime = new ObjectDateTime.local();
        currentTime.addDays(-1);
        var sunrise = sunTimes[0];
        var sunset = sunTimes[1];
        var afterSunrise = currentTime.isAfter(sunrise);
        var beforeSunset = currentTime.isBefore(sunset);
        return afterSunrise && beforeSunset;
    }

    public static string translateTimeForHourly(string originalTime) {
        var originalTimeComponents = originalTime.replace("T", "-").split("-");
        var hour = Too.Int(originalTimeComponents[3].replace(":00:00", ""));
        var hourString = Too.String(hour);
        var dayOfTheWeek = getDayOfWeekForHourly(originalTime);
        return dayOfTheWeek + " " + hourString;
    }

    public static string getDayOfWeekForHourly(string originalTime) {
        var originalTimeComponents = originalTime.replace("T", "-").split("-");
        var year = Too.Int(originalTimeComponents[0]);
        var month = Too.Int(originalTimeComponents[1]);
        var day = Too.Int(originalTimeComponents[2]);
        var hour = Too.Int(originalTimeComponents[3].replace(":00:00", ""));
        return ObjectDateTime.dayOfWeekAbbreviation(year, month, day, hour);
    }
}
