// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class FutureBytes {

    public delegate void FBUpdateFunc(uint8[] data);
    unowned FBUpdateFunc updateFunc;
    uint8[] data;
    string arg1;
    FutureType dataType;

    public FutureBytes(string arg1, FBUpdateFunc updateFunc) {
        this.updateFunc = updateFunc;
        this.arg1 = arg1;
        dataType = FutureType.bytes;
        run();
    }

    void run() {
        new Thread<void*>("downloadImage", download);
    }

    void* download() {
        data = UtilityIO.downloadAsByteArray(arg1);
        GLib.Idle.add(() => { updateFunc(data); return false; });
        return null;
    }
}
