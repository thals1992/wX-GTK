// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class WarnData {

    public ArrayList<double?> data;

    public WarnData(ArrayList<double?> data) {
        this.data = data;
    }

    public WarnData.zero() {
        this.data = new ArrayList<double?>();
    }
}
