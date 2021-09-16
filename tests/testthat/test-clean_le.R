f <- system.file('extdata',
                 "FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv",
                 package='fluxcleanr')

dat <- clean_le(f)

test_that("dataframe dimensions are correct", {
  expect_equal(ncol(dat), 4)
})

test_that('dataframe has correct number of rows', {
  expect_equal(nrow(dat), 22393)
})

