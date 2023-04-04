// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class DownloadText {

    const bool useNwsApi = false;

    public static string byProduct(string produ) {
        if (produ.has_prefix("http")) {
            return UtilityIO.getHtml(produ);
        }
        var text = "";
        var no = "";
        var textUrl = "";
        var prod = produ.ascii_up();
        if (prod == "AFDLOC") {
            text = byProduct("afd" + Location.office().ascii_down());
        } else if (prod == "HWOLOC") {
            text = byProduct("hwo" + Location.office().ascii_down());
        } else if (prod == "WFO_TEXT") {
            text = byProduct("AFD" + Location.office());
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
          text = byProduct(prod + "%");
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
        //  var t1 = prodLocal.substring(0, 3);
        var t2 = prodLocal.substring(3);
        //  var url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=" + t2 + "&product=" + t1 + "&format=CI&version=2&glossary=0";
        var url = "https://forecast.weather.gov/product.php?site=NWS&product=FTM&issuedby=" + t2;
        var text = UtilityIO.getHtml(url);
        text = UtilityString.parse(text, GlobalVariables.prePattern);
        text = text.replace("^<br>", "");
        return text;
    }
}
