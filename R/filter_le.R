
#' Filter out missing latent heat flux such that all data from all flux towers have at least 2 years of complete data.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param dat data frame containing filtered flux data for a single tower.
#' @param hh boolean - is the data half-hourly (TRUE), or hourly (FALSE)?
#'
#' @return  Data frame where daily missing values are gap filled and
#' @export
#'
#' @examples
#' # Add acual example with dummy data
#' sum(1, 2)
filter_le <- function(dat, hh) {

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
    dplyr::filter(na_count >= 36)

  date_tbl <- tibble::tibble(
    date =seq(range(tmp$date)[1], range(tmp$date)[2], by='30 min')
  )

  joined <- dplyr::right_join(tmp, date_tbl, by='date') %>%
    dplyr::arrange(date)

  joined$LE_CORR <- zoo::na.approx(joined$LE_CORR, maxgap = 13, rule=2)
  joined$LE_CORR_25 <- zoo::na.approx(joined$LE_CORR_25, maxgap = 13, rule=2)
  joined$LE_CORR_75 <- zoo::na.approx(joined$LE_CORR_75, maxgap = 13, rule=2)

  joined %>%
    dplyr::group_by(day) %>%
    dplyr::summarise(
      LE_CORR = mean(LE_CORR),
      LE_CORR_25 = mean(LE_CORR_25),
      LE_CORR_75 = mean(LE_CORR_75)
    )
}
