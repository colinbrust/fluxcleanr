test_that("dataframe dimensions are correct", {
  dat <- clean_le(
    'http://files.ntsg.umt.edu/data/colin_data/fluxcleanr/hh_ex.csv'
    )

  expect_equal(ncol(dat), 4)
})
