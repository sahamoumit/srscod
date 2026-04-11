# R/analysis.R
# Summary and analytical helper functions for srscod

# Suppress R CMD check notes for internal package function calls
utils::globalVariables(c(
  "get_top_causes", "get_age_gender_deaths", "compare_regions"
))


#' Summarise overall mortality burden for India
#'
#' Returns a printed summary of national-level key statistics from the
#' SRS CoD 2021-2023 report. Useful as a quick orientation.
#'
#' @return Invisibly returns a named list of summary statistics.
#' @export
#' @examples
#' srs_summary()
srs_summary <- function() {
  cat("==========================================================\n")
  cat(" India SRS Causes of Death 2021-2023 - Summary\n")
  cat(" Source: ORGI, Ministry of Home Affairs\n")
  cat("==========================================================\n\n")
  cat("Total deaths coded : 1,59,296\n")
  cat("Period             : 2021-2023 (half-yearly VA rounds)\n")
  cat("Sample units       : 8,839 (4,960 rural + 3,879 urban)\n")
  cat("States/UTs covered : 28 states + 8 UTs\n")
  cat("Cause categories   : 63 (ICD-10 coded)\n\n")

  cat("Major Cause Group Distribution (All Persons):\n")
  cat("  Non-Communicable Diseases       : 56.7%\n")
  cat("  Communicable/Maternal/Perinatal : 23.4%\n")
  cat("  Injuries                        :  9.4%\n")
  cat("  Ill-defined/Symptoms            : 10.5%\n\n")

  cat("Leading cause (all ages)         : Cardiovascular diseases (31.0%)\n")
  cat("Leading cause (age 15-29)        : Intentional injuries - Suicide (17.3%)\n")
  cat("Leading cause (age <29 days)     : Prematurity & low birth weight (48.0%)\n")
  cat("Leading cause (age 70+)          : Cardiovascular diseases (32.5%)\n\n")

  cat("Regional CVD range               : 22.9% (Central) to 35.1% (East)\n")
  cat("NCD burden: Other States vs EAG  : 59.9% vs 50.6%\n")
  cat("NCD burden: Urban vs Rural       : 60.3% vs 55.7%\n\n")

  invisible(list(
    total_deaths    = 159296,
    period          = "2021-2023",
    sample_units    = 8839,
    cause_categories = 63,
    ncd_pct         = 56.7,
    communicable_pct = 23.4,
    injuries_pct    = 9.4,
    illdefined_pct  = 10.5,
    top_cause_all_ages = "Cardiovascular diseases"
  ))
}


#' Cross-tabulate top causes across multiple age bands
#'
#' Returns a wide-format table showing the rank-1 and rank-2 causes for each
#' age group side by side. Useful for quick comparisons.
#'
#' @param sex Character. \code{"Person"} (default), \code{"Male"}, or
#'   \code{"Female"}.
#' @param n_ranks Integer. How many ranks to show per age band. Default 3.
#' @return A data frame where each row is an age band and columns show ranked causes.
#' @export
#' @examples
#' \dontrun{
#' age_band_comparison()
#' age_band_comparison(sex = "Female", n_ranks = 2)
#' }
age_band_comparison <- function(sex = "Person", n_ranks = 3) {
  bands <- c("neonatal","infant","child_1_4","child_0_4",
             "school","youth","adult","elderly")
  labels <- c("< 29 Days","< 1 Year","1-4 Years","0-4 Years (U5)",
              "5-14 Years","15-29 Years","30-69 Years","70+ Years")

  rows <- lapply(seq_along(bands), function(i) {
    df <- get_top_causes(bands[i], sex = sex, n = n_ranks)
    row <- data.frame(age_group = labels[i], stringsAsFactors = FALSE)
    for (r in seq_len(n_ranks)) {
      if (r <= nrow(df)) {
        row[[paste0("rank", r)]] <- paste0(df$cause[r], " (", df$pct[r], "%)")
      } else {
        row[[paste0("rank", r)]] <- NA_character_
      }
    }
    row
  })
  do.call(rbind, rows)
}


