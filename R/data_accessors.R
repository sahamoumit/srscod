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

#' Get top N causes of death for a specific age group
#'
#' @param age_group Character. One of "all_ages", "neonatal", "infant",
#'   "child_1_4", "child_0_4", "school", "youth", "adult", "elderly".
#' @param sex Character. "Person" (default), "Male", or "Female".
#' @param n Integer. Number of top causes to return. Default 10.
#' @param stratum Character. For all_ages only: "India", "EAG and Assam",
#'   "Other States", "Rural", "Urban". Default "India".
#' @return A data frame with columns: rank, cause, pct.
#' @export
#' @examples
#' get_top_causes("all_ages")
#' get_top_causes("youth", sex = "Female", n = 5)
get_top_causes <- function(age_group = "all_ages", sex = "Person",
                           n = 10, stratum = "India") {
  sex <- match.arg(sex, c("Person", "Male", "Female"))
  pct_col <- switch(sex,
                    Person = "person_pct",
                    Male   = "male_pct",
                    Female = "female_pct")

  if (age_group == "all_ages") {
    if (stratum == "India") {
      df <- srs_data("top10_allages_india")
    } else if (stratum %in% c("EAG and Assam", "Other States")) {
      df <- srs_data("top10_allages_eag")
      df <- df[df$group == stratum, ]
    } else {
      df <- srs_data("top10_allages_residence")
      df <- df[df$residence == stratum, ]
    }
  } else {
    dataset_map <- c(
      neonatal  = "top10_neonatal",
      infant    = "top10_infant",
      child_1_4 = "top10_child_1_4",
      child_0_4 = "top10_child_0_4",
      school    = "top10_school",
      youth     = "top10_youth",
      adult     = "top10_adult",
      elderly   = "top10_elderly"
    )
    if (!age_group %in% names(dataset_map))
      stop("Unknown age_group: ", age_group)
    df <- srs_data(dataset_map[age_group])
    if ("geography" %in% names(df))
      df <- df[df$geography == "India", ]
  }

  if (!pct_col %in% names(df)) {
    warning("Column ", pct_col, " not found. Falling back to person_pct.")
    pct_col <- "person_pct"
  }

  df <- df[order(-df[[pct_col]]), ]
  df <- head(df, n)
  df$pct <- df[[pct_col]]
  df$rank <- seq_len(nrow(df))
  df[, c("rank", "cause", "pct")]
}


#' Get age-gender death distribution
#'
#' @param stratum Character. One of "India", "EAG and Assam",
#'   "Other States", "Rural", "Urban". Default "India".
#' @param type Character. "pct" (default) or "count".
#' @return A data frame with age_group, male and female columns.
#' @export
#' @examples
#' get_age_gender_deaths()
#' get_age_gender_deaths("Rural", type = "count")
get_age_gender_deaths <- function(stratum = "India", type = "pct") {
  type <- match.arg(type, c("pct", "count"))

  if (stratum == "India") {
    df <- srs_data("deaths_age_gender_india")
  } else if (stratum %in% c("EAG and Assam", "Other States")) {
    df <- srs_data("deaths_age_gender_eag")
    df <- df[df$group == stratum, ]
  } else {
    df <- srs_data("deaths_age_gender_residence")
    df <- df[df$residence == stratum, ]
  }
  df
}


#' Compare causes of death across geographic regions
#'
#' @param region Character or NULL. One of "North", "North-East", "East",
#'   "Central", "West", "South". NULL (default) returns all regions.
#' @param cause Character or NULL. Partial cause name to filter. Default NULL.
#' @param n Integer. Top N causes per region. Default 10.
#' @return A data frame with region, rank, cause, and person_pct columns.
#' @export
#' @examples
#' compare_regions()
#' compare_regions(region = "South")
#' compare_regions(cause = "Cardiovascular")
compare_regions <- function(region = NULL, cause = NULL, n = 10) {
  df <- srs_data("top10_by_region")

  if (!is.null(region)) {
    df <- df[df$region == region, ]
    if (nrow(df) == 0)
      stop("No data for region: ", region,
           ". Valid: North, North-East, East, Central, West, South")
  }

  if (!is.null(cause)) {
    df <- df[grepl(cause, df$cause, ignore.case = TRUE), ]
    if (nrow(df) == 0) {
      message("Cause '", cause, "' not found in regional data.")
      return(invisible(data.frame()))
    }
  }

  if (!is.null(n) && is.null(cause)) {
    df <- do.call(rbind, lapply(split(df, df$region), function(x) {
      x <- x[order(-x$person_pct), ]
      head(x, n)
    }))
  }

  df
}
