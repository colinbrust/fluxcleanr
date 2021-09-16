
#' Process all raw FLUXNET2015 data in a directory.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @param flux_dir Directory containing raw fluxnet data.
#' @param out_dir Directory to save processed fluxnet data to.
#' @param avg_daily boolean - Return the average daily latent heat flux for each
#'   site (TRUE) or keep the data at half-hourly and hourly intervals (FALSE).
#'
#' @return  Data frame where daily missing values are gap filled and
#' @export
#'
#' @examples
#' \dontrun{
#' process_le('path/to/flux/dir', '/path/to/save/dir', avg_daily = TRUE)
#' }
process_le <- function(flux_dir, out_dir, avg_daily=TRUE) {
  list.files(flux_dir, full.names = TRUE, pattern = 'FULLSET') %>%
    grep('_HR_|_HH_', ., value = TRUE) %>%
    lapply(function(x) {

      name_split <- x %>%
        basename() %>%
        stringr::str_split('_') %>%
        unlist()

      name <- magrittr::extract(name_split, 2)

      if (file.exists(file.path(out_dir, glue::glue('{name}_cleaned.csv')))) {
        print(glue::glue('{name} already exists in out_dir. Skipping file.'))
      } else {
        hh <- magrittr::extract(name_split, 5) == 'HH'

        print(glue::glue('Processing {name}...'))

        out <- x %>%
          clean_le() %>%
          filter_le(hh = hh, avg_daily = avg_daily)

        if (!is.null(out)) {
          readr::write_csv(
            out,
            file.path(out_dir, glue::glue('{name}_cleaned.csv'))
          )
        }
      }
    })
}
