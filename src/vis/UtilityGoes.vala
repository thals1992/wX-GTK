// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityGoes {

    static HashMap<string, LatLon> sectorToLatLon;
    public static ArrayList<string> sectorsInGoes17;
    static HashMap<string, string> sizeMap;
    public static string[] sectors;
    static HashMap<string, string> sectorToName;
    public static string[] labels;
    public static ArrayList<string> productCodes;

    public static string getNearestGoesLocation(LatLon location) {
        var shortestDistance = 1000.00;
        var currentDistance = 0.0;
        var bestIndex = "";
        foreach (var k in sectorToLatLon.keys) {
            currentDistance = LatLon.distance(location, sectorToLatLon[k]);
            if (currentDistance < shortestDistance) {
                shortestDistance = currentDistance;
                bestIndex = k;
            }
        }
        if (bestIndex == "") {
            return "BLAH";
        }
        return bestIndex;
    }

    public static string getImageFileName(string sector) {
        const string fullsize = "latest";
        var size = sizeMap[sector] ?? fullsize;
        return size + ".jpg";
    }

    public static string getImageGoesFloater(string url, string product) {
        var urlFinal = url;
        urlFinal = urlFinal.replace("GEOCOLOR", product);
        return urlFinal;

    }

    // https://cdn.star.nesdis.noaa.gov/GOES16/GLM/CONUS/EXTENT/20201641856GOES16-GLM-CONUS-EXTENT-2500x1500.jpg
    // https://cdn.star.nesdis.noaa.gov/GOES16/GLM/CONUS/EXTENT/1250x750.jpg

    public static string getImage(string product, string sector) {
        var sectorLocal = "SECTOR/" + sector;
        if (sector == "FD" || sector == "CONUS" || sector == "CONUS-G17") {
            sectorLocal = sector;
        }
        var satellite = "GOES16";
        if (sectorsInGoes17.contains(sector)) {
            satellite = "GOES17";
            if (sector == "CONUS-G17")
                sectorLocal = "CONUS";
        }
        //  if (product == "GLM" && !sectorsWithAdditional.contains(sector)) {
        //      product = "GEOCOLOR";
        //  }
        var url = GlobalVariables.goes16Url + "/" + satellite + "/ABI/" + sectorLocal + "/" + product + "/" + getImageFileName(sector);
        if (product == "GLM") {
            url = url.replace("ABI", "GLM");
            url = url.replace(sector + "/GLM", sector + "/EXTENT3");
        }
        return url;
    }

    //  https://www.star.nesdis.noaa.gov/GOES/sectorband.php?sat=G17&sector=ak&band=GEOCOLOR&length=12
    //  https://www.star.nesdis.noaa.gov/GOES/sectorband.php?sat=G16&sector=cgl&band=GEOCOLOR&length=12
    //  public static string[] getAnimation(string product, string sector, int frameCnt) {
    //      var frameCount = Too.String(frameCnt);
    //      var url = "";
    //      var satellite = "G16";
    //      if (sectorsInGoes17.contains(sector)) {
    //          satellite = "G17";
    //      }
    //      if (sector == "FD") {
    //          url = "https://www.star.nesdis.noaa.gov/GOES/GOES16_FullDisk_Band.php?band=" + product.replace("GLM", "EXTENT") + "&length=" + frameCount;
    //      } else if (sector == "CONUS" || sector == "CONUS-G17") {
    //          url = "https://www.star.nesdis.noaa.gov/GOES/conus_band.php?sat=" + satellite + "&band=" + product.replace("GLM", "EXTENT") + "&length=" + frameCount;
    //      } else {
    //          url = "https://www.star.nesdis.noaa.gov/GOES/sector_band.php?sat=" + satellite + "&sector=" + sector + "&band=" + product + "&length=" + frameCount;
    //      }
    //      var data = UtilityIO.getHtml(url);
    //      var html = data.replace("\n", "").replace("\r", "");
    //      var imageHtml = UtilityString.parse(html, "animationImages = \\[(.*?)\\];");
    //      var stringList = UtilityString.parseColumn(imageHtml, "'(https.*?jpg)'");
    //      var stringArray = UtilityList.listToArray(stringList);
    //      return stringArray;
    //  }

    public static string[] getAnimation(string product, string sector, int frameCount) {
        var baseUrl = getImage(product, sector);
        var itemsArray = baseUrl.split("/");
        var items = UtilityList.wrap(itemsArray);
        items.remove_at(items.size - 1);
        items.remove_at(items.size - 1);
        if (product == "GLM") {
            baseUrl = UtilityList.join(items, "/") + "/EXTENT3/";
        } else {
            baseUrl = UtilityList.join(items, "/") + "/" + product + "/";
        }
        var html = UtilityIO.getHtml(baseUrl);
        var urlList = new ArrayList<string>();
        if (product == "GLM") {
            urlList = UtilityString.parseColumn(html.replace("\r\n", " "), "<a href=\"([^\\s]*?1250x750.jpg)\">");
        } else {
            urlList = UtilityString.parseColumn(html.replace("\r\n", " "), "<a href=\"([^\\s]*?1200x1200.jpg)\">");
        }
        var returnList = new ArrayList<string>();
        if (urlList.size > frameCount) {
            UtilityList.range(frameCount).foreach((unused) => {
                var u = urlList.last();
                urlList.remove_at(urlList.size - 1);
                returnList.insert(0, baseUrl + u);
                return true;
            });
        }
        var returnVector = UtilityList.listToArray(returnList);
        return returnVector;
        // <a href="20211842100_GOES16-ABI-FL-GEOCOLOR-AL052021-1000x1000.jpg">
    }

    public static string[] getAnimationGoesFloater(string product, string url, int frameCount) {
        var baseUrl = url;
        baseUrl = baseUrl.replace("GEOCOLOR", product).replace("latest.jpg", "");
        var html = UtilityIO.getHtml(baseUrl);
        var urlList = UtilityString.parseColumn(html.replace("\r\n", " "), "<a href=\"([^\\s]*?1000x1000.jpg)\">");
        var returnList = new ArrayList<string>();
        if (urlList.size > frameCount) {
            var s = urlList.size - frameCount;
            foreach (var u in urlList[s:urlList.size]) {
                returnList.add(baseUrl + u);
            }
        }
        var stringArray = UtilityList.listToArray(returnList);
        return stringArray;
    }

    public static void initStatic() {
        sectorToLatLon = new HashMap<string, LatLon>();
        sectorsInGoes17 = new ArrayList<string>();
        sizeMap = new HashMap<string, string>();
        sectorToName = new HashMap<string, string>();
        productCodes = new ArrayList<string>();

        sectorToLatLon["cgl"] = new LatLon.fromDouble(39.123405, -82.532938); // cgl wellston, Oh
        sectorToLatLon["ne"] = new LatLon.fromDouble(39.360611, -74.431877); // ne Atlantic City, NJ
        sectorToLatLon["umv"] = new LatLon.fromDouble(40.622777, -93.934116); // umv  Lamoni, IA
        sectorToLatLon["pnw"] = new LatLon.fromDouble(41.589703, -119.858865); // pnw Vya, NV
        sectorToLatLon["psw"] = new LatLon.fromDouble(38.524448, -118.623611); // psw Hawthorne, NV
        sectorToLatLon["nr"] = new LatLon.fromDouble(41.139980, -104.820244); // nr   Cheyenne, Wy
        sectorToLatLon["sr"] = new LatLon.fromDouble(34.653376, -108.677852); // sr Fence Lake, NM
        sectorToLatLon["sp"] = new LatLon.fromDouble(31.463787, -96.058022); // sp Buffalo, TX
        sectorToLatLon["smv"] = new LatLon.fromDouble(31.326460, -89.289658); // smv Hattiesburg, MS
        sectorToLatLon["se"] = new LatLon.fromDouble(30.332184, -81.655647); // se Jacksonville, FL

        sectorsInGoes17 = UtilityList.wrap({
            "CONUS-G17",
            "FD-G17",
            "ak",
            "cak",
            "sea",
            "hi",
            "pnw",
            "psw",
            "tpw",
            "wus",
            "np"
        });

        sectors = {
            "FD: Full Disk",
            "CONUS: GOES-EAST US",
            "CONUS-G17: GOES-WEST US",
            "pnw: Pacific Northwest",
            "nr: Northern Rockies",
            "umv: Upper Mississippi Valley",
            "cgl: Central Great Lakes",
            "ne: Northeast",
            "psw: Pacific Southwest",
            "sr: Southern Rockies",
            "sp: Southern Plains",
            "smv: Southern Mississippi Valley",
            "se: Southeast",
            "gm: Gulf of Mexico",
            "car: Caribbean",
            "eus: U.S. Atlantic Coast",
            "pr: Puerto Rico",
            "cam: Central America",
            "taw: Tropical Atlantic",
            "ak: Alaska",
            "cak: Central Alaska",
            "sea: Southeastern Alaska",
            "hi: Hawaii",
            "wus: US Pacific Coast",
            "tpw: Tropical Pacific",
            "eep: Eastern Pacific",
            "np: Northern Pacific",
            "can: Canada",
            "mex: Mexico",
            "nsa: South America (north)",
            "ssa: South America (south)"
        };


        labels = {
            "True color daytime, multispectral IR at night",
            "00.47 um (Band 1) Blue - Visible",
            "00.64 um (Band 2) Red - Visible",
            "00.86 um (Band 3) Veggie - Near IR",
            "01.37 um (Band 4) Cirrus - Near IR",
            "01.6 um (Band 5) Snow/Ice - Near IR",
            "02.2 um (Band 6) Cloud Particle - Near IR",
            "03.9 um (Band 7) Shortwave Window - IR",
            "06.2 um (Band 8) Upper-Level Water Vapor - IR",
            "06.9 um (Band 9) Mid-Level Water Vapor - IR",
            "07.3 um (Band 10) Lower-level Water Vapor - IR",
            "08.4 um (Band 11) Cloud Top - IR",
            "09.6 um (Band 12) Ozone - IR",
            "10.3 um (Band 13) Clean Longwave Window - IR",
            "11.2 um (Band 14) Longwave Window - IR",
            "12.3 um (Band 15) Dirty Longwave Window - IR",
            "13.3 um (Band 16) CO2 Longwave - IR",
            "AirMass - RGB composite based on the data from IR and WV",
            "Sandwich RGB - Bands 3 and 13 combo",
            "Day Cloud Phase",
            "Night Microphysics",
            "Fire Temperature",
            "Dust RGB",
            "GLM FED+GeoColor",
            "DMW"
        };

        productCodes = UtilityList.wrap({
            "GEOCOLOR",
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "AirMass",
            "Sandwich",
            "DayCloudPhase",
            "NightMicrophysics",
            "FireTemperature",
            "Dust",
            "GLM",
            "DMW"
        });

        sizeMap["CONUS-G17"] = "1250x750";
        sizeMap["CONUS"] = "1250x750";
        sizeMap["FD"] = "1808x1808";
        sizeMap["gm"] = "1000x1000";
        sizeMap["car"] = "1000x1000";
        sizeMap["eus"] = "1000x1000";
        sizeMap["taw"] = "1800x1080";
        sizeMap["tpw"] = "1800x1080";
        sizeMap["can"] = "1125x560";
        sizeMap["mex"] = "1000x1000";
        sizeMap["cam"] = "1000x1000";
        sizeMap["eep"] = "1000x1000";
        sizeMap["wus"] = "1000x1000";
        sizeMap["nsa"] = "1800x1080";
        sizeMap["ssa"] = "1800x1080";
        sizeMap["np"] = "1800x1080";
        sizeMap["ak"] = "1000x1000";
        sizeMap["cak"] = "1200x1200";
        sizeMap["sea"] = "1200x1200";
        sizeMap["hi"] = "1200x1200";
        //  sizeMap["pnw"] = "1200x1200");
        //  sizeMap["nr"] = "1200x1200");
        //  sizeMap["umv"] = "1200x1200");
        //  sizeMap["cgl"] = "1200x1200");
        //  sizeMap["ne"] = "1200x1200");
        //  sizeMap["psw"] = "1200x1200");
        //  sizeMap["sr"] = "1200x1200");
        //  sizeMap["sp"] = "1200x1200");
        //  sizeMap["smv"] = "1200x1200");
        //  sizeMap["se"] = "1200x1200");
        sectorToName["FD"] = "Full Disk";
        sectorToName["CONUS"] = "GOES-EAST US";
        sectorToName["CONUS-G17"] = "GOES-WEST US";
        sectorToName["pnw"] = "Pacific Northwest";
        sectorToName["nr"] = "Northern Rockies";
        sectorToName["umv"] = "Upper Mississippi Valley";
        sectorToName["cgl"] = "Central Great Lakes";
        sectorToName["ne"] = "Northeast";
        sectorToName["psw"] = "Pacific Southwest";
        sectorToName["sr"] = "Southern Rockies";
        sectorToName["sp"] = "Southern Plains";
        sectorToName["smv"] = "Southern Mississippi Valley";
        sectorToName["se"] = "Southeast";
        sectorToName["gm"] = "Gulf of Mexico";
        sectorToName["car"] = "Caribbean";
        sectorToName["eus"] = "U.S. Atlantic Coast";
        sectorToName["pr"] = "Puerto Rico";
        sectorToName["cam"] = "Central America";
        sectorToName["taw"] = "Tropical Atlantic";
        sectorToName["ak"] = "Alaska";
        sectorToName["cak"] = "Central Alaska";
        sectorToName["sea"] = "Southeastern Alaska";
        sectorToName["hi"] = "Hawaii";
        sectorToName["wus"] = "US Pacific Coast";
        sectorToName["tpw"] = "Tropical Pacific";
        sectorToName["eep"] = "Eastern Pacific";
        sectorToName["np"] = "Northern Pacific";
        sectorToName["can"] = "Canada";
        sectorToName["mex"] = "Mexico";
        sectorToName["nsa"] = "South America (north)";
    }
}
