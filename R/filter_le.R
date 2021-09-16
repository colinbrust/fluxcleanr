
#' Filter out missing latent heat flux such and linearly interpolate missing
#'   values.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param dat data frame containing filtered flux data for a single tower.
#' @param hh boolean - is the data half-hourly (TRUE), or hourly (FALSE)?
#' @param avg_daily boolean - average latent heat flux values to a daily timestep (TRUE) or keep the values at half-hourly intervals (FALSE)
#'
#' @return  Data frame where daily missing values are gap filled and
#' @export
#'
#' @examples
#' \dontrun{
#' #' f <- system.file('extdata',
#'   "FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv",
#'   package='fluxcleanr'
#')
#' cleaned <- clean_le(f)
#' filter_le(clean)
#' }
filter_le <- function(dat, hh=TRUE, avg_daily=TRUE) {

  tmp <- dat %>%
    dplyr::na_if(-9999) %>%
    dplyr::mutate(day = lubridate::date(date)) %>%
    dplyr::group_by(day) %>%
    dplyr::mutate(
      na_count = max(
        sum(!is.na(.data$LE_CORR)),
        sum(!is.na(.data$LE_CORR_25)),
        sum(!is.na(.data$LE_CORR_75))
        )
      ) %>%
    # Following Zhang et al. (2019), remove days with more than 6 hours missing.
    dplyr::filter(na_count >= ifelse(hh, 36, 6))

  if (nrow(tmp) == 0) {return(NULL)}

  date_tbl <- tibble::tibble(
    date =seq(range(tmp$date)[1], range(tmp$date)[2], by='30 min')
  )

  joined <- dplyr::right_join(tmp, date_tbl, by='date') %>%
    dplyr::arrange(date)

  gap <- ifelse(hh, 12, 6)

  joined$LE_CORR <- zoo::na.approx(joined$LE_CORR, maxgap = gap, rule=2)
  joined$LE_CORR_25 <- zoo::na.approx(joined$LE_CORR_25, maxgap = gap, rule=2)
  joined$LE_CORR_75 <- zoo::na.approx(joined$LE_CORR_75, maxgap = gap, rule=2)

  if (avg_daily) {
    joined %>%
      dplyr::group_by(day) %>%
      dplyr::summarise(
        LE_CORR = mean(LE_CORR),
        LE_CORR_25 = mean(LE_CORR_25),
        LE_CORR_75 = mean(LE_CORR_75)
      ) %>%
      # Filter out NA edge cases from the interpolation.
      stats::na.omit() %>%
      return()
  } else {
    return(joined)
  }
}
