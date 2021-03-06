% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_le.R
\name{filter_le}
\alias{filter_le}
\title{Filter out missing latent heat flux such and linearly interpolate missing
values.}
\usage{
filter_le(dat, hh = TRUE, avg_daily = TRUE)
}
\arguments{
\item{dat}{data frame containing filtered flux data for a single tower.}

\item{hh}{boolean - is the data half-hourly (TRUE), or hourly (FALSE)?}

\item{avg_daily}{boolean - average latent heat flux values to a daily timestep (TRUE) or keep the values at half-hourly intervals (FALSE)}
}
\value{
Data frame where daily missing values are gap filled and
}
\description{
Filter out missing latent heat flux such and linearly interpolate missing
values.
}
\examples{
\dontrun{
#' f <- system.file('extdata',
  "FLX_AR-SLu_FLUXNET2015_FULLSET_HH_2009-2011_1-4.csv",
  package='fluxcleanr'
)
cleaned <- clean_le(f)
filter_le(clean)
}
}
