import csv, os

BASE = "/home/claude/srscod/inst/extdata"
os.makedirs(BASE, exist_ok=True)

def write_csv(filename, headers, rows):
    path = os.path.join(BASE, filename)
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(headers)
        w.writerows(rows)
    print(f"  wrote {filename} ({len(rows)} rows)")

# ── Table 1.1 ───────────────────────────────────────────────
write_csv("sample_units.csv",
["state_ut","category","eag_group","units_total","units_rural","units_urban","pop_total_000","pop_rural_000","pop_urban_000"],
[
["India","National","National",8839,4960,3879,8810,6323,2487],
["Andhra Pradesh","Bigger","Other",325,198,127,358,275,82],
["Assam","Bigger","EAG",299,89,210,252,122,130],
["Bihar","Bigger","EAG",330,200,130,412,326,86],
["Chhattisgarh","Bigger","EAG",158,73,85,130,78,51],
["NCT of Delhi","Bigger","Other",196,10,186,160,17,143],
["Gujarat","Bigger","Other",476,231,245,465,316,149],
["Haryana","Bigger","Other",256,144,112,280,208,71],
["Jammu & Kashmir","Bigger","Other",279,177,102,232,187,45],
["Jharkhand","Bigger","EAG",210,91,119,180,107,73],
["Karnataka","Bigger","Other",511,361,150,515,421,94],
["Kerala","Bigger","Other",280,175,105,394,332,62],
["Madhya Pradesh","Bigger","EAG",448,285,163,445,339,106],
["Maharashtra","Bigger","Other",660,306,354,606,389,217],
["Odisha","Bigger","EAG",405,290,115,387,314,74],
["Punjab","Bigger","Other",249,130,119,237,160,77],
["Rajasthan","Bigger","EAG",350,236,114,362,297,65],
["Tamil Nadu","Bigger","Other",544,235,309,568,349,218],
["Telangana","Bigger","Other",224,121,103,234,164,69],
["Uttar Pradesh","Bigger","EAG",500,328,172,582,465,116],
["Uttarakhand","Bigger","EAG",374,195,179,342,214,128],
["West Bengal","Bigger","Other",555,304,251,596,450,147],
["Arunachal Pradesh","Smaller","Other",65,50,15,56,41,15],
["Goa","Smaller","Other",95,45,50,94,69,25],
["Himachal Pradesh","Smaller","Other",210,155,55,126,96,30],
["Manipur","Smaller","Other",165,120,45,133,108,25],
["Meghalaya","Smaller","Other",130,95,35,92,71,21],
["Mizoram","Smaller","Other",45,25,20,38,26,12],
["Nagaland","Smaller","Other",50,35,15,38,30,8],
["Sikkim","Smaller","Other",65,50,15,73,57,15],
["Tripura","Smaller","Other",90,65,25,120,103,17],
["Andaman & Nicobar Islands","UT","Other",55,37,18,60,45,15],
["Chandigarh","UT","Other",40,5,35,43,12,31],
["Dadra & Nagar Haveli","UT","Other",35,15,20,45,30,16],
["Daman & Diu","UT","Other",25,15,10,33,24,9],
["Ladakh","UT","Other",71,49,22,54,47,8],
["Lakshadweep","UT","Other",14,2,12,15,4,11],
["Puducherry","UT","Other",55,18,37,53,30,24],
])

# ── Table 1.2 ───────────────────────────────────────────────
write_csv("va_srs_comparison.csv",
["age_group","eag_srs_pct","eag_va_pct","other_srs_pct","other_va_pct"],
[["0-4",11.1,8.7,3.9,2.8],["05-14",1.6,1.4,1.0,0.7],["15-29",6.3,6.5,4.4,4.3],
 ["30-34",2.7,2.8,2.4,2.4],["35-44",6.9,7.3,6.6,6.8],["45-54",9.0,9.1,10.5,10.7],
 ["55-69",26.2,27.4,29.0,29.6],["70+",36.3,36.7,42.2,42.6]])

