
#'Read and clean latent heat flux data in a FLUXNET2015 .csv file.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param f Path to .csv file.
#'
#' @return  Data frame containing timeseries of latent heat flux values.
#' @export
#'
#' @examples
#' clean_le('http://files.ntsg.umt.edu/data/colin_data/fluxcleanr/hh_ex.csv')
clean_le <- function(f) {

  f %>%
    readr::read_csv(col_types = readr::cols()) %>%
    dplyr::filter(
      .data$LE_F_MDS_QC %in% c(0, 1),
      .data$LE_CORR_25 != -9999,
      .data$LE_CORR_75 != -9999
    ) %>%
    dplyr::mutate(
      date = paste0(as.character(.data$TIMESTAMP_START), '00'),
      date = lubridate::as_datetime(date)) %>%
    dplyr::select(
      'date',
      dplyr::contains('LE_CORR'),
      -dplyr::contains('UNC')
    )
}
