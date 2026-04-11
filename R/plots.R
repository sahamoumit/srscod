# R/plots.R
# Visualisation functions for srscod

# Suppress R CMD check notes for ggplot2 aesthetic variable names
utils::globalVariables(c(
  "pct", "cause", "age_group", "sex", "region", "person_pct",
  "stratum", "cause_short", "disease"
))


#' Plot top N causes of death as a horizontal bar chart
#'
#' @param age_group Passed to \code{get_top_causes()}.
#' @param sex Character. \code{"Person"}, \code{"Male"}, or \code{"Female"}.
#' @param n Integer. Number of causes to plot.
#' @param stratum Passed to \code{get_top_causes()} when age_group = "all_ages".
#' @param title Optional plot title. Auto-generated if NULL.
#' @return A ggplot2 object.
#' @export
#' @examples
#' \dontrun{
#' plot_top_causes("youth")
#' plot_top_causes("all_ages", sex = "Female", stratum = "Rural")
#' }
plot_top_causes <- function(age_group = "all_ages",
                            sex = "Person",
                            n = 10,
                            stratum = "India",
                            title = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("ggplot2 is required. Install with: install.packages('ggplot2')")

  df <- get_top_causes(age_group, sex = sex, n = n, stratum = stratum)

  band_labels <- c(
    neonatal  = "Age < 29 Days (Neonatal)",
    infant    = "Age < 1 Year (Infant)",
    child_1_4 = "Age 1-4 Years",
    child_0_4 = "Age 0-4 Years (Under-5)",
    school    = "Age 5-14 Years",
    youth     = "Age 15-29 Years",
    adult     = "Age 30-69 Years",
    elderly   = "Age 70+ Years",
    all_ages  = paste0("All Ages - ", stratum)
  )
  band_label <- band_labels[age_group]
  if (is.null(title))
    title <- paste0("Top ", n, " Causes of Death - ", band_label, " (", sex, ")\nIndia SRS 2021-2023")

  df$cause <- factor(df$cause, levels = rev(df$cause))

  ggplot2::ggplot(df, ggplot2::aes(x = pct, y = cause)) +
    ggplot2::geom_col(fill = "#1a6faf", width = 0.7) +
    ggplot2::geom_text(ggplot2::aes(label = paste0(pct, "%")),
                       hjust = -0.15, size = 3.2, colour = "grey30") +
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0, 0.15))) +
    ggplot2::labs(title = title,
                  x = "Proportion of Deaths (%)", y = NULL,
                  caption = "Source: SRS Causes of Death 2021-2023, ORGI") +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(face = "bold", size = 11),
                   plot.caption = ggplot2::element_text(colour = "grey50", size = 8))
}


#' Plot age-gender death pyramid
#'
#' Renders a population pyramid showing the percentage distribution of deaths
#' by age group for males and females.
#'
#' @param stratum Character. Stratum to display. One of \code{"India"},
#'   \code{"EAG and Assam"}, \code{"Other States"}, \code{"Rural"},
#'   \code{"Urban"}.
#' @param title Optional plot title.
#' @return A ggplot2 object.
#' @export
#' @examples
#' \dontrun{
#' plot_age_pyramid()
#' plot_age_pyramid("Rural")
#' }
plot_age_pyramid <- function(stratum = "India", title = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("ggplot2 is required.")

  df <- get_age_gender_deaths(stratum = stratum, type = "pct")
  df <- df[!df$age_group %in% c("0-4","1-4"), ]  # avoid double-counting

  if (is.null(title))
    title <- paste0("Age-Gender Distribution of Deaths - ", stratum,
                    "\nIndia SRS 2021-2023")

  age_order <- c("0-1","05-14","15-29","30-34","35-44","45-54","55-69","70+")
  df$age_group <- factor(df$age_group, levels = age_order)

  df_long <- data.frame(
    age_group = rep(df$age_group, 2),
    sex       = rep(c("Male","Female"), each = nrow(df)),
    pct       = c(-df$male_pct, df$female_pct)
  )

  ggplot2::ggplot(df_long, ggplot2::aes(x = pct, y = age_group, fill = sex)) +
    ggplot2::geom_col(width = 0.75) +
    ggplot2::scale_x_continuous(
      labels = function(x) paste0(abs(x), "%"),
      breaks = seq(-50, 50, 10)
    ) +
    ggplot2::scale_fill_manual(values = c(Male = "#1a6faf", Female = "#c0392b")) +
    ggplot2::geom_vline(xintercept = 0, colour = "white", linewidth = 0.5) +
    ggplot2::labs(title = title, x = "Proportion of Deaths (%)",
                  y = "Age Group", fill = NULL,
                  caption = "Source: SRS Causes of Death 2021-2023, ORGI") +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = "bottom",
                   plot.title = ggplot2::element_text(face = "bold", size = 11),
                   plot.caption = ggplot2::element_text(colour = "grey50", size = 8))
}


