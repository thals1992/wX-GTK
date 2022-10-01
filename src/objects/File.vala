// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class File {

    public static string getText(string fileName) {
        try {
            string read;
            FileUtils.get_contents(fileName, out read);
            return read;
        } catch (Error e) {
            print(e.message + "\n");
            return "";
        }

    }
    
    public static uint8[] getBinaryDataFromResource(string fileName) {
        try {
            size_t bytesRead;
            var file = GLib.File.new_for_uri("resource:///" + fileName);
            var fileInfo = file.query_info("standard::*", 0);
            var bufferSize = fileInfo.get_size();
            var buffer = new uint8[bufferSize];
            var fileInputStream = file.read();
            fileInputStream.read_all(buffer, out bytesRead);
            return buffer;
        } catch (Error e) {
            print(e.message + "\n");
            return new uint8[0];
        }
    }
    
    public static void setText(string fileName, string data) {
        try {
            FileUtils.set_contents(fileName, data);
        } catch (Error e) {
            print(e.message + "\n");
        }
    }
}
