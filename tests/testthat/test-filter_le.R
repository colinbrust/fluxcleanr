

test_that("no NA values present", {
  tmp <- dplyr::filter(filtered, is.na(LE_CORR))
  expect_equal(nrow(tmp), 0)
})

test_that('initial date is correct', {
  expect_equal(filtered$day[1], as.Date('2009-12-26'))
})

test_that('dims are correct', {
  expect_equal(TRUE, all(dim(filtered) == c(456, 4)))
})