#' Plot regional comparison for a specific cause
#'
#' Visualises how the proportion of deaths from a specific cause varies across
#' India's six geographic zones.
#'
#' @param cause Character. Full or partial cause name to match.
#' @param title Optional plot title.
#' @return A ggplot2 object.
#' @export
#' @examples
#' \dontrun{
#' plot_regional_cause("Cardiovascular")
#' plot_regional_cause("Tuberculosis")
#' }
plot_regional_cause <- function(cause, title = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("ggplot2 is required.")

  df <- compare_regions(cause = cause)
  if (nrow(df) == 0) stop("No matching cause found. Check the cause name.")

  # pick the first matching cause string if multiple
  matched_cause <- df$cause[1]
  df <- df[df$cause == matched_cause, ]
  df$region <- factor(df$region,
    levels = c("North","North-East","East","Central","West","South"))

  if (is.null(title))
    title <- paste0("Proportion of Deaths: ", matched_cause,
                    "\nBy Region - India SRS 2021-2023")

  ggplot2::ggplot(df, ggplot2::aes(x = region, y = person_pct, fill = region)) +
    ggplot2::geom_col(width = 0.65, show.legend = FALSE) +
    ggplot2::geom_text(ggplot2::aes(label = paste0(person_pct, "%")),
                       vjust = -0.5, size = 3.5, colour = "grey30") +
    ggplot2::scale_fill_brewer(palette = "Set2") +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.15))) +
    ggplot2::labs(title = title, x = "Region",
                  y = "Proportion of Deaths (%)",
                  caption = "Source: SRS Causes of Death 2021-2023, ORGI") +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", size = 11),
                   plot.caption = ggplot2::element_text(colour = "grey50", size = 8))
}


