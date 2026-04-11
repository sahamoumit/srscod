# srscod — India SRS Causes of Death 2021-2023

An R package providing tidy access to all tables from the **Sample Registration
System (SRS) Causes of Death Report 2021-2023**, published by the Office of the
Registrar General of India (ORGI).

---

## Installation

```r
# Install from GitHub
# install.packages("devtools")
devtools::install_github("sahamoumit/srscod")
```

> **Note for developers (Apple Silicon / R 4.5):** If you encounter a
> `lazy-load database is corrupt` error, use:
> ```r
> install.packages(
>   "path/to/srscod", repos = NULL, type = "source",
>   INSTALL_opts = "--no-byte-compile"
> )
> ```
> Or load directly from source during development:
> ```r
> devtools::load_all("path/to/srscod")
> ```

---

## What is this data?

The SRS Causes of Death report is based on **Verbal Autopsy (VA)** of
**1,59,296 deaths** recorded between 2021 and 2023, across **8,839 sample
units** in 28 states and 8 Union Territories. Causes are coded using **ICD-10**
and classified into 63 categories.

Key national findings:

- **Leading cause (all ages):** Cardiovascular diseases (31.0%)
- **Leading cause (age 15–29):** Intentional injuries — Suicide (17.3%)
- **Leading cause (neonates):** Prematurity & low birth weight (48.0%)
- **NCD burden:** 56.7% of all deaths

---

## Package structure

### Datasets — 21 CSVs in `inst/extdata/`

| `srs_data()` key | PDF tables | Description |
|---|---|---|
| `sample_units` | 1.1 | Sample units & population covered |
| `va_srs_comparison` | 1.2 | Verbal autopsy vs SRS comparison |
| `deaths_age_gender_india` | 1.3A/B/C + 2.2A | Deaths by age & gender — India |
| `deaths_age_gender_eag` | 2.2B | Deaths by age & gender — EAG states |
| `deaths_age_gender_residence` | 2.2C | Deaths by age & gender — Rural/Urban |
| `major_cause_groups_india` | 2.1A | Major cause groups — India |
| `major_cause_groups_eag` | 2.1B | Major cause groups — EAG states |
| `major_cause_groups_residence` | 2.1C | Major cause groups — Rural/Urban |
| `top10_allages_india` | 2.3A | Top 10 causes, all ages — India |
| `top10_allages_eag` | 2.3B | Top 10 causes, all ages — EAG states |
| `top10_allages_residence` | 2.3C | Top 10 causes, all ages — Rural/Urban |
| `top10_neonatal` | 3.1A/B/C | Top 10 — age < 29 days (5 geographies) |
| `top10_infant` | 3.2A/B/C | Top 10 — age < 1 year (5 geographies) |
| `top10_child_1_4` | 3.3A/B/C | Top 10 — age 1–4 years (5 geographies) |
| `top10_child_0_4` | 3.4A/B/C | Top 10 — age 0–4 years (5 geographies) |
| `top10_school` | 3.5A/B/C | Top 10 — age 5–14 years (5 geographies) |
| `top10_youth` | 3.6A/B/C | Top 10 — age 15–29 years (5 geographies) |
| `top10_adult` | 3.7A/B/C | Top 10 — age 30–69 years (5 geographies) |
| `top10_elderly` | 3.8A/B/C | Top 10 — age 70+ years (5 geographies) |
| `specific_diseases` | 4.1/4.2/4.3 | Specific disease burden by stratum |
| `top10_by_region` | 5.1A–F | Top 10 by major geographic region |

> **Geography column:** Age-specific datasets (neonatal through elderly) contain
> a `geography` column with five values: `India`, `EAG and Assam`,
> `Other States`, `Rural`, `Urban` — covering all A, B and C sub-tables from
> the PDF.

### Functions — 17 across 3 files

| File | Functions |
|---|---|
| `data_accessors.R` | `srs_data()`, `get_top_causes()`, `get_disease_burden()`, `get_age_gender_deaths()`, `get_cause_groups()`, `compare_regions()`, `get_sample_coverage()`, `get_va_srs_concordance()` |
| `analysis.R` | `srs_summary()`, `age_band_comparison()`, `find_cause_across_ages()`, `gender_disparity()`, `eag_disparity()` |
| `plots.R` | `plot_top_causes()`, `plot_age_pyramid()`, `plot_regional_cause()`, `plot_disease_profile()`, `plot_cause_group_comparison()` |

