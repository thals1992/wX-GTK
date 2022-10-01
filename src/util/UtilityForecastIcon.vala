// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityForecastIcon {

    // Given the raw icon URL from NWS, determine if bitmap is on disk or must be created
    // Note that the url given to getIcon can handle either the new or old format below
    //
    // NEW API input examples
    //  https://api.weather.gov/icons/land/day/rain_showers,60/rain_showers,30?size=medium
    //  https://api.weather.gov/icons/land/night/bkn?size=medium
    //  https://api.weather.gov/icons/land/day/tsra_hi,40?size=medium
    //
    // OLD API input examples
    //
    // <icon-link>http://forecast.weather.gov/DualImage.php?i=nbkn&j=nsn&jp=60</icon-link>
    // <icon-link>http://forecast.weather.gov/newimages/medium/ra_sn30.png</icon-link>
    // <icon-link>http://forecast.weather.gov/newimages/medium/nsct.png</icon-link>
    // <icon-link>http://forecast.weather.gov/DualImage.php?i=sn&j=ra_sn&ip=30&jp=30</icon-link>
    public static Gdk.Pixbuf getIcon(string url) {
        var fileName = getFilename(url);
        //  print(fileName + ":\n");
        if (url == "NULL" || url == "" || fileName == ""|| url == "https://api.weather.gov/icons/land/night/?size=medium") {
            return ForecastIcon.blankBitmap();
        }
        if (fileName + ".png" in UtilityNwsIcon.iconMap) {
            return new ForecastIcon(fileName).get();
        }
        return parseBitmapString(fileName);
    }

    // Given one string that does not have a match on disk, decode and return a bitmap with textual labels
    // it could be composed of 2 bitmaps with one or more textual labels (if string has a "/" ) or just one bitmap with label
    // input examples
    //  rain_showers,70/tsra,80
    //  ntsra,80
    public static Gdk.Pixbuf parseBitmapString(string url) {
        // legacy: i=nsn;j=nsn;ip=60;jp=30
        // legacy add - 2nd condition
        if (url.contains("/") || url.contains(";jp=") || (url.contains("i=") && url.contains("j="))) {
            var items = url.split("/");
            if (items.length > 1) {
                return getDualBitmapWithNumbers(items[0], items[1]);
            }
            // legacy add
            var urlTmp = url.replace("i=", "");
            urlTmp = urlTmp.replace("j=", "");
            urlTmp = urlTmp.replace("ip=", "");
            urlTmp = urlTmp.replace("jp=", "");
            items = urlTmp.split(";");
            if (items.length > 3) {
                return getDualBitmapWithNumbers(items[0] + items[2], items[1] + items[3]);
            } else if (items.length > 2) {
                if (url.contains(";jp=")) {
                    return getDualBitmapWithNumbers(items[0], items[1] + items[2]);
                } else {
                    return getDualBitmapWithNumbers(items[0] + items[2], items[1]);
                }
            } else {
                return getDualBitmapWithNumbers(items[0], items[1]);
            }
            // legacy add end
        }
        return getBitmapWithOneNumber(url);
    }

    // Given two strings return a custom bitmap made of two bitmaps with optional numeric label
    // input examples
    //  rain_showers,60 rain_showers,30
    //  nrain_showers,80 nrain_showers,70
    //  ntsra_hi,40 ntsra_hi
    //  bkn rain
    public static Gdk.Pixbuf getDualBitmapWithNumbers(string iconLeftString, string iconRightString) {
        var leftTokens = iconLeftString.split(",");
        var rightTokens = iconRightString.split(",");
        var leftNumber = leftTokens.length > 1 ? leftTokens[1] : "";
        var rightNumber = rightTokens.length > 1 ? rightTokens[1] : "";
        var leftWeatherCondition = "";
        var rightWeatherCondition = "";
        if (leftTokens.length > 0 && rightTokens.length > 0) {
            leftWeatherCondition = leftTokens[0];
            rightWeatherCondition = rightTokens[0];
        } else {
            leftWeatherCondition = "";
            rightWeatherCondition = "";
        }
        // legacy add
        if (!iconLeftString.contains(",") && !iconRightString.contains(",")) {
            leftNumber = UtilityString.parse(iconLeftString, ".*?([0-9]+)");
            leftWeatherCondition = UtilityString.parse(iconLeftString, "([a-z_]+)");
            rightNumber = UtilityString.parse(iconRightString, ".*?([0-9]+)");
            rightWeatherCondition = UtilityString.parse(iconRightString, "([a-z_]+)");
        }
        // legacy add end
        var forecastIcon = new ForecastIcon.fromTwo(leftWeatherCondition, rightWeatherCondition);
        forecastIcon.drawLeftText(leftNumber);
        forecastIcon.drawRightText(rightNumber);
        return forecastIcon.get();
    }

    // https://valadoc.org/cairo/Cairo.Context.set_source_surface.html
    public static Gdk.Pixbuf getBitmapWithOneNumber(string iconString) {
        var items = iconString.split(",");
        var number = items.length > 1 ? items[1] : "";
        var weatherCondition = items.length > 0 ? items[0] : "";
        // legacy add
        if (!iconString.contains(",")) {
            number = UtilityString.parse(iconString, ".*?([0-9]+)");
            weatherCondition = UtilityString.parse(iconString, "([a-z_]+)");
        }
        // legacy add end
        var forecastIcon = new ForecastIcon(weatherCondition);
        forecastIcon.drawSingleText(number);
        return forecastIcon.get();
    }

    static string getFilename(string url) {
        var fileName = url.replace("?size=medium", "");
        fileName = fileName.replace("?size=small", "");
        fileName = fileName.replace("https://api.weather.gov/icons/land/", "");
        fileName = fileName.replace("http://api.weather.gov/icons/land/", "");
        fileName = fileName.replace("day/", "");
        // legacy add
        fileName = fileName.replace("http://forecast.weather.gov/newimages/medium/", "");
        fileName = fileName.replace("https://forecast.weather.gov/newimages/medium/", "");
        fileName = fileName.replace(".png", "");
        fileName = fileName.replace("http://forecast.weather.gov/DualImage.php?", "");
        fileName = fileName.replace("https://forecast.weather.gov/DualImage.php?", "");
        fileName = fileName.replace("&amp", "");
        // legacy add end
        if (fileName.contains("night")) {
            fileName = fileName.replace("night//", "n");
            fileName = fileName.replace("night/", "n");
            fileName = fileName.replace("/", "/n");
        }
        return fileName;
    }
}
