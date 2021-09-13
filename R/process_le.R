
#' Process all raw FLUXNET2015 data in a directory.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param flux_dir Directory containing raw fluxnet data.
#' @param out_dir Directory to save processed fluxnet data to.
#' @param reduce boolean - Return the average daily latent heat flux for each
#'   site (TRUE) or keep the data at half-hourly and hourly intervals (FALSE).
#'
#' @return  Data frame where daily missing values are gap filled and
#' @export
#'
#' @examples
#' # Add acual example with dummy data
#' sum(1, 2)
process_le <- function(flux_dir, out_dir, avg_daily=TRUE) {
  list.files(flux_dir, full.names = TRUE, pattern = 'FULLSET') %>%
    grep('_HR_|_HH_', ., value = TRUE) %>%
    lapply(function(x) {
      name <- x %>%
        basename() %>%
        stringr::str_split('_') %>%
        unlist() %>%
        magrittr::extract(2)

      print(glue::glue('Processing {name}...'))

      x %>%
        clean_le() %>%
        filter_le() %>%
        readr::write_csv(
          file.path(out_dir, glue::glue('{name}_cleaned.csv'))
        )
    })
}
