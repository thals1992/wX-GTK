// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class DownloadParallelBytes {

    public ArrayList<WByteArray> byteList = new ArrayList<WByteArray>();
    string[] urls;
    ArrayList<bool> downloadComplete = new ArrayList<bool>();
    //  ArrayList<FutureVoid> threads = new ArrayList<FutureVoid>();

    public DownloadParallelBytes(string[] urls) {
        this.urls = urls;
        byteList.clear();
        foreach (var u in urls) {
            byteList.add(new WByteArray());
            downloadComplete.add(false);
        }
        foreach (var i in range(urls.length)) {
            new FutureVoidInt((idx) => download(idx), (idx) => update(idx), i);
        }
        while (true) {
            // time.sleep(0.001);
            var done = true;
            foreach (var b in downloadComplete) {
                if (!b) {
                    done = false;
                }
            }
            if (done) {
                break;
            }
        }
    }

    void download(int i) {
        print(Too.String(i) + "\n");
        byteList[i] = new WByteArray.fromArray(UtilityIO.downloadAsByteArray(urls[i]));
        downloadComplete[i] = true;
    }

    void update(int i) {
        //downloadComplete[i] = true;
    }
}
