
#'Read and clean latent heat flux data in a FLUXNET2015 .csv file.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param f Path to .csv file.
#'
#' @return  Data frame containing timeseries of latent heat flux values with
#'   low quality data removed.
#' @export
#'
#' @examples
#' \dontrun{
#' f <- system.file('extdata',
#'   "FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv",
#'   package='fluxcleanr'
#')
#' clean_le(f)
#' }
clean_le <- function(f) {

  f %>%
    readr::read_csv(col_types = readr::cols()) %>%
    # Filter out low quality data
    dplyr::filter(
      .data$LE_F_MDS_QC %in% c(0, 1)
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
