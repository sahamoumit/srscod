#' srscod: India SRS Causes of Death Statistics 2021-2023
#'
#' Provides tidy datasets and analytical functions from the Sample Registration
#' System (SRS) Causes of Death Report 2021-2023, published by the Office of
#' the Registrar General of India (ORGI). Covers 1,59,296 coded deaths across
#' 28 states and 8 UTs, classified under 63 ICD-10 cause categories.
#'
#' @section Data Sources:
#' All data are sourced from:
#' "Causes of Death Statistics 2021-2023", Office of the Registrar General
#' of India, Ministry of Home Affairs, September 2025.
#' Verbal Autopsy method; ICD-10 classification.
#'
#' @section Key Datasets:
#' Use \code{srs_data("name")} to load any dataset. Valid names:
#' \code{sample_units}, \code{va_srs_comparison},
#' \code{major_cause_groups_india}, \code{major_cause_groups_eag},
#' \code{major_cause_groups_residence}, \code{deaths_age_gender_india},
#' \code{deaths_age_gender_eag}, \code{deaths_age_gender_residence},
#' \code{top10_allages_india}, \code{top10_allages_eag},
#' \code{top10_allages_residence}, \code{top10_neonatal},
#' \code{top10_infant}, \code{top10_child_1_4}, \code{top10_child_0_4},
#' \code{top10_school}, \code{top10_youth}, \code{top10_adult},
#' \code{top10_elderly}, \code{specific_diseases}, \code{top10_by_region}.
#'
#' @docType package
#' @name srscod-package
#' @importFrom utils read.csv
"_PACKAGE"

# Internal helper: load CSV from inst/extdata
.load_csv <- function(filename) {
  path <- system.file("extdata", filename, package = "srscod")
  if (!nzchar(path)) stop("Dataset not found: ", filename)
  utils::read.csv(path, stringsAsFactors = FALSE)
}
