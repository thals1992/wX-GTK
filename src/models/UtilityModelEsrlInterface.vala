// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelEsrlInterface {

    public const string[] models = {
        "HRRR_NCEP",
        "RAP_NCEP"
    };

    public const string[] sectorsHrrr = {
        "Full",
        "NW",
        "NC",
        "NE",
        "SW",
        "SC",
        "SE",
        "Great Lakes",
        "East CO",
    };

    public const string[] sectorsHrrrAk = {
        "Full"
    };

    public const string[] sectorsRap = {
        "Full",
        "CONUS",
        "NW",
        "NC",
        "NE",
        "SW",
        "SC",
        "SE",
        "Great Lakes",
    };

    public const string[] modelHrrrParams = {
        "1ref_full_1000m",
        "cref_full_sfc",
        "mref_full_sfc",
        "ref_full_m10",
        "ref_full_maxm10",
        "G113bt_full_sat",
        "G123bt_full_sat",
        "G114bt_full_sat",
        "G124bt_full_sat",
        "cape_full_sfc",
        "cin_full_sfc",
        "cape_full_mx90mb",
        "cape_full_mu",
        "cape_full_mul",
        "li_full_best",
        "lcl_full_sfc",
        "shear_full_01km",
        "shear_full_06km",
        "hlcy_full_sr01",
        "hlcy_full_sr03",
        "hlcy_full_mx25",
        "hlcy_full_mn25",
        "hlcy_full_mx02",
        "hlcy_full_mn02",
        "hlcy_full_mx03",
        "hlcy_full_mn03",
        "hlcytot_full_mx25",
        "hlcytot_full_mn25",
        "hlcytot_full_mx02",
        "hlcytot_full_mn02",
        "hlcytot_full_mx03",
        "hlcytot_full_mn03",
        "vvort_full_mx01",
        "vvort_full_mx02",
        "ltg3_full_sfc",
        "vig_full_sfc",
        "wspeed_full_max",
        "wspeed_full_10m",
        "gust_full_10m",
        "wspeed_full_80m",
        "temp_full_sfc",
        "temp_full_2m",
        "ptmp_full_2m",
        "temp_full_2ds",
        "dewp_full_2m",
        "rh_full_2m",
        "pres_full_sfc",
        "pwtr_full_sfc",
        "weasd_full_sfc",
        "1hsnw_full_sfc",
        // "acsnw_full_sfc",
        // "snod_full_sfc",
        // "acsnod_full_sfc",
        "totp_full_sfc",
        // "acpcp_full_sfc",
        "hail_full_maxsfc",
        "hail_full_max",
        "cpofp_full_sfc",
        "acfrzr_full_sfc",
        "acfrozr_full_sfc",
        // "ssrun_full_sfc",
        "temp_full_925mb",
        "temp_full_850mb",
        "wspeed_full_850mb",
        "rh_full_850mb",
        "rh_full_mean",
        "rh_full_pw",
        "temp_full_700mb",
        "vvel_full_700mb",
        "vvel_full_mean",
        "wspeed_full_mup",
        "wspeed_full_mdn",
        "temp_full_500mb",
        "vort_full_500mb",
        "wspeed_full_250mb",
        "vis_full_sfc",
        "cloudcover_full_total",
        "cloudcover_full_low",
        "cloudcover_full_mid",
        "cloudcover_full_high",
        "ctop_full",
        "ceil_full",
        "echotop_full_sfc",
        "vil_full_sfc",
        "rvil_full_sfc",
        "flru_full_sfc",
        "ulwrf_full_top",
        "uswrf_full_top",
        "ulwrf_full_sfc",
        "uswrf_full_sfc",
        "solar_full_sfc",
        "vbdsf_full_sfc",
        "vddsf_full_sfc",
        "lhtfl_full_sfc",
        "shtfl_full_sfc",
        "hpbl_full_sfc",
        "soilt_full_0cm",
        "soilt_full_1cm",
        "soilt_full_4cm",
        "soilt_full_10cm",
        "soilt_full_30cm",
        "soilt_full_60cm",
        "soilt_full_1m",
        "soilt_full_1.6m",
        "soilt_full_3m",
        "soilw_full_0cm",
        "soilw_full_1cm",
        "soilw_full_4cm",
        "soilw_full_10cm",
        "soilw_full_30cm",
        "soilw_full_60cm",
        "soilw_full_1m",
        "soilw_full_1.6m",
        "soilw_full_3m",
    };

    public const string[] modelHrrrLabels = {
        "1 km agl reflectivity",
        "composite reflectivity",
        // "ensemble comp reflectivity",
        "max 1 km agl reflectivity",
        "-10C isothermal reflectivity",
        "max 1h -10C isothermal reflectivity",
        "GOES-W water vapor",
        "GOES-E water vapor",
        "GOES-W Infrared",
        "GOES-E Infrared",
        "surface CAPE",
        "surface CIN",
        "mixed CAPE",
        "most unstable CAPE",
        "most unstable layer CAPE",
        "best LI",
        "LCL",
        "0-1 km shear",
        "0-6 km shear",
        "0-1 km helicity, storm motion",
        "0-3 km helicity, storm motion",
        "2-5 km max updraft helicity",
        "2-5 km min updraft helicity",
        "0-2 km max updraft helicity",
        "0-2 km min updraft helicity",
        "0-3 km max updraft helicity",
        "0-3 km min updraft helicity",
        // "ensemble updraft helicity",
        "run total 2-5 km max updraft helicity",
        "run total 2-5 km min updraft helicity",
        "run total 0-2 km max updraft helicity",
        "run total 0-2 km min updraft helicity",
        "run total 0-3 km max updraft helicity",
        "run total 0-3 km min updraft helicity",
        "0-1 km max vertical vorticity",
        "0-2 km max vertical vorticity",
        "lightning threat 3",
        "max vert int graupel",
        "max 10m wind",
        "10m wind",
        "10m wind gust potential",
        "80m wind",
        // "1h 80m wind speed change",
        // "ensemble 1h 80m wind speed change",
        "skin temp",
        "2m temp",
        "2m potential temp",
        "2m temp - skin temp",
        "2m dew point",
        "2m RH",
        // "fire weather index",
        "surface pressure",
        // "3h pressure change",
        "precipitable water",
        "snow water equiv",
        "1h snowfall (10-1)",
        // "ensemble 1h heavy snowfall (10-1)",
        // "total acc snowfall (10-1)",
        // "snow depth",
        // "acc snow depth (var dens)",
        // "ensemble acc snowfall",
        // "mean ensemble acc snowfall",
        "1h precip",
        // "ensemble 1h precip",
        // "mean ensemble 1h precip",
        // "ensemble 1h heavy precip",
        // "total acc precip",
        // "ensemble total acc precip",
        // "mean ensemble total acc precip",
        // "precip type",
        "max 1h hail/graupel diameter (at sfc)",
        // "max 1h hail/graupel (at sfc) from HAILCAST",
        "max 1h hail/graupel diameter (entire atmosphere)",
        "frozen precip percentage",
        "total acc freezing rain",
        // "total acc graupel (sleet)",
        // "supercooled liquid water",
        "1h storm surface runoff",
        // "3h storm surface runoff",
        "925mb temp",
        "850mb temp",
        "850mb wind",
        "850mb rh",
        "850-500mb mean rh",
        "rh with respect to pw",
        "700mb temp",
        "700mb vvel",
        "mean vvel",
        "max updraft",
        "max downdraft",
        "500mb temp",
        "500mb vort",
        "250mb wind",
        "visibility",
        "total cloud cover",
        "low-level cloud cover",
        "mid-level cloud cover",
        "high-level cloud cover",
        "cloud top height",
        "ceiling",
        // "ceiling (experimental)",
        // "ceiling (experimental-2)",
        "echotop height",
        "VIL",
        "RADAR VIL",
        "aviation flight rules",
        "outgoing longwave radiation (top of atmosphere)",
        "outgoing shortwave radiation (top of atmosphere)",
        "upward longwave radiation (surface)",
        "upward shortwave radiation (surface)",
        "incoming shortwave radiation",
        "incoming direct radiation",
        "incoming diffuse radiation",
        "latent heat flux",
        "sensible heat flux",
        "PBL height",
        "soil temp at sfc",
        "soil temp at 1cm",
        "soil temp at 4cm",
        "soil temp at 10cm",
        "soil temp at 30cm",
        "soil temp at 60cm",
        "soil temp at 1m",
        "soil temp at 1.6m",
        "soil temp at 3m",
        "soil moisture at sfc",
        "soil moisture at 1cm",
        "soil moisture at 4cm",
        "soil moisture at 10cm",
        "soil moisture at 30cm",
        "soil moisture at 60cm",
        "soil moisture at 1m",
        "soil moisture at 1.6m",
        "soil moisture at 3m",
        // "cross section BOU cloud water mixing ratio",
        // "cross section BOU rain mixing ratio",
        // "cross section BOU graupel mixing ratio",
        // "cross section BOU snow mixing ratio",
        // "cross section BOU total condensate",
        // "cross section BOU wind",
        // "cross section LWX cloud water mixing ratio",
        // "cross section LWX rain mixing ratio",
        // "cross section LWX graupel mixing ratio",
        // "cross section LWX snow mixing ratio",
        // "cross section LWX total condensate",
        // "cross section LWX wind",
        // "cross section MKX cloud water mixing ratio",
        // "cross section MKX rain mixing ratio",
        // "cross section MKX graupel mixing ratio",
        // "cross section MKX snow mixing ratio",
        // "cross section MKX total condensate",
        // "cross section MKX wind",
        // "cross section SEA cloud water mixing ratio",
        // "cross section SEA rain mixing ratio",
        // "cross section SEA graupel mixing ratio",
        // "cross section SEA snow mixing ratio",
        // "cross section SEA total condensate",
        // "cross section SEA wind",
        // "cross section MIA cloud water mixing ratio",
        // "cross section MIA rain mixing ratio",
        // "cross section MIA graupel mixing ratio",
        // "cross section MIA snow mixing ratio",
        // "cross section MIA total condensate",
        // "cross section MIA wind",
        // "cross section ATL cloud water mixing ratio",
        // "cross section ATL rain mixing ratio",
        // "cross section ATL graupel mixing ratio",
        // "cross section ATL snow mixing ratio",
        // "cross section ATL total condensate",
        // "cross section ATL wind",
        // "cross section BOS cloud water mixing ratio",
        // "cross section BOS rain mixing ratio",
        // "cross section BOS graupel mixing ratio",
        // "cross section BOS snow mixing ratio",
        // "cross section BOS total condensate",
        // "cross section BOS wind",
        // "cross section NYC cloud water mixing ratio",
        // "cross section NYC rain mixing ratio",
        // "cross section NYC graupel mixing ratio",
        // "cross section NYC snow mixing ratio",
        // "cross section NYC total condensate",
        // "cross section NYC wind",

    };

    public const string[] modelRapParams = {
        "cref_full_sfc",
        "cape_full_sfc",
        "cin_full_sfc",
        "cape_full_mx90mb",
        "cape_full_mu",
        "cape_full_mul",
        "wspeed_full_10m",
        "wspeed_full_80m",
        "gust_full_10m",
        "temp_full_sfc",
        "temp_full_2m",
        "ptmp_full_2m",
        "temp_full_2ds",
        "dewp_full_2m",
        "rh_full_2m",
        "pwtr_full_sfc",
        "weasd_full_sfc",
        "1hsnw_full_sfc",
        "acsnw_full_sfc",
        "totp_full_sfc",
        "acpcp_full_sfc",
        "ptyp_full_sfc",
        "temp_full_925mb",
        "temp_full_850mb",
        "wspeed_full_850mb",
        "rh_full_850mb",
        "rh_full_mean",
        "temp_full_700mb",
        "vvel_full_700mb",
        "temp_full_500mb",
        "vort_full_500mb",
        "wspeed_full_250mb",
        "vis_full_sfc",
        "ctop_full",
        "ceil_full",
        "vil_full_sfc",
        "rvil_full_sfc",
        "cloudcover_full_total",
        "cloudcover_full_low",
        "cloudcover_full_mid",
        "cloudcover_full_high",
        "solar_full_sfc",
        "hpbl_full_sfc",
        "soilt_full_1cm",
        "soilt_full_4cm",
        "soilt_full_10cm",
        "soilw_full_1cm",
        "soilw_full_4cm",
        "soilw_full_10cm",
    };

    public const string[] modelRapLabels = {
        "reflectivity",
        "surface CAPE",
        "surface CIN",
        "mixed CAPE",
        "most unstable CAPE",
        "most unstable layer CAPE",
        // "lightning potential",
        "10m wind",
        "80m wind",
        // "1h 80m wind speed change",
        "10m wind gust potential",
        "skin temp",
        "2m temp",
        "2m potential temp",
        "2m temp - skin temp",
        "2m dew point",
        "2m RH",
        // "3h pressure change",
        "precipitable water",
        "snow water equiv",
        "1h snowfall",
        "total acc snowfall",
        // "snow depth",
        "1h precip",
        "total acc precip",
        "precip type",
        // "total acc freezing rain",
        // "total acc graupel (sleet)",
        "925mb temp",
        "850mb temp",
        "850mb wind",
        "850 RH",
        "850-500mb mean RH",
        // "RH with respect to PW",
        "700mb temp",
        "700mb vvel",
        "500mb temp",
        "500mb vort",
        "250mb wind",
        "visibility",
        "cloud top height",
        "convective cloud top height",
        "ceiling",
        // "ceiling (experimental)",
        // "ceiling (experimental-2)",
        // "echotop height",
        "VIL",
        // "RADAR VIL",
        "total cloud cover",
        "low-level cloud cover",
        "mid-level cloud cover",
        "high-level cloud cover",
        // "boundary layer cloud cover",
        // "aviation flight rules",
        // "outgoing longwave radiation (top of atmosphere)",
        // "outgoing shortwave radiation (top of atmosphere)",
        // "upward longwave radiation (surface)",
        // "upward shortwave radiation (surface)",
        "incoming shortwave radiation (surface)",
        // "fog",
        // "sfc ozone concentration",
        // "sfc pm10 aerosol dry mass",
        // "sfc pm2.5 aerosol dry mass",
        // "downward long-wave radiation",
        // "downward short-wave radiation",
        // "ground heat flux",
        // "latent heat flux",
        // "sensible heat flux",
        "PBL height",
        "soil temp at 1cm",
        "soil temp at 4cm",
        "soil temp at 10cm",
        // "soil moisture at sfc",
        "soil moisture at 1cm",
        "soil moisture at 4cm",
        "soil moisture at 10cm",
    };
}
