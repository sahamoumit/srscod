# R/data_accessors.R
# All core dataset accessor functions for srscod

#' Load any SRS dataset by name
#'
#' Convenience function to load any package dataset from inst/extdata.
#'
#' @param name Character string. One of the dataset names listed in
#'   \code{?srscod-package}.
#' @param geography Character or NULL. For age-specific datasets, filter by
#'   geography. One of \code{"India"}, \code{"EAG and Assam"},
#'   \code{"Other States"}, \code{"Rural"}, \code{"Urban"}.
#'   NULL (default) returns all geographies.
#' @return A data frame.
#' @export
#' @examples
#' srs_data("sample_units")
#' srs_data("top10_allages_india")
#' srs_data("top10_neonatal", geography = "Rural")
#' srs_data("top10_youth", geography = "EAG and Assam")
srs_data <- function(name, geography = NULL) {
  csv_map <- list(
    sample_units                  = "sample_units.csv",
    va_srs_comparison             = "va_srs_comparison.csv",
    major_cause_groups_india      = "major_cause_groups_india.csv",
    major_cause_groups_eag        = "major_cause_groups_eag.csv",
    major_cause_groups_residence  = "major_cause_groups_residence.csv",
    deaths_age_gender_india       = "deaths_age_gender_india.csv",
    deaths_age_gender_eag         = "deaths_age_gender_eag.csv",
    deaths_age_gender_residence   = "deaths_age_gender_residence.csv",
    top10_allages_india           = "top10_allages_india.csv",
    top10_allages_eag             = "top10_allages_eag.csv",
    top10_allages_residence       = "top10_allages_residence.csv",
    top10_neonatal                = "top10_neonatal_lt29days_india.csv",
    top10_infant                  = "top10_infant_lt1year_india.csv",
    top10_child_1_4               = "top10_child_1_4years_india.csv",
    top10_child_0_4               = "top10_child_0_4years_india.csv",
    top10_school                  = "top10_school_5_14years_india.csv",
    top10_youth                   = "top10_youth_15_29years_india.csv",
    top10_adult                   = "top10_adult_30_69years_india.csv",
    top10_elderly                 = "top10_elderly_70plus_india.csv",
    specific_diseases             = "specific_diseases.csv",
    top10_by_region               = "top10_by_region.csv"
  )
  
  if (!name %in% names(csv_map))
    stop("Unknown dataset '", name, "'. See ?srscod-package for valid names.")
  
  df <- .load_csv(csv_map[[name]])
  
  if (!is.null(geography)) {
    if (!"geography" %in% names(df)) {
      warning("Dataset '", name, "' does not have a geography column. ",
              "Ignoring geography filter.")
      return(df)
    }
    valid_geos <- c("India", "EAG and Assam", "Other States", "Rural", "Urban")
    geography  <- match.arg(geography, valid_geos)
    df <- df[df$geography == geography, ]
    if (nrow(df) == 0)
      warning("No rows found for geography = '", geography,
              "' in dataset '", name, "'.")
  }
  
  df
}