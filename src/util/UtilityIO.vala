// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;
using BZLib;

class UtilityIO {

    public static uint8[] uncompress(uint8[] compressedData) {
        var size = 2000000;
        var oBuff = new uint8[size];
        BZLib.BuffToBuffDecompress(oBuff, ref size, compressedData, compressedData.length, 1, 0);
        return oBuff[0:size];
    }

    // Don't want to use below method as it requires writing to user's filesystem.
    // public static uint8[] uncompress(uint8[] compressedData, string fnAdd) {
    //     string tmpFileName = "tmpFile" + fnAdd + ".bz2";
    //     writeBinaryFile(tmpFileName, compressedData);
    //     BZLib.BZFileStream bz = BZLib.BZFileStream.open(tmpFileName);
    //     uint8[] uncompressedData = new uint8[2000000];
    //     int bytesRead = bz.read(uncompressedData);
    //     return uncompressedData[0:bytesRead - 1];
    // }

    // public static ArrayList<string> rawFileToStringArray(string srcFile) {
    //     try {
    //         string read;
    //         FileUtils.get_contents(srcFile, out read);
    //         return UtilityList.wrap(read.split(GlobalVariables.newline));
    //     } catch(Error e) {
    //         print(e.message + "\n");
    //         return UtilityList.wrap({});
    //     }
    // }

    public static ArrayList<string> rawFileToStringArrayFromResource(string fileName) {
        return UtilityList.wrap(readTextFileFromResource(fileName).split(GlobalVariables.newline));
    }

    public static string readTextFile(string fileName) {
        return File.getText(fileName);
    }

    public static string readTextFileFromResource(string fileName) {
        return (string)readBinaryFileFromResource(fileName);
    }

    public static void writeTextFile(string fileName, string data) {
        File.setText(fileName, data);
    }

    // KEEP
    // public static void writeBinaryFile(string fileName, uint8[] content) {
    //     try {
    //         FileUtils.set_data(fileName, content);
    //     } catch (Error e) {
    //         print(e.message + "\n");
    //     }
    // }

    // KEEP
    // public static uint8[] readBinaryFile(string srcFile) {
    //     try {
    //         uint8[] read;
    //         FileUtils.get_data(srcFile, out read);
    //         return read;
    //     } catch (Error e) {
    //         print(e.message + "\n");
    //         return new uint8[]{};
    //     }
    // }

    public static uint8[] readBinaryFileFromResource(string fileName) {
        return File.getBinaryDataFromResource(fileName);
    }

    public static uint8[] downloadAsByteArray(string url) {
        return URL.getBytes(url);
    }

    public static string getHtml(string url) {
        return URL.getText(url);
    }
}
