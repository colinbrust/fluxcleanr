
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

  dat %>%
    dplyr::na_if(-9999) %>%
    dplyr::mutate(day = lubridate::date(date)) %>%
    dplyr::group_by(day) %>%
    dplyr::mutate(
      na_count = max(
        # Figure out why this isn't working
        sum(!is.na(.data$LE_CORR)),
        sum(!is.na(.data$LE_CORR_25)),
        sum(!is.na(.data$LE_CORR_75))
        )
      ) %>%
    dplyr::filter(
      na_count < 12
    )

}