# ── Table 2.1A ──────────────────────────────────────────────
write_csv("major_cause_groups_india.csv",
["cause_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["Non-Communicable diseases",54901,35419,90320,58.7,53.9,56.7],
 ["Communicable maternal perinatal and nutritional conditions",20215,17042,37257,21.6,25.9,23.4],
 ["Injuries",10531,4480,15011,11.3,6.8,9.4],
 ["Symptoms signs and Ill-defined conditions",7938,8770,16708,8.5,13.4,10.5]])

# ── Table 2.1B ──────────────────────────────────────────────
write_csv("major_cause_groups_eag.csv",
["group","cause_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["EAG and Assam","Non-Communicable diseases",16910,10978,27888,52.5,47.9,50.6],
 ["EAG and Assam","Communicable maternal perinatal and nutritional conditions",9111,7833,16944,28.3,34.2,30.8],
 ["EAG and Assam","Injuries",3669,1621,5290,11.4,7.1,9.6],
 ["EAG and Assam","Symptoms signs and Ill-defined conditions",2499,2474,4973,7.8,10.8,9.0],
 ["Other States","Non-Communicable diseases",37991,24441,62432,61.9,57.1,59.9],
 ["Other States","Communicable maternal perinatal and nutritional conditions",11104,9209,20313,18.1,21.5,19.5],
 ["Other States","Injuries",6862,2859,9721,11.2,6.7,9.3],
 ["Other States","Symptoms signs and Ill-defined conditions",5439,6296,11735,8.9,14.7,11.3]])

# ── Table 2.1C ──────────────────────────────────────────────
write_csv("major_cause_groups_residence.csv",
["residence","cause_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["Rural","Non-Communicable diseases",41786,27121,68907,57.5,53.0,55.7],
 ["Rural","Communicable maternal perinatal and nutritional conditions",15943,13412,29355,21.9,26.2,23.7],
 ["Rural","Injuries",8555,3642,12197,11.8,7.1,9.9],
 ["Rural","Symptoms signs and Ill-defined conditions",6370,6964,13334,8.8,13.6,10.8],
 ["Urban","Non-Communicable diseases",13115,8298,21413,62.7,56.9,60.3],
 ["Urban","Communicable maternal perinatal and nutritional conditions",4272,3630,7902,20.4,24.9,22.3],
 ["Urban","Injuries",1976,838,2814,9.4,5.8,7.9],
 ["Urban","Symptoms signs and Ill-defined conditions",1568,1806,3374,7.5,12.4,9.5]])

# ── Table 2.2A ──────────────────────────────────────────────
write_csv("deaths_age_gender_india.csv",
["age_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["0-1",4023,3051,7074,4.3,4.6,4.4],["1-4",361,275,636,0.4,0.4,0.4],
 ["0-4",4384,3326,7710,4.7,5.1,4.8],["05-14",858,689,1547,0.9,1.0,1.0],
 ["15-29",4922,3124,8046,5.3,4.8,5.1],["30-34",2954,1143,4097,3.2,1.7,2.6],
 ["35-44",8065,3014,11079,8.6,4.6,7.0],["45-54",11287,4932,16219,12.1,7.5,10.2],
 ["55-69",27428,18488,45916,29.3,28.1,28.8],["70+",33687,30995,64682,36.0,47.2,40.6]])

