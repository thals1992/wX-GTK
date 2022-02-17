// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityLightning {

    public const string[] sectors = {
        "US",
        "Florida",
        "Texas",
        "OK / KS",
        "North America",
        "South America",
        "Australia",
        "New Zealand"
    };

    public const string[] timeList = {
        "15 MIN",
        "2 HR",
        "12 HR",
        "24 HR",
        "48 HR"
    };

    public static string getImageUrl(string sector, string period) {
        var url = "";
        if (sector.contains("goes")) {
            var sectorCode = sector.split("")[1];
            var html = UtilityIO.getHtml("https://weather.msfc.nasa.gov/cgi-bin/sportPublishData.pl?dataset=goes16glm&product=group&loc=" + sectorCode);
            url = "https://weather.msfc.nasa.gov" + UtilityString.parse(html, "SRC=.(/sport/dynamic/goes16/glm/" + sectorCode + "/sportgoes16glm" + sectorCode + "group[0-9]{8}[0-9]{4}.png)");
        } else {
            var baseUrl = "http://images.lightningmaps.org/blitzortung/america/index.php?map=";
            var baseUrlOceania = "http://images.lightningmaps.org/blitzortung/oceania/index.php?map=";
            if (sector.contains("australia") || sector.contains("newzealand")) {
                url = baseUrlOceania + sector + "&" + "period=" + period;
            } else {
                url = baseUrl + sector + "&period=" + period;
            }
        }
        return url;
    }

    public static string getSectorPretty(string code) {
        if (code == "usa_big") {
            return "US";
        } else if (code == "florida_big") {
            return "Florida";
        } else if (code == "texas_big") {
            return "Texas";
        } else if (code == "oklahoma_kansas_big") {
            return "OK / KS";
        } else if (code == "north_middle_america") {
            return "North America";
        } else if (code == "south_america") {
            return "South America";
        } else if (code == "australia_big") {
            return "Australia";
        } else if (code == "new_zealand_big") {
            return "New Zealand";
        }
        return "";
    }

    public static string getSector(string sector) {
        if (sector == "US") {
            return "usa_big";
        } else if (sector == "Florida") {
            return "florida_big";
        } else if (sector == "Texas") {
            return "texas_big";
        } else if (sector == "OK / KS") {
            return "oklahoma_kansas_big";
        } else if (sector == "North America") {
            return "north_middle_america";
        } else if (sector == "South America") {
            return "south_america";
        } else if (sector == "Australia") {
            return "australia_big";
        } else if (sector == "New Zealand") {
            return "new_zealand_big";
        }
        return "";
    }

    public static string getTimePretty(string period) {
        switch (period) {
            case "0.25":
                return "15 MIN";
            case "2":
                return "2 HR";
            case "12":
                return "12 HR";
            case "24":
                return "24 HR";
            case "48":
                return "48 HR";
            default:
                return "";
        }
    }

    public static string getTime(string periodPretty) {
        switch (periodPretty) {
            case "15 MIN":
                return "0.25";
            case "2 HR":
                return "2";
            case "12 HR":
                return "12";
            case "24 HR":
                return "24";
            case "48 HR":
                return "48";
            default:
                return "";
        }
    }
}
