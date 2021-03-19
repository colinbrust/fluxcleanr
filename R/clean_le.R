#' Read and clean latent heat flux daata in a fluxnet2015 .csv file.
#'
#' @param f Path to .csv file.
#' @importFrom magrittr %>%
#' @return Data frame containing timeseries of latent heat flux values.
#' @examples
#' clean_le('./data/FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv')
clean_le <- function(f) {

  f %>%
    readr::read_csv() %>%
    dplyr::filter(
      LE_F_MDS_QC %in% c(0, 1),
      LE_CORR_25 != -9999,
      LE_CORR_75 != -9999
    ) %>%
    dplyr::select(
      dplyr::starts_with('TIME'),
      dplyr::contains('LE_CORR'),
      -dplyr::contains('UNC')
    )
}
