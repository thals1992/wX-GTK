// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class WByteArray {

    public uint8[] data;

    public WByteArray() {
        this.data = new uint8[0];
    }

    public WByteArray.fromArray(uint8[] data) {
        this.data = data;
    }
}
