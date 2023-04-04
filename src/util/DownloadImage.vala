// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class DownloadImage {

    public static string byProduct(string product) {
        var url = "";
        switch (product) {
            case "GOES16":
                return UtilityGoes.getImage(Utility.readPref("GOES16PROD", "GEOCOLOR"), Utility.readPref("GOES16SECTOR", "cgl"));
            case "VISCONUS":
                return UtilityGoes.getImage("GEOCOLOR", "CONUS");
            case "VISIBLE_SATELLITE":
                var sector = UtilityGoes.getNearest(Location.getLatLonCurrent());
                return UtilityGoes.getImage("GEOCOLOR", sector);
            case "ANALYSIS_RADAR_AND_WARNINGS":
                return GlobalVariables.nwsWPCwebsitePrefix + "/images/wwd/radnat/NATRAD_24.gif";
            case "RADAR_MOSAIC":
                var radarMosaicSector = UtilityNwsRadarMosaic.getNearestMosaic(Location.getLatLonCurrent());
                return UtilityNwsRadarMosaic.get(radarMosaicSector);
            case "RTMA_TEMP":
                return UtilityRtma.getUrlForHomeScreen("2m_temp");
                //  var radarMosaicSector = UtilityAwcRadarMosaic.getNearestMosaic(Location.getLatLonCurrent());
                //  return UtilityAwcRadarMosaic.get("rad_rala", radarMosaicSector);
            //  case "WEATHERSTORY":
            //      var url = "https://www.weather.gov/images/" + Location.office.ascii_down() + "/wxstory/Tab2FileL.png";
            //      print(url);
            //      return url;
            //      break;
            //  case "WFOWARNINGS":
            //      var url = "https://www.weather.gov/wwamap/png/" + Location.office.ascii_down() + ".png";
            //      return url;
            //      break;
            //  case "RAD2KM":
            //      var product = "radrala";
            //      var prefTokenProduct = "AWCMOSAICPRODUCTLASTUSED";
            //      var sector = UtilityAwcRadarMosaic.getNearestMosaic(Location.latLon);
            //      product = Utility.readPref(prefTokenProduct, product);
            //      return UtilityAwcRadarMosaic.get(sector, product);
            //      break;
            case "USWARN":
                url = "https://forecast.weather.gov/wwamap/png/US.png";
                break;
            case "AKWARN":
                url = "https://forecast.weather.gov/wwamap/png/ak.png";
                break;
            case "HIWARN":
                url = "https://forecast.weather.gov/wwamap/png/hi.png";
                break;
            case "FMAPD1":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad1.gif";
                break;
            case "FMAPD2":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad2.gif";
                break;
            case "FMAPD3":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad3.gif";
                break;
            case "FMAP12":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/92fwbg.gif";
                break;
            case "FMAP24":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/94fwbg.gif";
                break;
            case "FMAP36":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/96fwbg.gif";
                break;
            case "FMAP48":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/98fwbg.gif";
                break;
            case "FMAP72":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf072.gif";
                break;
            case "FMAP96":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf096.gif";
                break;
            case "FMAP120":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf120.gif";
                break;
            case "FMAP144":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf144.gif";
                break;
            case "FMAP168":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf168.gif";
                break;
            case "FMAP3D":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9jhwbgconus.gif";
                break;
            case "FMAP4D":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9khwbgconus.gif";
                break;
            case "FMAP5D":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9lhwbgconus.gif";
                break;
            case "FMAP6D":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9mhwbgconus.gif";
                break;
            case "QPF1":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill94qwbg.gif";
                break;
            case "QPF2":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill98qwbg.gif";
                break;
            case "QPF3":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill99qwbg.gif";
                break;
            case "QPF1-2":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d12fill.gif";
                break;
            case "QPF1-3":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d13fill.gif";
                break;
            case "QPF4-5":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/95ep48iwbgfill.gif";
                break;
            case "QPF6-7":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/97ep48iwbgfill.gif";
                break;
            case "QPF1-5":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p120i.gif";
                break;
            case "QPF1-7":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p168i.gif";
                break;
            case "TWOATL0D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twoatl0d0.png";
                break;
            case "TWOATL2D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twoatl2d0.png";
                break;
            case "TWOATL5D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twoatl5d0.png";
                break;
            case "TWOEPAC0D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twopac0d0.png";
                break;
            case "TWOEPAC2D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twopac2d0.png";
                break;
            case "TWOEPAC5D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twopac5d0.png";
                break;
            case "TWOCPAC0D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twocpac0d0.png";
                break;
            case "TWOCPAC2D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twocpac2d0.png";
                break;
            case "TWOCPAC5D0":
                url = GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/twocpac5d0.png";
                break;
            case "WPCANALYSIS":
                url = GlobalVariables.nwsWPCwebsitePrefix + "/images/wwd/radnat/NATRAD24.gif";
                break;
            case "SWOD1":
                url = (UtilitySpcSwo.getImageUrls("1"))[0];
                break;
            case "SWOD2":
                url = (UtilitySpcSwo.getImageUrls("2"))[0];
                break;
            case "SWOD3":
                url = (UtilitySpcSwo.getImageUrls("3"))[0];
                break;
            case "STRPT":
                url = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/today.gif";
                break;
        }
        return url;
    }
}