---

## Quick start

```r
devtools::load_all("path/to/srscod")   # or library(srscod) after installation

# National summary
srs_summary()

# Top causes for a specific age group and geography
get_top_causes("youth")
get_top_causes("adult", sex = "Female", n = 5)
get_top_causes("all_ages", stratum = "Rural")

# Load raw data
srs_data("top10_neonatal")                          # all 5 geographies
srs_data("specific_diseases")
```

---

## Analysis examples

```r
# Compare cause profiles across all age bands
age_band_comparison()
age_band_comparison(sex = "Female", n_ranks = 2)

# Find where a specific cause peaks across the life course
find_cause_across_ages("Cardiovascular")
find_cause_across_ages("Suicide")
find_cause_across_ages("Prematurity")

# Gender disparity in cause of death
gender_disparity("all_ages")
gender_disparity("youth")

# EAG states vs Other States gap
eag_disparity()
eag_disparity(sex = "Female")

# Major cause group breakdown (NCD / Communicable / Injuries)
get_cause_groups()
get_cause_groups(by = "eag", sex = "Female")
get_cause_groups(by = "residence")

# Specific disease burden (Chapter 4 — TB, CVD, Cancer, Diabetes etc.)
get_disease_burden("cardiovascular")
get_disease_burden("tuberculosis", sex = "Male")
get_disease_burden("diabetes_mellitus", stratum_type = "Residence")

# Regional comparison (Chapter 5)
compare_regions()
compare_regions(region = "South")
compare_regions(cause = "Cardiovascular")

# Age-gender distribution
get_age_gender_deaths()
get_age_gender_deaths("Rural", type = "count")

# VA-SRS concordance — data quality check
get_va_srs_concordance()

# Sample coverage by state
get_sample_coverage()
get_sample_coverage(eag_group = "EAG")
```

---

## Visualisation examples

```r
# Horizontal bar chart of top causes
plot_top_causes("all_ages")
plot_top_causes("youth", sex = "Male")
plot_top_causes("all_ages", stratum = "EAG and Assam")

# Age-gender pyramid
plot_age_pyramid()
plot_age_pyramid("Urban")

# Regional comparison for a specific cause
plot_regional_cause("Cardiovascular")
plot_regional_cause("Tuberculosis")

# Disease burden across strata
plot_disease_profile(c("cardiovascular", "tuberculosis", "diabetes_mellitus"))
plot_disease_profile(c("malignant_neoplasms", "respiratory_diseases"), sex = "Female")

# Major cause group comparison
plot_cause_group_comparison()
plot_cause_group_comparison(sex = "Male")
```

---

## Analytical objectives by chapter

| Chapter | What you can study |
|---|---|
| Ch. 1 | Survey quality, national mortality profile, VA vs SRS diagnostic accuracy |
| Ch. 2 | NCD vs communicable burden; equity across state groups and residence |
| Ch. 3 | Life-stage cause profiles; child, youth and elderly health policy |
| Ch. 4 | Vertical disease programme monitoring — CVD, TB, Cancer, Diabetes |
| Ch. 5 | Geographic epidemiology; regional health planning |

---

## Research questions this package can help answer

- Which diseases kill the most in rural vs urban India?
- How does the leading cause of death change from birth to old age?
- Which diseases show the starkest male-female gap?
- Which EAG states lag most in health outcomes?
- How reliable is verbal autopsy diagnosis in the SRS data?
- Is India's NCD burden rising faster than communicable disease decline?

---

## Dependencies

- **Required:** R ≥ 4.0.0
- **Suggested for plots:** `ggplot2`, `tidyr`

---

## Citation

If you use this package in your work, please cite both the package and the
original data source:

**Package:**
> Saha, M. (2025). *srscod: India SRS Causes of Death Statistics 2021-2023*.
> R package version 1.0.0. https://github.com/sahamoumit/srscod

**Data source:**
> Office of the Registrar General of India (2025). *Causes of Death Statistics
> 2021-2023*. Vital Statistics Division, Sample Registration System Section,
> Ministry of Home Affairs, New Delhi.

---

## License

MIT © Moumita Saha