# ── Table 2.2B ──────────────────────────────────────────────
write_csv("deaths_age_gender_eag.csv",
["group","age_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["EAG and Assam","0-1",2535,1911,4446,7.9,8.3,8.1],
 ["EAG and Assam","1-4",191,158,349,0.6,0.7,0.6],
 ["EAG and Assam","0-4",2726,2069,4795,8.5,9.0,8.7],
 ["EAG and Assam","05-14",436,358,794,1.4,1.6,1.4],
 ["EAG and Assam","15-29",2039,1546,3585,6.3,6.7,6.5],
 ["EAG and Assam","30-34",1083,486,1569,3.4,2.1,2.8],
 ["EAG and Assam","35-44",2846,1160,4006,8.8,5.1,7.3],
 ["EAG and Assam","45-54",3457,1568,5025,10.7,6.8,9.1],
 ["EAG and Assam","55-69",8737,6343,15080,27.1,27.7,27.4],
 ["EAG and Assam","70+",10865,9376,20241,33.8,40.9,36.7],
 ["Other States","0-1",1488,1140,2628,2.4,2.7,2.5],
 ["Other States","1-4",170,117,287,0.3,0.3,0.3],
 ["Other States","0-4",1658,1257,2915,2.7,2.9,2.8],
 ["Other States","05-14",422,331,753,0.7,0.8,0.7],
 ["Other States","15-29",2883,1578,4461,4.7,3.7,4.3],
 ["Other States","30-34",1871,657,2528,3.0,1.5,2.4],
 ["Other States","35-44",5219,1854,7073,8.5,4.3,6.8],
 ["Other States","45-54",7830,3364,11194,12.8,7.9,10.7],
 ["Other States","55-69",18691,12145,30836,30.4,28.4,29.6],
 ["Other States","70+",22822,21619,44441,37.2,50.5,42.6]])

# ── Table 2.2C ──────────────────────────────────────────────
write_csv("deaths_age_gender_residence.csv",
["residence","age_group","male_n","female_n","person_n","male_pct","female_pct","person_pct"],
[["Rural","0-1",3418,2547,5965,4.7,5.0,4.8],["Rural","1-4",292,232,524,0.4,0.5,0.4],
 ["Rural","0-4",3710,2779,6489,5.1,5.4,5.2],["Rural","05-14",709,552,1261,1.0,1.1,1.0],
 ["Rural","15-29",3929,2533,6462,5.4,5.0,5.2],["Rural","30-34",2251,884,3135,3.1,1.7,2.5],
 ["Rural","35-44",6177,2305,8482,8.5,4.5,6.9],["Rural","45-54",8491,3748,12239,11.7,7.3,9.9],
 ["Rural","55-69",20986,14176,35162,28.9,27.7,28.4],["Rural","70+",26401,24162,50563,36.3,47.2,40.8],
 ["Urban","0-1",605,504,1109,2.9,3.5,3.1],["Urban","1-4",69,43,112,0.3,0.3,0.3],
 ["Urban","0-4",674,547,1221,3.2,3.8,3.4],["Urban","05-14",149,137,286,0.7,0.9,0.8],
 ["Urban","15-29",993,591,1584,4.7,4.1,4.5],["Urban","30-34",703,259,962,3.4,1.8,2.7],
 ["Urban","35-44",1888,709,2597,9.0,4.9,7.3],["Urban","45-54",2796,1184,3980,13.4,8.1,11.2],
 ["Urban","55-69",6442,4312,10754,30.8,29.6,30.3],["Urban","70+",7286,6833,14119,34.8,46.9,39.8]])

# ── Table 2.3A ──────────────────────────────────────────────
write_csv("top10_allages_india.csv",
["rank","cause","male_pct","female_pct","person_pct"],
[[1,"Cardiovascular diseases",32.4,29.1,31.0],
 [2,"Respiratory infections",8.9,9.9,9.3],
 [3,"Malignant and other Neoplasms",6.0,6.9,6.4],
 [4,"Respiratory diseases",5.6,6.0,5.7],
 [5,"Digestive diseases",6.7,3.2,5.3],
 [6,"Fever of unknown origin",4.1,6.0,4.9],
 [7,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.8,3.6,3.7],
 [8,"Diabetes mellitus",3.1,4.1,3.5],
 [9,"Genito-urinary diseases",3.3,2.6,3.0],
 [10,"Ill-defined/All other symptoms signs and abnormal clinical findings",8.5,13.4,10.5]])

