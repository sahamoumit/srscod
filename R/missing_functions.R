# R/missing_functions.R
# Missing accessor functions required by analysis and plot functions

#' Get top N causes of death for a specific age group
#' @param age_group Character. One of "all_ages", "neonatal", "infant",
#'   "child_1_4", "child_0_4", "school", "youth", "adult", "elderly".
#' @param sex Character. "Person" (default), "Male", or "Female".
#' @param n Integer. Number of top causes. Default 10.
#' @param stratum Character. For all_ages: "India", "EAG and Assam",
#'   "Other States", "Rural", "Urban". Default "India".
#' @return A data frame with columns: rank, cause, pct.
#' @export
get_top_causes <- function(age_group = "all_ages", sex = "Person",
                           n = 10, stratum = "India") {
  sex <- match.arg(sex, c("Person", "Male", "Female"))
  pct_col <- switch(sex, Person="person_pct", Male="male_pct", Female="female_pct")

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
  df$pct  <- df[[pct_col]]
  df$rank <- seq_len(nrow(df))
  df[, c("rank", "cause", "pct")]
}


#' Get age-gender death distribution
#' @param stratum Character. "India", "EAG and Assam", "Other States",
#'   "Rural", or "Urban". Default "India".
#' @param type Character. "pct" (default) or "count".
#' @return A data frame with age_group, male and female columns.
#' @export
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
#' @param region Character or NULL. One of "North", "North-East", "East",
#'   "Central", "West", "South". NULL returns all regions.
#' @param cause Character or NULL. Partial cause name to filter.
#' @param n Integer. Top N causes per region. Default 10.
#' @return A data frame with region, rank, cause, person_pct columns.
#' @export
compare_regions <- function(region = NULL, cause = NULL, n = 10) {
  df <- srs_data("top10_by_region")
  if (!is.null(region)) {
    df <- df[df$region == region, ]
    if (nrow(df) == 0)
      stop("No data for region: ", region)
  }
  if (!is.null(cause)) {
    df <- df[grepl(cause, df$cause, ignore.case = TRUE), ]
    if (nrow(df) == 0) {
      message("Cause not found in regional data.")
      return(invisible(data.frame()))
    }
  }
  if (is.null(cause)) {
    df <- do.call(rbind, lapply(split(df, df$region), function(x) {
      head(x[order(-x$person_pct), ], n)
    }))
  }
  df
}