#' Identify which age group has the highest burden for a specific cause
#'
#' Scans all age-band top-10 tables (India, all-persons) and returns the
#' cause proportions found, ranked by proportion.
#'
#' @param cause Character. Partial-match string to search for.
#' @return A data frame with age_band, rank, matched cause, and pct.
#' @export
#' @examples
#' \dontrun{
#' find_cause_across_ages("Cardiovascular")
#' find_cause_across_ages("Suicide")
#' find_cause_across_ages("Prematurity")
#' }
find_cause_across_ages <- function(cause) {
  bands <- list(
    "< 29 Days"      = srs_data("top10_neonatal"),
    "< 1 Year"       = srs_data("top10_infant"),
    "1-4 Years"      = srs_data("top10_child_1_4"),
    "0-4 Years"      = srs_data("top10_child_0_4"),
    "5-14 Years"     = srs_data("top10_school"),
    "15-29 Years"    = srs_data("top10_youth"),
    "30-69 Years"    = srs_data("top10_adult"),
    "70+ Years"      = srs_data("top10_elderly")
  )

  result <- do.call(rbind, lapply(names(bands), function(band) {
    df <- bands[[band]]
    matched <- df[grepl(cause, df$cause, ignore.case = TRUE), ]
    if (nrow(matched) == 0) return(NULL)
    data.frame(age_band = band, rank = matched$rank,
               cause = matched$cause, pct = matched$person_pct,
               stringsAsFactors = FALSE)
  }))

  if (is.null(result) || nrow(result) == 0) {
    message("Cause '", cause, "' not found in top-10 for any age band.")
    return(invisible(NULL))
  }
  result[order(-result$pct), ]
}


#' Gender disparity analysis for top causes
#'
#' Computes the male-female percentage point difference for each of the top N
#' causes and flags large disparities.
#'
#' @param age_group Passed to \code{get_top_causes()}.
#' @param n Integer. Number of causes. Default 10.
#' @param stratum Passed to \code{get_top_causes()}.
#' @return A data frame with cause, male_pct, female_pct, and disparity columns.
#' @export
#' @examples
#' \dontrun{
#' gender_disparity("all_ages")
#' gender_disparity("youth")
#' }
gender_disparity <- function(age_group = "all_ages", n = 10, stratum = "India") {
  male   <- get_top_causes(age_group, sex = "Male",   n = n, stratum = stratum)
  female <- get_top_causes(age_group, sex = "Female", n = n, stratum = stratum)
  person <- get_top_causes(age_group, sex = "Person", n = n, stratum = stratum)

  # merge on cause
  df <- merge(person[, c("cause","pct")],
              male[, c("cause","pct")], by = "cause", suffixes = c("_person","_male"),
              all.x = TRUE)
  df <- merge(df, female[, c("cause","pct")], by = "cause", all.x = TRUE)
  names(df)[names(df) == "pct"] <- "pct_female"

  df$disparity_M_F <- round(df$pct_male - df$pct_female, 1)
  df$higher_in     <- ifelse(df$disparity_M_F > 0, "Male",
                       ifelse(df$disparity_M_F < 0, "Female", "Equal"))
  df[order(-abs(df$disparity_M_F)), ]
}


#' EAG vs Other States disparity for top causes
#'
#' Returns the difference in cause proportions between EAG+Assam and Other
#' States for all-ages top-10 causes.
#'
#' @param sex Character. \code{"Person"} (default), \code{"Male"}, or
#'   \code{"Female"}.
#' @return A data frame showing the gap between state groups.
#' @export
#' @examples
#' \dontrun{
#' eag_disparity()
#' eag_disparity(sex = "Female")
#' }
eag_disparity <- function(sex = "Person") {
  sex <- match.arg(sex, c("Person","Male","Female"))
  pct_col <- switch(sex, Person="person_pct", Male="male_pct", Female="female_pct")

  eag   <- srs_data("top10_allages_eag")
  eag_s <- eag[eag$group == "EAG and Assam", c("cause", pct_col)]
  oth_s <- eag[eag$group == "Other States",  c("cause", pct_col)]

  df <- merge(eag_s, oth_s, by = "cause", suffixes = c("_eag","_other"))
  names(df)[2:3] <- c("eag_pct","other_pct")
  df$gap <- round(df$other_pct - df$eag_pct, 1)
  df$higher_in <- ifelse(df$gap > 0, "Other States",
                   ifelse(df$gap < 0, "EAG and Assam", "Equal"))
  df[order(-abs(df$gap)), ]
}
