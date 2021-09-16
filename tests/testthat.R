library(testthat)
library(fluxcleanr)

f <- system.file('extdata',
                 "FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv",
                 package='fluxcleanr')

cleaned <- clean_le(f)
filtered <- filter_le(cleaned)

test_check("fluxcleanr")
