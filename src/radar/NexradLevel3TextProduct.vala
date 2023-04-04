// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class NexradLevel3TextProduct {

    public static string download(string product, string radarSite) {
        var url = NexradDownload.getRadarFileUrl(radarSite, product, false);
        var byteArrayF = UtilityIO.downloadAsByteArray(url);
        //  return ((string)byteArrayF);
        // ISO-8859-1
        var builder = new StringBuilder();
        foreach (var i in range(byteArrayF.length)) {
            uint8 ch = byteArrayF[i];
            if (ch < 0x80 && ch != '\0') {
                builder.append_c((char)ch);
            } else {
                //  builder.append_c((char)(0xc0 | ch >> 6)); /* first byte, simplified since our range is only 8-bits */
                //  builder.append_c((char)(0x80 | (ch & 0x3f)));
            }
        }
        return builder.str;
    }
}
