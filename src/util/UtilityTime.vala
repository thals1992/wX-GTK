// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

// https://api.dartlang.org/stable/2.1.1/dart-core/DateTime-class.html

using Gee;

class UtilityTime {

    public static string convertFromUTCForMetar(string time) {
        // time comes in as follows 2018.02.11 2353 UTC
        try {
            var returnTime = time.strip();
            returnTime = returnTime.replace(" UTC", "00");
            returnTime = returnTime.replace(".", "");
            returnTime = returnTime.replace(" ", "T") + "00Z";
            // time should now be as "20120227T132700"
            var radarDate = new DateTime.from_iso8601(returnTime, new TimeZone.local());
            radarDate = radarDate.to_local();
            var timeString = radarDate.to_string();
            timeString = timeString.replace(":00.000", "");
            timeString = timeString.replace("T", " ");
            var regex = new Regex("-0[0-9]00");
            // FIXME TODO
            // timeString = UtilityString.replaceRegex(timeString, "-0[0-9]00", "");
            timeString = regex.replace(timeString, timeString.length, 0, "");
            return timeString;
        } catch (Error e) {
            print(e.message + "\n");
            return time;
        }
    }

    public static string monthWordToNumber(string month) {
        var s = month.replace("Jan", "01");
        s = s.replace("Feb", "02");
        s = s.replace("Mar", "03");
        s = s.replace("Apr", "04");
        s = s.replace("May", "05");
        s = s.replace("Jun", "06");
        s = s.replace("Jul", "07");
        s = s.replace("Aug", "08");
        s = s.replace("Sep", "09");
        s = s.replace("Oct", "10");
        s = s.replace("Nov", "11");
        s = s.replace("Dec", "12");
        return s;
    }

    //https://wiki.gnome.org/Projects/Vala/TimeSample
    public static string getLocalTimeAsStringForNexradTitle() {
        // The current time in local timezone
        var now = new DateTime.now_local();
        var timeStamp = now.format("%H:%M:%S").replace("T", "");
        return timeStamp;
    }

    public static int getYear() {
        return new DateTime.now_local().get_year();
    }

    //  public static int getHour() {
    //      return new DateTime.now_local().get_hour();
    //  }

    public static int getDayOfWeek() {
        return new DateTime.now_local().get_day_of_week();
    }

    public static string dayOfWeek(int year, int month, int day) {
        var localTime = new DateTime(new TimeZone.local(), year, month, day, 0, 0, 0);
        var dayIndex = localTime.get_day_of_week();
        var dayOfTheWeek = "";
        switch (dayIndex) {
            case 7:
                dayOfTheWeek = "Sun";
                break;
            case 1:
                dayOfTheWeek = "Mon";
                break;
            case 2:
                dayOfTheWeek = "Tue";
                break;
            case 3:
                dayOfTheWeek = "Wed";
                break;
            case 4:
                dayOfTheWeek = "Thu";
                break;
            case 5:
                dayOfTheWeek = "Fri";
                break;
            case 6:
                dayOfTheWeek = "Sat";
                break;
            default:
                break;
        }
        return dayOfTheWeek;
    }

    public static string hourlyDayOfWeek(string originalTime) {
        var originalTimeComponents = originalTime.replace("T", "-").split("-");
        var year = Too.Int(originalTimeComponents[0]);
        var month = Too.Int(originalTimeComponents[1]);
        var day = Too.Int(originalTimeComponents[2]);
        var hour = Too.Int(originalTimeComponents[3].replace(":00:00", ""));
        var localTime = new DateTime(new TimeZone.local(), year, month, day, hour, 0, 0);
        var dayIndex = localTime.get_day_of_week();
        var dayOfTheWeek = "";
        switch (dayIndex) {
            case 7:
                dayOfTheWeek = "Sun";
                break;
            case 1:
                dayOfTheWeek = "Mon";
                break;
            case 2:
                dayOfTheWeek = "Tue";
                break;
            case 3:
                dayOfTheWeek = "Wed";
                break;
            case 4:
                dayOfTheWeek = "Thu";
                break;
            case 5:
                dayOfTheWeek = "Fri";
                break;
            case 6:
                dayOfTheWeek = "Sat";
                break;
            default:
                break;
        }
        return dayOfTheWeek;
    }

    public static int getCurrentHourInUTC() {
        return new DateTime.now_utc().get_hour();
    }

    public static int secondsFromUTC() {
        var dt = new DateTime.now();
        TimeSpan ts = dt.get_utc_offset();
        return (int)(ts / 1000000.0);
    }

    public static int64 currentTimeMillis() {
        // return DateTime.now().millisecondsSinceEpoch;
        int64 msec = GLib.get_real_time() / 1000;
        return msec;
    }

    public static string getCurrentLocalTimeAsStringForLogging() {
        var now = new DateTime.now();
        var timeStamp = now.format("%H:%M:%S").replace("T", "");
        return timeStamp;
    }

    public static bool isRadarTimeOld(int radarMilli) { // string radarTime
        // 1 min is 60k ms
        //int radarMilli = Utility.readPrefInt("WXRADAR_CURRENT_MILLI" + to.String(paneNumber), 0)
        if (radarMilli > 20 * 60000) {
            return true;
        }
        return false;
    }

    public static bool isVtecCurrent(string vtec) {
        // example 190512T1252Z-190512T1545Z
        var timeRange = UtilityString.parse(vtec, "-([0-9]{6}T[0-9]{4})Z");
        DateTime timeInMinutes = decodeVtecTime(timeRange);
        DateTime currentTimeInMinutes = decodeVtecTime(getGmtTimeForVtec());
        return currentTimeInMinutes.difference(timeInMinutes) < 0;
    }

    public static DateTime decodeVtecTime(string timeRange) {
        // Y2K issue
        var year = Too.Int("20" + UtilityString.parse(timeRange, "([0-9]{2})[0-9]{4}T[0-9]{4}"));
        var month = Too.Int(UtilityString.parse(timeRange, "[0-9]{2}([0-9]{2})[0-9]{2}T[0-9]{4}"));
        var day = Too.Int(UtilityString.parse(timeRange, "[0-9]{4}([0-9]{2})T[0-9]{4}"));
        var hour = Too.Int(UtilityString.parse(timeRange, "[0-9]{6}T([0-9]{2})[0-9]{2}"));
        var minute = Too.Int(UtilityString.parse(timeRange, "[0-9]{6}T[0-9]{2}([0-9]{2})"));
        return new DateTime(new TimeZone.utc(), year, month, day, hour, minute, 0);
    }

    public static string getGmtTimeForVtec() {
        var now = new DateTime.now_utc();
        return now.format("%y%m%dT%H%M");
    }

    // wxc2 has 3rd arg , QString dateStr
    public static ArrayList<string> generateModelRuns(string time1, int hours) {
        //  QDateTime dateObject = QDateTime::fromString(time1, dateStr);
        var runs = new ArrayList<string>();
        //  for (int index = 1; index < 5; index++) {
        //      float timeChange = 60.0 * 60.0 * float(hours) * float(index);
        //      QDateTime newDateTime = dateObject.addSecs(-1.0 * timeChange);
        //      runs.append(newDateTime.toString(dateStr));
        //  }
        return runs;
    }

    public static string getTimeFromPointAsString(int64 sec) {
        var date = new DateTime.from_unix_local(sec);
        var dateString = date.format("%H:%M:%S");
        return dateString;
    }
}
