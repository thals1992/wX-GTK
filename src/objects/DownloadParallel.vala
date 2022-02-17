// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class DownloadParallel {

    FileStorage fileStorage;
    ArrayList<string> urls = new ArrayList<string>();
    ArrayList<bool> downloadComplete = new ArrayList<bool>();

    public DownloadParallel(FileStorage fileStorage, ArrayList<string> urls) {
        this.fileStorage = fileStorage;
        this.urls = urls;
        fileStorage.clearBuffers();
        urls.foreach((unused) => {
            fileStorage.animationMemoryBuffer.add(new MemoryBuffer(0));
            fileStorage.animationByteArray.add(new WByteArray());
            downloadComplete.add(false);
            return true;
        });
        foreach (var i in UtilityList.range(urls.size)) {
            var indexFinal = i;
            new FutureVoidInt((idx) => download(idx), (idx) => update(idx), indexFinal);
        }
        while (true) {
            // time.sleep(0.001);
            var done = true;
            foreach (var b in downloadComplete) {
                if(!b) {
                    done = false;
                }
            }
            if (done) {
                break;
            }
        }
    }

    void download(int i) {
        var byteArray = UtilityIO.downloadAsByteArray(urls[i]);
        fileStorage.setMemoryBufferForAnimation(i, new WByteArray.fromArray(byteArray));
        downloadComplete[i] = true;
    }

    void update(int i) {
        // downloadComplete[i] = true;
    }
}
