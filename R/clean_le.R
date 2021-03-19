#' @importFrom magrittr %>%
clean_hh <- function(f, bounds=TRUE) {

  f %>%
    readr::read_csv()

  a %>%
    dplyr::select(
      dplyr::starts_with('TIME'),
      dplyr::starts_with('LE_'),
      -dplyr::contains('UNC')
    )  %>%
    dplyr::filter(
      LE_F_MDS_QC %in% c(0, 1),
      if(bounds) LE_CORR_25 != -9999, LE_CORR_75 != -9999
    )
}
