// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityModels {

    public static string convertTimeRuntoTimeString(string runStr, string timeStrFunc) {
        var timeStr = timeStrFunc.split(" ")[0];
        var runInt = Too.Int(runStr);
        var timeInt = Too.Int(timeStr);
        var realTimeGmt = runInt + timeInt;
        int offsetFromUtc = UtilityTime.secondsFromUTC();
        double realTime = realTimeGmt + Math.floor(offsetFromUtc / 60 / 60);
        double hourOfDay = realTime % 24;
        var amPm = "";

        if (hourOfDay > 11) {
            amPm = "pm";
            if (hourOfDay > 12) {
                hourOfDay -= 12;
            }
        } else {
            amPm = "am";
        }
        double day = realTime / 24;
        if (hourOfDay < 0) {
            hourOfDay = 12 + hourOfDay;
            amPm = "pm";
            day -= 1;
        }

        //  if (hourOfDay > 11) {
        //      amPm = "pm";
        //      if (hourOfDay > 12) {
        //          hourOfDay -= 12;
        //      }
        //  } else {
        //      amPm = "am";
        //  }
        //  double day = realTime / 24;
        //  if (hourOfDay < 0) {
        //      hourOfDay = 12 + hourOfDay;
        //      amPm = "pm";
        //      day -= 1;
        //  }
        var dayOfWeek = UtilityTime.getDayOfWeek();
        //  var hourOfDayLocal = UtilityTime.getHour();
        //  if (runInt >= 0 && runInt < -offsetFromUtc / 60 / 60 && (hourOfDayLocal - offsetFromUtc / 60 / 60) >= 24) {
        //      day += 1;
        //  }
        var futureDay = "";
        var dayMod = (int)(dayOfWeek + day) % 7;
        // Vala/Dart: is Monday(1)..Sunday(7), Swift is Sat(0)..Fri(6)
        if (dayMod == 0) {
            dayMod = 7;
        }
        switch (dayMod) {
            case 7:
                futureDay = "Sun";
                break;
            case 1:
                futureDay = "Mon";
                break;
            case 2:
                futureDay = "Tue";
                break;
            case 3:
                futureDay = "Wed";
                break;
            case 4:
                futureDay = "Thu";
                break;
            case 5:
                futureDay = "Fri";
                break;
            case 6:
                futureDay = "Sat";
                break;
            default:
                break;
        }
        print(futureDay + "  " + Too.StringFromD(hourOfDay) + amPm + " " + dayMod.to_string() + " " + dayOfWeek.to_string() +  "\n");
        return futureDay + "  " + Too.StringFromD(hourOfDay) + amPm;
    }

    public static ArrayList<string> updateTime(string run, string modelCurrentTime, ArrayList<string> listTime, string prefix1) {
        var run2 = run;
        run2 = run2.replace("Z", "");
        run2 = run2.replace("z", "");
        var listTimeNew = new ArrayList<string>();
        var modelCurrentTime2 = modelCurrentTime;
        modelCurrentTime2 = modelCurrentTime2.replace("Z", "");
        modelCurrentTime2 = modelCurrentTime2.replace("z", "");
        if (modelCurrentTime2 != "") {
            if (Too.Int(run2) > Too.Int(modelCurrentTime2)) {
                run2 = Too.String(Too.Int(run2) - 24);
            }
            foreach (var value in listTime) {
                var tmp = value.split(" ")[0];
                var tmpStr = tmp.replace(prefix1, "");
                listTimeNew.add(prefix1 + tmpStr + " " + convertTimeRuntoTimeString(run2, tmpStr));
            }
        }
        return listTimeNew;
    }
}
