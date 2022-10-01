// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityString {

    public static string extractPreLsr(string html) {
        var seperator = "ABC123E";
        var htmlOneLine = html.replace(GlobalVariables.newline, seperator);
        var parsedText = parse(htmlOneLine, "<pre.*?>(.*?)</pre>");
        return parsedText.replace(seperator, GlobalVariables.newline);
    }

    public static ArrayList<string> parseColumn(string text, string regexp) {
        try {
            var regex = new GLib.Regex(regexp, DOTALL, 0);
            GLib.MatchInfo match_info;
            var items = new ArrayList<string>();
            regex.match(text, 0, out match_info);
            while (match_info.matches()) {
                items.add(match_info.fetch(1));
                match_info.next();
            }
            return items;
        } catch (Error e) {
            return UtilityList.wrap({});
        }
    }

    public static int parseAndCount(string str, string regexpStr) {
        return parseColumn(str, regexpStr).size;
    }

    //  G_REGEX_DOTALL and G_REGEX_MULTILINE
    // https://valadoc.org/glib-2.0/GLib.RegexCompileFlags.html
    //

    public static string parse(string text, string regexp) {
        try {
            var regex = new GLib.Regex(regexp, DOTALL, 0);
            GLib.MatchInfo match_info;
            if (regex.match(text, 0, out match_info)) {
                match_info.matches();
                return match_info.fetch(1);
            } else {
                return "";
            }
        } catch (Error e) {
            print(e.message + "\n");
            return "";
        }
    }

    public static string replaceRegex(string s, string regexp, string newString) {
        try {
            var regex = new Regex(regexp);
            var result = regex.replace(s, s.length, 0, newString);
            return result;
        } catch (Error e) {
            print(e.message + "\n");
            return "";
        }
    }

    public static bool match(string s, string regexp) {
        try {
            var regex = new Regex(regexp);
            var result = regex.match(s);
            return result;
        } catch (Error e) {
            print(e.message + "\n");
            return false;
        }
    }

    public static string[] parseTwo(string text, string regexp) {
        try {
            var regex = new GLib.Regex(regexp, 0, 0);
            GLib.MatchInfo match_info;
            if (regex.match(text, 0, out match_info)) {
                match_info.matches();
                // includes substr 0, need 3, might be redundant
                if (match_info.get_match_count() > 2) {
                    return new string[]{match_info.fetch(1), match_info.fetch(2)};
                } else {
                    return new string[]{""};
                }
            } else {
                return new string[]{""};
            }
        } catch (Error e) {
            return new string[]{""};
        }
    }

    public static string parseLastMatch(string data, string match) {
        var items = parseColumn(data, match);
        if (items.size > 0) {
            return items[items.size - 1];
        } else {
            return "";
        }
    }

    public static string insert(string originalstring, int index, string stringToInsert) {
        return originalstring.substring(0, index) + stringToInsert + originalstring.substring(index);
    }

    public static string addPeriodBeforeLastTwoChars(string str) {
        var index = str.length - 2;
        return insert(str, index, ".");
    }

    public static string getLastXChars(string s, int x) {
        var startIndex = s.length - x;
        if (startIndex < 0) {
            return s;
        }
        var value = s.substring(startIndex);
        return value;
    }

    //
    // capitalize first word of all words in phrase, used in curent conditions
    //
    public static string title(string text) {
        var words = text.split(" ");
        var newWords = new ArrayList<string>();
        var newText = "";
        foreach (var w in words) {
            newWords.add(w.substring(0, 1).ascii_up() + w.substring(1));
        }
        foreach (var w in newWords) {
            newText += w + " ";
        }
        return newText.strip();
    }

    public static string removeHtml(string text) {
        try {
            var regex = new Regex("(<([^>]+)>)");
            var result = regex.replace(text, text.length, 0, "");
            return result;
        } catch (Error e) {
            return text;
        }
    }

    public static string truncate(string originalString, int length) {
        if (length < originalString.length) {
            return originalString.substring(0, length);
        } else {
            return originalString;
        }
    }

    public static string[] parseXml(string payloadF, string delimF) {
        var payload = payloadF;
        var delim = delimF;
        if (delim == "start-valid-time") {
            payload = replaceRegex(payload, "<end-valid-time>.*?</end-valid-time>", "");
            payload = replaceRegex(payload, "<layout-key>.*?</layout-key>", "");
        }
        payload = replaceRegex(payload, "<name>.*?</name>", "");
        payload = replaceRegex(payload, "</" + delim + ">", "");
        return payload.split("<" + delim + ">");
    }

    public static ArrayList<string> parseXmlExt(string[] regexpList, string htmlF) {
        var items = new ArrayList<string>();
        var html = htmlF;
        html = html.replace("\n", " ");
        html = html.replace("\r", " ");
        foreach (var reg in regexpList) {
            items.add(parse(html, reg));
        }
        return items;
    }

    public static string[] parseXmlValue(string payloadF) {
        var payload = payloadF;
        payload = UtilityString.replaceRegex(payload, "<name>.*?</name>" , "");
        payload = UtilityString.replaceRegex(payload, "</value>" , "");
        return payload.split(GlobalVariables.xmlValuePattern);
    }
}
