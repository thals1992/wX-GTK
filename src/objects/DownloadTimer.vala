// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class DownloadTimer {

    public static int radarDataRefreshInterval = 6;

    bool initialized = false;
    int64 lastRefresh = 0;
    int refreshDataInMinutes = 6;
    string identifier = "";

    public DownloadTimer(string identifier) {
        this.identifier = identifier;
        refreshDataInMinutes = int.max(DownloadTimer.radarDataRefreshInterval, 6);
    }

    public bool isRefreshNeeded() {
        refreshDataInMinutes = int.max(DownloadTimer.radarDataRefreshInterval, 6);
        if (identifier.contains("WARNINGS")) {
            refreshDataInMinutes = int.max(DownloadTimer.radarDataRefreshInterval, 3);
        }
        var refreshNeeded = false;
        int64 currentTime = UtilityTime.currentTimeMillis();
        int64 currentTimeSeconds = currentTime / 1000;
        int refreshIntervalSeconds = refreshDataInMinutes * 60;
        if ((currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized) {
            refreshNeeded = true;
            initialized = true;
            lastRefresh = currentTime / 1000;
        }
        //print("REFRESH: " + identifier + " " + refreshNeeded.to_string());
        return refreshNeeded;
    }
}
