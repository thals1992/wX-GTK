// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityDownload {

    const bool useNwsApi = false;

    public static string getTextProduct(string produ) {
        if (produ.has_prefix("http")) {
            return UtilityIO.getHtml(produ);
        }
        var text = "";
        var no = "";
        var textUrl = "";
        var prod = produ.ascii_up();
        if (prod == "AFDLOC") {
            text = getTextProduct("afd" + Location.office().ascii_down());
        } else if (prod == "HWOLOC") {
            text = getTextProduct("hwo" + Location.office().ascii_down());
        } else if (prod == "WFO_TEXT") {
            text = UtilityDownload.getTextProduct("AFD" + Location.office());
        } else if (prod == "HOURLY") {
            text = UtilityHourly.get(Location.getCurrentLocation());
        } else if (prod == "SWPC3DAY") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/3-day-forecast.txt"); // FIXME use myapp URL var
        } else if (prod == "SWPC27DAY") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/27-day-outlook.txt");
        } else if (prod == "SWPCWWA") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/advisory-outlook.txt");
        } else if (prod == "SWPCHIGH") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/weekly.txt");
        } else if (prod == "SWPCDISC") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/discussion.txt");
        } else if (prod == "SWPC3DAYGEO") {
            text = UtilityIO.getHtml("https://services.swpc.noaa.gov/text/3-day-geomag-forecast.txt");
        } else if (prod.contains("MIAPWS") || prod.contains("MIAHS") || prod.contains("MIATCP") || prod.contains("MIATCM") || prod.contains("HFOTWOCP")) {
            textUrl = GlobalVariables.nwsNhcWebsitePrefix + "/text/" + prod + ".shtml";
            text = UtilityIO.getHtml(textUrl);
            text = UtilityString.extractPreLsr(text);
        } else if (prod.contains("MIAT")) {
            var url = GlobalVariables.nwsNhcWebsitePrefix + "/ftp/pub/forecasts/discussion/" + prod;
            text = UtilityIO.getHtml(url);
        } else if (prod.has_prefix("SCCNS")) {
            var textUrl1 = GlobalVariables.nwsWPCwebsitePrefix + "/discussions/nfd" + prod.ascii_down().replace("ns", "") + ".html";
            text = UtilityIO.getHtml(textUrl1);
            text = UtilityString.extractPreLsr(text);
        } else if (prod.contains("SPCMCD")) {
            no = prod.replace("SPCMCD", "");
            textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/md" + no + ".html";
            text = UtilityIO.getHtml(textUrl);
            text = UtilityString.parse(text, GlobalVariables.pre2Pattern);
            text = UtilityString.removeHtml(text);
        } else if (prod.contains("SPCWAT")) {
            no = prod.replace("SPCWAT", "");
            textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + no + ".html";
            text = UtilityIO.getHtml(textUrl);
            text = UtilityString.parse(text, GlobalVariables.pre2Pattern);
            text = UtilityString.removeHtml(text);
        } else if (prod.contains("WPCMPD")) {
            no = prod.replace("WPCMPD", "");
            textUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd_multi.php?md=" + no;
            text = UtilityIO.getHtml(textUrl);
            text = UtilityString.parse(text, GlobalVariables.pre2Pattern);
        } else if (prod.has_prefix("GLF")) {
            //  var product = prod.substring(0, 3);
            //  var site = prod.substring(3).replace("%", "");
            //  var url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=" + site + "&product=" + product + "&format=txt&version=1&glossary=0";
            //  var html = UtilityIO.getHtml(url);
            //  text = UtilityString.extractPreLsr(html);

            if (prod.ascii_down() == "glfsc") {
                var url = "https://tgftp.nws.noaa.gov/data/raw/fz/fzus63.kdtx.glf.sc.txt";
                text = UtilityIO.getHtml(url);
            } else if (prod.ascii_down() == "glfsl") {
                var url = "https://tgftp.nws.noaa.gov/data/raw/fz/fzus61.kbuf.glf.sl.txt";
                text = UtilityIO.getHtml(url);
            } else {
                var url = "https://w2.weather.gov/dmawds/prod_get.php?page=" + prod.ascii_down();
                var html = UtilityIO.getHtml(url);
                text = UtilityString.extractPreLsr(html);
                text = UtilityString.removeHtml(html);
            }
        } else if (prod == "QPF94E") {
            text = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "1";
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod == "QPF98E") {
            text = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "2";
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod == "QPF99E") {
            text = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "3";
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod.contains("FWDDY1")) {
            text = GlobalVariables.nwsSPCwebsitePrefix + "/products/fire_wx/fwdy1.html";
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod.contains("FWDDY2")) {
            text = GlobalVariables.nwsSPCwebsitePrefix + "/products/fire_wx/fwdy2.html";
            //  text = url.getHtml();
            //  text = text.extractPre().removeLineBreaks().removeHtml().removeDuplicateSpaces();
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod.contains("FWDDY38")) {
            text = GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/fire_wx/";
            text = UtilityIO.getHtml(text);
            text = UtilityString.extractPreLsr(text);
            text = UtilityString.removeHtml(text);
        } else if (prod.has_prefix("GLF") && !prod.contains("%")) {
          text = getTextProduct(prod + "%");
        } else if (prod.contains("FOCN45")) {
          text = UtilityIO.getHtml(GlobalVariables.tgftpSitePrefix + "/data/raw/fo/focn45.cwwg..txt");
        } else if (prod.has_prefix("VFD")) {
          var t2 = prod.substring(3);
          text = UtilityIO.getHtml(GlobalVariables.nwsAWCwebsitePrefix + "/fcstdisc/data?cwa=K" + t2);
          text = text.replace("\n", "<br>");
          text = UtilityString.parse(text, "<!-- raw data starts -->(.*?)<!-- raw data ends -->");
          text = text.replace("<br>", "\n");
        } else if (prod.has_prefix("AWCN")) {
          text = UtilityIO.getHtml(GlobalVariables.tgftpSitePrefix + "data/raw/aw/" + prod.ascii_down() + ".cwwg..txt");
        } else if (prod.contains("NFD")) {
          text = UtilityIO.getHtml(GlobalVariables.nwsOpcWebsitePrefix + "/mobile/mobile_product.php?id=" + prod.ascii_up());
          text = UtilityString.removeHtml(text);
        } else if (prod.contains("PMD30D")) {
            textUrl = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxus07.kwbc.pmd.30d.txt";
            text = UtilityIO.getHtml(textUrl);
        } else if (prod.contains("PMD90D")) {
            textUrl = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxus05.kwbc.pmd.90d.txt";
            text = UtilityIO.getHtml(textUrl);
        } else if (prod.contains("PMDMRD")) {
            textUrl = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxus06.kwbc.pmd.mrd.txt";
            text = UtilityIO.getHtml(textUrl);
        } else if (prod.contains("PMDHCO")) {
            textUrl = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxhw40.kwbc.pmd.hco.txt";
            text = UtilityIO.getHtml(textUrl);
        } else if (prod.contains("PMDTHR")) {
            var url = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxus21.kwnc.pmd.thr.txt";
            text = UtilityIO.getHtml(url);
        } else if (prod.contains("USHZD37")) {
            textUrl = "https://www.wpc.ncep.noaa.gov/threats/threats.php";
            text = UtilityIO.getHtml(textUrl);
            text = UtilityString.parse(text, "<div class=.haztext.>(.*?)</div>");
            text = text.replace("<br>", GlobalVariables.newline);
        } else if (prod.has_prefix("FXCN01")) {
            text = UtilityIO.getHtml("http://collaboration.cmc.ec.gc.ca/cmc/cmop/FXCN/");
            var dateList = UtilityString.parseColumn(text, "href=\"([0-9]{8})/\"");
            var datestring = dateList.last();
            var daysAndRegion = prod.replace("FXCN01", "").ascii_down();
            text = UtilityIO.getHtml("http://collaboration.cmc.ec.gc.ca/cmc/cmop/FXCN/" + datestring + "/fx_" + daysAndRegion + "_" + datestring + "00.html");
            text = UtilityString.removeHtml(text);
            text = text.replace(GlobalVariables.newline + GlobalVariables.newline, GlobalVariables.newline);
        } else if (prod.contains("FPCN48")) {
            text = UtilityIO.getHtml(GlobalVariables.tgftpSitePrefix + "data/raw/fp/fpcn48.cwao..txt");
        //  } else if (prod.startsWith("CLI")) {
        //    var location = prod.substring(3).replace("%", "");
        //    text = ("https://w2.weather.gov/climate/index.php?wfo=" + location.ascii_down()).getHtmlSep();
        //    text = ("https://forecast.weather.gov/product.php?site=DTX&product=CLI&issuedby=DTW").getHtmlSep();
        //    text = text.extractPreLsr();
        //  } else if (prod.startsWith("RWR")) {
        //    var product = prod.substring(0, 3);
        //    var location = prod.substring(3).replace("%", "");
        //    var locationName = Utility.getWfoSiteName(location);
        //    var state = locationName.split(",")[0];
        //    var url = "https://forecast.weather.gov/product.php?site=" + location + "&issuedby=" + state + "&product=" + product;
        //      // https://forecast.weather.gov/product.php?site=ILX&issuedby=IL&product=RWR
        //    text = url.getHtml();
        //    text = text.extractPreLsr();
        } else if (prod.contains("OFF") || prod == "UVICAC" || prod == "RWRMX" || prod.has_prefix("TPT")) {
            var product = prod.substring(0, 3);
            var site = prod.substring(3);
            var url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=" + site + "&product=" + product + "&format=txt&version=1&glossary=0";
            var html = UtilityIO.getHtml(url);
            text = UtilityString.extractPreLsr(html);
        } else {
            // exmaple URL https://api.weather.gov/products/types/AFD/locations/DTX
            // product
            var t1 = prod.substring(0, 3);
            // site
            var t2 = prod.substring(3).replace("%", "");
            // Feb 8 2020 Sat
            // The NWS API for text products has been unstable Since Wed Feb 5
            // resorting to alternatives
            if (useNwsApi) {
                var urlToGet = GlobalVariables.nwsApiUrl + "/products/types/" + t1 + "/locations/" + t2;
                //  print(urlToGet);
                var htmlFuture = UtilityIO.getHtml(urlToGet);
                var urlProd = "";
                urlProd = GlobalVariables.nwsApiUrl + "/products/" + UtilityString.parse(htmlFuture, "\"id\": \"(.*?)\"");
                var prodHtmlFuture = UtilityIO.getHtml(urlProd);
                text = UtilityString.parse(prodHtmlFuture, "\"productText\": \"(.*?)\\$");
                if (!prod.has_prefix("RTP")) {
                    text = text.replace("\\n\\n", "\n");
                    text = text.replace("\\n", " ");
                } else {
                    text = text.replace("\\n", "\n");
                }
            } else {
                switch (prod) {
                    case "SWOMCD":
                        var url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=MCD&product=SWO&format=CI&version=1&glossary=1";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "SWODY1":
                        var url = "https://www.spc.noaa.gov/products/outlook/day1otlk.html";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "SWODY2":
                        var url = "https://www.spc.noaa.gov/products/outlook/day2otlk.html";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "SWODY3":
                        var url = "https://www.spc.noaa.gov/products/outlook/day3otlk.html";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "SWOD48":
                        var url = "https://www.spc.noaa.gov/products/exper/day4-8/";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "PMDSPD":
                    case "PMDEPD":
                    case "PMDHMD":
                    case "PMDHI":
                    case "PMDAK":
                    case "QPFERD":
                    case "QPFHSD":
                        var url = "https://www.wpc.ncep.noaa.gov/discussions/hpcdiscussions.php?disc=" + prod.ascii_down();
                        var html = UtilityIO.getHtml(url);
                        text = html;
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);   //.removeLineBreaks()
                        break;
                    case "PMDSA":
                        var url = "https://www.wpc.ncep.noaa.gov/discussions/hpcdiscussions.php?disc=fxsa20";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    case "PMDCA":
                        var url = "https://www.wpc.ncep.noaa.gov/discussions/hpcdiscussions.php?disc=fxca20";
                        var html = UtilityIO.getHtml(url);
                        text = UtilityString.extractPreLsr(html);
                        text = UtilityString.removeHtml(text);
                        break;
                    default:
                        // https://forecast.weather.gov/product.php?site=DTX&issuedby=DTX&product=AFD&format=txt&version=1&glossary=0
                        var urlToGet = "https://forecast.weather.gov/product.php?site=" + t2 + "&issuedby=" + t2 + "&product=" + t1 + "&format=txt&version=1&glossary=0";
                        var prodHtmlFuture = UtilityIO.getHtml(urlToGet);
                        text = UtilityString.extractPreLsr(prodHtmlFuture);
                        break;
                }
            }
        }
        return text;
    }

    public static string getImageProduct(string product) {
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

    public static string getTextProductWithVersion(string product, int version) {
        var prodLocal = product.ascii_up();
        var t1 = prodLocal.substring(0, 3);
        var t2 = prodLocal.substring(3);
        var textUrl = "https://forecast.weather.gov/product.php?site=NWS&product=" + t1 + "&issuedby=" + t2 + "&version=" + Too.String(version);
        var text = UtilityIO.getHtml(textUrl);
        text = UtilityString.extractPreLsr(text);
        text = text.replace("Graphics available at <a href=\"/basicwx/basicwxwbg.php\"><u>www.wpc.ncep.noaa.gov/basicwx/basicwxwbg.php</u></a>", "");
        return text.replace("^<br>", "").replace(GlobalVariables.newline + GlobalVariables.newline, GlobalVariables.newline);
    }

    public static string getRadarStatusMessage(string radarSite) {
        var ridSmall = "";
        if (radarSite.length == 4) {
            ridSmall = radarSite.substring(1);
        } else {
            ridSmall = radarSite;
        }
        var prodLocal = "FTM" + ridSmall.ascii_up();
        var t1 = prodLocal.substring(0, 3);
        var t2 = prodLocal.substring(3);
        var url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=" + t2 + "&product=" + t1 + "&format=CI&version=2&glossary=0";
        var text = UtilityIO.getHtml(url);
        text = UtilityString.parse(text, GlobalVariables.prePattern);
        text = text.replace("^<br>", "");
        return text;
    }
}