# ── Table 2.3B ──────────────────────────────────────────────
write_csv("top10_allages_eag.csv",
["group","rank","cause","male_pct","female_pct","person_pct"],
[["EAG and Assam",1,"Cardiovascular diseases",27.2,24.6,26.1],
 ["EAG and Assam",2,"Respiratory infections",9.5,11.0,10.2],
 ["EAG and Assam",3,"Fever of unknown origin",5.4,7.4,6.2],
 ["EAG and Assam",4,"Respiratory diseases",6.1,6.2,6.2],
 ["EAG and Assam",5,"Digestive diseases",6.9,4.4,5.8],
 ["EAG and Assam",6,"Malignant and other Neoplasms",5.2,5.8,5.5],
 ["EAG and Assam",7,"Perinatal conditions",4.3,4.3,4.3],
 ["EAG and Assam",8,"Unintentional injuries: Other Than Motor Vehicle Accidents",4.2,4.0,4.1],
 ["EAG and Assam",9,"Diarrhoeal diseases",2.8,4.5,3.5],
 ["EAG and Assam",10,"Ill-defined/All other symptoms signs and abnormal clinical findings",7.8,10.8,9.0],
 ["Other States",1,"Cardiovascular diseases",35.2,31.5,33.6],
 ["Other States",2,"Respiratory infections",8.5,9.3,8.8],
 ["Other States",3,"Malignant and other Neoplasms",6.4,7.5,6.8],
 ["Other States",4,"Respiratory diseases",5.3,5.8,5.5],
 ["Other States",5,"Digestive diseases",6.7,2.6,5.0],
 ["Other States",6,"Fever of unknown origin",3.5,5.3,4.2],
 ["Other States",7,"Diabetes mellitus",3.5,4.8,4.0],
 ["Other States",8,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.5,3.4,3.5],
 ["Other States",9,"Genito-urinary diseases",3.5,2.9,3.3],
 ["Other States",10,"Ill-defined/All other symptoms signs and abnormal clinical findings",8.9,14.7,11.3]])

# ── Table 2.3C ──────────────────────────────────────────────
write_csv("top10_allages_residence.csv",
["residence","rank","cause","male_pct","female_pct","person_pct"],
[["Rural",1,"Cardiovascular diseases",31.4,28.4,30.1],
 ["Rural",2,"Respiratory infections",8.5,9.5,8.9],
 ["Rural",3,"Malignant and other Neoplasms",5.9,6.9,6.3],
 ["Rural",4,"Respiratory diseases",5.9,6.2,6.0],
 ["Rural",5,"Fever of unknown origin",4.4,6.3,5.2],
 ["Rural",6,"Digestive diseases",6.6,3.2,5.2],
 ["Rural",7,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.9,3.8,3.9],
 ["Rural",8,"Diabetes mellitus",3.0,3.8,3.3],
 ["Rural",9,"Unintentional injuries: Motor Vehicle Accidents",4.2,1.3,3.0],
 ["Rural",10,"Ill-defined/All other symptoms signs and abnormal clinical findings",8.8,13.6,10.8],
 ["Urban",1,"Cardiovascular diseases",36.1,31.6,34.2],
 ["Urban",2,"Respiratory infections",10.0,11.4,10.5],
 ["Urban",3,"Malignant and other Neoplasms",6.4,7.0,6.6],
 ["Urban",4,"Digestive diseases",7.2,3.3,5.6],
 ["Urban",5,"Respiratory diseases",4.5,5.1,4.7],
 ["Urban",6,"Diabetes mellitus",3.6,5.1,4.2],
 ["Urban",7,"Fever of unknown origin",3.1,4.9,3.9],
 ["Urban",8,"Genito-urinary diseases",3.7,3.0,3.4],
 ["Urban",9,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.1,3.2,3.1],
 ["Urban",10,"Ill-defined/All other symptoms signs and abnormal clinical findings",7.5,12.4,9.5]])

