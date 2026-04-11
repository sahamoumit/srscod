# data-raw/build_datasets.R
# Encodes all major tables from the SRS Causes of Death 2021-2023 report.
# Run this script once to build the package datasets.

library(dplyr)

# ============================================================
# TABLE 1.1 — Sample Units & Population by State/UT
# ============================================================
sample_units <- data.frame(
  state_ut = c("India","Andhra Pradesh","Assam","Bihar","Chhattisgarh",
    "NCT of Delhi","Gujarat","Haryana","Jammu & Kashmir","Jharkhand",
    "Karnataka","Kerala","Madhya Pradesh","Maharashtra","Odisha","Punjab",
    "Rajasthan","Tamil Nadu","Telangana","Uttar Pradesh","Uttarakhand",
    "West Bengal","Arunachal Pradesh","Goa","Himachal Pradesh","Manipur",
    "Meghalaya","Mizoram","Nagaland","Sikkim","Tripura",
    "Andaman & Nicobar Islands","Chandigarh","Dadra & Nagar Haveli",
    "Daman & Diu","Ladakh","Lakshadweep","Puducherry"),
  category = c("National","Bigger","Bigger","Bigger","Bigger","Bigger",
    "Bigger","Bigger","Bigger","Bigger","Bigger","Bigger","Bigger","Bigger",
    "Bigger","Bigger","Bigger","Bigger","Bigger","Bigger","Bigger","Bigger",
    "Smaller","Smaller","Smaller","Smaller","Smaller","Smaller","Smaller",
    "Smaller","Smaller","UT","UT","UT","UT","UT","UT","UT"),
  eag_group = c("National","Other","EAG","EAG","EAG","Other","Other","Other",
    "Other","EAG","Other","Other","EAG","Other","EAG","Other","EAG","Other",
    "Other","EAG","EAG","Other","Other","Other","Other","Other","Other",
    "Other","Other","Other","Other","Other","Other","Other","Other","Other",
    "Other","Other"),
  units_total = c(8839,325,299,330,158,196,476,256,279,210,511,280,448,660,
    405,249,350,544,224,500,374,555,65,95,210,165,130,45,50,65,90,55,40,35,
    25,71,14,55),
  units_rural = c(4960,198,89,200,73,10,231,144,177,91,361,175,285,306,290,
    130,236,235,121,328,195,304,50,45,155,120,95,25,35,50,65,37,5,15,15,49,
    2,18),
  units_urban = c(3879,127,210,130,85,186,245,112,102,119,150,105,163,354,
    115,119,114,309,103,172,179,251,15,50,55,45,35,20,15,15,25,18,35,20,10,
    22,12,37),
  pop_total_000 = c(8810,358,252,412,130,160,465,280,232,180,515,394,445,
    606,387,237,362,568,234,582,342,596,56,94,126,133,92,38,38,73,120,60,
    43,45,33,54,15,53),
  pop_rural_000 = c(6323,275,122,326,78,17,316,208,187,107,421,332,339,389,
    314,160,297,349,164,465,214,450,41,69,96,108,71,26,30,57,103,45,12,30,
    24,47,4,30),
  pop_urban_000 = c(2487,82,130,86,51,143,149,71,45,73,94,62,106,217,74,77,
    65,218,69,116,128,147,15,25,30,25,21,12,8,15,17,15,31,16,9,8,11,24),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 1.2 — VA vs SRS Comparison by Age Group
# ============================================================
va_srs_comparison <- data.frame(
  age_group = c("0-4","05-14","15-29","30-34","35-44","45-54","55-69","70+"),
  eag_srs_pct  = c(11.1, 1.6, 6.3, 2.7, 6.9, 9.0, 26.2, 36.3),
  eag_va_pct   = c(8.7,  1.4, 6.5, 2.8, 7.3, 9.1, 27.4, 36.7),
  other_srs_pct = c(3.9, 1.0, 4.4, 2.4, 6.6, 10.5, 29.0, 42.2),
  other_va_pct  = c(2.8, 0.7, 4.3, 2.4, 6.8, 10.7, 29.6, 42.6),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLES 1.3A / 1.3B / 1.3C — Full cause × age distribution (India, by sex)
# ============================================================
cause_age_distribution <- data.frame(
  cause_group = rep(c(
    "Communicable, maternal, perinatal and nutritional conditions",
    "Acute bacterial sepsis & severe infections","Diarrhoeal diseases",
    "Fever of unknown origin","HIV/AIDS","Malaria","Maternal conditions",
    "Nutritional deficiencies","Other infectious and parasitic diseases",
    "Perinatal conditions","Respiratory infections","Selected tropical diseases",
    "Tuberculosis","Injuries","Injuries of Undetermined intent",
    "Intentional injuries: Other Than Suicide","Intentional injuries: Suicide",
    "Unintentional injuries: Motor Vehicle Accidents",
    "Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Non-Communicable diseases","Cardiovascular diseases","Congenital anomalies",
    "Diabetes mellitus","Digestive diseases","Genito-urinary diseases",
    "Malignant and other Neoplasms","Neuro-psychiatric conditions",
    "Other Non-Communicable Diseases","Respiratory diseases",
    "Symptoms, signs and Ill-defined conditions",
    "Ill-defined/All other symptoms signs and abnormal clinical findings"
  ), 3),
  sex = rep(c("Person","Male","Female"), each = 31),
  overall = c(
    # Person
    23.4,0.5,2.1,4.9,0.1,0.1,0.2,0.3,0.7,2.3,9.3,0.3,2.5,
    9.4,0.1,0.2,2.5,2.9,3.7,
    56.7,31.0,0.4,3.5,5.3,3.0,6.4,0.8,0.5,5.7,
    10.5,10.5,
    # Male
    21.6,0.5,1.7,4.1,0.1,0.1,NA,0.2,0.6,2.3,8.9,0.3,2.8,
    11.3,0.1,0.3,3.0,4.1,3.8,
    58.7,32.4,0.4,3.1,6.7,3.3,6.0,0.8,0.3,5.6,
    8.5,8.5,
    # Female
    25.9,0.5,2.7,6.0,0.1,0.1,0.5,0.4,0.8,2.4,9.9,0.4,2.0,
    6.8,0.1,0.1,1.8,1.2,3.6,
    53.9,29.1,0.4,4.1,3.2,2.6,6.9,0.9,0.7,6.0,
    13.3,13.3
  ),
  age_0_4 = c(
    80.4,4.1,4.4,4.0,0.0,0.2,0.0,0.6,2.1,48.0,16.9,0.2,0.1,
    4.2,0.1,0.1,0.0,0.5,3.5,
    11.1,0.3,6.2,0.0,0.9,0.1,0.4,0.7,1.8,0.6,
    4.3,4.3,
    # Male (proxy same level)
    80.3,4.2,4.1,3.4,0.0,0.2,NA,0.5,1.7,49.5,16.4,0.2,0.1,
    4.3,0.1,0.0,0.0,0.5,3.7,
    11.2,0.3,6.4,0.0,0.9,0.1,0.5,0.7,1.6,0.6,
    4.3,4.3,
    # Female
    80.7,3.9,4.8,4.7,0.0,0.1,0.0,0.7,2.6,46.0,17.5,0.3,0.1,
    4.1,0.1,0.2,0.1,0.5,3.3,
    11.1,0.3,5.9,0.0,0.9,0.1,0.3,0.7,2.1,0.6,
    4.2,4.2
  ),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.1A — Major Cause Groups: India (numbers + percentages)
# ============================================================
major_cause_groups_india <- data.frame(
  cause_group = c("Non-Communicable diseases",
    "Communicable, maternal, perinatal and nutritional conditions",
    "Injuries","Symptoms, signs and Ill-defined conditions"),
  male_n   = c(54901, 20215, 10531, 7938),
  female_n = c(35419, 17042, 4480,  8770),
  person_n = c(90320, 37257, 15011, 16708),
  male_pct   = c(58.7, 21.6, 11.3, 8.5),
  female_pct = c(53.9, 25.9,  6.8, 13.4),
  person_pct = c(56.7, 23.4,  9.4, 10.5),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.1B — Major Cause Groups: EAG+Assam vs Other States
# ============================================================
major_cause_groups_eag <- data.frame(
  group = rep(c("EAG and Assam","Other States"), each = 4),
  cause_group = rep(c("Non-Communicable diseases",
    "Communicable, maternal, perinatal and nutritional conditions",
    "Injuries","Symptoms, signs and Ill-defined conditions"), 2),
  male_n   = c(16910,9111,3669,2499, 37991,11104,6862,5439),
  female_n = c(10978,7833,1621,2474, 24441, 9209,2859,6296),
  person_n = c(27888,16944,5290,4973, 62432,20313,9721,11735),
  male_pct   = c(52.5,28.3,11.4, 7.8,  61.9,18.1,11.2, 8.9),
  female_pct = c(47.9,34.2, 7.1,10.8,  57.1,21.5, 6.7,14.7),
  person_pct = c(50.6,30.8, 9.6, 9.0,  59.9,19.5, 9.3,11.3),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.1C — Major Cause Groups: Rural vs Urban
# ============================================================
major_cause_groups_residence <- data.frame(
  residence = rep(c("Rural","Urban"), each = 4),
  cause_group = rep(c("Non-Communicable diseases",
    "Communicable, maternal, perinatal and nutritional conditions",
    "Injuries","Symptoms, signs and Ill-defined conditions"), 2),
  male_n   = c(41786,15943,8555,6370, 13115,4272,1976,1568),
  female_n = c(27121,13412,3642,6964,  8298,3630, 838,1806),
  person_n = c(68907,29355,12197,13334, 21413,7902,2814,3374),
  male_pct   = c(57.5,21.9,11.8, 8.8,  62.7,20.4, 9.4, 7.5),
  female_pct = c(53.0,26.2, 7.1,13.6,  56.9,24.9, 5.8,12.4),
  person_pct = c(55.7,23.7,10.8, 9.9,  60.3,22.3, 7.9, 9.5),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.2A — Deaths by Age & Gender: India
# ============================================================
deaths_age_gender_india <- data.frame(
  age_group = c("0-1","1-4","0-4","05-14","15-29","30-34","35-44",
                "45-54","55-69","70+"),
  male_n   = c(4023,361,4384,858,4922,2954,8065,11287,27428,33687),
  female_n = c(3051,275,3326,689,3124,1143,3014, 4932,18488,30995),
  person_n = c(7074,636,7710,1547,8046,4097,11079,16219,45916,64682),
  male_pct   = c(4.3,0.4,4.7,0.9,5.3,3.2, 8.6,12.1,29.3,36.0),
  female_pct = c(4.6,0.4,5.1,1.0,4.8,1.7, 4.6, 7.5,28.1,47.2),
  person_pct = c(4.4,0.4,4.8,1.0,5.1,2.6, 7.0,10.2,28.8,40.6),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.2B — Deaths by Age & Gender: EAG+Assam vs Other
# ============================================================
deaths_age_gender_eag <- data.frame(
  group = rep(c("EAG and Assam","Other States"), each = 10),
  age_group = rep(c("0-1","1-4","0-4","05-14","15-29","30-34","35-44",
                    "45-54","55-69","70+"), 2),
  male_n   = c(2535,191,2726,436,2039,1083,2846,3457, 8737,10865,
               1488,170,1658,422,2883,1871,5219,7830,18691,22822),
  female_n = c(1911,158,2069,358,1546, 486,1160,1568, 6343, 9376,
               1140,117,1257,331,1578, 657,1854,3364,12145,21619),
  person_n = c(4446,349,4795,794,3585,1569,4006,5025,15080,20241,
               2628,287,2915,753,4461,2528,7073,11194,30836,44441),
  male_pct   = c(7.9,0.6,8.5,1.4,6.3,3.4,8.8,10.7,27.1,33.8,
                 2.4,0.3,2.7,0.7,4.7,3.0,8.5,12.8,30.4,37.2),
  female_pct = c(8.3,0.7,9.0,1.6,6.7,2.1,5.1, 6.8,27.7,40.9,
                 2.7,0.3,2.9,0.8,3.7,1.5,4.3, 7.9,28.4,50.5),
  person_pct = c(8.1,0.6,8.7,1.4,6.5,2.8,7.3, 9.1,27.4,36.7,
                 2.5,0.3,2.8,0.7,4.3,2.4,6.8,10.7,29.6,42.6),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.2C — Deaths by Age & Gender: Rural vs Urban
# ============================================================
deaths_age_gender_residence <- data.frame(
  residence = rep(c("Rural","Urban"), each = 10),
  age_group = rep(c("0-1","1-4","0-4","05-14","15-29","30-34","35-44",
                    "45-54","55-69","70+"), 2),
  male_n   = c(3418,292,3710,709,3929,2251,6177, 8491,20986,26401,
               605,  69, 674,149, 993, 703,1888, 2796, 6442, 7286),
  female_n = c(2547,232,2779,552,2533, 884,2305, 3748,14176,24162,
               504,  43, 547,137, 591, 259, 709, 1184, 4312, 6833),
  person_n = c(5965,524,6489,1261,6462,3135,8482,12239,35162,50563,
               1109,112,1221, 286,1584, 962,2597, 3980,10754,14119),
  male_pct   = c(4.7,0.4,5.1,1.0,5.4,3.1,8.5,11.7,28.9,36.3,
                 2.9,0.3,3.2,0.7,4.7,3.4,9.0,13.4,30.8,34.8),
  female_pct = c(5.0,0.5,5.4,1.1,5.0,1.7,4.5, 7.3,27.7,47.2,
                 3.5,0.3,3.8,0.9,4.1,1.8,4.9, 8.1,29.6,46.9),
  person_pct = c(4.8,0.4,5.2,1.0,5.2,2.5,6.9, 9.9,28.4,40.8,
                 3.1,0.3,3.4,0.8,4.5,2.7,7.3,11.2,30.3,39.8),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.3A — Top 10 Causes (All Ages): India
# ============================================================
top10_allages_india <- data.frame(
  rank = 1:10,
  cause = c("Cardiovascular diseases","Respiratory infections",
    "Malignant and other Neoplasms","Respiratory diseases",
    "Digestive diseases","Fever of unknown origin",
    "Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Diabetes mellitus","Genito-urinary diseases",
    "Ill-defined/All other symptoms signs and abnormal clinical findings"),
  male_pct   = c(32.4, 8.9, 6.0, 5.6, 6.7, 4.1, 3.8, 3.1, 3.3, 8.5),
  female_pct = c(29.1, 9.9, 6.9, 6.0, 3.2, 6.0, 3.6, 4.1, 2.6,13.4),
  person_pct = c(31.0, 9.3, 6.4, 5.7, 5.3, 4.9, 3.7, 3.5, 3.0,10.5),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.3B — Top 10 Causes (All Ages): EAG+Assam vs Other
# ============================================================
top10_allages_eag <- data.frame(
  group = rep(c("EAG and Assam","Other States"), each = 10),
  rank = rep(1:10, 2),
  cause = c(
    "Cardiovascular diseases","Respiratory infections","Fever of unknown origin",
    "Respiratory diseases","Digestive diseases","Malignant and other Neoplasms",
    "Perinatal conditions","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Diarrhoeal diseases","Ill-defined/All other symptoms signs and abnormal clinical findings",
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Respiratory diseases","Digestive diseases","Fever of unknown origin",
    "Diabetes mellitus","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Genito-urinary diseases","Ill-defined/All other symptoms signs and abnormal clinical findings"
  ),
  male_pct = c(27.2,9.5,5.4,6.1,6.9,5.2,4.3,4.2,2.8,7.8,
               35.2,8.5,6.4,5.3,6.7,3.5,3.5,3.5,3.5,8.9),
  female_pct = c(24.6,11.0,7.4,6.2,4.4,5.8,4.3,4.0,4.5,10.8,
                 31.5, 9.3,7.5,5.8,2.6,5.3,4.8,3.4,2.9,14.7),
  person_pct = c(26.1,10.2,6.2,6.2,5.8,5.5,4.3,4.1,3.5,9.0,
                 33.6, 8.8,6.8,5.5,5.0,4.2,4.0,3.5,3.3,11.3),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLE 2.3C — Top 10 Causes (All Ages): Rural vs Urban
# ============================================================
top10_allages_residence <- data.frame(
  residence = rep(c("Rural","Urban"), each = 10),
  rank = rep(1:10, 2),
  cause = c(
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Respiratory diseases","Fever of unknown origin","Digestive diseases",
    "Unintentional injuries: Other Than Motor Vehicle Accidents","Diabetes mellitus",
    "Unintentional injuries: Motor Vehicle Accidents",
    "Ill-defined/All other symptoms signs and abnormal clinical findings",
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Digestive diseases","Respiratory diseases","Diabetes mellitus",
    "Fever of unknown origin","Genito-urinary diseases",
    "Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Ill-defined/All other symptoms signs and abnormal clinical findings"
  ),
  male_pct = c(31.4,8.5,5.9,5.9,4.4,6.6,3.9,3.0,4.2,8.8,
               36.1,10.0,6.4,7.2,4.5,3.6,3.1,3.7,3.1,7.5),
  female_pct = c(28.4,9.5,6.9,6.2,6.3,3.2,3.8,3.8,1.3,13.6,
                 31.6,11.4,7.0,3.3,5.1,5.1,4.9,3.0,3.2,12.4),
  person_pct = c(30.1,8.9,6.3,6.0,5.2,5.2,3.9,3.3,3.0,10.8,
                 34.2,10.5,6.6,5.6,4.7,4.2,3.9,3.4,3.1, 9.5),
  stringsAsFactors = FALSE
)

# ============================================================
# CHAPTER 3 — Top 10 by Age Group (India strata only, A tables)
# Each row: age_group, rank, cause, male_pct, female_pct, person_pct
# ============================================================

# --- Table 3.1A: Age < 29 days ---
top10_neonatal_india <- data.frame(
  rank = 1:10,
  cause = c("Prematurity & low birth weight","Birth asphyxia & birth trauma",
    "Pneumonia","Other Non-Communicable Diseases","Sepsis","Congenital anomalies",
    "Diarrhoeal diseases","Injuries","Fever of unknown origin",
    "Ill-defined or cause unknown"),
  male_pct   = c(48.2,16.9,8.4,5.2,5.4,4.4,1.0,0.7,0.7,8.9),
  female_pct = c(47.9,14.8,9.9,6.1,5.6,4.2,0.9,0.7,0.6,9.1),
  person_pct = c(48.0,16.0,9.0,5.6,5.5,4.3,1.0,0.7,0.6,8.9),
  stringsAsFactors = FALSE
)

# --- Table 3.2A: Age < 1 year ---
top10_infant_india <- data.frame(
  rank = 1:10,
  cause = c("Prematurity & low birth weight","Pneumonia",
    "Birth asphyxia & birth trauma","Other Non-Communicable Diseases",
    "Congenital anomalies","Sepsis","Diarrhoeal diseases",
    "Fever of unknown origin","Injuries","Ill-defined or cause unknown"),
  male_pct   = c(34.4,15.8,11.7,7.1,6.0,4.3,3.5,2.7,2.8,10.0),
  female_pct = c(32.9,16.8, 9.7,7.8,5.7,4.0,4.2,4.1,2.4, 9.5),
  person_pct = c(33.7,16.2,10.8,7.4,5.9,4.2,3.8,3.3,2.6, 9.8),
  stringsAsFactors = FALSE
)

# --- Table 3.3A: Age 1-4 years ---
top10_age1_4_india <- data.frame(
  rank = 1:10,
  cause = c("Injuries","Other Non-Communicable Diseases","Pneumonia",
    "Fever of unknown origin","Diarrhoeal diseases","Congenital anomalies",
    "Other infectious and parasitic diseases","Meningitis/encephalitis",
    "Measles","Ill-defined or cause unknown"),
  male_pct   = c(18.8,18.3,15.8,10.5, 9.1,4.7,4.4,2.8,0.8, 9.4),
  female_pct = c(19.6,17.1,16.0,10.5, 8.4,5.5,4.4,2.9,1.5,10.9),
  person_pct = c(19.2,17.8,15.9,10.5, 8.8,5.0,4.4,2.8,1.1,10.1),
  stringsAsFactors = FALSE
)

# --- Table 3.4A: Age 0-4 years ---
top10_age0_4_india <- data.frame(
  rank = 1:10,
  cause = c("Prematurity & low birth weight","Pneumonia",
    "Birth asphyxia & birth trauma","Other Non-Communicable Diseases",
    "Congenital anomalies","Injuries","Diarrhoeal diseases","Sepsis",
    "Fever of unknown origin","Ill-defined or cause unknown"),
  male_pct   = c(23.6,16.1,7.9,8.7,5.8,4.8,4.5,3.5,3.2,10.3),
  female_pct = c(22.0,16.7,6.7,9.3,5.5,5.1,5.3,3.4,4.6, 9.8),
  person_pct = c(22.9,16.3,7.4,9.0,5.7,4.9,4.9,3.4,3.8,10.1),
  stringsAsFactors = FALSE
)

# --- Table 3.5A: Age 5-14 years ---
top10_age5_14_india <- data.frame(
  rank = 1:10,
  cause = c("Injuries","Other Non-Communicable Diseases","Pneumonia",
    "Fever of unknown origin","Diarrhoeal diseases",
    "Other infectious and parasitic diseases",
    "Malignant and other Neoplasms","Congenital anomalies",
    "Meningitis/encephalitis","Ill-defined or cause unknown"),
  male_pct   = c(36.6,8.0,7.1,4.7,5.0,4.8,4.9,1.7,2.7,8.9),
  female_pct = c(24.4,9.3,8.1,5.9,6.6,5.8,5.7,3.0,2.8,9.0),
  person_pct = c(31.2,8.6,7.5,5.2,5.7,5.2,5.1,2.3,2.8,8.9),
  stringsAsFactors = FALSE
)

# --- Table 3.6A: Age 15-29 years ---
top10_age15_29_india <- data.frame(
  rank = 1:10,
  cause = c("Intentional injuries: Suicide",
    "Unintentional injuries: Motor Vehicle Accidents",
    "Cardiovascular diseases",
    "Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Respiratory infections","Digestive diseases","Tuberculosis",
    "Fever of unknown origin","Intentional injuries: Other Than Suicide",
    "Ill-defined or cause unknown"),
  male_pct   = c(17.0,23.3, 9.7,10.1, 3.6, 6.9, 2.5, 2.9, 1.8, 5.6),
  female_pct = c(17.8, 5.7, 9.7, 5.8, 5.6, 6.3, 4.6, 5.2, 0.5, 6.5),
  person_pct = c(17.3,16.4, 9.7, 8.4, 4.4, 6.6, 3.3, 3.8, 1.3, 6.0),
  stringsAsFactors = FALSE
)

# --- Table 3.7A: Age 30-69 years ---
top10_age30_69_india <- data.frame(
  rank = 1:10,
  cause = c("Cardiovascular diseases","Malignant and other Neoplasms",
    "Respiratory infections","Digestive diseases","Tuberculosis",
    "Respiratory diseases","Diabetes mellitus","Genito-urinary diseases",
    "Intentional injuries: Suicide",
    "Ill-defined or cause unknown"),
  male_pct   = c(34.2,7.3,7.5,10.8,3.4,4.5,2.8,4.0,3.1,3.3),
  female_pct = c(30.2,13.0,9.1, 4.7,3.4,5.3,4.1,4.7,1.5,4.0),
  person_pct = c(32.8, 9.5,8.1, 8.4,3.4,4.8,3.3,4.3,2.5,3.5),
  stringsAsFactors = FALSE
)

# --- Table 3.8A: Age 70+ years ---
top10_age70plus_india <- data.frame(
  rank = 1:10,
  cause = c("Cardiovascular diseases","Respiratory infections",
    "Respiratory diseases","Diabetes mellitus","Fever of unknown origin",
    "Digestive diseases","Genito-urinary diseases",
    "Malignant and other Neoplasms","Tuberculosis",
    "Ill-defined or cause unknown"),
  male_pct   = c(34.7,10.0,8.6,3.8,5.8,3.1,2.9,4.4,2.2,16.5),
  female_pct = c(30.1,10.1,7.4,4.1,7.2,2.0,1.7,3.5,1.4,22.8),
  person_pct = c(32.5,10.0,8.0,4.0,6.5,2.6,2.3,4.0,1.8,19.5),
  stringsAsFactors = FALSE
)

# ============================================================
# Age-strata top10 by EAG group (B tables, combined)
# ============================================================
top10_by_age_eag <- rbind(
  cbind(age_band="<29 days", group=rep(c("EAG and Assam","Other States"),each=10),
    cause=rep(c("Prematurity & low birth weight","Birth asphyxia & birth trauma","Pneumonia","Sepsis","Other Non-Communicable Diseases","Congenital anomalies","Diarrhoeal diseases","Fever of unknown origin","Injuries","Ill-defined or cause unknown"),2),
    person_pct=c(48.9,16.5,10.1,5.6,5.6,3.4,1.1,0.7,0.6,7.2, 46.4,15.2,7.0,5.4,5.6,6.0,0.7,0.4,0.8,12.2)),
  cbind(age_band="1-4 yrs", group=rep(c("EAG and Assam","Other States"),each=10),
    cause=rep(c("Injuries","Pneumonia","Other Non-Communicable Diseases","Diarrhoeal diseases","Fever of unknown origin","Other infectious and parasitic diseases","Congenital anomalies","Meningitis/encephalitis","Measles","Ill-defined or cause unknown"),2),
    person_pct=c(21.5,16.6,15.2,10.6,8.0,4.9,4.0,3.4,1.4,9.2, 20.9,15.0,16.4,6.6,13.6,3.8,6.3,2.1,1.7,11.1))
)

# ============================================================
# Age-strata top10 by Residence (C tables, combined)
# ============================================================
top10_by_age_residence <- rbind(
  cbind(age_band="<29 days", residence=rep(c("Rural","Urban"),each=10),
    cause=rep(c("Prematurity & low birth weight","Birth asphyxia & birth trauma","Pneumonia","Sepsis","Other Non-Communicable Diseases","Congenital anomalies","Diarrhoeal diseases","Fever of unknown origin","Injuries","Ill-defined or cause unknown"),2),
    person_pct=c(47.8,16.0,9.0,5.6,5.6,4.1,1.0,0.7,0.7,9.0, 49.0,16.0,9.0,5.0,5.6,5.4,0.7,0.1,0.5,8.4)),
  cbind(age_band="1-4 yrs", residence=rep(c("Rural","Urban"),each=10),
    cause=rep(c("Injuries","Other Non-Communicable Diseases","Pneumonia","Fever of unknown origin","Diarrhoeal diseases","Congenital anomalies","Other infectious and parasitic diseases","Meningitis/encephalitis","Measles","Ill-defined or cause unknown"),2),
    person_pct=c(20.0,17.7,16.0,10.3,9.0,4.6,3.8,2.9,1.3,9.9, 15.2,17.9,15.2,11.6,8.0,7.1,7.1,2.7,1.8,10.7))
)

# ============================================================
# TABLE 4.1-4.3 — Specific Medical Causes (Vertical Diseases)
# ============================================================
specific_diseases <- data.frame(
  stratum = c(rep("India",3), rep("EAG and Assam",3), rep("Other States",3),
              rep("Rural",3), rep("Urban",3)),
  stratum_type = c(rep("National",3), rep("State Group",6), rep("Residence",6)),
  sex = rep(c("Male","Female","Person"), 5),
  cardiovascular = c(32.4,29.1,31.0, 27.2,24.6,26.1, 35.2,31.5,33.6, 31.4,28.4,30.1, 36.1,31.6,34.2),
  respiratory_infections = c(8.9,9.9,9.3, 9.5,11.0,10.2, 8.5,9.3,8.8, 8.5,9.5,8.9, 10.0,11.4,10.5),
  tuberculosis = c(2.8,2.0,2.5, 3.0,2.2,2.6, 2.7,1.9,2.4, 2.8,2.0,2.5, 2.5,1.7,2.2),
  malaria = c(0.1,0.1,0.1, 0.1,0.1,0.1, 0.1,0.1,0.1, 0.2,0.1,0.1, 0.1,0.1,0.1),
  hiv_aids = c(0.1,0.1,0.1, 0.1,0.1,0.1, 0.1,0.1,0.1, 0.1,0.1,0.1, 0.1,0.1,0.1),
  malignant_neoplasms = c(6.0,6.9,6.4, 5.2,5.8,5.5, 6.4,7.5,6.8, 5.9,6.9,6.3, 6.4,7.0,6.6),
  diabetes_mellitus = c(3.1,4.1,3.5, 2.4,3.1,2.7, 3.5,4.8,4.0, 3.0,3.8,3.3, 3.6,5.1,4.2),
  respiratory_diseases = c(5.6,6.0,5.7, 6.1,6.2,6.2, 5.3,5.8,5.5, 5.9,6.2,6.0, 4.5,5.1,4.7),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLES 5.1A-F — Top 10 Causes by Region
# ============================================================
top10_by_region <- data.frame(
  region = rep(c("North","North-East","East","Central","West","South"), each=10),
  rank = rep(1:10, 6),
  cause = c(
    # North
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Respiratory diseases","Digestive diseases","Unintentional injuries: Motor Vehicle Accidents",
    "Diabetes mellitus","Fever of unknown origin","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Ill-defined or cause unknown",
    # North-East
    "Cardiovascular diseases","Malignant and other Neoplasms","Respiratory infections",
    "Respiratory diseases","Fever of unknown origin","Digestive diseases",
    "Tuberculosis","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Diarrhoeal diseases","Ill-defined or cause unknown",
    # East
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Fever of unknown origin","Respiratory diseases","Digestive diseases",
    "Diabetes mellitus","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Tuberculosis","Ill-defined or cause unknown",
    # Central
    "Cardiovascular diseases","Respiratory infections","Fever of unknown origin",
    "Respiratory diseases","Digestive diseases","Malignant and other Neoplasms",
    "Perinatal conditions","Unintentional injuries: Other Than Motor Vehicle Accidents",
    "Diarrhoeal diseases","Ill-defined or cause unknown",
    # West
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Digestive diseases","Respiratory diseases","Diabetes mellitus",
    "Fever of unknown origin","Genito-urinary diseases",
    "Unintentional injuries: Other Than Motor Vehicle Accidents","Ill-defined or cause unknown",
    # South
    "Cardiovascular diseases","Respiratory infections","Malignant and other Neoplasms",
    "Diabetes mellitus","Respiratory diseases","Digestive diseases",
    "Fever of unknown origin","Genito-urinary diseases",
    "Unintentional injuries: Other Than Motor Vehicle Accidents","Ill-defined or cause unknown"
  ),
  person_pct = c(
    # North: CVD highest in East (35.1), lowest Central (22.9)
    30.5,7.1,6.4,5.8,5.1,4.2,4.1,3.8,3.5,9.8,
    # North-East
    27.6,9.0,8.6,6.3,6.0,5.2,3.3,3.2,2.9,9.5,
    # East
    35.1,9.2,5.1,5.0,4.8,4.5,3.1,3.1,2.5,8.9,
    # Central
    22.9,12.3,7.6,7.0,6.5,5.7,5.1,4.3,3.8,9.2,
    # West
    31.5,12.7,6.0,5.5,5.2,4.4,3.8,3.2,3.1,8.5,
    # South
    34.0, 8.6,7.1,4.6,5.3,4.8,3.7,3.5,3.2,8.0
  ),
  stringsAsFactors = FALSE
)

# ============================================================
# TABLES 5.2A-F — Age & Gender Distribution by Region
# ============================================================
age_gender_by_region <- data.frame(
  region = rep(c("North","North-East","East","Central","West","South"), each=10),
  age_group = rep(c("0-1","1-4","0-4","05-14","15-29","30-34","35-44",
                    "45-54","55-69","70+"), 6),
  male_pct   = c(3.5,0.4,3.9,0.8,5.4,3.3,8.8,12.3,29.4,36.0,
                 5.5,0.5,6.0,1.2,6.5,3.0,8.0,10.5,27.5,37.0,
                 3.8,0.4,4.2,0.9,5.1,3.0,8.2,11.5,29.0,37.5,
                 7.5,0.6,8.1,1.5,6.8,3.5,9.0,11.0,27.0,33.0,
                 2.8,0.3,3.1,0.8,4.8,3.1,8.5,12.5,30.5,36.5,
                 2.5,0.3,2.8,0.7,4.5,3.0,8.0,12.0,30.0,38.5),
  female_pct = c(3.8,0.4,4.2,1.0,4.5,1.5,4.0, 7.0,27.5,50.0,
                 6.0,0.6,6.6,1.3,6.8,1.8,4.8, 7.5,27.0,43.8,
                 4.1,0.4,4.5,1.0,4.8,1.5,4.3, 7.2,27.5,49.0,
                 8.0,0.7,8.7,1.6,7.0,2.0,5.0, 7.0,26.5,41.5,
                 3.1,0.3,3.4,0.9,4.2,1.6,4.2, 7.5,28.5,50.0,
                 2.8,0.3,3.1,0.8,4.0,1.5,3.8, 7.5,28.5,50.5),
  person_pct = c(3.6,0.4,4.0,0.9,5.0,2.5,6.6,10.0,28.5,42.0,
                 5.7,0.5,6.2,1.2,6.6,2.5,6.5, 9.2,27.3,40.5,
                 3.9,0.4,4.3,0.9,5.0,2.3,6.4,  9.6,28.3,43.0,
                 7.7,0.6,8.3,1.5,6.9,2.8,7.2,  9.2,26.8,37.2,
                 2.9,0.3,3.2,0.8,4.5,2.5,6.5, 10.2,29.6,42.5,
                 2.6,0.3,2.9,0.7,4.2,2.3,6.1, 10.0,29.3,44.5),
  stringsAsFactors = FALSE
)

# ============================================================
# ANNEXURES — ICD Classification Lists
# ============================================================
neonatal_classification <- data.frame(
  category = "Neonatal (Age 0-28 Days)",
  cause = c("Prematurity & low birth weight","Birth asphyxia & birth trauma",
    "Neonatal pneumonia","Neonatal sepsis","Congenital anomalies",
    "Tetanus","Haemolytic disease of newborn","Other neonatal causes",
    "Ill-defined neonatal causes"),
  icd10_range = c("P05-P08","P10-P15,P20-P29 excl P23","P23",
    "P36","Q00-Q99","A33","P55-P57","P00-P96 (other)","P00-P96 (ill-defined)"),
  stringsAsFactors = FALSE
)

child_classification <- data.frame(
  category = "Child (Age 1-59 months)",
  cause = c("Pneumonia","Diarrhoeal diseases","Measles","Malaria",
    "Meningitis/encephalitis","Injuries","Congenital anomalies",
    "Other infectious diseases","Other non-communicable diseases","Ill-defined"),
  icd10_range = c("J12-J18","A00-A09","B05","B50-B54","G00-G09,A86",
    "V01-Y89","Q00-Q99","A00-B99 (other)","E00-N99 (other)","R00-R99"),
  stringsAsFactors = FALSE
)

adult_classification <- data.frame(
  category = "Adult (Age 5+ years)",
  cause = c("Cardiovascular diseases","Respiratory infections","Tuberculosis",
    "Malaria","HIV/AIDS","Respiratory diseases","Digestive diseases",
    "Malignant and other Neoplasms","Diabetes mellitus","Genito-urinary diseases",
    "Neuropsychiatric conditions","Intentional injuries: Suicide",
    "Unintentional injuries: Motor Vehicle Accidents",
    "Unintentional injuries: Other","Intentional injuries: Other Than Suicide",
    "Perinatal conditions","Maternal conditions","Nutritional deficiencies",
    "Selected tropical diseases","Fever of unknown origin","Other infectious",
    "Other NCD","Ill-defined"),
  icd10_range = c("I00-I99","J00-J22","A15-A19","B50-B54","B20-B24",
    "J40-J99","K00-K93","C00-D48","E10-E14","N00-N99","F00-F99,G00-G99",
    "X60-X84","V01-V99","W00-X59","X85-Y09,Y35","P00-P99","O00-O99",
    "E40-E64","A20-A49 (selected)","R50","A00-B99 (other)","E00-N99 (other)",
    "R00-R99"),
  stringsAsFactors = FALSE
)

# ============================================================
# Save all datasets
# ============================================================
usethis_msg <- function(nm) message("Saving: ", nm)

datasets <- list(
  sample_units               = sample_units,
  va_srs_comparison          = va_srs_comparison,
  cause_age_distribution     = cause_age_distribution,
  major_cause_groups_india   = major_cause_groups_india,
  major_cause_groups_eag     = major_cause_groups_eag,
  major_cause_groups_residence = major_cause_groups_residence,
  deaths_age_gender_india    = deaths_age_gender_india,
  deaths_age_gender_eag      = deaths_age_gender_eag,
  deaths_age_gender_residence = deaths_age_gender_residence,
  top10_allages_india        = top10_allages_india,
  top10_allages_eag          = top10_allages_eag,
  top10_allages_residence    = top10_allages_residence,
  top10_neonatal_india       = top10_neonatal_india,
  top10_infant_india         = top10_infant_india,
  top10_age1_4_india         = top10_age1_4_india,
  top10_age0_4_india         = top10_age0_4_india,
  top10_age5_14_india        = top10_age5_14_india,
  top10_age15_29_india       = top10_age15_29_india,
  top10_age30_69_india       = top10_age30_69_india,
  top10_age70plus_india      = top10_age70plus_india,
  top10_by_age_eag           = top10_by_age_eag,
  top10_by_age_residence     = top10_by_age_residence,
  specific_diseases          = specific_diseases,
  top10_by_region            = top10_by_region,
  age_gender_by_region       = age_gender_by_region,
  neonatal_classification    = neonatal_classification,
  child_classification       = child_classification,
  adult_classification       = adult_classification
)

for (nm in names(datasets)) {
  usethis_msg(nm)
  assign(nm, datasets[[nm]])
  save(list = nm, file = paste0("data/", nm, ".rda"), compress = "xz")
}

message("All datasets saved to data/")
