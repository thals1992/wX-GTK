// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class FileStorage {

    public MemoryBuffer memoryBuffer = new MemoryBuffer(0);
    public MemoryBuffer memoryBufferLevel2 = new MemoryBuffer(0);
    public ArrayList<WByteArray> animationByteArray = new ArrayList<WByteArray>();
    public ArrayList<MemoryBuffer> animationMemoryBuffer = new ArrayList<MemoryBuffer>();
    public ArrayList<WByteArray> animationByteArrayL2 = new ArrayList<WByteArray>();
    public ArrayList<MemoryBuffer> animationMemoryBufferL2 = new ArrayList<MemoryBuffer>();
    public HashMap<string, string> level3TextProductMap = new HashMap<string, string>();
    public ArrayList<double?> stiData = new ArrayList<double?>();
    public ArrayList<double?> hiData = new ArrayList<double?>();
    public ArrayList<double?> tvsData = new ArrayList<double?>();
    public string radarInfo = "";
    public string radarDate = "";
    public string radarVcp = "";
    public int radarAgeMilli = 0;
    public int radarProductId = 0;
    public ArrayList<string> obsArr = new ArrayList<string>();
    public ArrayList<string> obsArrExt = new ArrayList<string>();
    public ArrayList<string> obsArrWb = new ArrayList<string>();
    public ArrayList<string> obsArrWbGust = new ArrayList<string>();
    public ArrayList<double?> obsArrX = new ArrayList<double?>();
    public ArrayList<double?> obsArrY = new ArrayList<double?>();
    public ArrayList<int> obsArrAviationColor = new ArrayList<int>();
    public string obsOldRadarSite = "";
    public DownloadTimer obsDownloadTimer = new DownloadTimer("OBS_AND_WIND_BARBS");

    public void clearBuffers() {
        animationByteArray.clear();
        animationMemoryBuffer.clear();
    }

    public void setMemoryBufferForAnimation(int index, WByteArray byteArray) {
        animationByteArray[index] = new WByteArray.fromArray(byteArray.data);
        animationMemoryBuffer[index] = new MemoryBuffer.fromArray(animationByteArray[index].data);
    }

    public void setMemoryBufferForL3TextProducts(string product, uint8[] byteArrayF) {
        // ISO-8859-1
        var builder = new StringBuilder();
        foreach (var i in UtilityList.range(byteArrayF.length)) {
            uint8 ch = byteArrayF[i];
            if (ch < 0x80 && ch != '\0') {
                builder.append_c((char)ch);
            } else {
                builder.append_c((char)(0xc0 | ch >> 6)); /* first byte, simplified since our range is only 8-bits */
                builder.append_c((char)(0x80 | (ch & 0x3f)));
            }
        }
        level3TextProductMap[product] = builder.str;
    }
}