# ── Chapter 3 tables: top10 by age band ─────────────────────
age_bands = {
  "neonatal_lt29days": {
    "india": [
      [1,"Prematurity & low birth weight",48.2,47.9,48.0],
      [2,"Birth asphyxia & birth trauma",16.9,14.8,16.0],
      [3,"Pneumonia",8.4,9.9,9.0],
      [4,"Other Non-Communicable Diseases",5.2,6.1,5.6],
      [5,"Sepsis",5.4,5.6,5.5],
      [6,"Congenital anomalies",4.4,4.2,4.3],
      [7,"Diarrhoeal diseases",1.0,0.9,1.0],
      [8,"Injuries",0.7,0.7,0.7],
      [9,"Fever of unknown origin",0.7,0.6,0.6],
      [10,"Ill-defined or cause unknown",8.9,9.1,8.9],
    ]
  },
  "infant_lt1year": {
    "india": [
      [1,"Prematurity & low birth weight",34.4,32.9,33.7],
      [2,"Pneumonia",15.8,16.8,16.2],
      [3,"Birth asphyxia & birth trauma",11.7,9.7,10.8],
      [4,"Other Non-Communicable Diseases",7.1,7.8,7.4],
      [5,"Congenital anomalies",6.0,5.7,5.9],
      [6,"Sepsis",4.3,4.0,4.2],
      [7,"Diarrhoeal diseases",3.5,4.2,3.8],
      [8,"Fever of unknown origin",2.7,4.1,3.3],
      [9,"Injuries",2.8,2.4,2.6],
      [10,"Ill-defined or cause unknown",10.0,9.5,9.8],
    ]
  },
  "child_1_4years": {
    "india": [
      [1,"Injuries",18.8,19.6,19.2],
      [2,"Other Non-Communicable Diseases",18.3,17.1,17.8],
      [3,"Pneumonia",15.8,16.0,15.9],
      [4,"Fever of unknown origin",10.5,10.5,10.5],
      [5,"Diarrhoeal diseases",9.1,8.4,8.8],
      [6,"Congenital anomalies",4.7,5.5,5.0],
      [7,"Other infectious and parasitic diseases",4.4,4.4,4.4],
      [8,"Meningitis/encephalitis",2.8,2.9,2.8],
      [9,"Measles",0.8,1.5,1.1],
      [10,"Ill-defined or cause unknown",9.4,10.9,10.1],
    ]
  },
  "child_0_4years": {
    "india": [
      [1,"Prematurity & low birth weight",23.6,22.0,22.9],
      [2,"Pneumonia",16.1,16.7,16.3],
      [3,"Birth asphyxia & birth trauma",7.9,6.7,7.4],
      [4,"Other Non-Communicable Diseases",8.7,9.3,9.0],
      [5,"Congenital anomalies",5.8,5.5,5.7],
      [6,"Injuries",4.8,5.1,4.9],
      [7,"Diarrhoeal diseases",4.5,5.3,4.9],
      [8,"Sepsis",3.5,3.4,3.4],
      [9,"Fever of unknown origin",3.2,4.6,3.8],
      [10,"Ill-defined or cause unknown",10.3,9.8,10.1],
    ]
  },
  "school_5_14years": {
    "india": [
      [1,"Injuries",36.6,24.4,31.2],
      [2,"Other Non-Communicable Diseases",8.0,9.3,8.6],
      [3,"Pneumonia",7.1,8.1,7.5],
      [4,"Fever of unknown origin",4.7,5.9,5.2],
      [5,"Diarrhoeal diseases",5.0,6.6,5.7],
      [6,"Other infectious and parasitic diseases",4.8,5.8,5.2],
      [7,"Malignant and other Neoplasms",4.9,5.7,5.1],
      [8,"Congenital anomalies",1.7,3.0,2.3],
      [9,"Meningitis/encephalitis",2.7,2.8,2.8],
      [10,"Ill-defined or cause unknown",8.9,9.0,8.9],
    ]
  },
  "youth_15_29years": {
    "india": [
      [1,"Intentional injuries: Suicide",17.0,17.8,17.3],
      [2,"Unintentional injuries: Motor Vehicle Accidents",23.3,5.7,16.4],
      [3,"Cardiovascular diseases",9.7,9.7,9.7],
      [4,"Unintentional injuries: Other Than Motor Vehicle Accidents",10.1,5.8,8.4],
      [5,"Respiratory infections",3.6,5.6,4.4],
      [6,"Digestive diseases",6.9,6.3,6.6],
      [7,"Tuberculosis",2.5,4.6,3.3],
      [8,"Fever of unknown origin",2.9,5.2,3.8],
      [9,"Intentional injuries: Other Than Suicide",1.8,0.5,1.3],
      [10,"Ill-defined or cause unknown",5.6,6.5,6.0],
    ]
  },
  "adult_30_69years": {
    "india": [
      [1,"Cardiovascular diseases",34.2,30.2,32.8],
      [2,"Malignant and other Neoplasms",7.3,13.0,9.5],
      [3,"Respiratory infections",7.5,9.1,8.1],
      [4,"Digestive diseases",10.8,4.7,8.4],
      [5,"Tuberculosis",3.4,3.4,3.4],
      [6,"Respiratory diseases",4.5,5.3,4.8],
      [7,"Diabetes mellitus",2.8,4.1,3.3],
      [8,"Genito-urinary diseases",4.0,4.7,4.3],
      [9,"Intentional injuries: Suicide",3.1,1.5,2.5],
      [10,"Ill-defined or cause unknown",3.3,4.0,3.5],
    ]
  },
  "elderly_70plus": {
    "india": [
      [1,"Cardiovascular diseases",34.7,30.1,32.5],
      [2,"Respiratory infections",10.0,10.1,10.0],
      [3,"Respiratory diseases",8.6,7.4,8.0],
      [4,"Diabetes mellitus",3.8,4.1,4.0],
      [5,"Fever of unknown origin",5.8,7.2,6.5],
      [6,"Digestive diseases",3.1,2.0,2.6],
      [7,"Genito-urinary diseases",2.9,1.7,2.3],
      [8,"Malignant and other Neoplasms",4.4,3.5,4.0],
      [9,"Tuberculosis",2.2,1.4,1.8],
      [10,"Ill-defined or cause unknown",16.5,22.8,19.5],
    ]
  }
}

