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

    public static ArrayList<string> rawFileToStringArrayFromResource(string srcFile) {
        try {
            size_t bytesRead;
            var file = File.new_for_uri("resource:///" + srcFile);
            //  print("resource:///" + srcFile + "\n");
            FileInfo info = file.query_info("standard::*", 0);
            int64 bufferSize = info.get_size();
            var buffer = new uint8[bufferSize];
            FileInputStream stream = file.read();
            stream.read_all(buffer, out bytesRead);
            var contents = (string)buffer;
            return UtilityList.wrap(contents.split(GlobalVariables.newline));
        } catch(Error e) {
            print(e.message + "\n");
            return UtilityList.wrap({""});
        }
    }

    public static string readTextFile(string srcFile) {
        try {
            string read;
            FileUtils.get_contents(srcFile, out read);
            return read;
        } catch (Error e) {
            print(e.message + "\n");
            return "";
        }
    }

    public static string readTextFileFromResource(string srcFile) {
        try {
            size_t bytesRead;
            var file = File.new_for_uri("resource:///" + srcFile);
            FileInfo info = file.query_info("standard::*", 0);
            int64 bufferSize = info.get_size();
            var buffer = new uint8[bufferSize];
            FileInputStream stream = file.read();
            stream.read_all(buffer, out bytesRead);
            var data = (string)buffer;
            return data;
        } catch (Error e) {
            print(e.message + "\n");
            return "";
        }
    }

    public static void writeTextFile(string fileName, string content) {
        try {
            FileUtils.set_contents(fileName, content);
        } catch (Error e) {
            print(e.message + "\n");
        }
    }

    // public static void writeBinaryFile(string fileName, uint8[] content) {
    //     try {
    //         FileUtils.set_data(fileName, content);
    //     } catch (Error e) {
    //         print(e.message + "\n");
    //     }
    // }

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

    public static uint8[] readBinaryFileFromResource(string srcFile) {
        try {
            size_t bytesRead;
            var file = File.new_for_uri("resource:///" + srcFile);
            FileInfo info = file.query_info("standard::*", 0);
            int64 bufferSize = info.get_size();
            var buffer = new uint8[bufferSize];
            FileInputStream stream = file.read();
            stream.read_all(buffer, out bytesRead);
            return buffer;
        } catch (Error e) {
            print(e.message + "\n");
            return new uint8[0];
        }
    }

    // public static string downloadFile(string url) {
    //     try {
    //         string fileName = "./data";
    //         File file_from_http = File.new_for_uri(url);
    //         File local_file = File.new_for_path(fileName);
    //         file_from_http.copy(local_file, FileCopyFlags.OVERWRITE);
    //         return fileName;
    //     } catch(Error e) {
    //         return "";
    //     }
    // }

    // public static uint8[] getData(string url) {
    //     print("Binary download: " + url + "\n");
    //     try {
    //         string fileName = "./data";
    //         File file_from_http = File.new_for_uri(url);
    //         File local_file = File.new_for_path(fileName);
    //         file_from_http.copy(local_file, FileCopyFlags.OVERWRITE);
    //         uint8[] read;
    //         FileUtils.get_data(fileName, out read);
    //         return read;
    //     } catch (Error e) {
    //         print(e.message + "\n");
    //         return new uint8[]{};
    //     }
    // }

    public static uint8[] downloadAsByteArray(string url) {
    //  public static uint8[] getData(string url) {
        UtilityLog.d(url);
        //  try {
        var session = new Soup.Session();
        var message = new Soup.Message("GET", url);
        message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
        session.send_message(message);
        var data = message.response_body.data;
        return data;
        //  } catch (Error e) {
        //      print(e.message + " failed in getHtml with " + url + "\n");
        //      return new uint8[]{0};
        //  }
    }

    // libsoup-3.0
    //  public static uint8[] getData(string url) {
    //      UtilityLog.d(url);
    //      try {
    //          Soup.Session session = new Soup.Session();
    //          Soup.Message message = new Soup.Message("GET", url);
    //          message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
    //          message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
    //          var data = session.send_and_read(message).get_data();
    //          if (data == null) {
    //              return new uint8[]{0};
    //          }
    //          return data;
    //      } catch (Error e) {
    //          return new uint8[]{0};
    //      }
    //  }

    //  public static string getHtml(string url) {
    //      var fileName = "./data.html";
    //      var file_from_http = File.new_for_uri(url);
    //      File local_file = File.new_for_path(fileName);
    //      file_from_http.copy(local_file, FileCopyFlags.OVERWRITE);
    //      string read;
    //      FileUtils.get_contents(fileName, out read);
    //      return read;
    //  }

    public static string getHtml(string url) {
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
        //print((string)message.response_headers);
        var data = (string)message.response_body.data;
        return data;
    }

    // libsoup-3.0
    //  public static string getHtml(string url) {
    //      if (url != "") {
    //          UtilityLog.d(url);
    //          try {
    //              Soup.Session session = new Soup.Session();
    //              Soup.Message message = new Soup.Message("GET", url);
    //              message.request_headers.append("user-agent", GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail);
    //              message.request_headers.append("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
    //              var data = session.send_and_read(message).get_data();
    //              if (data == null) {
    //                  return "";
    //              }
    //              return (string)data;
    //          } catch (Error e) {
    //              return "";
    //          }
    //      } else {
    //          return "";
    //      }
    //  }
}
