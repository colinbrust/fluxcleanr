test_that("data processing works", {
  tmp <- tempdir()
  f_dir <- system.file('extdata', package='fluxcleanr')

  process_le(f_dir, tmp, TRUE)
  expect_length(list.files(tmp, pattern = 'AR-SLu'), 1)
})