for band_name, strata in age_bands.items():
    for strata_name, rows in strata.items():
        fname = f"top10_{band_name}_{strata_name}.csv"
        write_csv(fname,["rank","cause","male_pct","female_pct","person_pct"], rows)

# ── Table 4 — Specific disease burden ───────────────────────
write_csv("specific_diseases.csv",
["stratum","stratum_type","sex","cardiovascular","respiratory_infections",
 "tuberculosis","malaria","hiv_aids","malignant_neoplasms","diabetes_mellitus",
 "respiratory_diseases"],
[["India","National","Male",32.4,8.9,2.8,0.1,0.1,6.0,3.1,5.6],
 ["India","National","Female",29.1,9.9,2.0,0.1,0.1,6.9,4.1,6.0],
 ["India","National","Person",31.0,9.3,2.5,0.1,0.1,6.4,3.5,5.7],
 ["EAG and Assam","State Group","Male",27.2,9.5,3.0,0.1,0.1,5.2,2.4,6.1],
 ["EAG and Assam","State Group","Female",24.6,11.0,2.2,0.1,0.1,5.8,3.1,6.2],
 ["EAG and Assam","State Group","Person",26.1,10.2,2.6,0.1,0.1,5.5,2.7,6.2],
 ["Other States","State Group","Male",35.2,8.5,2.7,0.1,0.1,6.4,3.5,5.3],
 ["Other States","State Group","Female",31.5,9.3,1.9,0.1,0.1,7.5,4.8,5.8],
 ["Other States","State Group","Person",33.6,8.8,2.4,0.1,0.1,6.8,4.0,5.5],
 ["Rural","Residence","Male",31.4,8.5,2.8,0.2,0.1,5.9,3.0,5.9],
 ["Rural","Residence","Female",28.4,9.5,2.0,0.1,0.1,6.9,3.8,6.2],
 ["Rural","Residence","Person",30.1,8.9,2.5,0.1,0.1,6.3,3.3,6.0],
 ["Urban","Residence","Male",36.1,10.0,2.5,0.1,0.1,6.4,3.6,4.5],
 ["Urban","Residence","Female",31.6,11.4,1.7,0.1,0.1,7.0,5.1,5.1],
 ["Urban","Residence","Person",34.2,10.5,2.2,0.1,0.1,6.6,4.2,4.7]])

