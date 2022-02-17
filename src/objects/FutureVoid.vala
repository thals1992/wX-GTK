// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class FutureVoid {

    public delegate void DownloadFuncVoid();
    public delegate void UpdateFuncVoid();
    unowned DownloadFuncVoid downloadFuncVoid;
    unowned UpdateFuncVoid updateFuncVoid;
    bool finished = false;

    //
    // void, no args
    //
    public FutureVoid(DownloadFuncVoid downloadFuncVoid, UpdateFuncVoid updateFuncVoid) {
        this.downloadFuncVoid = downloadFuncVoid;
        this.updateFuncVoid = updateFuncVoid;
        new Thread<void*>("downloadVoid", downloadVoid);
    }

    void* downloadVoid() {
        downloadFuncVoid();
        GLib.Idle.add(() => {
            updateFuncVoid();
            finished = true;
            return false;
        });
        return null;
    }

    public bool isFinished() {
        return finished;
    }
}
