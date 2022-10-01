// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class URL {

    #if SOUP30
    // libsoup-3.0
    public static string getText(string url) {
        if (url != "") {
            UtilityLog.d(url);
            try {
                Soup.Session session = new Soup.Session();
                Soup.Message message = new Soup.Message("GET", url);
                message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
                message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
                var data = session.send_and_read(message).get_data();
                if (data == null) {
                    return "";
                }
                return (string)data;
            } catch (Error e) {
                return "";
            }
        } else {
            return "";
        }
    }
    #else
    // libsoup-2.4
    public static string getText(string url) {
        if (url == "") {
            return "";
        }
        UtilityLog.d(url);
        var session = new Soup.Session();
        var message = new Soup.Message("GET", url);
        message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
        message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
        //message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
        //message.request_headers.append("cache-control", "max-age=0");
        //message.request_headers.append("if-modified-since", "Wed, 17 Feb 2021 13:26:23 GMT");
        // message.request_headers.append("user-agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36");
        session.send_message(message);
        var data = (string)message.response_body.data;
        if (data == null) {
            return "";
        }
        return data;
    }
    #endif

    #if SOUP30
    public static string getTextXmlAcceptHeader(string url) {
        if (url != "") {
            UtilityLog.d(url);
            try {
                Soup.Session session = new Soup.Session();
                Soup.Message message = new Soup.Message("GET", url);
                message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
                message.request_headers.append("Accept", "Application/atom+xml");
                var data = session.send_and_read(message).get_data();
                if (data == null) {
                    return "";
                }
                return (string)data;
            } catch (Error e) {
                return "";
            }
        } else {
            return "";
        }
    }
    #else
    public static string getTextXmlAcceptHeader(string url) {
        if (url == "") {
            return "";
        }
        UtilityLog.d(url);
        var session = new Soup.Session();
        var message = new Soup.Message("GET", url);
        message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
        message.request_headers.append("Accept", "Application/atom+xml");
        session.send_message(message);
        var data = (string)message.response_body.data;
        if (data == null) {
            return "";
        }
        return data;
    }
    #endif

    #if SOUP30
    public static uint8[] getBytes(string url) {
        UtilityLog.d(url);
        try {
            Soup.Session session = new Soup.Session();
            Soup.Message message = new Soup.Message("GET", url);
            message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
            message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
            var data = session.send_and_read(message).get_data();
            if (data == null) {
                return new uint8[]{0};
            }
            return data;
        } catch (Error e) {
            return new uint8[]{0};
        }
    }
    #else
    // libsoup-2.4
    public static uint8[] getBytes(string url) {
        UtilityLog.d(url);
        var session = new Soup.Session();
        var message = new Soup.Message("GET", url);
        message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
        session.send_message(message);
        return message.response_body.data;
    }
    #endif
}