# ── Table 5.1 — Top 10 by Region ─────────────────────────────
regions = {
  "North":       [[1,"Cardiovascular diseases",30.5],[2,"Respiratory infections",7.1],
                  [3,"Malignant and other Neoplasms",6.4],[4,"Respiratory diseases",5.8],
                  [5,"Digestive diseases",5.1],[6,"Unintentional injuries: Motor Vehicle Accidents",4.2],
                  [7,"Diabetes mellitus",4.1],[8,"Fever of unknown origin",3.8],
                  [9,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.5],
                  [10,"Ill-defined or cause unknown",9.8]],
  "North-East":  [[1,"Cardiovascular diseases",27.6],[2,"Malignant and other Neoplasms",9.0],
                  [3,"Respiratory infections",8.6],[4,"Respiratory diseases",6.3],
                  [5,"Fever of unknown origin",6.0],[6,"Digestive diseases",5.2],
                  [7,"Tuberculosis",3.3],[8,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.2],
                  [9,"Diarrhoeal diseases",2.9],[10,"Ill-defined or cause unknown",9.5]],
  "East":        [[1,"Cardiovascular diseases",35.1],[2,"Respiratory infections",9.2],
                  [3,"Malignant and other Neoplasms",5.1],[4,"Fever of unknown origin",5.0],
                  [5,"Respiratory diseases",4.8],[6,"Digestive diseases",4.5],
                  [7,"Diabetes mellitus",3.1],[8,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.1],
                  [9,"Tuberculosis",2.5],[10,"Ill-defined or cause unknown",8.9]],
  "Central":     [[1,"Cardiovascular diseases",22.9],[2,"Respiratory infections",12.3],
                  [3,"Fever of unknown origin",7.6],[4,"Respiratory diseases",7.0],
                  [5,"Digestive diseases",6.5],[6,"Malignant and other Neoplasms",5.7],
                  [7,"Perinatal conditions",5.1],[8,"Unintentional injuries: Other Than Motor Vehicle Accidents",4.3],
                  [9,"Diarrhoeal diseases",3.8],[10,"Ill-defined or cause unknown",9.2]],
  "West":        [[1,"Cardiovascular diseases",31.5],[2,"Respiratory infections",12.7],
                  [3,"Malignant and other Neoplasms",6.0],[4,"Digestive diseases",5.5],
                  [5,"Respiratory diseases",5.2],[6,"Diabetes mellitus",4.4],
                  [7,"Fever of unknown origin",3.8],[8,"Genito-urinary diseases",3.2],
                  [9,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.1],
                  [10,"Ill-defined or cause unknown",8.5]],
  "South":       [[1,"Cardiovascular diseases",34.0],[2,"Respiratory infections",8.6],
                  [3,"Malignant and other Neoplasms",7.1],[4,"Diabetes mellitus",4.6],
                  [5,"Respiratory diseases",5.3],[6,"Digestive diseases",4.8],
                  [7,"Fever of unknown origin",3.7],[8,"Genito-urinary diseases",3.5],
                  [9,"Unintentional injuries: Other Than Motor Vehicle Accidents",3.2],
                  [10,"Ill-defined or cause unknown",8.0]],
}
rows = []
for region, causes in regions.items():
    for r in causes:
        rows.append([region] + r)
write_csv("top10_by_region.csv",["region","rank","cause","person_pct"], rows)

print("\nAll CSV files written successfully.")
