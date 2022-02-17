// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityModelSpcSrefInterface {

    public const string[] paramCodes = {
        "SREF_PROB_TRW_CALIBRATED_HRLY__",
        "SREF_03HR_SVR_PROBS__",
        "SREF_03HR_SVR_PROBS_CONDITIONAL__",
        "SREF_PROB_TRW_CALIBRATED_DRY_ONLY__",
        "SREF_03HR_DEN100_PROBS__",
        "SREF_PROB_TRW_CALIBRATED_12HR__",
        "SREF_12HR_SVR_PROBS__",
        "SREF_PROB_TRW_CALIBRATED_24HR__",
        "SREF_24HR_SVR_PROBS__",
        "SREF_ROADSNOW_CON_NORMALIZED__",
        "SREF_ROADSNOW_06__",
        "SREF_500MB-HGHT_VORT__",
        "SREF_H5__",
        "SREF_500MB-HGHT_MEAN_SD__",
        "SREF_Spaghetti_H5_5460__",
        "SREF_Spaghetti_H5_5580__",
        "SREF_Spaghetti_H5_5700__",
        "SREF_Spaghetti_H5_5820__",
        "SREF_500MB-TEMP_MEAN_SD__",
        "SREF_Spaghetti_H5_M15__",
        "SREF_Spaghetti_H5_M20__",
        "SREF_Spaghetti_H5_M25__",
        "SREF_700MB-HGHT_MEAN_SD__",
        "SREF_700MB-TEMP_MEAN_SD__",
        "SREF_Spaghetti_H7_10__",
        "SREF_Spaghetti_H7_15__",
        "SREF_H8__",
        "SREF_850MB-TEMP_MEAN_SD__",
        "SREF_PMSL_1000-500_THK_BLW_",
        "SREF_PMSL_MEAN_SD_",
        "SREF_Spaghetti_Low_Centers__",
        "SREF_Spaghetti_High_Centers__",
        "SREF_TMPF_MAX_",
        "SREF_Mean_Temp_",
        "SREF_meanpcp_pcvv_thck_omega_3hr_",
        "SREF_2M_DWPT_F_",
        "SREF_2M-DWPF_MEDIAN_MXMN__",
        "SREF_2M-DWPF_MEAN_SD__",
        "SREF_prob_2mdewpt_50F__",
        "SREF_prob_2mdewpt_55F__",
        "SREF_prob_2mdewpt_60F__",
        "SREF_prob_2mdewpt_65F__",
        "SREF_prob_2mdewpt_70F__",
        "SREF_Spaghetti_2m_dewpt_50__",
        "SREF_Spaghetti_2m_dewpt_55__",
        "SREF_Spaghetti_2m_dewpt_60__",
        "SREF_Spaghetti_2m_dewpt_65__",
        "SREF_Spaghetti_2m_dewpt_70__",
        "SREF_pwat_mean_",
        "SREF_pwat_median_mxmn__",
        "SREF_Spaghetti_pwat_1in__",
        "SREF_Spaghetti_pwat_1.5in__",
        "SREF_prob_MLLCL_750__",
        "SREF_prob_MLLCL_1000__",
        "SREF_prob_MLLCL_1250__",
        "SREF_prob_MLLCL_1500__",
        "SREF_850MB-DWPC_MEAN_SD__",
        "SREF_700MB-DWPC_MEAN_SD__",
        "SREF_SFCLI_MEDIAN_MXMN__",
        "SREF_SFC_LI_",
        "SREF_prob_lift_0__",
        "SREF_prob_lift_2__",
        "SREF_prob_lift_4__",
        "SREF_prob_lift_6__",
        "SREF_SFCCAPE_MEDIAN_MXMN__",
        "SREF_prob_sfccape_250__",
        "SREF_prob_sfccape_500__",
        "SREF_prob_sfccape_1000__",
        "SREF_prob_sfccape_2000__",
        "SREF_prob_sfccape_3000__",
        "SREF_mlcape_MEDIAN_MXMN__",
        "SREF_prob_mlcape_500__",
        "SREF_prob_mlcape_1000__",
        "SREF_prob_mlcape_2000__",
        "SREF_prob_mlcape_3000__",
        "SREF_hicape_MEDIAN_MXMN__",
        "SREF_LPL__",
        "SREF_prob_hicape_50__",
        "SREF_prob_hicape_100__",
        "SREF_prob_hicape_250__",
        "SREF_prob_hicape_500__",
        "SREF_prob_hicape_1000__",
        "SREF_prob_hicape_2000__",
        "SREF_prob_hicape_3000__",
        "SREF_Spaghetti_MUCAPE_100__",
        "SREF_Spaghetti_MUCAPE_250__",
        "SREF_Spaghetti_MUCAPE_500__",
        "SREF_Spaghetti_MUCAPE_1000__",
        "SREF_dcape_MEDIAN_MXMN__",
        "SREF_prob_dcape_1000__",
        "SREF_prob_dcape_1500__",
        "SREF_prob_dcape_2000__",
        "SREF_prob_teql_m15__",
        "SREF_prob_teql_m20__",
        "SREF_prob_cptp_1__",
        "SREF_prob_H7_to_H5_LapseRate_7__",
        "SREF_prob_H7_to_H5_LapseRate_8__",
        "SREF_prob_mistab_650-900mb__",
        "SREF_wind_vector_10m_",
        "SREF_wind_vector_300mb_",
        "SREF_wind_vector_500mb_",
        "SREF_wind_vector_700mb_",
        "SREF_wind_vector_850mb_",
        "SREF_300MB-WSPD_MEAN_SD__",
        "SREF_300MB-WSPD_MEDIAN_MXMN__",
        "SREF_500MB-WSPD_MEAN_SD__",
        "SREF_500MB-WSPD_MEDIAN_MXMN__",
        "SREF_Spaghetti_H5_WSPD_50__",
        "SREF_Spaghetti_H5_WSPD_70__",
        "SREF_850MB-WSPD_MEDIAN_MXMN__",
        "SREF_0-6KMSHR_SSB_MEDIAN_MXMN__",
        "SREF_prob_10m_to_6km_shear_30kt__",
        "SREF_prob_10m_to_6km_shear_40kt__",
        "SREF_prob_10m_to_6km_shear_50kt__",
        "SREF_Spaghetti_6KM_shear_40__",
        "SREF_ESHR_SSB_MEDIAN_MXMN__",
        "SREF_prob_ESHR_30kt__",
        "SREF_prob_ESHR_40kt__",
        "SREF_prob_ESHR_50kt__",
        "SREF_Spaghetti_ESHR_40__",
        "SREF_1KMHEL_SSB_MEDIAN_MXMN__",
        "SREF_prob_SSB_1kmHel_50__",
        "SREF_prob_SSB_1kmHel_100__",
        "SREF_prob_SSB_1kmHel_150__",
        "SREF_Spaghetti_0-1KM_SSB_Hel_100__",
        "SREF_Spaghetti_0-1KM_SSB_Hel_200__",
        "SREF_3KMHEL_SSB_MEDIAN_MXMN__",
        "SREF_prob_SSB_3kmHel_100__",
        "SREF_prob_SSB_3kmHel_200__",
        "SREF_prob_SSB_3kmHel_300__",
        "SREF_Spaghetti_0-3KM_SSB_Hel_150__",
        "SREF_Spaghetti_0-3KM_SSB_Hel_300__",
        "SREF_prob_H7_omega_3__",
        "SREF_prob_H7_omega_6__",
        "SREF_prob_H7_omega_9__",
        "SREF_front_MEAN_ONLY_",
        "SREF_front_mpv_mean2__",
        "SREF_front_mpv_mean1__",
        "SREF_prob_front_650-900mb__",
        "SREF_prob_front_mpv_2__",
        "SREF_prob_front_mpv_1__",
        "SREF_prob_front_mpv_3__",
        "SREF_precip_MAX_3hr_",
        "SREF_3HRTOTPCPN_MEDIAN_MXMN__",
        "SREF_meanpcp_pcvv_thck_omega_3hr_",
        "SREF_medpcp_pcvv_thck_omega_3hr_",
        "SREF_prmnpcp_pcvv_thck_omega_3hr_",
        "SREF_prob_totpcpn_0.01_3hr__",
        "SREF_prob_totpcpn_0.05_3hr__",
        "SREF_prob_totpcpn_0.10_3hr__",
        "SREF_prob_totpcpn_0.25_3hr__",
        "SREF_prob_totpcpn_0.50_3hr__",
        "SREF_prob_unscaled_combined_CPTP_P03M_",
        "SREF_Spaghetti_p03m_.01__",
        "SREF_Spaghetti_p03m_.10__",
        "SREF_3HRCONPCPN_MEDIAN_MXMN__",
        "SREF_prob_conpcpn_0.01_3hr__",
        "SREF_prob_conpcpn_0.05_3hr__",
        "SREF_prob_conpcpn_0.10_3hr__",
        "SREF_prob_conpcpn_0.25_3hr__",
        "SREF_prob_conpcpn_0.50_3hr__",
        "SREF_Spaghetti_c03m_.01__",
        "SREF_Spaghetti_c03m_.10__",
        "SREF_precip_MAX_6hr_",
        "SREF_prob_totpcpn_0.01_6hr__",
        "SREF_prob_totpcpn_0.10_6hr__",
        "SREF_prob_totpcpn_0.25_6hr__",
        "SREF_prob_totpcpn_0.50_6hr__",
        "SREF_prob_totpcpn_1.00_6hr__",
        "SREF_precip_MAX_12hr_",
        "SREF_prob_totpcpn_0.01_12hr__",
        "SREF_prob_totpcpn_0.10_12hr__",
        "SREF_prob_totpcpn_0.25_12hr__",
        "SREF_prob_totpcpn_0.50_12hr__",
        "SREF_prob_totpcpn_1.00_12hr__",
        "SREF_prob_totpcpn_2.00_12hr__",
        "SREF_prob_totpcpn_3.00_12hr__",
        "SREF_precip_MAX_24hr_",
        "SREF_prob_totpcpn_0.01_24hr__",
        "SREF_prob_totpcpn_0.10_24hr__",
        "SREF_prob_totpcpn_0.25_24hr__",
        "SREF_prob_totpcpn_0.50_24hr__",
        "SREF_prob_totpcpn_1.00_24hr__",
        "SREF_prob_totpcpn_2.00_24hr__",
        "SREF_prob_totpcpn_3.00_24hr__",
        "SREF_CB_MEDIAN_MXMN__",
        "SREF_prob_cbsigsvr_10000__",
        "SREF_prob_cbsigsvr_20000__",
        "SREF_prob_cbsigsvr_40000__",
        "SREF_prob_cbsigsvr_60000__",
        "SREF_Spaghetti_CBSS_10000__",
        "SREF_Spaghetti_CBSS_20000__",
        "SREF_prob_combined_0.01_30_500__",
        "SREF_prob_combined_0.01_40_500__",
        "SREF_prob_combined_0.01_30_1000__",
        "SREF_prob_combined_0.01_40_1000__",
        "SREF_prob_combined_0.01_30_2000__",
        "SREF_prob_combined_0.01_40_2000__",
        "SREF_prob_combined_0.01_ESHR30_500__",
        "SREF_prob_combined_0.01_ESHR40_500__",
        "SREF_prob_combined_0.01_ESHR30_1000__",
        "SREF_prob_combined_0.01_ESHR40_1000__",
        "SREF_prob_combined_0.01_ESHR30_2000__",
        "SREF_prob_combined_0.01_ESHR40_2000__",
        "SREF_prob_combined_0.01_ESHR20_3000__",
        "SREF_prob_combined_0.01_DCAPE1000_1000__",
        "SREF_prob_combined_0.01_DCAPE2000_1000__",
        "SREF_prob_combined_0.01_DCAPELCL1000_1000__",
        "SREF_SUPERCELL__",
        "SREF_EFF_SUPERCELL__",
        "SREF_SCCP_MEDIAN_MXMN__",
        "SREF_prob_supercomp_1__",
        "SREF_prob_supercomp_3__",
        "SREF_prob_supercomp_6__",
        "SREF_Spaghetti_SCCP_1__",
        "SREF_Spaghetti_SCCP_3__",
        "SREF_prob_combined_supercell__",
        "SREF_SIGTOR_MEDIAN_MXMN__",
        "SREF_prob_sigtor_1__",
        "SREF_prob_sigtor_3__",
        "SREF_prob_sigtor_5__",
        "SREF_prob_combined_sigtor__",
        "SREF_Spaghetti_SigTor_1__",
        "SREF_Spaghetti_SigTor_2__",
        "SREF_derecho_MEDIAN_MXMN__",
        "SREF_prob_derecho_1__",
        "SREF_prob_derecho_3__",
        "SREF_prob_derecho_5__",
        "SREF_prob_combined_derecho__",
        "SREF_Spaghetti_derecho_1__",
        "SREF_850MB-TEMP_MEAN_SD__",
        "SREF_Spaghetti_H8_0__",
        "SREF_prob_H8_TM2__",
        "SREF_prob_H8_T0__",
        "SREF_prob_H8_T2__",
        "SREF_700MB-TEMP_MEAN_SD__",
        "SREF_prob_Thck_528__",
        "SREF_prob_Thck_534__",
        "SREF_prob_Thck_540__",
        "SREF_SNOWFALL_MAX_",
        "SREF_SNOWFALL_MEAN_",
        "SREF_SNOWFALL_PMMEAN_",
        "SREF_SNOWFALL_MEAN6HR_",
        "SREF_SNOWFALL_MEAN12HR_",
        "SREF_snowfall_ratio__",
        "SREF_SNOWRATE_1INCH__",
        "SREF_SNOWRATE_2INCH__",
        "SREF_SNOWRATE_3INCH__",
        "SREF_ZR_0.05INCH__",
        "SREF_ZR_CHANGE_ZR__",
        "SREF_RN_CHANGE_ZR__",
        "SREF_ZR_CHANGE_RN__",
        "SREF_DEND_MEDIAN_MDXN__",
        "SREF_prob_dend_50__",
        "SREF_prob_dend_100__",
        "SREF_LIKELY__",
        "SREF_LIKELY_CZYS__",
        "SREF_prob_liquid_precip_01__",
        "SREF_prob_liquid_conditional__",
        "SREF_prob_snow_precip_01__",
        "SREF_prob_snow_conditional__",
        "SREF_prob_ip_precip_01__",
        "SREF_prob_ip_conditional__",
        "SREF_prob_zr_precip_01__",
        "SREF_prob_zr_conditional__",
        "SREF_prob_front_mpv_2__",
        "SREF_prob_front_mpv_1__",
        "SREF_prob_front_mpv_3__",
        "SREF_Mean_Temp_",
        "SREF_Prob_Temp_60__",
        "SREF_FIRE_DWPF_MAX__",
        "SREF_FIRE_DWPF_MIN__",
        "SREF_FIRE_DWPF_MEDIAN_MXMN__",
        "SREF_FIRE_DWPF_MEAN_",
        "SREF_prob_DWPF_LE15__",
        "SREF_prob_DWPF_LE25__",
        "SREF_prob_DWPF_LE35__",
        "SREF_prob_DWPF_LE45__",
        "SREF_RH_MIN_",
        "SREF_2M_RH_MEAN_SD_FIRE__",
        "SREF_prob_FIRE_relh_lt10__",
        "SREF_prob_FIRE_relh_lt15__",
        "SREF_prob_FIRE_relh_lt20__",
        "SREF_prob_FIRE_relh_lt25__",
        "SREF_prob_FIRE_relh_lt30__",
        "SREF_prob_totpcpn_lt_0.01_3hr__",
        "SREF_prob_totpcpn_lt_0.05_3hr__",
        "SREF_prob_totpcpn_lt_0.10_3hr__",
        "SREF_prob_totpcpn_lt_0.01_12hr__",
        "SREF_prob_totpcpn_lt_0.10_12hr__",
        "SREF_10M_WIND_MAX__",
        "SREF_10M_WIND_MEAN__",
        "SREF_prob_FIRE_10mWSPD_10__",
        "SREF_prob_FIRE_10mWSPD_20__",
        "SREF_prob_FIRE_10mWSPD_30__",
        "SREF_FOSBERG_MAX__",
        "SREF_FOSBERG_MEDIAN_MXMN__",
        "SREF_FOSBERG_MEAN_ONLY_",
        "SREF_prob_FIRE_fosb_50__",
        "SREF_prob_FIRE_fosb_60__",
        "SREF_prob_FIRE_fosb_70__",
        "SREF_HAINES_MEDIAN_MXMN__",
        "SREF_prob_FIRE_HAINES_5__",
        "SREF_SMLCOMBO_WSPD20_RH15__",
        "SREF_COMBO_WSPD15_RH15__",
        "SREF_COMBO_WSPD15_RH20__",
        "SREF_COMBO_WSPD15_RH25__",
        "SREF_COMBO_WSPD15_RH30__",
        "SREF_COMBO_WSPD20_RH10__",
        "SREF_COMBO_WSPD20_RH15__",
        "SREF_COMBO_WSPD20_RH20__",
        "SREF_COMBO_WSPD20_RH30__",
        "SREF_COMBO_WSPD20_RH35__",
        "SREF_COMBO_WSPD30_RH10__",
        "SREF_COMBO_WSPD30_RH15__",
        "SREF_COMBO_WSPD30_RH20__",
        "SREF_maxtop_max_",
        "SREF_maxtop_median_",
        "SREF_maxtop_",
        "SREF_maxtop_totalprob_low_",
        "SREF_maxtop_totalprob_mid_",
        "SREF_maxtop_totalprob_high_",
        "SREF_maxtop_prob_low_",
        "SREF_maxtop_prob_mid_",
        "SREF_maxtop_prob_high_"
    };

    public const string[] labels = {
        "{PR}:3hr Calibrated Thunderstorm",
        "{PR}:3hr Calibrated Severe Thunderstorm",
        "{PR}:3hr Calibrated Conditional Severe Tstm",
        "{PR}:3hr Dry Thunderstorm Potential",
        "{PR}:3hr Calibrated Tstm >=100 CG Strikes",
        "{PR}:12hr Calibrated Thunderstorm",
        "{PR}:12hr Calibrated Severe Thunderstorm",
        "{PR}:24hr Calibrated Thunderstorm",
        "{PR}:24hr Calibrated Severe Thunderstorm",
        "{PR}:3Hr New Snow on Roads (rel to normal)",
        "{PR}:6Hr Calibrated New Snow on Roads",
        "{MN}:500MB Height~Absolute_Vorticity",
        "{MN}:500MB Height~Wind~Temp~Isotach",
        "{MNSD}:500MB_Height",
        "{SP}:500MB_Height_5460m",
        "{SP}:500MB_Height_5580m",
        "{SP}:500MB_Height_5700m",
        "{SP}:500MB_Height_5820m",
        "{MNSD}:500MB_Temp",
        "{SP}:500MB_Temp_-15C",
        "{SP}:500MB_Temp_-20C",
        "{SP}:500MB_Temp_-25C",
        "{MNSD}:700MB_Height",
        "{MNSD}:700MB_Temp",
        "{SP}:700MB_Temp_+10C",
        "{SP}:700MB_Temp_+15C",
        "{MN}:850MB_Height~Wind~Temp~Isotach",
        "{MNSD}:850MB_Temp",
        "{MN}:PMSL~Thickness~10m_Wind",
        "{MNSD}:Sea_Level_Pres",
        "{SP}:PMSL_Low_Centers",
        "{SP}:PMSL_High_Centers",
        "{MAX}:2m_Temp",
        "{MN}:2m_Temp",
        "{MN}:700-500_UVV~3hr_QPF",
        "{MN}:2M_Dewpoint(F)",
        "{MDXN}:2M_DewPoint",
        "{MNSD}:2_Meter_DewPoint",
        "{PR}:2m_DewPoint_>=50F",
        "{PR}:2m_DewPoint_>=55F",
        "{PR}:2m_Dewpoint_>=60F",
        "{PR}:2m_Dewpoint_>=65F",
        "{PR}:2m_Dewpoint_>=70F",
        "{SP}:2m_DewPoint_50F",
        "{SP}:2m_DewPoint_55F",
        "{SP}:2m_DewPoint_60F",
        "{SP}:2m_DewPoint_65F",
        "{SP}:2m_DewPoint_70F",
        "{MN}:Precipitable_Water",
        "{MDXN}:Precipitable_Water",
        "{SP}:Precipitable_Water_1.0in",
        "{SP}:Precipitable_Water_1.5in",
        "{PR}:Mixed_Layer_LCL<=750m",
        "{PR}:Mixed_Layer_LCL<=1000m",
        "{PR}:Mixed_Layer_LCL<=1250m",
        "{PR}:Mixed_Layer_LCL<=1500m",
        "{MNSD}:850MB_DewPoint",
        "{MNSD}:700MB_DewPoint",
        "{MDXN}:Surface_L",
        "{MN}:Surface_LI",
        "{PR}:Surface_LI_<=0",
        "{PR}:Surface_LI_<=-2",
        "{PR}:Surface_LI_<=-4",
        "{PR}:Surface_LI_<=-6",
        "{MDXN}:Surface_CAPE",
        "{PR}:Surface_Cape_>=250",
        "{PR}:Surface_Cape_>=500",
        "{PR}:Surface_Cape_>=1000",
        "{PR}:Surface_Cape_>=2000",
        "{PR}:Surface_Cape_>=3000",
        "{MDXN}:Mixed_Layer_CAPE",
        "{PR}:Mixed_Layer_CAPE_>=500",
        "{PR}:Mixed_Layer_CAPE_>=1000",
        "{PR}:Mixed_Layer_CAPE_>=2000",
        "{PR}:Mixed_Layer_CAPE_>=3000",
        "{MDXN}:Most_Unstable_CAPE",
        "{MN}:MUCAPE_and_MULPL(MB_AGL)",
        "{PR}:Most_Unstable_CAPE_>=50",
        "{PR}:Most_Unstable_CAPE_>=100",
        "{PR}:Most_Unstable_CAPE_>=250",
        "{PR}:Most_Unstable_CAPE_>=500",
        "{PR}:Most_Unstable_CAPE_>=1000",
        "{PR}:Most_Unstable_CAPE_>=2000",
        "{PR}:Most_Unstable_CAPE_>=3000",
        "{SP}:Most_Unstable_CAPE_100",
        "{SP}:Most_Unstable_CAPE_250",
        "{SP}:Most_Unstable_CAPE_500",
        "{SP}:Most_Unstable_CAPE_1000",
        "{MDXN}:Downdraft_CAPE",
        "{PR}:Downdraft_CAPE_>=1000",
        "{PR}:Downdraft_CAPE_>=1500",
        "{PR}:Downdraft_CAPE_>=2000",
        "{PR}:Equilibrium_Level_Temp_<=-15C",
        "{PR}:Equilibrium_Lvl_Temp_<=-20C",
        "{PR}:Cloud_Physics_Thunder_Param_>=1",
        "{PR}:700-500MB_Lapse_rate_>=7.0",
        "{PR}:700-500MB_Lapse_rate_>=8.0",
        "{PR}:MPV_900-650mb_<=0.05",
        "{MN}:Vector_Wind_10m",
        "{MN}:Vector_Wind_300mb",
        "{MN}:Vector_Wind_500mb",
        "{MN}:Vector_Wind_700mb",
        "{MN}:Vector_Wind_850mb",
        "{MNSD}:300MB_Wind_Speed",
        "{MDXN}:300MB_Wind_Speed",
        "{MNSD}:500MB_Wind_Speed",
        "{MDXN}:500MB_Wind_Speed",
        "{SP}:500MB_Wind_Speed_50kts",
        "{SP}:500MB_Wind_Speed_70kts",
        "{MDXN}:850MB_Wind_Speed",
        "{MDXN}:0-6KM_Bulk_Shear",
        "{PR}:0-6km_Bulk_Shear_>=30kts",
        "{PR}:0-6km_Bulk_Shear_>=40kts",
        "{PR}:0-6km_Bulk_Shear_>=50kts",
        "{SP}:0-6KM_Bulk_Shear_40KTS",
        "{MDXN}:Effective_Bulk_Shear",
        "{PR}:Effective_Bulk_Shear_>=30kts",
        "{PR}:Effective_Bulk_Shear_>=40kts",
        "{PR}:Effective_Bulk_Shear_>=50kts",
        "{SP}:Effective_Bulk_Shear_40KTS",
        "{MDXN}:0-1KM_Helicity",
        "{PR}:1KM_Helicity_>=50m2s-2",
        "{PR}:1KM_Helicity_>=100m2s-2",
        "{PR}:1KM_Helicity_>=150m2s-2",
        "{SP}:0-1KM_Helicity_100m2s-2",
        "{SP}:0-1KM_Helicity_200m2s-2",
        "{MDXN}:0-3KM_Helicity",
        "{PR}:3KM_Helicity_>=100m2s-2",
        "{PR}:3KM_Helicity_>=200m2s-2",
        "{PR}:3KM_Helicity_>=300m2s-2",
        "{SP}:0-3KM_Helicity_150m2s-2",
        "{SP}:0-3KM_Helicity_300m2s-2",
        "{PR}:700mb_Omega_<=-3",
        "{PR}:700mb_Omega_<=-6",
        "{PR}:700mb_Omega_<=-9",
        "{MN}:Frontogenesis_900-650mb_layer",
        "{MN}:Frontogenesis_and_MPV_850mb",
        "{MN}:Frontogenesis_and_MPV_700mb",
        "{PR}:Front_900-650mb_layer>=0.1K",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_850mb",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_700mb",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_900-650mb",
        "{MAX}:3hr_total_pcpn",
        "{MDXN}:3hr_total_pcpn",
        "{MN}:700-500_UVV~3hr_mean_QPF",
        "{MD}:700-500_UVV~3hr_median_QPF",
        "{PM}:700-500_UVV~3hr_prob_match_QPF",
        "{PR}:3hr_total_pcpn_>=0.01in",
        "{PR}:3hr_total_pcpn_>=0.05in",
        "{PR}:3hr_total_pcpn_>=0.10in",
        "{PR}:3hr_total_pcpn_>=0.25in",
        "{PR}:3hr_total_pcpn_>=0.50in",
        "{PR}:CPTP_>=1_and_3hr_pcpn_>=0.01in",
        "{SP}:3hr_total_pcpn_0.01in",
        "{SP}:3hr_total_pcpn_0.10in",
        "{MDXN}:3hr_convective_pcpn",
        "{PR}:3hr_convective_pcpn_>=_0.01in",
        "{PR}:3hr_convective_pcpn_>=_0.05in",
        "{PR}:3hr_convective_pcpn_>=_0.10in",
        "{PR}:3hr_convective_pcpn_>=_0.25in",
        "{PR}:3hr_convective_pcpn_>=_0.50in",
        "{SP}:3hr_convective_pcpn_0.01in",
        "{SP}:3hr_convective_pcpn_0.10in",
        "{MAX}:6hr_total_pcpn",
        "{PR}:6hr_total_pcpn_>=0.01in",
        "{PR}:6hr_total_pcpn_>=0.10in",
        "{PR}:6hr_total_pcpn_>=0.25in",
        "{PR}:6hr_total_pcpn_>=0.50in",
        "{PR}:6hr_total_pcpn_>=1.00in",
        "{MAX}:12hr_total_pcpn",
        "{PR}:12hr_total_pcpn_>=0.01in",
        "{PR}:12hr_total_pcpn_>=0.10in",
        "{PR}:12hr_total_pcpn_>=0.25in",
        "{PR}:12hr_total_pcpn_>=0.50in",
        "{PR}:12hr_total_pcpn_>=1.00in",
        "{PR}:12hr_total_pcpn_>=2.00in",
        "{PR}:12hr_total_pcpn_>=3.00in",
        "{MAX}:24hr_total_pcpn",
        "{PR}:24hr_total_pcpn_>=0.01in",
        "{PR}:24hr_total_pcpn_>=0.10in",
        "{PR}:24hr_total_pcpn_>=0.25in",
        "{PR}:24hr_total_pcpn_>=0.50in",
        "{PR}:24hr_total_pcpn_>=1.00in",
        "{PR}:24hr_total_pcpn_>=2.00in",
        "{PR}:24hr_total_pcpn_>=3.00in",
        "{MDXN}:CravenBrooks_Significant_Severe",
        "{PR}:CravenBrooks_Significant_Severe_>=10000",
        "{PR}:CravenBrooks_Significant_Severe_>=20000",
        "{PR}:CravenBrooks_Significant_Severe_>=40000",
        "{PR}:CravenBrooks_Significant_Severe_>=60000",
        "{SP}:CravenBrooks_Significant_Severe_10000",
        "{SP}:CravenBrooks_Significant_Severe_20000",
        "{PR}:MUCAPE>=500&0-6Shr>=30&C03I>=.01",
        "{PR}:MUCAPE>=500&0-6Shr>=40&C03I>=.01",
        "{PR}:MUCAPE>=1000&0-6Shr>=30&C03I>=.01",
        "{PR}:MUCAPE>=1000&0-6Shr>=40&C03I>=.01",
        "{PR}:MUCAPE>=2000&0-6Shr>=30&C03I>=.01",
        "{PR}:MUCAPE>=2000&0-6Shr>=40&C03I>=.01",
        "{PR}:MUCAPE>=500&EShear>=30&C03I>=.01",
        "{PR}:MUCAPE>=500&EShear>=40&C03I>=.01",
        "{PR}:MUCAPE>=1000&EShear>=30&C03I>=.01",
        "{PR}:MUCAPE>=1000&EShear>=40&C03I>=.01",
        "{PR}:MUCAPE>=2000&EShear>=30&C03I>=.01",
        "{PR}:MUCAPE>=2000&EShear>=40&C03I>=.01",
        "{PR}:MUCAPE>=3000&EShear>=20&C03I>=.01",
        "{PR}:MUCAPE>=1000&DCAPE>=1000&C03I>=.01",
        "{PR}:MUCAPE>=1000&DCAPE>=2000&C03I>=.01",
        "{PR}:MUCAPE>=1000&DCAPELCL>=1000&C03I>=.01",
        "{MN}:Supercell_Composite(0-500mb_bulk_shear)",
        "{MN}:Supercell_Composite(effective_bulk_shear)",
        "{MDXN}:Supercell_Composite_Parameter",
        "{PR}:Supercell_Composite_Parameter_>=1",
        "{PR}:Supercell_Composite_Parameter_>=3",
        "{PR}:Supercell_Composite_Parameter_>=6",
        "{SP}:Supercell_Composite_Parameter_1",
        "{SP}:Supercell_Composite_Parameter_3",
        "{PR}:Supercell_Parameter_>=1_&_pcpn_>=0.01",
        "{MDXN}:Significant_Tornado_Parameter",
        "{PR}:Significant_Tornado_Parameter_>=1",
        "{PR}:Significant_Tornado_Parameter_>=3",
        "{PR}:Significant_Tornado_Parameter_>=5",
        "{PR}:Significant_Tornado_Ingredients",
        "{SP}:Significant_Tornado_Parameter_1",
        "{SP}:Significant_Tornado_Parameter_2",
        "{MDXN}:Derecho_Parameter",
        "{PR}:Derecho_Parameter_>=_1",
        "{PR}:Derecho_Parameter_>=_3",
        "{PR}:Derecho_Parameter_>=_5",
        "{PR}:Derecho_Param_>=1_&_C03I_>=0.01",
        "{SP}:Derecho_Parameter_1",
        "{MNSD}:850MB_Temp",
        "{SP}:850MB_Temp_0C_Isotherm",
        "{PR}:850MB_Temp_<=-2C",
        "{PR}:850MB_Temp_<=0C",
        "{PR}:850MB_Temp_<=+2C",
        "{MNSD}:700MB_Temp",
        "{PR}:1000-500MB_Thickness_<=5280m",
        "{PR}:1000-500MB_Thickness_<=5340m",
        "{PR}:1000-500MB_Thickness_<=5400m",
        "{MAX}:3hr_Snowfall(inches)",
        "{MN}:3hr_Snowfall(inches)",
        "{PM}:3hr_Snowfall(inches)",
        "{MN}:6hr_Snowfall(inches)",
        "{MN}:12hr_Snowfall(inches)",
        "{MN}:Snowfall_Ratio(Snow:Liquid_Eqv)",
        "{PR}:Snowfall_Rate_>=1in(perhr)",
        "{PR}:Snowfall_Rate_>=2in(perhr)",
        "{PR}:Snowfall_Rate_>=3in(perhr)",
        "{PR}:Freezing_Rain_Rate_>=0.05_in(per3hr)",
        "{PR}:Freezing_Rain_lasting_>=3hrs",
        "{PR}:Rain_Change_to_Freezing_Rain",
        "{PR}:Freezing_Rain_Change_to_Rain",
        "{MDXN}:Dendritic_Growth_Zone_Depth(mb)",
        "{PR}:Dendritic_Growth_Zone_Depth_>=50mb",
        "{PR}:Dendritic_Growth_Zone_Depth_>=100mb",
        "{MN}:Precipitation_Type_(NCEP_Algorithm)",
        "{MN}:Precipitation_Type_(SPC_Czys_Algorithm)",
        "{PR}:Probability_Rain(All_members)",
        "{CPR}:Cond_Prob_Rain(Given_member_precips)",
        "{PR}:Probability_Snow(All_members)",
        "{CPR}:Cond_Prob_Snow(Given_member_precips)",
        "{PR}:Probability_Ice_Pellets(All_members)",
        "{CPR}:Cond_Prob_IP(Given_member_precips)",
        "{PR}:Probability_Freezing_Rain(All_members)",
        "{CPR}:Cond_Prob_ZR(Given_member_precips)",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_850mb",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_700mb",
        "{PR}:Front_>=0.1_and_MPV_<=0.25_900-650mb",
        "{MN}:2m_Temp",
        "{PR}:2m_Temp_>=60F",
        "{MAX}:2m_DewPoint",
        "{MIN}:2m_DewPoint",
        "{MDXN}:2m_DewPoint",
        "{MN}:2m_DewPoint",
        "{PR}:2m_DewPoint_<=15F",
        "{PR}:2m_DewPoint_<=25F",
        "{PR}:2m_DewPoint_<=35F",
        "{PR}:2m_DewPoint_<=45F",
        "{MIN}:2m_RH",
        "{MNSD}:2m_RH",
        "{PR}:RH_<=10%",
        "{PR}:RH_<=15%",
        "{PR}:RH_<=20%",
        "{PR}:RH_<=25%",
        "{PR}:RH_<=30%",
        "{PR}:Tot_3hr_Pcpn_<=0.01in",
        "{PR}:Tot_3hr_Pcpn_<=0.05in",
        "{PR}:Tot_3hr_Pcpn_<=0.10in",
        "{PR}:Tot_12hr_Pcpn_<=0.01in",
        "{PR}:Tot_12hr_Pcpn_<=0.10in",
        "{MAX}:10m_Wind_Speed",
        "{MN}:10m_Wind_Speed",
        "{PR}:10m_Wind_Speed_>=10mph",
        "{PR}:10m_Wind_Speed_>=20mph",
        "{PR}:10m_Wind_Speed_>=30mph",
        "{MAX}:Fosberg_Fire_Wx_Index",
        "{MDXN}:Fosberg_Fire_Wx_Index",
        "{MN}:Fosberg_Fire_Wx_Index",
        "{PR}:Fosberg_Fire_Wx_Index_>=50",
        "{PR}:Fosberg_Fire_Wx_Index_>=60",
        "{PR}:Fosberg_Fire_Wx_Index_>=70",
        "{MDXN}:Haines_Index",
        "{PR}:Haines_Index_>=5",
        "{PR}:WSPD>=20&RH<=15",
        "{PR}:WSPD>=15&RH<=15&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=15&RH<=20&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=15&RH<=25&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=15&RH<=30&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=20&RH<=10&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=20&RH<=15&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=20&RH<=20&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=20&RH<=30&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=20&RH<=35&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=30&RH<=10&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=30&RH<=15&Temp>=60&P12I<=0.01",
        "{PR}:WSPD>=30&RH<=20&Temp>=60&P12I<=0.01",
        "{MAX}:Convective_Cloud_Top(CCT)",
        "{MD}:Convective_Cloud_Top(CCT)",
        "{MN}:Convective_Cloud_Top(CCT)",
        "{PR}:Probability_CCT_<=31KFT",
        "{PR}:Probability_CCT_31-37KFT",
        "{PR}:Probability_CCT_>37KFT",
        "{CPR}:Conditional_Prob_CCT_<=31KFT",
        "{CPR}:Conditional_Prob_CCT_31-37KFT",
        "{CPR}:Conditional_Prob_CCT_>37KFT"
    };
}