#' Plot specific disease burdens across strata
#'
#' Compares the burden (% of all deaths) from up to three specific diseases
#' across strata types.
#'
#' @param diseases Character vector. Up to 3 disease names from:
#'   \code{"cardiovascular"}, \code{"respiratory_infections"},
#'   \code{"tuberculosis"}, \code{"malaria"}, \code{"hiv_aids"},
#'   \code{"malignant_neoplasms"}, \code{"diabetes_mellitus"},
#'   \code{"respiratory_diseases"}.
#' @param sex Character. \code{"Person"} (default), \code{"Male"}, or
#'   \code{"Female"}.
#' @return A ggplot2 object.
#' @export
#' @examples
#' \dontrun{
#' plot_disease_profile(c("cardiovascular","tuberculosis","diabetes_mellitus"))
#' plot_disease_profile(c("malignant_neoplasms","respiratory_diseases"), sex = "Female")
#' }
plot_disease_profile <- function(diseases = c("cardiovascular","tuberculosis","diabetes_mellitus"),
                                 sex = "Person") {
  if (!requireNamespace("ggplot2", quietly = TRUE) ||
      !requireNamespace("tidyr", quietly = TRUE))
    stop("ggplot2 and tidyr are required.")

  sex <- match.arg(sex, c("Person","Male","Female"))
  diseases <- diseases[1:min(3, length(diseases))]

  df <- srs_data("specific_diseases")
  df <- df[df$sex == sex, c("stratum","stratum_type", diseases)]

  df_long <- tidyr::pivot_longer(df, cols = tidyr::all_of(diseases),
                                 names_to = "disease", values_to = "pct")
  df_long$disease <- gsub("_", " ", df_long$disease)
  df_long$disease <- tools::toTitleCase(df_long$disease)

  stratum_order <- c("India","EAG and Assam","Other States","Rural","Urban")
  df_long$stratum <- factor(df_long$stratum, levels = stratum_order)

  title <- paste0("Disease Burden by Stratum - ", sex, "\nIndia SRS 2021-2023")

  ggplot2::ggplot(df_long, ggplot2::aes(x = stratum, y = pct, fill = disease)) +
    ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.75), width = 0.65) +
    ggplot2::scale_fill_brewer(palette = "Set1") +
    ggplot2::labs(title = title, x = "Stratum", y = "Proportion of Deaths (%)",
                  fill = "Disease",
                  caption = "Source: SRS Causes of Death 2021-2023, ORGI") +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = "bottom",
                   axis.text.x = ggplot2::element_text(angle = 20, hjust = 1),
                   plot.title = ggplot2::element_text(face = "bold", size = 11),
                   plot.caption = ggplot2::element_text(colour = "grey50", size = 8))
}


#' Plot cause group comparison across major strata
#'
#' Faceted bar chart showing the four major cause groups (NCD, Communicable,
#' Injuries, Ill-defined) across national/state-group/residence strata.
#'
#' @param sex Character. \code{"Person"} (default), \code{"Male"}, or
#'   \code{"Female"}.
#' @return A ggplot2 object.
#' @export
#' @examples
#' \dontrun{
#' plot_cause_group_comparison()
#' plot_cause_group_comparison(sex = "Female")
#' }
plot_cause_group_comparison <- function(sex = "Person") {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("ggplot2 is required.")

  sex <- match.arg(sex, c("Person","Male","Female"))
  pct_col <- switch(sex, Person="person_pct", Male="male_pct", Female="female_pct")

  d1 <- srs_data("major_cause_groups_india")
  d1$stratum <- "India"
  d2 <- srs_data("major_cause_groups_eag")
  names(d2)[names(d2) == "group"] <- "stratum"
  d3 <- srs_data("major_cause_groups_residence")
  names(d3)[names(d3) == "residence"] <- "stratum"

  df <- rbind(d1[, c("stratum","cause_group",pct_col)],
              d2[, c("stratum","cause_group",pct_col)],
              d3[, c("stratum","cause_group",pct_col)])
  names(df)[3] <- "pct"

  df$stratum <- factor(df$stratum,
    levels = c("India","EAG and Assam","Other States","Rural","Urban"))

  short_causes <- c(
    "Non-Communicable diseases"                                     = "NCD",
    "Communicable maternal perinatal and nutritional conditions"    = "Communicable",
    "Injuries"                                                      = "Injuries",
    "Symptoms signs and Ill-defined conditions"                     = "Ill-defined"
  )
  df$cause_short <- short_causes[df$cause_group]
  df$cause_short[is.na(df$cause_short)] <- df$cause_group[is.na(df$cause_short)]

  ggplot2::ggplot(df, ggplot2::aes(x = cause_short, y = pct, fill = stratum)) +
    ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.8), width = 0.7) +
    ggplot2::scale_fill_brewer(palette = "Set2") +
    ggplot2::labs(
      title = paste0("Major Cause Group Distribution by Stratum - ", sex,
                     "\nIndia SRS 2021-2023"),
      x = "Cause Group", y = "Proportion of Deaths (%)", fill = "Stratum",
      caption = "Source: SRS Causes of Death 2021-2023, ORGI") +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = "bottom",
                   plot.title = ggplot2::element_text(face = "bold", size = 11),
                   plot.caption = ggplot2::element_text(colour = "grey50", size = 8))
}
