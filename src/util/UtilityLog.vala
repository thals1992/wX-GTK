// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityLog {

    public static void d(string logMessage) {
        print(UtilityTime.getCurrentLocalTimeAsStringForLogging() + " " + logMessage + "\n");
    }
}
