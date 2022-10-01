// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class FutureVoidInt {

    unowned FnInt downloadFuncVoid1;
    unowned FnInt updateFuncVoid1;
    int index;
    bool finished = false;

    public FutureVoidInt(FnInt downloadFuncVoid1, FnInt updateFuncVoid1, int i) {
        this.downloadFuncVoid1 = downloadFuncVoid1;
        this.updateFuncVoid1 = updateFuncVoid1;
        index = i;
        new Thread<void*>("downloadVoid1", downloadVoid1);
    }

    void* downloadVoid1() {
        downloadFuncVoid1(index);
        GLib.Idle.add(() => {
            updateFuncVoid1(index);
            finished = true;
            return false;
        });
        return null;
    }

    public bool isFinished() {
        return finished;
    }
}
